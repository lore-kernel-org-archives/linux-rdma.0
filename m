From: root <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] IB core: Add link layer information to sysfs
Date: Fri, 22 Oct 2010 14:32:05 +0200
Message-ID: <20101022123205.GA8923@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Since an IB port may use either IB or Ethernet as its link layer, add
the file /sys/class/infiniband/<device>/ports/<port_num>/link_layer to
provide the configured link layer for the port.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
Roland, this patch was intended to be sent with the whole series but
somehow did not find its way out. I hope it you can intergrate it too.

 drivers/infiniband/core/sysfs.c |   15 +++++++++++++++
 1 files changed, 15 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 3627300..934e27d 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -222,6 +222,19 @@ static ssize_t phys_state_show(struct ib_port *p, struct port_attribute *unused,
 	}
 }
 
+static ssize_t link_layer_show(struct ib_port *p, struct port_attribute *unused,
+			       char *buf)
+{
+	switch (rdma_port_get_link_layer(p->ibdev, p->port_num)) {
+	case IB_LINK_LAYER_INFINIBAND:
+		return sprintf(buf, "%s\n", "IB");
+	case IB_LINK_LAYER_ETHERNET:
+		return sprintf(buf, "%s\n", "Ethernet");
+	default:
+		return sprintf(buf, "%s\n", "Unknown");
+	}
+}
+
 static PORT_ATTR_RO(state);
 static PORT_ATTR_RO(lid);
 static PORT_ATTR_RO(lid_mask_count);
@@ -230,6 +243,7 @@ static PORT_ATTR_RO(sm_sl);
 static PORT_ATTR_RO(cap_mask);
 static PORT_ATTR_RO(rate);
 static PORT_ATTR_RO(phys_state);
+static PORT_ATTR_RO(link_layer);
 
 static struct attribute *port_default_attrs[] = {
 	&port_attr_state.attr,
@@ -240,6 +254,7 @@ static struct attribute *port_default_attrs[] = {
 	&port_attr_cap_mask.attr,
 	&port_attr_rate.attr,
 	&port_attr_phys_state.attr,
+	&port_attr_link_layer.attr,
 	NULL
 };
 
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
