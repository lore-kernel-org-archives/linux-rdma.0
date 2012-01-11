From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 2/6] IB/core: fix wrong display of rate in sysfs
Date: Wed, 11 Jan 2012 18:56:50 +0200
Message-ID: <alpine.LRH.2.00.1201111856160.10264@ogerlitz.voltaire.com>
References: <alpine.LRH.2.00.1201111850330.10264@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201111850330.10264-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Marcel Apfelbaum <marcela-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dotan Barak <dotanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

commit 71eeba16 "IB: Add new InfiniBand link speeds" introduced a bug
under which the rate for IB SDR/4X links was displayed as 8.5Gbs
instead of 10Gbs, fix that.

Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c |   12 +++++++++---
 1 files changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 9ce70ca..0b3edc0 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -213,12 +213,18 @@ static ssize_t rate_show(struct ib_port *p, struct port_attribute *unused,
 	}

 	rate *= ib_width_enum_to_int(attr.active_width);
+
 	if (rate < 0)
 		return -EINVAL;

-	return sprintf(buf, "%d%s Gb/sec (%dX%s)\n",
-		       rate, (attr.active_speed == IB_SPEED_SDR) ? ".5" : "",
-		       ib_width_enum_to_int(attr.active_width), speed);
+	if (attr.active_speed == IB_SPEED_SDR) {
+		rate = (25 * ib_width_enum_to_int(attr.active_width)) / 10;
+		return sprintf(buf, "%d%s Gb/sec (%dX%s)\n", rate,
+			       (attr.active_width == IB_WIDTH_1X) ? ".5" : "",
+				ib_width_enum_to_int(attr.active_width), speed);
+	} else
+		return sprintf(buf, "%d Gb/sec (%dX%s)\n",
+		       rate, ib_width_enum_to_int(attr.active_width), speed);
 }

 static ssize_t phys_state_show(struct ib_port *p, struct port_attribute *unused,
-- 
1.7.1


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
