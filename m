From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/3] IB/core: Add HDR speed enum
Date: Thu, 20 Apr 2017 20:53:31 +0300
Message-ID: <20170420175333.7082-2-leon@kernel.org>
References: <20170420175333.7082-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170420175333.7082-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add high data rate speed to the ib_port_speed enumeration.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c | 4 ++++
 include/rdma/ib_verbs.h         | 3 ++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index daadf3130c9f..b6317f220f7d 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -253,6 +253,10 @@ static ssize_t rate_show(struct ib_port *p, struct port_attribute *unused,
 		speed = " EDR";
 		rate = 250;
 		break;
+	case IB_SPEED_HDR:
+		speed = " HDR";
+		rate = 500;
+		break;
 	case IB_SPEED_SDR:
 	default:		/* default to SDR for invalid rates */
 		rate = 25;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 3a8e05894e9b..796a38609e1a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -431,7 +431,8 @@ enum ib_port_speed {
 	IB_SPEED_QDR	= 4,
 	IB_SPEED_FDR10	= 8,
 	IB_SPEED_FDR	= 16,
-	IB_SPEED_EDR	= 32
+	IB_SPEED_EDR	= 32,
+	IB_SPEED_HDR	= 64
 };
 
 /**
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
