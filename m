From: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Subject: [PATCH v2 17/18] IB/ucm: clean whitespace errors
Date: Tue, 02 Feb 2010 12:09:11 -0700
Message-ID: <20100202190911.28217.23795.stgit@bob.kio>
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

As shown when 'let c_space_errors=1' is set in vim.

Signed-off-by: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
---

 drivers/infiniband/core/ucm.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/ucm.c b/drivers/infiniband/core/ucm.c
index 1203ca4..7bf0a82 100644
--- a/drivers/infiniband/core/ucm.c
+++ b/drivers/infiniband/core/ucm.c
@@ -1223,10 +1223,10 @@ static void ib_ucm_release_dev(struct device *dev)
 }
 
 static const struct file_operations ucm_fops = {
-	.owner 	 = THIS_MODULE,
-	.open 	 = ib_ucm_open,
+	.owner	 = THIS_MODULE,
+	.open	 = ib_ucm_open,
 	.release = ib_ucm_close,
-	.write 	 = ib_ucm_write,
+	.write	 = ib_ucm_write,
 	.poll    = ib_ucm_poll,
 };
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
