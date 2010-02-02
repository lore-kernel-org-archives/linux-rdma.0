From: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH v2 13/18] IB/umad: clean whitespace
Date: Tue, 02 Feb 2010 12:08:50 -0700
Message-ID: <20100202190850.28217.88334.stgit@bob.kio>
References: <20100202185235.28217.64521.stgit@bob.kio>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100202185235.28217.64521.stgit-tBlMHHroXgg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, justin.chen-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Clean errors as shown when 'let c_space_errors=1' is set in vim.

Signed-off-by: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
---

 drivers/infiniband/core/user_mad.c |   26 +++++++++++++-------------
 1 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 7fc1e51..3595bd5 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -487,8 +487,8 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 		ah_attr.ah_flags = IB_AH_GRH;
 		memcpy(ah_attr.grh.dgid.raw, packet->mad.hdr.gid, 16);
 		ah_attr.grh.sgid_index	   = packet->mad.hdr.gid_index;
-		ah_attr.grh.flow_label 	   = be32_to_cpu(packet->mad.hdr.flow_label);
-		ah_attr.grh.hop_limit  	   = packet->mad.hdr.hop_limit;
+		ah_attr.grh.flow_label	   = be32_to_cpu(packet->mad.hdr.flow_label);
+		ah_attr.grh.hop_limit	   = packet->mad.hdr.hop_limit;
 		ah_attr.grh.traffic_class  = packet->mad.hdr.traffic_class;
 	}
 
@@ -519,9 +519,9 @@ static ssize_t ib_umad_write(struct file *filp, const char __user *buf,
 		goto err_ah;
 	}
 
-	packet->msg->ah 	= ah;
+	packet->msg->ah		= ah;
 	packet->msg->timeout_ms = packet->mad.hdr.timeout_ms;
-	packet->msg->retries 	= packet->mad.hdr.retries;
+	packet->msg->retries	= packet->mad.hdr.retries;
 	packet->msg->context[0] = packet;
 
 	/* Copy MAD header.  Any RMPP header is already in place. */
@@ -856,16 +856,16 @@ static int ib_umad_close(struct inode *inode, struct file *filp)
 }
 
 static const struct file_operations umad_fops = {
-	.owner 	 	= THIS_MODULE,
-	.read 	 	= ib_umad_read,
-	.write 	 	= ib_umad_write,
-	.poll 	 	= ib_umad_poll,
+	.owner		= THIS_MODULE,
+	.read		= ib_umad_read,
+	.write		= ib_umad_write,
+	.poll		= ib_umad_poll,
 	.unlocked_ioctl = ib_umad_ioctl,
 #ifdef CONFIG_COMPAT
-	.compat_ioctl 	= ib_umad_compat_ioctl,
+	.compat_ioctl	= ib_umad_compat_ioctl,
 #endif
-	.open 	 	= ib_umad_open,
-	.release 	= ib_umad_close
+	.open		= ib_umad_open,
+	.release	= ib_umad_close
 };
 
 static int ib_umad_sm_open(struct inode *inode, struct file *filp)
@@ -930,8 +930,8 @@ static int ib_umad_sm_close(struct inode *inode, struct file *filp)
 }
 
 static const struct file_operations umad_sm_fops = {
-	.owner 	 = THIS_MODULE,
-	.open 	 = ib_umad_sm_open,
+	.owner	 = THIS_MODULE,
+	.open	 = ib_umad_sm_open,
 	.release = ib_umad_sm_close
 };
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
