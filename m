From: Chris Moore <Chris.Moore-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] iser-target: Handle errors from isert_put_datain and
 isert_get_dataout
Date: Fri, 6 Mar 2015 17:56:34 +0000
Message-ID: <462EF229174FDB4D92ACE4656EA561005DD2BD41@CMEXMB1.ad.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Sagi Grimberg (sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org)" <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "target-devel (target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

isert_put_datain() always returns 1 and isert_get_dataout() always returns 0, even if
ib_post_send() fails.   They should return an error in this case so the caller can handle it.
Also, in the case of an ib_post_send() failure, user isert_err instead of isert_warn.  

With these changes, these two functions handle errors from ib_post_send() in the 
same way as other functions within ib_isert.c

Signed-off-by: Chris Moore <chris.moore-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

---

diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 075b19c..7394ba9 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -2860,8 +2860,10 @@ isert_put_datain(struct iscsi_conn *conn, struct iscsi_cmd *cmd)
 	}
 
 	rc = ib_post_send(isert_conn->conn_qp, wr->send_wr, &wr_failed);
-	if (rc)
-		isert_warn("ib_post_send() failed for IB_WR_RDMA_WRITE\n");
+	if (rc) {
+		isert_err("ib_post_send() failed for IB_WR_RDMA_WRITE\n");
+		return rc;
+	}
 
 	if (!isert_prot_cmd(isert_conn, se_cmd))
 		isert_dbg("Cmd: %p posted RDMA_WRITE + Response for iSER Data "
@@ -2894,8 +2896,10 @@ isert_get_dataout(struct iscsi_conn *conn, struct iscsi_cmd *cmd, bool recovery)
 	}
 
 	rc = ib_post_send(isert_conn->conn_qp, wr->send_wr, &wr_failed);
-	if (rc)
-		isert_warn("ib_post_send() failed for IB_WR_RDMA_READ\n");
+	if (rc) {
+		isert_err("ib_post_send() failed for IB_WR_RDMA_READ\n");
+		return rc;
+	}
 
 	isert_dbg("Cmd: %p posted RDMA_READ memory for ISER Data WRITE\n",
 		 isert_cmd);
---

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
