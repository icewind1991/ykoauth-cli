use chrono::offset::Utc;
use fuzzy_finder::{item::Item, FuzzyFinder};
use ykoath::{BulkResponse, BulkResponseData, YubiKey};

fn main() -> anyhow::Result<()> {
    let mut buf = Vec::new();
    let yubikey = YubiKey::connect(&mut buf)?;
    yubikey.select(&mut buf)?;

    let challenge = Utc::now().timestamp() / 30;

    let keys: Vec<_> = yubikey
        .calculate_all(true, challenge, &mut buf)?
        .into_iter()
        .filter_map(Result::ok)
        .map(|result| Item::new(result.name.into(), result))
        .collect();

    let result = FuzzyFinder::find(keys, 8)?;
    println!();

    let code = match result {
        Some(BulkResponse {
                 name,
                 data: BulkResponseData::Totp(mut code),
             }) => {
            let new_challenge = Utc::now().timestamp() / 30;
            let mut buf = Vec::new();

            if new_challenge / 30 > challenge / 30 {
                code = yubikey.calculate(true, name.as_bytes(), new_challenge, &mut buf)?;
            }

            code
        }
        Some(BulkResponse {
                 name,
                 data: BulkResponseData::Touch,
             }) => {
            eprintln!("Touch YubiKey ...");
            let new_challenge = Utc::now().timestamp() / 30;
            let mut buf = Vec::new();
            yubikey.calculate(true, name.as_bytes(), new_challenge, &mut buf)?
        }
        _ => {
            return Ok(());
        }
    };

    if let Err(_) = cli_clipboard::set_contents(code.to_string()) {
        println!("{}", code);
    } else {
        println!("{} - Copied", code);
    }

    Ok(())
}
