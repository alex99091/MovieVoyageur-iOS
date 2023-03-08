# MovieVoyageur-iOS

### How to run

```
> cd MovieVoyageur-iOS
> open MovieVoyageur-iOS.xcodeproj
```
### Contents

- [App Apperance](https://github.com/alex99091/MovieVoyageur-iOS#app-apperance)
- [앱 개요](https://github.com/alex99091/MovieVoyageur-iOS#앱-개요)
- [Compositional Layout이란??](https://github.com/alex99091/MovieVoyageur-iOS#Compositional-Layout이란??)

## App Apperance

<table>
<tr>
<td>
<img src="https://user-images.githubusercontent.com/111719007/223450741-f5ec1dc1-37c2-4c51-829b-17f680e35e6e.gif" width="200" height="400"/>
</td>
<td>
<img src="https://user-images.githubusercontent.com/111719007/223464706-38b197dd-b44b-4020-a01d-8c785960ed99.gif" width="200" height="400"/>
</td>
<td>
<img src="https://user-images.githubusercontent.com/111719007/223459629-667ac295-0130-4b0f-845d-91d2dcb1e902.gif" width="200" height="400"/>
</td>
<td>
<img src="https://user-images.githubusercontent.com/111719007/223459638-60844406-0679-4954-951b-4517016ce132.gif" width="200" height="400"/>
</td>
</tr>
</table>


### 앱 개요

&nbsp; 이 샘플 앱은 [TMDB API](https://developers.themoviedb.org/3)를 사용하여 `개봉 예정`/`현재 상영중`/`높은 평점`/`인기있는` 영화 정보를 볼 수 있는 `앱`입니다. 

해당 프로젝트는 영화정보의 `CRUD` 기능을 구현하기 위하여 `UIKit / Storyboard` 기반으로 `Compositional Layout`을 사용한 다양한 화면 구성, 코드의 재사용성을 높이기 위한 View/Cell등의 상속, `Rxswift`를 활용한 `데이터 전달` 등을 포함하고 있습니다.

### Compositional Layout이란??

&nbsp; `Compositional Layout`은 `UICollectionView`에서 사용할 수 있는 유연하고 강력한 `레이아웃 시스템`이며, 이를 사용하여 `컬렉션 뷰`의 `항목`을 `그룹`화하고 `배치`하는 방법을 `정의`할 수 있습니다.

`아이템`, `그룹`, `섹션`을 정의하고, 이들을 통해 `셀의 위치`와 `크기`를 `결정`하기 위해 다음과 같이 코드를 구현하였습니다.


`NSCollectionLayoutItem` - 하나의 `셀`에 해당하는 레이아웃 아이템입니다. 아래 코드에서는 `100%`의 `너비`와 `높이`를 갖는 `셀 아이템`을 생성하고, 셀 내부의 콘텐츠 간격을 5로 정의하였습니다.

```Swift
let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                                      heightDimension: .fractionalHeight(1.0))
                let item = NSCollectionLayoutItem(layoutSize: itemSize)
                item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
```

`NSCollectionLayoutGroup` - 셀을 `그룹`화하는 레이아웃 그룹입니다. 아래 코드에서는 70%의 너비와 100%의 높이를 갖는 `그룹`을 생성하고, `그룹`에 `아이템`들을 담아주었습니다.

```Swift
let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.7),
                                                       heightDimension: .fractionalWidth(1.0))
                let groupSpacing = NSCollectionLayoutSpacing.fixed(0)
                let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize,
                                                               subitems: [item])
```

`NSCollectionLayoutSection` - 컬렉션 뷰의 `섹션`에 해당하는 레이아웃 섹션입니다. 아래 코드에서는 `섹션의 간격`을 설정하고, 섹션의 `스크롤 방향`을 `가로`로 설정하였습니다.

```Swift
let section = NSCollectionLayoutSection(group: group)
                section.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 0, bottom: 10, trailing: 0)
                section.orthogonalScrollingBehavior = .continuous
```

아래는 위의 코드들을 레이아웃 설정입니다. 

layout을 (키:값, 키:값)의 묶음의 `튜플 형식`으로 만들어 `콜렉션 레이아웃`을 반환하였습니다. 각 섹션의 index를 통하여 섹션마다 다른 화면구성을 하였습니다.

```Swift
 let layout = UICollectionViewCompositionalLayout{
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
    if sectionIndex == 0 {
    ...
    return section
    } else {
    ...
    return section
    }
  return layout
}
```

위와 코드를 응용하여 `셀`마다 `다른` `화면구성`을 구현하였습니다. 또한, 이 때 `UICollectionViewDelegate`의 `didSelectItemAt` 함수를 사용하여 영화 화면을 터치하였을 때 `상세 페이지`를 구성하였습니다.

