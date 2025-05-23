from flask import Blueprint, request

from blueprints import db
from ..utils.orderlist_util import process_order_item
from sqlalchemy import desc
from ..utils.response_util import ResponseUtil
from ..Models.OrderModel import Order

bp = Blueprint('orderlist', __name__)


@bp.route('/tasks', methods=['POST'])
def get_tasks():
    # 获取分页参数
    data = request.json
    page = data['page']
    page_size = data['pageSize']

    # 总记录数
    total_records = Order.query.count()
    todoTasks = Order.query.filter(Order.order_state == 2).count()
    completedTasks = Order.query.filter(Order.order_state == 5).count()
    # 分页处理，按 payLatestTime 降序排序
    orders = Order.query.order_by(desc(Order.pay_latest_time)) \
        .offset((page - 1) * page_size) \
        .limit(page_size) \
        .all()
    # 初始化返回数据
    result = {
        "counts": total_records,
        "pageSize": page_size,
        "pages": (total_records + page_size - 1) // page_size,  # 总页数
        "page": page,
        'todoTasks': todoTasks,
        'completedTasks': completedTasks,
        "items": []
    }

    # 遍历查询结果，使用提取的公共函数处理每个订单数据
    for order in orders:
        order_item = process_order_item(order)
        result["items"].append(order_item)
    print(result)

    return ResponseUtil.success(result=result)


@bp.route('/consignment', methods=['POST'])
def getConsignment():
    data = request.json
    page = data.get('page', 1)  # 添加默认值
    pageSize = data.get('pageSize', 10)  # 添加默认值
    orderNumber = data.get('orderNumber', '')  # 修改参数名以匹配前端，添加默认值
    
    # 构建基础查询
    query = Order.query.filter(Order.order_state == 2)  # 筛选订单状态为2（待发货）
    
    # 如果提供了订单号，添加筛选条件
    if orderNumber:  # 使用新的参数名
        query = query.filter(Order.order_id.like(f'%{orderNumber}%'))
    
    # 获取符合条件的总记录数
    total_count = query.count()
    
    # 应用排序和分页
    orders = query.order_by(desc(Order.pay_latest_time)) \
        .offset((page - 1) * pageSize) \
        .limit(pageSize) \
        .all()
    
    # 计算总页数
    total_pages = (total_count + pageSize - 1) // pageSize
    
    # 初始化返回数据
    result = {
        "pages": total_pages,
        "page": page,
        "items": []
    }
    
    # 处理订单数据
    for order in orders:
        order_item = process_order_item(order)
        result["items"].append(order_item)

    return ResponseUtil.success(result=result)


@bp.route('/consignment/<id>', methods=['POST'])
def Consignment(id):
    print(id)
    order = Order.query.filter(Order.order_id == id).first()

    if not order:
        return ResponseUtil.error('订单未找到')  # 如果订单未找到，返回错误信息

    try:
        order.order_state = 3  # 发货状态
        db.session.commit()
        return ResponseUtil.success(result=order.order_state)
    except Exception as e:
        db.session.rollback()  # 如果发生异常，回滚事务
        return ResponseUtil.error(f"数据库操作失败: {str(e)}")

