From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/qib: Add support for the new QMH7360 card
Date: Fri, 16 Jan 2015 08:55:37 -0500
Message-ID: <20150116135537.18232.63517.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Vinit Agnihotri <vinit.abhay.agnihotri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add support to recognize another board variation named QMH7360.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Vinit Agnihotri <vinit.abhay.agnihotri-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_iba7322.c |    5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/infiniband/hw/qib/qib_iba7322.c b/drivers/infiniband/hw/qib/qib_iba7322.c
index 23ca2ac..a07f7f2 100644
--- a/drivers/infiniband/hw/qib/qib_iba7322.c
+++ b/drivers/infiniband/hw/qib/qib_iba7322.c
@@ -158,6 +158,7 @@ MODULE_PARM_DESC(txselect, \
 
 #define BOARD_QME7342 5
 #define BOARD_QMH7342 6
+#define BOARD_QMH7360 9
 #define IS_QMH(dd) (SYM_FIELD((dd)->revision, Revision, BoardID) == \
 		    BOARD_QMH7342)
 #define IS_QME(dd) (SYM_FIELD((dd)->revision, Revision, BoardID) == \
@@ -3617,6 +3618,10 @@ static unsigned qib_7322_boardname(struct qib_devdata *dd)
 		n = "InfiniPath_QME7362";
 		dd->flags |= QIB_HAS_QSFP;
 		break;
+	case BOARD_QMH7360:
+		n = "Intel IB QDR 1P FLR-QSFP Adptr";
+		dd->flags |= QIB_HAS_QSFP;
+		break;
 	case 15:
 		n = "InfiniPath_QLE7342_TEST";
 		dd->flags |= QIB_HAS_QSFP;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
