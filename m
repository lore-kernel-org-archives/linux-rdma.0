From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 7/8] nvme.h: Add keep-alive opcode and identify controller attribute
Date: Mon, 13 Jun 2016 16:45:27 +0200
Message-ID: <1465829128-22993-8-git-send-email-hch@lst.de>
References: <1465829128-22993-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465829128-22993-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

KAS: keep-alive support and granularity of kato in units of 100 ms
nvme_admin_keep_alive opcode: 0x18

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 include/linux/nvme.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/nvme.h b/include/linux/nvme.h
index 7525030..d8b37ba 100644
--- a/include/linux/nvme.h
+++ b/include/linux/nvme.h
@@ -202,7 +202,9 @@ struct nvme_id_ctrl {
 	__u8			apsta;
 	__le16			wctemp;
 	__le16			cctemp;
-	__u8			rsvd270[242];
+	__u8			rsvd270[50];
+	__le16			kas;
+	__u8			rsvd322[190];
 	__u8			sqes;
 	__u8			cqes;
 	__le16			maxcmd;
@@ -556,6 +558,7 @@ enum nvme_admin_opcode {
 	nvme_admin_async_event		= 0x0c,
 	nvme_admin_activate_fw		= 0x10,
 	nvme_admin_download_fw		= 0x11,
+	nvme_admin_keep_alive		= 0x18,
 	nvme_admin_format_nvm		= 0x80,
 	nvme_admin_security_send	= 0x81,
 	nvme_admin_security_recv	= 0x82,
@@ -580,6 +583,7 @@ enum {
 	NVME_FEAT_WRITE_ATOMIC	= 0x0a,
 	NVME_FEAT_ASYNC_EVENT	= 0x0b,
 	NVME_FEAT_AUTO_PST	= 0x0c,
+	NVME_FEAT_KATO		= 0x0f,
 	NVME_FEAT_SW_PROGRESS	= 0x80,
 	NVME_FEAT_HOST_ID	= 0x81,
 	NVME_FEAT_RESV_MASK	= 0x82,
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
