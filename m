From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] ofa_kernel madeye.c
Date: Tue, 25 May 2010 14:51:50 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A488D3FF@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a simple fix. Several of the snoop filters in ./drivers/infiniband/util/madeye.c don't switch the attribute id to host byte order before checking it.

Signed-off-by: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

diff --git a/drivers/infiniband/util/madeye.c b/drivers/infiniband/util/madeye.c
index 0cda06c..2c650a3 100644
--- a/drivers/infiniband/util/madeye.c
+++ b/drivers/infiniband/util/madeye.c
@@ -401,7 +401,7 @@ static void snoop_smi_handler(struct ib_mad_agent *mad_agent,
 
 	if (!smp && hdr->mgmt_class != mgmt_class)
 		return;
-	if (attr_id && hdr->attr_id != attr_id)
+	if (attr_id && be16_to_cpu(hdr->attr_id) != attr_id)
 		return;
 
 	printk("Madeye:sent SMP\n");
@@ -413,7 +413,7 @@ static void recv_smi_handler(struct ib_mad_agent *mad_agent,
 {
 	if (!smp && mad_recv_wc->recv_buf.mad->mad_hdr.mgmt_class != mgmt_class)
 		return;
-	if (attr_id && mad_recv_wc->recv_buf.mad->mad_hdr.attr_id != attr_id)
+	if (attr_id && be16_to_cpu(mad_recv_wc->recv_buf.mad->mad_hdr.attr_id) != attr_id)
 		return;
 
 	printk("Madeye:recv SMP\n");
@@ -446,7 +446,7 @@ static void snoop_gsi_handler(struct ib_mad_agent *mad_agent,
 
 	if (!gmp && hdr->mgmt_class != mgmt_class)
 		return;
-	if (attr_id && hdr->attr_id != attr_id)
+	if (attr_id && be16_to_cpu(hdr->attr_id) != attr_id)
 		return;
 
 	printk("Madeye:sent GMP\n");
@@ -468,7 +468,7 @@ static void recv_gsi_handler(struct ib_mad_agent *mad_agent,
 
 	if (!gmp && hdr->mgmt_class != mgmt_class)
 		return;
-	if (attr_id && mad_recv_wc->recv_buf.mad->mad_hdr.attr_id != attr_id)
+	if (attr_id && be16_to_cpu(mad_recv_wc->recv_buf.mad->mad_hdr.attr_id) != attr_id)
 		return;
 
 	printk("Madeye:recv GMP\n");
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
