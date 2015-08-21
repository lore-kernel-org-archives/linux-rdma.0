From: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>
Subject: [PATCH] staging/hfi1: replace indent spaces with tabs
Date: Fri, 21 Aug 2015 12:26:22 -0700
Message-ID: <1440185182-56772-1-git-send-email-Jeffrey.C.Becker@nasa.gov>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Running checkpatch.pl on mad.c produces several 
"ERROR: code indent should use tabs where possible" messages.
This patch fixes these.

Signed-off-by: Jeff Becker <Jeffrey.C.Becker-NSQ8wuThN14@public.gmane.org>

---
 drivers/staging/hfi1/mad.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/hfi1/mad.c b/drivers/staging/hfi1/mad.c
index 0a18fee..37269eb 100644
--- a/drivers/staging/hfi1/mad.c
+++ b/drivers/staging/hfi1/mad.c
@@ -4075,11 +4075,11 @@ bail:
 }
 
 static int hfi1_process_opa_mad(struct ib_device *ibdev, int mad_flags,
-			        u8 port, const struct ib_wc *in_wc,
-			        const struct ib_grh *in_grh,
-			        const struct opa_mad *in_mad,
-			        struct opa_mad *out_mad, size_t *out_mad_size,
-			        u16 *out_mad_pkey_index)
+				u8 port, const struct ib_wc *in_wc,
+				const struct ib_grh *in_grh,
+				const struct opa_mad *in_mad,
+				struct opa_mad *out_mad, size_t *out_mad_size,
+				u16 *out_mad_pkey_index)
 {
 	int ret;
 	int pkey_idx;
-- 
2.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
