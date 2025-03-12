#include "drv8353s.h"
#include "hw_config.h"
#include "stm32g4xx_hal_gpio.h"
#include "tim.h"
#include <stdio.h>
/*
 * @brief Delay in microseconds
 *
 * @param n: Number of microseconds to delay
 */
void delay_us(uint16_t n) {
  __HAL_TIM_SET_COUNTER(&htim16, 0);
  while (__HAL_TIM_GET_COUNTER(&htim16) < n)
    ;
}

/*
 * @brief Send 16-bit value via SPI and receive the response
 *
 * @param drv: Pointer to the DRVStruct
 * @param val: 16-bit value to send
 * @return 16-bit response
 */
uint16_t drv_spi_write(DRVStruct *drv, uint16_t val) {
  HAL_GPIO_WritePin(DRV_CS, GPIO_PIN_RESET);
  delay_us(1);
  drv->spi_rx_word = 0;
  drv->spi_tx_word = val;

  for (int i = 15; i >= 0; i--) {
    // Transmit each bit to drv (MSB first)
    HAL_GPIO_WritePin(DRV_MOSI, (drv->spi_tx_word & (1 << i) ? 1 : 0));
    HAL_GPIO_WritePin(DRV_SCLK,
                      GPIO_PIN_SET); // According to datasheet of drv8353s,
    delay_us(1);                     // The clock has config: CPOL=0, CPHA=1
    HAL_GPIO_WritePin(DRV_SCLK, GPIO_PIN_RESET); // set the frequency to

    drv->spi_rx_word <<= 1;
    drv->spi_rx_word |= HAL_GPIO_ReadPin(DRV_MISO);
    delay_us(1);
  }
  HAL_GPIO_WritePin(DRV_MOSI, GPIO_PIN_SET);
  HAL_GPIO_WritePin(DRV_CS, GPIO_PIN_SET);
  return drv->spi_rx_word;
}

/*
 * @brief Read the general purpose register FSR1
 *
 * @parm drv: The DRVStruct
 */
uint16_t drv_read_FSR1(DRVStruct drv) {
  return drv_spi_write(&drv, (1 << 15) |
                                 (FSR1 << 11)); // Enable bit 15 for read access
}

/*
 * @brief Read the general purpose register FSR2
 *
 * @parm drv: The DRVStruct
 */
uint16_t drv_read_FSR2(DRVStruct drv) {
  return drv_spi_write(&drv, (1 << 15) |
                                 (FSR2 << 11)); // Enable bit 15 for read access
}

/*
 * @brief Read the data at the specific register with given address
 *
 * @param drv: The DRVStruct
 * @param reg: address of the register
 */
uint16_t drv_read_register(DRVStruct drv, int reg) {
  return drv_spi_write(&drv, (1 << 15) | (reg << 11));
}

/*
 * @brief Write the data at the any register with given address
 *
 * Heavily discourage to use this
 *
 * @param drv: The DRVStruct
 * @param reg: Address of the register
 * @param val: The 16-bit value to be writen
 */
void drv_write_register(DRVStruct drv, int reg, int val) {
  drv_spi_write(&drv, (reg << 11) | (val));
}

/*
 * @brief Write the data at the specific register (need not to give the adress)
 *
 * Consider to use it properly
 *
 * @param drv: The DRVStruct
 * @param 10- (int ...): 10-bit FIELDS control
 */
void drv_write_DCR(DRVStruct drv, int OCP_ACT, int DIS_GDUV, int DIS_GDF,
                   int OTW_REP, int PWM_MODE, int PWM_COM, int PWM_DIR,
                   int COAST, int BRAKE, int CLR_FLT) {
  uint16_t val = (DCR << 11) | (OCP_ACT << 10) | (DIS_GDUV << 9) |
                 (DIS_GDF << 8) | (OTW_REP << 7) | (PWM_MODE << 5) |
                 (PWM_COM << 4) | (PWM_DIR << 3) | (COAST << 2) | (BRAKE << 1) |
                 CLR_FLT;
  drv_spi_write(&drv, val);
}

void drv_write_HSR(DRVStruct drv, int LOCK, int IDRIVEP_HS, int IDRIVEN_HS) {
  uint16_t val = (HSR << 11) | (LOCK << 8) | (IDRIVEP_HS << 4) | IDRIVEN_HS;
  drv_spi_write(&drv, val);
}

void drv_write_LSR(DRVStruct drv, int CBC, int TDRIVE, int IDRIVEP_LS,
                   int IDRIVEN_LS) {
  uint16_t val = (LSR << 11) | (CBC << 10) | (TDRIVE << 8) | (IDRIVEP_LS << 4) |
                 IDRIVEN_LS;
  drv_spi_write(&drv, val);
}

void drv_write_OCPCR(DRVStruct drv, int TRETRY, int DEAD_TIME, int OCP_MODE,
                     int OCP_DEG, int VDS_LVL) {
  uint16_t val = (OCPCR << 11) | (TRETRY << 10) | (DEAD_TIME << 8) |
                 (OCP_MODE << 6) | (OCP_DEG << 4) | VDS_LVL;
  drv_spi_write(&drv, val);
}

void drv_write_CSACR(DRVStruct drv, int CSA_FET, int VREF_DIV, int LS_REF,
                     int CSA_GAIN, int DIS_SEN, int CSA_CAL_A, int CSA_CAL_B,
                     int CSA_CAL_C, int SEN_LVL) {
  uint16_t val = (CSACR << 11) | (CSA_FET << 10) | (VREF_DIV << 9) |
                 (LS_REF << 8) | (CSA_GAIN << 6) | (DIS_SEN << 5) |
                 (CSA_CAL_A << 4) | (CSA_CAL_B << 3) | (CSA_CAL_C << 2) |
                 SEN_LVL;
  drv_spi_write(&drv, val);
}

/*
 * @brief: These are control functions (Enable/Disable the gate driver &&
 * Calibration)
 *
 * @param drv: The DRVStruct
 */
void drv_enable_gd(DRVStruct drv) {
  uint16_t val = (drv_read_register(drv, DCR)) & (~(0x1 << 2));
  drv_write_register(drv, DCR, val);
}
void drv_disable_gd(DRVStruct drv) {
  uint16_t val = (drv_read_register(drv, DCR)) | (0x1 << 2);
  drv_write_register(drv, DCR, val);
}

void drv_calibrate_mode_manual(DRVStruct drv) {
  uint16_t val = (0x0 << 1);
  drv_write_register(drv, DCONFR, val);
}

void drv_calibrate_mode_auto(DRVStruct drv) {
  uint16_t val = (0x1 << 1);
  drv_write_register(drv, DCONFR, val);
}

void drv_calibrate(DRVStruct drv) {
  uint16_t val = (0x1 << 4) + (0x1 << 3) + (0x1 << 2);
  drv_write_register(drv, CSACR, val);
}
void drv_print_faults(DRVStruct drv) {
  uint16_t val1 = drv_read_FSR1(drv);
  uint16_t val2 = drv_read_FSR2(drv);

  if (val1 & (1 << 10)) {
    printf("\n\rFAULT\n\r");
  }

  if (val1 & (1 << 9)) {
    printf("VDS_OCP\n\r");
  }
  if (val1 & (1 << 8)) {
    printf("GDF\n\r");
  }
  if (val1 & (1 << 7)) {
    printf("UVLO\n\r");
  }
  if (val1 & (1 << 6)) {
    printf("OTSD\n\r");
  }
  if (val1 & (1 << 5)) {
    printf("VDS_HA\n\r");
  }
  if (val1 & (1 << 4)) {
    printf("VDS_LA\n\r");
  }
  if (val1 & (1 << 3)) {
    printf("VDS_HB\n\r");
  }
  if (val1 & (1 << 2)) {
    printf("VDS_LB\n\r");
  }
  if (val1 & (1 << 1)) {
    printf("VDS_HC\n\r");
  }
  if (val1 & (1)) {
    printf("VDS_LC\n\r");
  }

  if (val2 & (1 << 10)) {
    printf("SA_OC\n\r");
  }
  if (val2 & (1 << 9)) {
    printf("SB_OC\n\r");
  }
  if (val2 & (1 << 8)) {
    printf("SC_OC\n\r");
  }
  if (val2 & (1 << 7)) {
    printf("OTW\n\r");
  }
  if (val2 & (1 << 6)) {
    printf("GDUV\n\r");
  }
  if (val2 & (1 << 5)) {
    printf("VGS_HA\n\r");
  }
  if (val2 & (1 << 4)) {
    printf("VGS_LA\n\r");
  }
  if (val2 & (1 << 3)) {
    printf("VGS_HB\n\r");
  }
  if (val2 & (1 << 2)) {
    printf("VGS_LB\n\r");
  }
  if (val2 & (1 << 1)) {
    printf("VGS_HC\n\r");
  }
  if (val2 & (1)) {
    printf("VGS_LC\n\r");
  }
}
