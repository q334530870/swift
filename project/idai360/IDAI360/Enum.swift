enum ProductType:Int{
    case 推荐区 = 1,首发区,市价买入,市价卖出
}

enum RefreshType:Int{
    case 下拉刷新 = 1,上拉加载
}

enum Payment:Int {
    case 交易付款 = 0,履约中,履约结束,交易余额支付,我的持仓量,买入成交单,卖出成交单,现金日记账,到期本息支付,投资损益表,将到期本息汇总,产品变动,转账记录
}

enum Gather:Int{
    case 委托卖出 = 0,委托买入
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