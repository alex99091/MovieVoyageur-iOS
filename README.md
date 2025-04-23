
# 🎬 MovieVoyageur-iOS

An iOS app powered by the [TMDB API](https://developers.themoviedb.org/3)  
Browse movies by category: **Upcoming**, **Now Playing**, **Top Rated**, and **Popular**.  
Built with **UIKit**, **Storyboard**, **RxSwift**, and **Compositional Layout**.

---

## 🚀 How to Run

```
cd MovieVoyageur-iOS
open MovieVoyageur-iOS.xcodeproj
```

---

## 📁 Project Structure

<details>
<summary>Click to expand project tree</summary>

```
📦 MovieVoyageur-iOS
├── Model/
│   ├── MovieResponse.swift
│   ├── MovieResult.swift
│   ├── MovieDetail.swift
│   └── MovieIdData.swift
│
├── API/
│   └── MovieAPI.swift
│
├── View/
│   ├── Common/
│   │   ├── Main.storyboard
│   │   └── MovieCell.swift
│   ├── Home/
│   │   ├── BannerCell.swift
│   │   ├── SectionHeaderView.swift
│   │   └── MovieListHeaderView.swift
│   ├── Search/
│   │   ├── SearchCell.swift
│   │   ├── RecentSearchCell.swift
│   │   └── SearchHeaderView.swift
│   ├── Genre/
│   │   └── GenreCell.swift
│   └── Like/
│       └── LikeCell.swift
│
├── Controller/
│   ├── Common/
│   │   ├── MainTabbarVC.swift
│   │   ├── MovieDetailVC.swift
│   │   ├── AppDelegate.swift
│   │   └── SceneDelegate.swift
│   ├── Home/
│   │   ├── HomeVC.swift
│   │   └── HomeListVC.swift
│   ├── Search/
│   │   └── SearchVC.swift
│   ├── Genre/
│   │   └── GenreVC.swift
│   └── Like/
│       └── LikeListVC.swift
│
└── Extension/
    ├── APIKey.swift
    ├── Nibbed.swift
    ├── ReuseIdentifiable.swift
    └── UIImage+Extension.swift
```

</details>

---

## 🖼 App Preview

<table>
<tr>
<td><img src="https://user-images.githubusercontent.com/111719007/223450741-f5ec1dc1-37c2-4c51-829b-17f680e35e6e.gif" width="200"/></td>
<td><img src="https://user-images.githubusercontent.com/111719007/223464706-38b197dd-b44b-4020-a01d-8c785960ed99.gif" width="200"/></td>
<td><img src="https://user-images.githubusercontent.com/111719007/223459629-667ac295-0130-4b0f-845d-91d2dcb1e902.gif" width="200"/></td>
<td><img src="https://user-images.githubusercontent.com/111719007/223459638-60844406-0679-4954-951b-4517016ce132.gif" width="200"/></td>
</tr>
</table>

---

## 🧭 Overview

This app demonstrates:

- UIKit + Storyboard-based screen architecture
- Compositional Layout for advanced UICollectionView designs
- Reusable cells and views via subclassing
- Data flow using RxSwift & RxCocoa

---

## 🧱 Compositional Layout Example

<details>
<summary>Click to expand</summary>

### 📌 Item

```
let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                      heightDimension: .fractionalHeight(1.0))
let item = NSCollectionLayoutItem(layoutSize: itemSize)
item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
```

### 📌 Group

```
let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                       heightDimension: .fractionalWidth(1.0))
let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
```

### 📌 Section

```
let section = NSCollectionLayoutSection(group: group)
section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0)
section.orthogonalScrollingBehavior = .continuous
```

### 📌 Full Layout Setup

```
let layout = UICollectionViewCompositionalLayout { (sectionIndex, _) in
    if sectionIndex == 0 {
        return section // Custom layout for section 0
    } else {
        return section // Shared layout
    }
}
```

</details>

---

📌 *Tap on any cell to navigate to the movie detail page using `UICollectionViewDelegate.didSelectItemAt`.*

---

## 📚 Lessons Learned

This project helped solidify several key iOS development concepts:

- **Compositional Layout**: Learned how to build complex, scrollable collection views with different layouts per section.
- **RxSwift**: Understood reactive programming and how to manage asynchronous data flow in a clean, declarative way.
- **Code Reusability**: Implemented reusable view components and cells for better maintainability.
- **Clean Architecture**: Designed the folder and class structure to be modular and scalable.
- **TMDB API Integration**: Practiced decoding network responses and handling remote image/media rendering.
