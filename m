From: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 05/14] drivers/infiniband: Use printf extension %pR for struct resource
Date: Fri, 12 Nov 2010 13:37:55 -0800
Message-ID: <d12116b0a742471f5df94bd93a946b9171cce114.1289597644.git.joe@perches.com>
References: <cover.1289597644.git.joe@perches.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1289597644.git.joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jiri Kosina <trivial-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Ralph Campbell <infinipath-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Using %pR standardizes the struct resource output.

Signed-off-by: Joe Perches <joe-6d6DIl74uiNBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/ipath/ipath_driver.c |    5 ++---
 1 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/ipath/ipath_driver.c b/drivers/infiniband/hw/ipath/ipath_driver.c
index 765f0fc..b33f045 100644
--- a/drivers/infiniband/hw/ipath/ipath_driver.c
+++ b/drivers/infiniband/hw/ipath/ipath_driver.c
@@ -530,9 +530,8 @@ static int __devinit ipath_init_one(struct pci_dev *pdev,
 	for (j = 0; j < 6; j++) {
 		if (!pdev->resource[j].start)
 			continue;
-		ipath_cdbg(VERBOSE, "BAR %d start %llx, end %llx, len %llx\n",
-			   j, (unsigned long long)pdev->resource[j].start,
-			   (unsigned long long)pdev->resource[j].end,
+		ipath_cdbg(VERBOSE, "BAR %d %pR, len %llx\n",
+			   j, &pdev->resource[j],
 			   (unsigned long long)pci_resource_len(pdev, j));
 	}
 
-- 
1.7.3.1.g432b3.dirty

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
