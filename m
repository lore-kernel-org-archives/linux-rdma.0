From: Honggang LI <honli@redhat.com>
Subject: [PATCH 2/2] IB/core: Set width to 1X for invalid active widths when port is down
Date: Thu, 15 Mar 2018 17:02:14 +0800
Message-ID: <20180315090214.21706-3-honli@redhat.com>
References: <20180315090214.21706-1-honli@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180315090214.21706-1-honli@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dledford@redhat.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org
Cc: noaos@mellanox.com, linux-kernel@vger.kernel.org, honli@redhat.com
List-Id: linux-rdma@vger.kernel.org

From: Honggang Li <honli@redhat.com>

commit f1b65df5a232 ("IB/mlx5: Add support for active_width and
active_speed in RoCE"). Before this patch applied, the mlx5_ib
driver set default active_width and active_speed to IB_WIDTH_4X
and IB_SPEED_QDR.

When the RoCE port is down, the RoCE port did not negotiate the
active width with remote side. The active width is zero. If run
ibstat to require the port status, ibstat will panic as it read
invalid width from sys file.

Signed-off-by: Honggang Li <honli@redhat.com>
---
 drivers/infiniband/core/sysfs.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index cf36ff1f0068..722e4571f4d2 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -240,6 +240,7 @@ static ssize_t rate_show(struct ib_port *p, struct port_attribute *unused,
 	struct ib_port_attr attr;
 	char *speed = "";
 	int rate;		/* in deci-Gb/sec */
+	int width;
 	ssize_t ret;
 
 	ret = ib_query_port(p->ibdev, p->port_num, &attr);
@@ -278,13 +279,19 @@ static ssize_t rate_show(struct ib_port *p, struct port_attribute *unused,
 		break;
 	}
 
-	rate *= ib_width_enum_to_int(attr.active_width);
-	if (rate < 0)
-		return -EINVAL;
+	width = ib_width_enum_to_int(attr.active_width);
+	if (width < 0) {
+		if (attr.state != IB_PORT_ACTIVE)
+			width = 1; /* default to 1X for invalid widths */
+		else
+			return -EINVAL;
+	}
+
+	rate *= width;
 
 	return sprintf(buf, "%d%s Gb/sec (%dX%s)\n",
 		       rate / 10, rate % 10 ? ".5" : "",
-		       ib_width_enum_to_int(attr.active_width), speed);
+		       width, speed);
 }
 
 static ssize_t phys_state_show(struct ib_port *p, struct port_attribute *unused,
-- 
2.14.GIT
