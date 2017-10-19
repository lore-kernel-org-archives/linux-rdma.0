From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next 02/16] IB/uverbs: Expose max_counter_sets capability
Date: Thu, 19 Oct 2017 17:41:44 +0300
Message-ID: <1508424118-27205-3-git-send-email-yishaih@mellanox.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1508424118-27205-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

max_counter_sets represents the number of different counter sets
exposed from the device.
A valid counter set id must be in range of [0, max_counter_sets - 1],
it will be used with counter set verbs in downstream patches in
this series.

Signed-off-by: Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 8 ++++++++
 include/uapi/rdma/ib_user_verbs.h    | 2 ++
 2 files changed, 10 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index ce969cc..9c6b795 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3861,6 +3861,14 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 	resp.cq_moderation_caps.max_cq_moderation_period =
 		attr.cq_caps.max_cq_moderation_period;
 	resp.response_length += sizeof(resp.cq_moderation_caps);
+
+	if (ucore->outlen < resp.response_length +
+		sizeof(resp.max_counter_sets) + sizeof(resp.reserved))
+		goto end;
+
+	resp.max_counter_sets = attr.max_counter_sets;
+	resp.response_length += sizeof(resp.max_counter_sets) +
+			 sizeof(resp.reserved);
 end:
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	return err;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 7745a0e..b3f952c 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -270,6 +270,8 @@ struct ib_uverbs_ex_query_device_resp {
 	__u32 raw_packet_caps;
 	struct ib_uverbs_tm_caps tm_caps;
 	struct ib_uverbs_cq_caps cq_moderation_caps;
+	__u16 max_counter_sets;
+	__u8 reserved[6];
 };
 
 struct ib_uverbs_query_port {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
