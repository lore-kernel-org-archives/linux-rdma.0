From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: Handling busy responses from the SA
Date: Fri, 4 Jun 2010 12:21:02 -0500
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB49A488DADA@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The purpose of this patch is to cause the ib_mad driver to discard busy=
 responses from the SA, effectively causing busy responses to become ti=
me outs.

This ensures that na=EFve IB applications cannot overwhelm the SA with =
queries, which could happen when a cluster is being rebooted, or when a=
 large HPC application is started.

Note that this patch directly changes the same code affected by the mad=
 user rmpp patch - it cannot be successfully applied without that patch=
=2E

Signed-Off-By: Michael Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

----

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/ma=
d.c
index efca783..05f2930 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -1815,9 +1815,20 @@ static void ib_mad_complete_recv(struct ib_mad_a=
gent_private *mad_agent_priv,
 	 */
 	/* Complete corresponding request */
 	if (ib_response_mad(mad_recv_wc->recv_buf.mad)) {
+		u16 busy =3D __be16_to_cpu(mad_recv_wc->recv_buf.mad->mad_hdr.status=
) &
+					IB_MGMT_MAD_STATUS_BUSY;
+
 		spin_lock_irqsave(&mad_agent_priv->lock, flags);
 		mad_send_wr =3D ib_find_send_mad(mad_agent_priv, mad_recv_wc);
 		if (mad_send_wr) {
+			if (busy && mad_send_wr->retries_left) {
+				/* Just let the query timeout and have it requeued later */
+				spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
+				ib_free_recv_mad(mad_recv_wc);
+				deref_mad_agent(mad_agent_priv);
+				printk(KERN_NOTICE PFX "Response returned with MAD_STATUS_BUSY\n")=
;
+				return;
+			}
 			ib_mark_mad_done(mad_send_wr);
 			spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
=20
diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
index 2651e93..e9dc4cc 100644
--- a/include/rdma/ib_mad.h
+++ b/include/rdma/ib_mad.h
@@ -77,6 +77,15 @@
=20
 #define IB_MGMT_MAX_METHODS			128
=20
+/* MAD Status field bit masks */
+#define IB_MGMT_MAD_STATUS_SUCCESS						0x0000
+#define IB_MGMT_MAD_STATUS_BUSY							0x0001
+#define IB_MGMT_MAD_STATUS_REDIRECT_REQD				0x0002
+#define IB_MGMT_MAD_STATUS_BAD_VERERSION				0x0004=09
+#define IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD			0x0008=09
+#define IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD_ATTRIB	0x000c
+#define IB_MGMT_MAD_STATUS_INVALID_ATTRIB_VALUE			0x001c
+
 /* RMPP information */
 #define IB_MGMT_RMPP_VERSION			1
 #define IB_MGMT_RMPP_PASSTHRU			255
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
