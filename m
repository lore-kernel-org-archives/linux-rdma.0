From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH infiniband-diags] ibdiag_sa.c: In sa_get_handle, handle umad_open_port
 and umad_register failures
Date: Thu, 07 May 2015 13:54:52 +0300
Message-ID: <554B447C.1040003@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Treat umad_open_port and umad_register errors as failures for sa_get_handle

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/src/ibdiag_sa.c b/src/ibdiag_sa.c
index 018a428..a089aee 100644
--- a/src/ibdiag_sa.c
+++ b/src/ibdiag_sa.c
@@ -60,18 +60,32 @@ struct sa_handle * sa_get_handle(void)
 		IBWARN("No SM/SA found on port %s:%d",
 			ibd_ca ? "" : ibd_ca,
 			ibd_ca_port);
-		free(handle);
-		return (NULL);
+		goto err;
 	}
 
 	handle->dport.qp = 1;
 	if (!handle->dport.qkey)
 		handle->dport.qkey = IB_DEFAULT_QP1_QKEY;
 
-	handle->fd = umad_open_port(ibd_ca, ibd_ca_port);
-	handle->agent = umad_register(handle->fd, IB_SA_CLASS, 2, 1, NULL);
+	if ((handle->fd = umad_open_port(ibd_ca, ibd_ca_port)) < 0) {
+		IBWARN("umad_open_port on port %s:%d failed",
+			ibd_ca ? "" : ibd_ca,
+			ibd_ca_port);
+		goto err;
+	}
+	if ((handle->agent = umad_register(handle->fd, IB_SA_CLASS, 2, 1, NULL)) < 0) {
+		umad_close_port(handle->fd);
+		IBWARN("umad_register for SA class failed on port %s:%d",
+		       ibd_ca ? "" : ibd_ca,
+		       ibd_ca_port);
+		goto err;
+	}
 
 	return handle;
+
+err:
+	free(handle);
+	return (NULL);
 }
 
 void sa_free_handle(struct sa_handle * h)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
