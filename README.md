# pwrench

**A Personal R Package for Data Analysis**

**Purpose:**
* Provides custom functions for data visualization and number conversion.
* Primarily designed for personal use but may be useful for others working with Persian data.
* I recommend to use it with caution. 
* Let me know if you have questions.

**Key Functions:**

* **theme_fa():** Creates a Persian-friendly theme for ggplot2.
* **theme_map_fa():** Creates a Persian-friendly theme for maps in ggplot2.
* **to_en_number():** Converts Persian numbers to English numbers.
* **to_fa_number():** Converts English numbers to Persian numbers.

**Installation:**

```R
devtools::install_github("bahmanajdari/pwrench")
```
**Usage:**
```R
library(pwrench)
```
# Example using theme_fa()
```R
library(ggplot2)
ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) +
  geom_point() +
  labs(
    title = "این یک عنوان فارسی است",
    subtitle = "این یک زیر عنوان فارسی است",
    x = "عرض کاسبرگ",
    y = "طول کاسبرگ",
    color = "گونه",
    caption="منبع:این یک منبع فارسی است"
  )+
  theme_fa()
```
![Image Description](img/Rplot_fa.png)

# Example using to_en_number()
```R
persian_number <- "۱۲۳"
english_number <- to_en_number(persian_number)
```
** Note: This package is primarily for personal use, and public usage may have limitations. Please report any issues or provide feedback.**
