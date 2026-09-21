Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77FFE4570FA;
	Mon, 21 Sep 2026 08:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789980627; cv=none; b=lEDehHMa0kZjJc3dm2iQ5XprJAraKFPwSFitbQJxy/3XLwFsEqj7AZabpbfeKf/s3EdiuAEf0+wwmzwlqM2GKCtKh2SfvnPUTVEmd/u0EAXIQ1YcCb4BiuaCvXkJxQDiIvMLKqeFAcRx9Z7Ob9rg17APRkJGudnx4tRwlOqwMIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789980627; c=relaxed/simple;
	bh=1roAp1njcsMyiE7wSbk0IspcEIahhecqC9rN69VBbnM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YKr5NpTfAb1oqBVyCzT1vUgyvdg9JBDibuZPM11EHNwMIl54T76SyHOlEYCSwFjloxWupAYKzcnS7W1A+DlUDMQko3BRZwuV8gf+zgxBibCjVe67xPwkHIEzU84MCN/tFz9QdzDAjWBe0s8ikSHBmujlLegESSGASOlgK96hn70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZtouWXXp; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZtouWXXp"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68L2v2bd721555;
	Mon, 21 Sep 2026 08:50:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=corp-2025-04-25; bh=xZnfuy0MLFoO7/PvZGdS5CEeE7/Hb
	mCgxHT5yvfF75c=; b=ZtouWXXpl4QrrKgZqovn9dEzzJhqEkhLyWVTB+yJKcbh/
	YkGiZOj7lwInpcJWgv4Qevr8MTF/mDqXcGxsXu9IJTnVHdy9na7p8XvPn3DGomXj
	hRpHnPt5/2Xo+luTeC8xzD1ImXx2xUssnqHUg2OcStgedyHM1Mqt5Hdj/FFV8Lll
	9ZP4TxUZRuB+JPCPgSglfeUsUgsDzPa/L5eTnWcAfflQ1oSlCruwb19RoztDFrY5
	j1IV3/WI5PObM+ElOu5jw+Cxr74mESbHqC8XGkBxqt8ugKuGIE4ttsNlCr/YwpDE
	eVH/sI5iRKpYV7xUN7hxbx0jZttT5c1k45AD/coXg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4gsk2d1vt0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Sep 2026 08:50:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 68L8o0To034301;
	Mon, 21 Sep 2026 08:50:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4gtegmn3r5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 21 Sep 2026 08:50:12 +0000 (GMT)
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 68L8jOHG025134;
	Mon, 21 Sep 2026 08:50:11 GMT
Received: from pkannoju-dev-build.osdevelopmeniad.oraclevcn.com (pkannoju-dev-build.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.252.59])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4gtegmn3px-1;
	Mon, 21 Sep 2026 08:50:11 +0000 (GMT)
From: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
To: jgg@ziepe.ca, leon@kernel.org, saeedm@nvidia.com, tariqt@nvidia.com,
        mbloch@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, jiri@resnulli.us,
        kalesh-anakkur.purayil@broadcom.com, ynachum@amazon.com,
        kees@kernel.org, mrgolin@amazon.com, parav@nvidia.com,
        linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc: anand.a.khoje@oracle.com,
        Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
Subject: [PATCH v2] RDMA/mlx5: Add poll-EQ callback for ULP recovery
Date: Mon, 21 Sep 2026 08:50:06 +0000
Message-ID: <20260921085006.1443240-1-praveen.kannoju@oracle.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-21_03,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 lowpriorityscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 bulkscore=0
 spamscore=0 mlxscore=0 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2609040000 definitions=main-2609210126
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIxMDEyNSBTYWx0ZWRfX84bzhXzx/qpL
 t+uenacsH3JH1RspQzYQop4GqIcUyhV+7U2usoFGDKbD8qzCgeFnh7etaz/K70eGb8zEEvNh4pI
 rNdWnN75Sa0kDmKTkIsTfLYot59QeK7dlmLAFh0iNTbD8t3Uxr60VGtgwYHoX2TlafDBM2j0Bkn
 qdQ/VlCTrQpI2QEUnFWoBEzHShhnJolHEfjg+rAtdeOjZGzh0BJlWMD56tqOKtW1q0XcOfF1kK5
 C4s+soWws+CAYwZCy84kwzjjveiBYBfA3GGKo+/hwf9k4wQSF4Cu+ZgI3H8iwu90jtywdyNuCnU
 FgXJ6rsMcYjMyw77nsAZftaxg6VuR9Q++0RtUsX2ic4iOHGuj3yDYzNf2TCPwT0DHdN6talfeo7
 BRyK/9zBFCMa3iEnaxaIq0YfasWfkY+5gDxGdWFYkBQgHuGj+WgKh3hsYPJqYCSRZjDqlrprAs5
 JJK82zeVrRSQht5fGIg==
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIxMDEyNSBTYWx0ZWRfX/OcE+KV/WWgb
 i7yAY0ZTh/ZOwqL2gNOHPyqonlEIHFalDsS3WGU6YNjgKbpAOKPDXCBU2Ec4vW/gwhjbhAPwD1i
 S6KdSKpntgcKQyHSLL3jutapnkQcdPA1lmfUTeSqcgt2StCJkU29
X-Proofpoint-ORIG-GUID: Kp3y8Bf8CTv1sz5BIwO5VGdfT0XlI3Mm
X-Authority-Analysis: v=2.4 cv=f+Ddl+yM c=1 sm=1 tr=0 ts=6ab0efc5 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=VdqzKS8jKosA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=GFc6DVPmfN4-scXs8msA:9
X-Proofpoint-GUID: Kp3y8Bf8CTv1sz5BIwO5VGdfT0XlI3Mm

Some upper layer protocols, such as RDS, use mlx5 RDMA CQs whose
completion EQs are not shared with mlx5e queues. If an EQ notification is
missed for one of those CQs, the ULP can remain idle until another event
arrives or a driver health recovery path polls the EQ.

mlx5e already has a recovery path that polls a completion EQ from the tx
timeout handler through mlx5_eq_poll_irq_disabled(). That mechanism is
internal to the mlx5 core and is not reachable from RDMA ULPs such as RDS
when they need to recover a CQ-associated EQ.

Add an optional RDMA device operation, reap_eq, and an ib_reap_eq() helper
so ULPs can ask the provider to poll the event queue associated with a CQ.
Providers that do not implement the callback return -EOPNOTSUPP.

The recovery poll path is sleepable: mlx5 disables the IRQ synchronously
and serializes recovery polling with a mutex. Document that ib_reap_eq()
must be called from process context, assert the contract with
might_sleep(), and reject interrupt-context or IRQ-disabled callers with
-EWOULDBLOCK before invoking the provider callback.

Validate the device and CQ passed to ib_reap_eq() before dereferencing the
callback table or provider-private CQ storage. The mlx5 callback also
checks that the CQ belongs to the supplied device and that the mlx5 device
and completion EQ are present before polling.

Implement the callback for mlx5 by mapping the ib_cq to the mlx5 CQ and
polling the CQ's completion EQ through a new exported mlx5_eq_reap()
helper. mlx5_eq_reap() logs the EQ state, invokes
mlx5_eq_poll_irq_disabled(), and reports any recovered EQEs.

Serialize mlx5_eq_poll_irq_disabled() with a per-EQ mutex. The recovery
poll path disables the IRQ, runs the EQ handler, advances the EQ consumer
index, and updates the CI doorbell. Multiple recovery callers polling the
same EQ concurrently could race on that state and reap the same EQ in
parallel.

Use this only as a recovery path for missed EQ notifications. It is not a
normal completion polling path.

Signed-off-by: Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
---
v1: https://lore.kernel.org/linux-rdma/20260919100609.732391F000FF@smtp.kernel.org/T/#t

Changes in v2:
- Document ib_reap_eq() as process-context-only because the mlx5 recovery
  path may sleep while synchronously disabling the IRQ.
- Reject interrupt-context or IRQ-disabled callers with -EWOULDBLOCK before
  invoking the provider callback.
- Add might_sleep() assertions in ib_reap_eq() and
  mlx5_eq_poll_irq_disabled().
- Validate device/CQ input and CQ ownership before provider-private
  dereferences.
- Serialize mlx5_eq_poll_irq_disabled() with a per-EQ mutex so concurrent
  recovery callers cannot reap the same EQ in parallel.

 drivers/infiniband/core/device.c              |  1 +
 drivers/infiniband/hw/mlx5/main.c             | 18 ++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/eq.c  | 25 +++++++++++++-
 .../net/ethernet/mellanox/mlx5/core/lib/eq.h  |  2 ++
 include/linux/mlx5/eq.h                       |  2 ++
 include/rdma/ib_verbs.h                       | 34 +++++++++++++++++++
 6 files changed, 81 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 7a3ed5ecac00..a0a6e4a9ed50 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -3016,6 +3016,7 @@ void ib_set_device_ops(struct ib_device *dev, const struct ib_device_ops *ops)
 	SET_DEVICE_OP(dev_ops, rdma_netdev_get_params);
 	SET_DEVICE_OP(dev_ops, read_counters);
 	SET_DEVICE_OP(dev_ops, read_comp_cntr);
+	SET_DEVICE_OP(dev_ops, reap_eq);
 	SET_DEVICE_OP(dev_ops, reg_dm_mr);
 	SET_DEVICE_OP(dev_ops, reg_user_mr);
 	SET_DEVICE_OP(dev_ops, reg_user_mr_dmabuf);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 373ee1f42d4a..ae8d32358e82 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -22,6 +22,7 @@
 #include <rdma/ib_addr.h>
 #include <rdma/ib_cache.h>
 #include <linux/mlx5/port.h>
+#include <linux/mlx5/eq.h>
 #include <linux/mlx5/vport.h>
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/eswitch.h>
@@ -3654,6 +3655,22 @@ static void get_dev_fw_str(struct ib_device *ibdev, char *str)
 		 fw_rev_sub(dev->mdev));
 }
 
+static int mlx5_ib_reap_eq(struct ib_device *ibdev, struct ib_cq *ibcq)
+{
+	struct mlx5_ib_dev *dev;
+	struct mlx5_ib_cq *cq;
+
+	if (!ibdev || !ibcq || ibcq->device != ibdev)
+		return -EINVAL;
+
+	dev = to_mdev(ibdev);
+	if (!dev->mdev)
+		return -ENODEV;
+
+	cq = to_mcq(ibcq);
+	return mlx5_eq_reap(dev->mdev, cq->mcq.eq);
+}
+
 static int lag_event(struct notifier_block *nb, unsigned long event, void *data)
 {
 	struct mlx5_ib_dev *dev = container_of(nb, struct mlx5_ib_dev,
@@ -4642,6 +4659,7 @@ static const struct ib_device_ops mlx5_ib_dev_ops = {
 	.query_ucontext = mlx5_ib_query_ucontext,
 	.reg_user_mr = mlx5_ib_reg_user_mr,
 	.reg_user_mr_dmabuf = mlx5_ib_reg_user_mr_dmabuf,
+	.reap_eq = mlx5_ib_reap_eq,
 	.req_notify_cq = mlx5_ib_arm_cq,
 	.rereg_user_mr = mlx5_ib_rereg_user_mr,
 	.resize_user_cq = mlx5_ib_resize_cq,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eq.c b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
index d11ec263d53c..5a91cbf34125 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eq.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eq.c
@@ -148,21 +148,43 @@ static int mlx5_eq_comp_int(struct notifier_block *nb,
 /* Some architectures don't latch interrupts when they are disabled, so using
  * mlx5_eq_poll_irq_disabled could end up losing interrupts while trying to
  * avoid losing them.  It is not recommended to use it, unless this is the last
- * resort.
+ * resort. This function may sleep and must be called from process context.
  */
 u32 mlx5_eq_poll_irq_disabled(struct mlx5_eq_comp *eq)
 {
 	u32 count_eqe;
 
+	might_sleep();
+	mutex_lock(&eq->poll_lock);
 	disable_irq(eq->core.irqn);
 	count_eqe = eq->core.cons_index;
 	mlx5_eq_comp_int(&eq->irq_nb, 0, NULL);
 	count_eqe = eq->core.cons_index - count_eqe;
 	enable_irq(eq->core.irqn);
+	mutex_unlock(&eq->poll_lock);
 
 	return count_eqe;
 }
 
+int mlx5_eq_reap(struct mlx5_core_dev *dev, struct mlx5_eq_comp *eq)
+{
+	u32 eqe_count;
+
+	if (!dev || !eq)
+		return -EINVAL;
+
+	mlx5_core_dbg(dev, "EQ 0x%x: Cons = 0x%x, irqn = 0x%x\n",
+		      eq->core.eqn, eq->core.cons_index, eq->core.irqn);
+
+	eqe_count = mlx5_eq_poll_irq_disabled(eq);
+	if (eqe_count)
+		mlx5_core_warn(dev, "Recovered %d EQEs on EQ 0x%x\n",
+			       eqe_count, eq->core.eqn);
+
+	return 0;
+}
+EXPORT_SYMBOL(mlx5_eq_reap);
+
 static void mlx5_eq_async_int_lock(struct mlx5_eq_async *eq, bool recovery,
 				   unsigned long *flags)
 	__acquires(&eq->lock)
@@ -1012,6 +1034,7 @@ static int create_comp_eq(struct mlx5_core_dev *dev, u16 vecidx)
 	INIT_LIST_HEAD(&eq->tasklet_ctx.list);
 	INIT_LIST_HEAD(&eq->tasklet_ctx.process_list);
 	spin_lock_init(&eq->tasklet_ctx.lock);
+	mutex_init(&eq->poll_lock);
 	tasklet_setup(&eq->tasklet_ctx.task, mlx5_cq_tasklet_cb);
 
 	irq = xa_load(&table->comp_irqs, vecidx);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
index b1edc71ffc6d..ca019b3019aa 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/eq.h
@@ -6,6 +6,7 @@
 #include <linux/mlx5/driver.h>
 #include <linux/mlx5/eq.h>
 #include <linux/mlx5/cq.h>
+#include <linux/mutex.h>
 
 #define MLX5_EQE_SIZE       (sizeof(struct mlx5_eqe))
 
@@ -46,6 +47,7 @@ struct mlx5_eq_comp {
 	struct notifier_block   irq_nb;
 	struct mlx5_eq_tasklet  tasklet_ctx;
 	struct list_head        list;
+	struct mutex            poll_lock; /* protect recovery polling */
 };
 
 static inline u32 eq_get_size(struct mlx5_eq *eq)
diff --git a/include/linux/mlx5/eq.h b/include/linux/mlx5/eq.h
index 3705a382276b..a053f9eb2614 100644
--- a/include/linux/mlx5/eq.h
+++ b/include/linux/mlx5/eq.h
@@ -9,6 +9,7 @@
 #define MLX5_NUM_SPARE_EQE (0x80)
 
 struct mlx5_eq;
+struct mlx5_eq_comp;
 struct mlx5_irq;
 struct mlx5_core_dev;
 
@@ -29,6 +30,7 @@ void mlx5_eq_disable(struct mlx5_core_dev *dev, struct mlx5_eq *eq,
 
 struct mlx5_eqe *mlx5_eq_get_eqe(struct mlx5_eq *eq, u32 cc);
 void mlx5_eq_update_ci(struct mlx5_eq *eq, u32 cc, bool arm);
+int mlx5_eq_reap(struct mlx5_core_dev *dev, struct mlx5_eq_comp *eq);
 
 /* The HCA will think the queue has overflowed if we
  * don't tell it we've been processing events.  We
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index cb3b6163961b..c9a41c88839a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -13,6 +13,7 @@
 #define IB_VERBS_H
 
 #include <linux/ethtool.h>
+#include <linux/kernel.h>
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/bvec.h>
@@ -2542,6 +2543,7 @@ struct ib_device_ops {
 	int (*poll_cq)(struct ib_cq *cq, int num_entries, struct ib_wc *wc);
 	int (*peek_cq)(struct ib_cq *cq, int wc_cnt);
 	int (*req_notify_cq)(struct ib_cq *cq, enum ib_cq_notify_flags flags);
+	int (*reap_eq)(struct ib_device *device, struct ib_cq *cq);
 	int (*post_srq_recv)(struct ib_srq *srq,
 			     const struct ib_recv_wr *recv_wr,
 			     const struct ib_recv_wr **bad_recv_wr);
@@ -4296,6 +4298,38 @@ static inline int ib_req_notify_cq(struct ib_cq *cq,
 	return cq->device->ops.req_notify_cq(cq, flags);
 }
 
+/**
+ * ib_reap_eq - Poll the event queue associated with a CQ.
+ * @device: Device that owns the CQ.
+ * @cq: CQ whose associated event queue should be polled.
+ *
+ * Poll the device event queue associated with @cq to recover completions
+ * after a missed event queue notification. This is an optional provider
+ * callback.
+ *
+ * This helper may sleep and must be called from process context without
+ * spinlocks held or IRQs disabled.
+ *
+ * Return: 0 on success, %-EINVAL for invalid input, %-EWOULDBLOCK when
+ * called from interrupt context or with IRQs disabled, and %-EOPNOTSUPP
+ * when unsupported.
+ */
+static inline int ib_reap_eq(struct ib_device *device, struct ib_cq *cq)
+{
+	if (!device || !cq || cq->device != device)
+		return -EINVAL;
+
+	if (WARN_ON_ONCE(in_interrupt() || irqs_disabled()))
+		return -EWOULDBLOCK;
+
+	might_sleep();
+
+	if (!device->ops.reap_eq)
+		return -EOPNOTSUPP;
+
+	return device->ops.reap_eq(device, cq);
+}
+
 struct ib_cq *ib_cq_pool_get(struct ib_device *dev, unsigned int nr_cqe,
 			     int comp_vector_hint,
 			     enum ib_poll_context poll_ctx);
-- 
2.43.7

