#![no_std]
#![no_main]

use adafruit_kb2040::entry;

use embedded_hal::delay::DelayNs;

use panic_halt as _;

use adafruit_kb2040::{
    hal::{clocks::init_clocks_and_plls, pac, timer::Timer, watchdog::Watchdog},
    XOSC_CRYSTAL_FREQ,
};

#[entry]
fn main() -> ! {
    let mut pac = pac::Peripherals::take().unwrap();

    let mut watchdog = Watchdog::new(pac.WATCHDOG);

    let clocks = init_clocks_and_plls(
        XOSC_CRYSTAL_FREQ,
        pac.XOSC,
        pac.CLOCKS,
        pac.PLL_SYS,
        pac.PLL_USB,
        &mut pac.RESETS,
        &mut watchdog,
    )
    .ok()
    .unwrap();

    let mut timer = Timer::new(pac.TIMER, &mut pac.RESETS, &clocks);

    loop {
        timer.delay_ms(1_000);
    }
}
