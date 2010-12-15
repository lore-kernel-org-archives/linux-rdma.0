From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH] infiniband-diags: Verify timeout value specified to
 diagnostics
Date: Wed, 15 Dec 2010 11:47:09 -0800
Message-ID: <20101215114709.82671602.weiny2@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Verify timeout value specified to diagnostics


Signed-off-by: Ira Weiny <weiny2-eSE4LqFkL++LYFxP40JT4w@public.gmane.org>
---
 infiniband-diags/src/ibdiag_common.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/infiniband-diags/src/ibdiag_common.c b/infiniband-diags/src/ibdiag_common.c
index 99861f1..8ccf2fc 100644
--- a/infiniband-diags/src/ibdiag_common.c
+++ b/infiniband-diags/src/ibdiag_common.c
@@ -175,9 +175,13 @@ static int process_opt(int ch, char *optarg)
 		ibd_dest_type = IB_DEST_GUID;
 		break;
 	case 't':
-		val = strtoul(optarg, 0, 0);
-		madrpc_set_timeout(val);
-		ibd_timeout = val;
+		val = (int)strtol(optarg, NULL, 0);
+		if (val > 0) {
+			madrpc_set_timeout(val);
+			ibd_timeout = val;
+		} else
+			IBERROR("Invalid timeout \"%s\".  Timeout requires a "
+				"positive integer value.", optarg);
 		break;
 	case 's':
 		/* srcport is not required when resolving via IB_DEST_LID */
-- 
1.5.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
