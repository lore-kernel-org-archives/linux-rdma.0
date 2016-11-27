From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 07/10] IB/uverbs: Propagate supported QP types to user-space
Date: Sun, 27 Nov 2016 16:51:33 +0200
Message-ID: <1480258296-27032-8-git-send-email-leon@kernel.org>
References: <1480258296-27032-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1480258296-27032-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Selvin Xavier <selvin.xavier-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Devesh Sharma <devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Mitesh Ahuja <mitesh.ahuja-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>, Christian Benvenuti <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Propagate supported qp types to user-space when they issue a query
port call. From user-space point of view, zero means that the query
is not supported, under the reasoning that it doesn't make sense
to have user-space devices that don't support any qp type. Note that
this will only happen when they run over older kernels.

Make sure to filter out qp types which are not supported for
user-space (SMI, GSI, etc).

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 2 ++
 include/uapi/rdma/ib_user_verbs.h    | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index cb3f515a..1c386bc 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -526,6 +526,8 @@ ssize_t ib_uverbs_query_port(struct ib_uverbs_file *file,
 	resp.phys_state      = attr.phys_state;
 	resp.link_layer      = rdma_port_get_link_layer(ib_dev,
 							cmd.port_num);
+	/* don't expose to user-space QPTs they don't know */
+	resp.qp_type_cap = attr.qp_type_cap & ~(BIT(IB_QPT_SMI) | BIT(IB_QPT_GSI));
 
 	if (copy_to_user((void __user *) (unsigned long) cmd.response,
 			 &resp, sizeof resp))
diff --git a/include/uapi/rdma/ib_user_verbs.h b/include/uapi/rdma/ib_user_verbs.h
index 25225eb..a50604f 100644
--- a/include/uapi/rdma/ib_user_verbs.h
+++ b/include/uapi/rdma/ib_user_verbs.h
@@ -276,7 +276,7 @@ struct ib_uverbs_query_port_resp {
 	__u8  active_speed;
 	__u8  phys_state;
 	__u8  link_layer;
-	__u8  reserved[2];
+	__u16 qp_type_cap;
 };
 
 struct ib_uverbs_alloc_pd {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
