From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 13/14] RDMA/verbs: Check existence of function prior to accessing it
Date: Wed, 14 Feb 2018 14:38:43 +0200
Message-ID: <20180214123844.30321-14-leon@kernel.org>
References: <20180214123844.30321-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180214123844.30321-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Update all the flows to ensure that function pointer exists prior
to accessing it. It will allow to remove uverbs_ex_mask variable
in the next patch.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h  |  3 +++
 drivers/infiniband/core/uverbs_cmd.c | 21 +++++++++++++++++++++
 2 files changed, 24 insertions(+)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index c4560d84dfae..c91f9a80b831 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -309,6 +309,9 @@ static inline struct ib_qp *_ib_create_qp(struct ib_device *dev,
 {
 	struct ib_qp *qp;
 
+	if (!dev->create_qp)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	qp = dev->create_qp(pd, attr, udata);
 	if (IS_ERR(qp))
 		return qp;
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 256934d1f64f..2b149e52b355 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -979,6 +979,9 @@ static struct ib_ucq_object *create_cq(struct ib_uverbs_file *file,
 	struct ib_uverbs_ex_create_cq_resp resp;
 	struct ib_cq_init_attr attr = {};
 
+	if (!ib_dev->create_cq)
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (cmd->comp_vector >= file->device->num_comp_vectors)
 		return ERR_PTR(-EINVAL);
 
@@ -2941,6 +2944,11 @@ int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
 		wq_init_attr.create_flags = cmd.create_flags;
 	obj->uevent.events_reported = 0;
 	INIT_LIST_HEAD(&obj->uevent.event_list);
+
+	if (!pd->device->create_wq) {
+		err = -EOPNOTSUPP;
+		goto err_put_cq;
+	}
 	wq = pd->device->create_wq(pd, &wq_init_attr, uhw);
 	if (IS_ERR(wq)) {
 		err = PTR_ERR(wq);
@@ -3084,7 +3092,12 @@ int ib_uverbs_ex_modify_wq(struct ib_uverbs_file *file,
 		wq_attr.flags = cmd.flags;
 		wq_attr.flags_mask = cmd.flags_mask;
 	}
+	if (!wq->device->modify_wq) {
+		ret = -EOPNOTSUPP;
+		goto out;
+	}
 	ret = wq->device->modify_wq(wq, &wq_attr, cmd.attr_mask, uhw);
+out:
 	uobj_put_obj_read(wq);
 	return ret;
 }
@@ -3181,6 +3194,11 @@ int ib_uverbs_ex_create_rwq_ind_table(struct ib_uverbs_file *file,
 
 	init_attr.log_ind_tbl_size = cmd.log_ind_tbl_size;
 	init_attr.ind_tbl = wqs;
+
+	if (!ib_dev->create_rwq_ind_table) {
+		err = -EOPNOTSUPP;
+		goto err_uobj;
+	}
 	rwq_ind_tbl = ib_dev->create_rwq_ind_table(ib_dev, &init_attr, uhw);
 
 	if (IS_ERR(rwq_ind_tbl)) {
@@ -3770,6 +3788,9 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	struct ib_device_attr attr = {0};
 	int err;
 
+	if (!ib_dev->query_device)
+		return -EOPNOTSUPP;
+
 	if (ucore->inlen < sizeof(cmd))
 		return -EINVAL;
 
-- 
2.16.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
