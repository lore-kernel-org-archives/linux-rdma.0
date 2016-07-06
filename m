From: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB core: Add port_xmit_wait counter display
Date: Wed, 6 Jul 2016 09:40:55 -0500 (CDT)
Message-ID: <alpine.DEB.2.20.1607060939450.10572@east.gentwo.org>
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dled-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add the missing port_xmit_wait counter. This counter is displayed through
some tools like perfquery but is not available via sysfs.

For the PORT_PMA_ATTR macro the _counter field is set to zero
allowing us to specify the offset directly like with PORT_PMA_ATTR_EXT

See also the earlier work in 2008 by Vladimir Skolovsky

https://www.mail-archive.com/general-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org/msg20313.html

Signed-off-by: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>

Index: linux/drivers/infiniband/core/sysfs.c
===================================================================
--- linux.orig/drivers/infiniband/core/sysfs.c
+++ linux/drivers/infiniband/core/sysfs.c
@@ -530,6 +530,7 @@ static PORT_PMA_ATTR(port_xmit_data
 static PORT_PMA_ATTR(port_rcv_data		    , 13, 32, 224);
 static PORT_PMA_ATTR(port_xmit_packets		    , 14, 32, 256);
 static PORT_PMA_ATTR(port_rcv_packets		    , 15, 32, 288);
+static PORT_PMA_ATTR(port_xmit_wait		    ,  0, 32, 320);

 /*
  * Counters added by extended set
@@ -560,6 +561,7 @@ static struct attribute *pma_attrs[] = {
 	&port_pma_attr_port_rcv_data.attr.attr,
 	&port_pma_attr_port_xmit_packets.attr.attr,
 	&port_pma_attr_port_rcv_packets.attr.attr,
+	&port_pma_attr_port_xmit_wait.attr.attr,
 	NULL
 };

@@ -604,6 +606,7 @@ static struct attribute *pma_attrs_noiet
 	&port_pma_attr_ext_port_rcv_data.attr.attr,
 	&port_pma_attr_ext_port_xmit_packets.attr.attr,
 	&port_pma_attr_ext_port_rcv_packets.attr.attr,
+	&port_pma_attr_port_xmit_wait.attr.attr,
 	NULL
 };

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
