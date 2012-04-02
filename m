From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/2] IB/core: add missing string for the display of SDR rates in sysfs
Date: Mon,  2 Apr 2012 17:45:21 +0300
Message-ID: <1333377921-8349-3-git-send-email-ogerlitz@mellanox.com>
References: <1333377921-8349-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1333377921-8349-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

commits 2e96691c "IB: Use central enum for speed instead of hard-coded values"
and  e9319b0cb "IB/core: Fix SDR rates in sysfs" still didn't fill in the "SDR"
string in the SDR switch case, fix that.
---
 drivers/infiniband/core/sysfs.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 83b720e..1611569 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -188,6 +188,7 @@ static ssize_t rate_show(struct ib_port *p, struct port_attribute *unused,
 
 	switch (attr.active_speed) {
 	case IB_SPEED_SDR:
+		speed = " SDR";
 		rate = 25;
 		break;
 	case IB_SPEED_DDR:
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
