From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 6/8] RDMA/core: Add physical link state information to the UAPI
Date: Tue, 15 Aug 2017 12:14:29 +0300
Message-ID: <20170815091431.12822-7-leon@kernel.org>
References: <20170815091431.12822-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815091431.12822-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add physical link state information to the UAPI and convert hardcoded
values to use the exported enum.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c | 24 ++++++++++++++++--------
 include/uapi/rdma/rdma.h        | 40 ++++++++++++++++++++++++++++++++++++++++
 2 files changed, 56 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index c43280f8d5b3..913919c6822b 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -284,14 +284,22 @@ static ssize_t phys_state_show(struct ib_port *p, struct port_attribute *unused,
 		return ret;
 
 	switch (attr.phys_state) {
-	case 1:  return sprintf(buf, "1: Sleep\n");
-	case 2:  return sprintf(buf, "2: Polling\n");
-	case 3:  return sprintf(buf, "3: Disabled\n");
-	case 4:  return sprintf(buf, "4: PortConfigurationTraining\n");
-	case 5:  return sprintf(buf, "5: LinkUp\n");
-	case 6:  return sprintf(buf, "6: LinkErrorRecovery\n");
-	case 7:  return sprintf(buf, "7: Phy Test\n");
-	default: return sprintf(buf, "%d: <unknown>\n", attr.phys_state);
+	case RDMA_LINK_PHYS_STATE_SLEEP:
+		return sprintf(buf, "1: Sleep\n");
+	case RDMA_LINK_PHYS_STATE_POLLING:
+		return sprintf(buf, "2: Polling\n");
+	case RDMA_LINK_PHYS_STATE_DISABLED:
+		return sprintf(buf, "3: Disabled\n");
+	case RDMA_LINK_PHYS_STATE_PORT_CONFIGURATION_TRAINING:
+		return sprintf(buf, "4: PortConfigurationTraining\n");
+	case RDMA_LINK_PHYS_STATE_LINK_UP:
+		return sprintf(buf, "5: LinkUp\n");
+	case RDMA_LINK_PHYS_STATE_LINK_ERROR_RECOVER:
+		return sprintf(buf, "6: LinkErrorRecovery\n");
+	case RDMA_LINK_PHYS_STATE_LINK_PHY_TEST:
+		return sprintf(buf, "7: Phy Test\n");
+	default:
+		return sprintf(buf, "%d: <unknown>\n", attr.phys_state);
 	}
 }
 
diff --git a/include/uapi/rdma/rdma.h b/include/uapi/rdma/rdma.h
index 5f4019e2c5d4..42af3fe57b5a 100644
--- a/include/uapi/rdma/rdma.h
+++ b/include/uapi/rdma/rdma.h
@@ -152,5 +152,45 @@ enum rdma_link_state {
 	RDMA_LINK_STATE_ACTIVE,
 	RDMA_LINK_STATE_ACTIVE_DEFER,
 };
+
+/*
+ * When writing this field, only values 0, 1, 2, and 3
+ * are valid. Other values are ignored. See InfiniBand Architecture
+ * Specification Volume 2, Link/Phy Interface chapter.
+ */
+enum rdma_link_phys_state {
+	/*
+	 * 0 - 7 are according to the IB specification
+	 * 8 - 15 -  Reserved and ignored in IB, but partially
+	 *	     in use by OmniPath
+	 */
+	RDMA_LINK_PHYS_STATE_NOP,
+	RDMA_LINK_PHYS_STATE_SLEEP,
+	RDMA_LINK_PHYS_STATE_POLLING,
+	RDMA_LINK_PHYS_STATE_DISABLED,
+	RDMA_LINK_PHYS_STATE_PORT_CONFIGURATION_TRAINING,
+	RDMA_LINK_PHYS_STATE_LINK_UP,
+	RDMA_LINK_PHYS_STATE_LINK_ERROR_RECOVER,
+	RDMA_LINK_PHYS_STATE_LINK_PHY_TEST,
+
+	/* 8 is reserved in OPA */
+
+	/*
+	 * Offline: Port is quiet (transmitters disabled) due to lack of
+	 * physical media, unsupported media, or transition between link up
+	 * and next link up attempt
+	 */
+	RDMA_LINK_PHYS_STATE_OFFLINE = 9,
+
+	/* 10 is reserved in OPA */
+
+	/*
+	 * Phy_Test: Specific test patterns are transmitted, and receiver BER
+	 * can be monitored. This facilitates signal integrity testing for the
+	 * physical layer of the port.
+	 */
+	RDMA_LINK_PHYS_STATE_TEST = 11,
+
+	/* values 12-15 are reserved/ignored */
 };
 #endif /* _RDMA_H */
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
