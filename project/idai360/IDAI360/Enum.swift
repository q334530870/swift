enum ProductType:Int{
    case 推荐区 = 1,首发区,二手转让
}

enum RefreshType:Int{
    case 下拉刷新 = 1,上拉加载
}

enum Payment:Int {
    case 待确认 = 0,还款中,还款结束,我的投资,我的持仓量,我的买入成交单,我的卖出成交单,本息支付,到期本息支付汇总
}

enum SafeType:Int{
    case 基本信息 = 1,登录密码,实名认证,银行卡绑定
}

enum Sex:Int{
    case 女 = 0,男
}

enum Seniority:Int{
    case A = 1,B
}




