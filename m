From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 06/11] IB/uverbs: Enable WQ creation and modification with cvlan offload
Date: Wed, 18 Jan 2017 15:39:59 +0200
Message-ID: <20170118134004.5380-7-leon@kernel.org>
References: <20170118134004.5380-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118134004.5380-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Enable user space application via WQ creation and modification to
turn on and off cvlan offload.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 9 ++++++++-
 include/uapi/rdma/ib_user_verbs.h    | 4 ++++
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 48c7852..014143a 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3325,6 +3325,9 @@ int ib_uverbs_ex_create_wq(struct ib_uverbs_file *file,
 	wq_init_attr.wq_context = file;
 	wq_init_attr.wq_type = cmd.wq_type;
 	wq_init_attr.event_handler = ib_uverbs_wq_event_handler;
+	if (ucore->inlen >= (offsetof(typeof(cmd), create_flags) +
+			     sizeof(cmd.create_flags)))
+		wq_init_attr.create_flags = cmd.create_flags;
 	obj->uevent.events_reported = 0;
 	INIT_LIST_HEAD(&obj->uevent.event_list);
 	wq = pd->device->create_wq(pd, &wq_init_attr, uhw);
@@ -3480,7 +3483,7 @@ int ib_uverbs_ex_modify_wq(struct ib_uverbs_file *file,
 	if (!cmd.attr_mask)
 		return -EINVAL;
 
-	if (cmd.attr_mask > (IB_WQ_STATE | IB_WQ_CUR_STATE))
+	if (cmd.attr_mask > (IB_WQ_STATE | IB_WQ_CUR_STATE | IB_WQ_FLAGS))
 		return -EINVAL;
 
 	wq = idr_read_wq(cmd.wq_handle, file->ucontext);
@@ -3489,6 +3492,10 @@ int ib_uverbs_ex_modify_wq(struct ib_uverbs_file *file,
 
 	wq_attr.curr_wq_state = cmd.curr_wq_state;
 	wq_attr.wq_state = cmd.wq_state;
+	if (cmd.attr_mask & IB_WQ_FLAGS) {
+		wq_attr.flags = cmd.flags;
+		wq_attr.flags_mask = cmd.flags_mask;
+	}
 	ret = wq->device->modify_wq(wq, &wq_attr, cmd.attr_mask, uhw);
 	put_wq_read(wq);
 	return ret;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 4811b6a..598f095 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -1048,6 +1048,8 @@ struct ib_uverbs_ex_create_wq  {
 	__u32 cq_handle;
 	__u32 max_wr;
 	__u32 max_sge;
+	__u32 create_flags; /* Use enum ib_wq_flags */
+	__u32 reserved;
 };
 
 struct ib_uverbs_ex_create_wq_resp {
@@ -1076,6 +1078,8 @@ struct ib_uverbs_ex_modify_wq  {
 	__u32 wq_handle;
 	__u32 wq_state;
 	__u32 curr_wq_state;
+	__u32 flags; /* Use enum ib_wq_flags */
+	__u32 flags_mask; /* Use enum ib_wq_flags */
 };
 
 /* Prevent memory allocation rather than max expected size */
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
