'''
Author: asdevao 1097802349@qq.com
Date: 2025-01-02 17:23:15
LastEditors: asdevao 1097802349@qq.com
LastEditTime: 2025-01-05 22:04:02
FilePath: \新建文件夹\mini_program_backend\blueprints\manage_api\workbench.py
Description: 这是默认设置,请设置`customMade`, 打开koroFileHeader查看配置 进行设置: https://github.com/OBKoro1/koro1FileHeader/wiki/%E9%85%8D%E7%BD%AE
'''
from flask import Blueprint, session
from ..Models.OrderModel import Order
from ..utils.response_util import ResponseUtil
from ..Models.UserModel import ManageUser

bp = Blueprint('workbeach', __name__)


@bp.route('/info', methods=['GET'])
def getWorkBeachData():
    # 使用filter_by来筛选name匹配且department不等于“小程序用户”
    order_count = Order.query.count()
    user_count = ManageUser.query.count()
    # 查询Order表中orderstate为2的数据并计数
    uncompleted_order_count = Order.query.filter(Order.order_state == 2).count()
    # 构造返回的数据
    data = {
        'order_count': order_count,
        'user_count': user_count,
        'uncompleted_order_count': uncompleted_order_count
    }
    return ResponseUtil.success(result=data)
