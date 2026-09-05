# pwrench

**Utilities for Persian/Farsi data in R** — themes, number conversion, date conversion, and helpers for working with Iranian data.

---

## Overview

pwrench is a personal R package that provides:

- **Persian-friendly ggplot2 themes** (Sahel font, RTL alignment, configurable sizes)
- **Number conversion** (Persian ↔ English digits)
- **Date conversion** (Gregorian ↔ Jalali calendar)
- **Event scraping** (Iranian events from time.ir + UN international days)
- **Helpers** for Iranian data (e.g. province names, churn rates)

It is primarily for personal use but may be useful for others working with Persian text and data. Use with caution; feedback and issues are welcome.

---

## Installation

```r
# install.packages("devtools")
devtools::install_github("bahmanajdari/pwrench")
```

```r
library(pwrench)
```

### Dependencies

- **ggplot2** - for theme functions
- **rvest** - for web scraping (event functions)
- **httr2** - for HTTP requests (event functions)

---

## Key functions

| Function | Description |
|----------|-------------|
| `theme_fa()` | Persian-friendly ggplot2 theme (title, subtitle, caption, legend; optional RTL) |
| `theme_map_fa()` | Same style for maps (minimal axes, `theme_void` base) |
| `rasmio_theme()` | Alternative Persian theme (Rasmio standards) |
| `to_en_numbers()` | Convert Persian/Arabic numerals to English (0–9) |
| `to_fa_numbers()` | Convert English numerals to Persian |
| `gregorian_to_jalali()` | Convert Gregorian date to Jalali date |
| `jalali_to_gregorian()` | Convert Jalali date to Gregorian date |
| `get_jalali_events()` | Get events for a Jalali date (from time.ir + UN) |
| `get_un_observances()` | Get all UN international days/weeks for a Jalali year |
| `mutate_state_en()` | Add English province names from a column of Persian استان names |
| `calculate_churn_rate()` | Churn and retention rates by product and year |
| `psave_plot()` | Save a ggplot with consistent size and DPI |
| `detect_fake_phone_numbers()` | Flag invalid/fake phone numbers |
| `farsi_keyboard()` | Farsi keyboard–related helper |

---

## Examples

### theme_fa()

Persian-friendly plot with optional right-aligned title (RTL):

```r
library(ggplot2)
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  labs(
    title = "این یک عنوان فارسی است",
    subtitle = "این یک زیر عنوان فارسی است",
    x = "عرض کاسبرگ",
    y = "طول کاسبرگ",
    color = "گونه",
    caption = "منبع: این یک منبع فارسی است"
  ) +
  theme_fa()
```

Right-aligned title for RTL:

```r
theme_fa(title_hjust = 1)
```

![Example plot](img/Rplot_fa.png)

### to_en_numbers() and to_fa_numbers()

```r
persian_number <- "۱۲۳"
to_en_numbers(persian_number)  # "123"

to_fa_numbers(123)             # Persian digits
```

### Date conversion

Convert between Gregorian and Jalali calendars:

```r
# Gregorian to Jalali
gregorian_to_jalali("2026-09-02")  # "1405-06-11"

# Jalali to Gregorian
jalali_to_gregorian("1405-06-11")  # "2026-09-02"
```

### Event scraping

Get events for a specific Jalali date from time.ir and UN international days:

```r
# Get all events for a date
get_jalali_events("1405-06-11")

# Get only time.ir events (skip UN)
get_jalali_events("1405-06-11", include_un = FALSE)

# Get all UN international days for a year
get_un_observances(1405)
```

Example output:

```
                             event_name  source  event_date has_detail
1                      جشن میانه زمستان time.ir [ ۱۵ بهمن ]      FALSE
2                     World Braille Day      UN     15 بهمن      FALSE
3 International Day of Human Fraternity      UN     15 بهمن      FALSE
```

### calculate_churn_rate()

Data with columns `purchase_year`, `product_id`, and `renewed` (logical):

```r
dat <- data.frame(
  purchase_year = c(2022, 2022, 2023),
  product_id = c("A", "A", "B"),
  renewed = c(TRUE, FALSE, FALSE)
)
calculate_churn_rate(dat, year = 2022:2023)
```

---

## Disclaimer

This package is primarily for personal use; public use may have limitations. Please report issues or send feedback.
