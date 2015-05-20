From: Suri Shelvapille <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Subject: RE: [PATCH 14/14] IB/mad: Add final OPA MAD processing
Date: Wed, 20 May 2015 21:11:14 +0000
Message-ID: <CY1PR03MB1440B98A7FE0A82E1BE53D75DEC20@CY1PR03MB1440.namprd03.prod.outlook.com>
References: <1432109615-19564-1-git-send-email-ira.weiny@intel.com>
 <1432109615-19564-15-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432109615-19564-15-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org" <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Can you please clarify:

+static enum smi_action
+handle_opa_smi(struct ib_mad_port_private *port_priv,
+       struct ib_mad_qp_info *qp_info,
+       struct ib_wc *wc,
+       int port_num,
+       struct ib_mad_private *recv,
+       struct ib_mad_private *response) {
+enum smi_forward_action retsmi;
+
+if (opa_smi_handle_dr_smp_recv(&recv->mad.opa_smp,
+   port_priv->device->node_type,
+   port_num,
+   port_priv->device->phys_port_cnt) ==
+   IB_SMI_DISCARD)
+return IB_SMI_DISCARD;
+
+retsmi = opa_smi_check_forward_dr_smp(&recv->mad.opa_smp);
+if (retsmi == IB_SMI_LOCAL)
+return IB_SMI_HANDLE;
+
+if (retsmi == IB_SMI_SEND) { /* don't forward */
+if (opa_smi_handle_dr_smp_send(&recv->mad.opa_smp,
+   port_priv->device->node_type,
+   port_num) == IB_SMI_DISCARD)
+return IB_SMI_DISCARD;
+
+if (opa_smi_check_local_smp(&recv->mad.opa_smp, port_priv->device) == IB_SMI_DISCARD)
+return IB_SMI_DISCARD;
+
+} else if (port_priv->device->node_type == RDMA_NODE_IB_SWITCH) {
+/* forward case for switches */
+memcpy(response, recv, sizeof(*response));
+response->header.recv_wc.wc = &response->header.wc;
+response->header.recv_wc.recv_buf.opa_mad = &response->mad.opa_mad;
+response->header.recv_wc.recv_buf.grh = &response->grh;
+
+agent_send_response((struct ib_mad *)&response->mad.mad,
+    &response->grh, wc,
+    port_priv->device,
+    opa_smi_get_fwd_port(&recv->mad.opa_smp),
+    qp_info->qp->qp_num,
+    recv->header.wc.byte_len,
+    1);
+
+return IB_SMI_DISCARD;
+}
+
+return IB_SMI_HANDLE;
+}
+

Why do you have RDMA_NODE_IB_SWITCH related stuff inside the handle_opa_smi() function?
Is there a node type of "switch" in OPA similar to IB?


Thanks,
Suri

This correspondence, and any attachments or files transmitted with this correspondence, contains information which may be confidential and privileged and is intended solely for the use of the addressee. Unless you are the addressee or are authorized to receive messages for the addressee, you may not use, copy, disseminate, or disclose this correspondence or any information contained in this correspondence to any third party. If you have received this correspondence in error, please notify the sender immediately and delete this correspondence and any attachments or files transmitted with this correspondence from your system, and destroy any and all copies thereof, electronic or otherwise. Your cooperation and understanding are greatly appreciated.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
