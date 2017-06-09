From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH for-next 10/10] IB/hfi1: Handle missing magic values in
 config file
Date: Fri, 09 Jun 2017 16:00:26 -0700
Message-ID: <20170609230024.26710.48240.stgit@scvm10.sc.intel.com>
References: <20170609225424.26710.70167.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170609225424.26710.70167.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Driver does not check whether proper configuration file exist in EPROM,
and treats empty partition as possible valid configuration, preventing
fallback to default firmware. Change EPROM read function to treat
missing magic number as read error.

Reviewed-by: Jakub Byczkowski <jakub.byczkowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jan Sokolowski <jan.sokolowski-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/eprom.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/eprom.c b/drivers/infiniband/hw/hfi1/eprom.c
index 26da124..d46b171 100644
--- a/drivers/infiniband/hw/hfi1/eprom.c
+++ b/drivers/infiniband/hw/hfi1/eprom.c
@@ -250,7 +250,6 @@ static int read_partition_platform_config(struct hfi1_devdata *dd, void **data,
 {
 	void *buffer;
 	void *p;
-	u32 length;
 	int ret;
 
 	buffer = kmalloc(P1_SIZE, GFP_KERNEL);
@@ -265,13 +264,13 @@ static int read_partition_platform_config(struct hfi1_devdata *dd, void **data,
 
 	/* scan for image magic that may trail the actual data */
 	p = strnstr(buffer, IMAGE_TRAIL_MAGIC, P1_SIZE);
-	if (p)
-		length = p - buffer;
-	else
-		length = P1_SIZE;
+	if (!p) {
+		kfree(buffer);
+		return -ENOENT;
+	}
 
 	*data = buffer;
-	*size = length;
+	*size = p - buffer;
 	return 0;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
