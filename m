From: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 for-next 01/15] IB/usnic: Fix stack frame size exceed warnings
Date: Thu,  9 Jan 2014 14:47:29 -0800
Message-ID: <1389307663-11296-2-git-send-email-umalhi@cisco.com>
References: <1389307663-11296-1-git-send-email-umalhi@cisco.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389307663-11296-1-git-send-email-umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Compiler spits out *stack frame size exceeds* warnings on usNIC code
when CONFIG_FRAME_WARN=1024.  Keep stack frame size under 1024
everywhere in usNIC code.

Signed-off-by: Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_main.c   | 2 +-
 drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index 2bbfa09..1771eec 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -73,7 +73,7 @@ static void usnic_ib_dump_vf(struct usnic_ib_vf *vf, char *buf, int buf_sz)
 
 void usnic_ib_log_vf(struct usnic_ib_vf *vf)
 {
-	char buf[1024];
+	char buf[1000];
 	usnic_ib_dump_vf(vf, buf, sizeof(buf));
 	usnic_dbg(buf);
 }
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
index 24da928..5ba8678 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_qp_grp.c
@@ -430,7 +430,7 @@ static void qp_grp_and_vf_unbind(struct usnic_ib_qp_grp *qp_grp)
 static void log_spec(const struct usnic_vnic_res_spec
 					const *res_spec)
 {
-	char buf[1024];
+	char buf[512];
 	usnic_vnic_spec_dump(buf, sizeof(buf), res_spec);
 	usnic_dbg(buf);
 }
-- 
1.8.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
