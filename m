From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 05/11] IB/uverbs: Expose vlan offloads capabilities
Date: Wed, 18 Jan 2017 15:39:58 +0200
Message-ID: <20170118134004.5380-6-leon@kernel.org>
References: <20170118134004.5380-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118134004.5380-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Expose raw packet capabilities to user space as part of query device.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 6 ++++++
 include/uapi/rdma/ib_user_verbs.h    | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 7007822..48c7852 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -4323,6 +4323,12 @@ int ib_uverbs_ex_query_device(struct ib_uverbs_file *file,
 
 	resp.max_wq_type_rq = attr.max_wq_type_rq;
 	resp.response_length += sizeof(resp.max_wq_type_rq);
+
+	if (ucore->outlen < resp.response_length + sizeof(resp.raw_packet_caps))
+		goto end;
+
+	resp.raw_packet_caps = attr.raw_packet_caps;
+	resp.response_length += sizeof(resp.raw_packet_caps);
 end:
 	err = ib_copy_to_udata(ucore, &resp, resp.response_length);
 	return err;
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index dfdfe4e..4811b6a 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -247,7 +247,7 @@ struct ib_uverbs_ex_query_device_resp {
 	__u64 device_cap_flags_ex;
 	struct ib_uverbs_rss_caps rss_caps;
 	__u32  max_wq_type_rq;
-	__u32 reserved;
+	__u32 raw_packet_caps;
 };
 
 struct ib_uverbs_query_port {
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
