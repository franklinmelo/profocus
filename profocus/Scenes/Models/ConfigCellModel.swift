struct ConfigCellModel {
    let title: String
    let type: ConfigType
}

enum ConfigType {
    case editName
    case editJob
    case editPhoto
    case logout
    case linkRepo
}
