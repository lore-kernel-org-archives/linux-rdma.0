From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v5 14/17] RDMA/counter: Allow manual mode configuration support
Date: Tue,  2 Jul 2019 13:02:43 +0300
Message-ID: <20190702100246.17382-15-leon@kernel.org>
References: <20190702100246.17382-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190702100246.17382-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Majd Dibbiny <majd@mellanox.com>, Mark Zhang <markz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Zhang <markz@mellanox.com>

In manual mode a QP is bound to a counter manually. If counter is not
specified then a new one will be allocated.
Manually mode is enabled when user binds a QP, and disabled when the
last manually bound QP is unbound.
When auto-mode is turned off and there are counters left, manual mode
is enabled so that the user is able to access these counters.

Signed-off-by: Mark Zhang <markz@mellanox.com>
Reviewed-by: Majd Dibbiny <majd@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/counters.c | 219 ++++++++++++++++++++++++++++-
 include/rdma/rdma_counter.h        |   7 +
 include/uapi/rdma/rdma_netlink.h   |   6 +
 3 files changed, 229 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/counters.c b/drivers/infiniband/core/counters.c
index 2de4c555eba9..6ac8bf1240de 100644
--- a/drivers/infiniband/core/counters.c
+++ b/drivers/infiniband/core/counters.c
@@ -27,7 +27,9 @@ static int __counter_set_mode(struct rdma_counter_mode *curr,
 /**
  * rdma_counter_set_auto_mode() - Turn on/off per-port auto mode
  *
- * When @on is true, the @mask must be set
+ * When @on is true, the @mask must be set; When @on is false, it goes
+ * into manual mode if there's any counter, so that the user is able to
+ * manually access them.
  */
 int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
 			       bool on, enum rdma_nl_counter_mask mask)
@@ -45,8 +47,13 @@ int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
 			ret = -EINVAL;
 			goto out;
 		}
-		ret = __counter_set_mode(&port_counter->mode,
-					 RDMA_COUNTER_MODE_NONE, 0);
+
+		if (port_counter->num_counters)
+			ret = __counter_set_mode(&port_counter->mode,
+						 RDMA_COUNTER_MODE_MANUAL, 0);
+		else
+			ret = __counter_set_mode(&port_counter->mode,
+						 RDMA_COUNTER_MODE_NONE, 0);
 	}
 
 out:
@@ -57,7 +64,9 @@ int rdma_counter_set_auto_mode(struct ib_device *dev, u8 port,
 static struct rdma_counter *rdma_counter_alloc(struct ib_device *dev, u8 port,
 					       enum rdma_nl_counter_mode mode)
 {
+	struct rdma_port_counter *port_counter;
 	struct rdma_counter *counter;
+	int ret;
 
 	if (!dev->ops.counter_dealloc || !dev->ops.counter_alloc_stats)
 		return NULL;
@@ -73,12 +82,27 @@ static struct rdma_counter *rdma_counter_alloc(struct ib_device *dev, u8 port,
 	if (!counter->stats)
 		goto err_stats;
 
+	port_counter = &dev->port_data[port].port_counter;
+	mutex_lock(&port_counter->lock);
+	if (mode == RDMA_COUNTER_MODE_MANUAL) {
+		ret = __counter_set_mode(&port_counter->mode,
+					 RDMA_COUNTER_MODE_MANUAL, 0);
+		if (ret)
+			goto err_mode;
+	}
+
+	port_counter->num_counters++;
+	mutex_unlock(&port_counter->lock);
+
 	counter->mode.mode = mode;
 	kref_init(&counter->kref);
 	mutex_init(&counter->lock);
 
 	return counter;
 
+err_mode:
+	mutex_unlock(&port_counter->lock);
+	kfree(counter->stats);
 err_stats:
 	kfree(counter);
 	return NULL;
@@ -86,6 +110,18 @@ static struct rdma_counter *rdma_counter_alloc(struct ib_device *dev, u8 port,
 
 static void rdma_counter_free(struct rdma_counter *counter)
 {
+	struct rdma_port_counter *port_counter;
+
+	port_counter = &counter->device->port_data[counter->port].port_counter;
+	mutex_lock(&port_counter->lock);
+	port_counter->num_counters--;
+	if (!port_counter->num_counters &&
+	    (port_counter->mode.mode == RDMA_COUNTER_MODE_MANUAL))
+		__counter_set_mode(&port_counter->mode, RDMA_COUNTER_MODE_NONE,
+				   0);
+
+	mutex_unlock(&port_counter->lock);
+
 	rdma_restrack_del(&counter->res);
 	kfree(counter->stats);
 	kfree(counter);
@@ -363,6 +399,183 @@ u64 rdma_counter_get_hwstat_value(struct ib_device *dev, u8 port, u32 index)
 	return sum;
 }
 
+static struct ib_qp *rdma_counter_get_qp(struct ib_device *dev, u32 qp_num)
+{
+	struct rdma_restrack_entry *res = NULL;
+	struct ib_qp *qp = NULL;
+
+	res = rdma_restrack_get_byid(dev, RDMA_RESTRACK_QP, qp_num);
+	if (IS_ERR(res))
+		return NULL;
+
+	if (!rdma_is_visible_in_pid_ns(res))
+		goto err;
+
+	qp = container_of(res, struct ib_qp, res);
+	if (qp->qp_type == IB_QPT_RAW_PACKET && !capable(CAP_NET_RAW))
+		goto err;
+
+	return qp;
+
+err:
+	rdma_restrack_put(&qp->res);
+	return NULL;
+}
+
+static int rdma_counter_bind_qp_manual(struct rdma_counter *counter,
+				       struct ib_qp *qp)
+{
+	if ((counter->device != qp->device) || (counter->port != qp->port))
+		return -EINVAL;
+
+	return __rdma_counter_bind_qp(counter, qp);
+}
+
+static struct rdma_counter *rdma_get_counter_by_id(struct ib_device *dev,
+						   u32 counter_id)
+{
+	struct rdma_restrack_entry *res;
+	struct rdma_counter *counter;
+
+	res = rdma_restrack_get_byid(dev, RDMA_RESTRACK_COUNTER, counter_id);
+	if (IS_ERR(res))
+		return NULL;
+
+	if (!rdma_is_visible_in_pid_ns(res)) {
+		rdma_restrack_put(res);
+		return NULL;
+	}
+
+	counter = container_of(res, struct rdma_counter, res);
+	kref_get(&counter->kref);
+	rdma_restrack_put(res);
+
+	return counter;
+}
+
+/**
+ * rdma_counter_bind_qpn() - Bind QP @qp_num to counter @counter_id
+ */
+int rdma_counter_bind_qpn(struct ib_device *dev, u8 port,
+			  u32 qp_num, u32 counter_id)
+{
+	struct rdma_counter *counter;
+	struct ib_qp *qp;
+	int ret;
+
+	qp = rdma_counter_get_qp(dev, qp_num);
+	if (!qp)
+		return -ENOENT;
+
+	counter = rdma_get_counter_by_id(dev, counter_id);
+	if (!counter) {
+		ret = -ENOENT;
+		goto err;
+	}
+
+	if (counter->res.task != qp->res.task) {
+		ret = -EINVAL;
+		goto err_task;
+	}
+
+	ret = rdma_counter_bind_qp_manual(counter, qp);
+	if (ret)
+		goto err_task;
+
+	rdma_restrack_put(&qp->res);
+	return 0;
+
+err_task:
+	kref_put(&counter->kref, counter_release);
+err:
+	rdma_restrack_put(&qp->res);
+	return ret;
+}
+
+/**
+ * rdma_counter_bind_qpn_alloc() - Alloc a counter and bind QP @qp_num to it
+ *   The id of new counter is returned in @counter_id
+ */
+int rdma_counter_bind_qpn_alloc(struct ib_device *dev, u8 port,
+				u32 qp_num, u32 *counter_id)
+{
+	struct rdma_counter *counter;
+	struct ib_qp *qp;
+	int ret;
+
+	if (!rdma_is_port_valid(dev, port))
+		return -EINVAL;
+
+	qp = rdma_counter_get_qp(dev, qp_num);
+	if (!qp)
+		return -ENOENT;
+
+	if (rdma_is_port_valid(dev, qp->port) && (qp->port != port)) {
+		ret = -EINVAL;
+		goto err;
+	}
+
+	counter = rdma_counter_alloc(dev, port, RDMA_COUNTER_MODE_MANUAL);
+	if (!counter) {
+		ret = -ENOMEM;
+		goto err;
+	}
+
+	ret = rdma_counter_bind_qp_manual(counter, qp);
+	if (ret)
+		goto err_bind;
+
+	if (counter_id)
+		*counter_id = counter->id;
+
+	rdma_counter_res_add(counter, qp);
+
+	rdma_restrack_put(&qp->res);
+	return ret;
+
+err_bind:
+	rdma_counter_free(counter);
+err:
+	rdma_restrack_put(&qp->res);
+	return ret;
+}
+
+/**
+ * rdma_counter_unbind_qpn() - Unbind QP @qp_num from a counter
+ */
+int rdma_counter_unbind_qpn(struct ib_device *dev, u8 port,
+			    u32 qp_num, u32 counter_id)
+{
+	struct rdma_port_counter *port_counter;
+	struct ib_qp *qp;
+	int ret;
+
+	if (!rdma_is_port_valid(dev, port))
+		return -EINVAL;
+
+	qp = rdma_counter_get_qp(dev, qp_num);
+	if (!qp)
+		return -ENOENT;
+
+	if (rdma_is_port_valid(dev, qp->port) && (qp->port != port)) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	port_counter = &dev->port_data[port].port_counter;
+	if (!qp->counter || qp->counter->id != counter_id ||
+	    port_counter->mode.mode != RDMA_COUNTER_MODE_MANUAL) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	ret = rdma_counter_unbind_qp(qp, false);
+
+out:
+	rdma_restrack_put(&qp->res);
+	return ret;
+}
+
 void rdma_counter_init(struct ib_device *dev)
 {
 	struct rdma_port_counter *port_counter;
diff --git a/include/rdma/rdma_counter.h b/include/rdma/rdma_counter.h
index bf2c3578768f..6603e10eb352 100644
--- a/include/rdma/rdma_counter.h
+++ b/include/rdma/rdma_counter.h
@@ -28,6 +28,7 @@ struct rdma_counter_mode {
 struct rdma_port_counter {
 	struct rdma_counter_mode mode;
 	struct rdma_hw_stats *hstats;
+	unsigned int num_counters;
 	struct mutex lock;
 };
 
@@ -51,5 +52,11 @@ int rdma_counter_unbind_qp(struct ib_qp *qp, bool force);
 
 int rdma_counter_query_stats(struct rdma_counter *counter);
 u64 rdma_counter_get_hwstat_value(struct ib_device *dev, u8 port, u32 index);
+int rdma_counter_bind_qpn(struct ib_device *dev, u8 port,
+			  u32 qp_num, u32 counter_id);
+int rdma_counter_bind_qpn_alloc(struct ib_device *dev, u8 port,
+				u32 qp_num, u32 *counter_id);
+int rdma_counter_unbind_qpn(struct ib_device *dev, u8 port,
+			    u32 qp_num, u32 counter_id);
 
 #endif /* _RDMA_COUNTER_H_ */
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 22c5bc7a82dd..ebd728f9e351 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -536,6 +536,12 @@ enum rdma_nl_counter_mode {
 	 */
 	RDMA_COUNTER_MODE_AUTO,
 
+	/*
+	 * Which qp are bound with which counter is explicitly specified
+	 * by the user
+	 */
+	RDMA_COUNTER_MODE_MANUAL,
+
 	/*
 	 * Always the end
 	 */
-- 
2.20.1
