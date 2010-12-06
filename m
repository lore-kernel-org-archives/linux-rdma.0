From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH V5] SA Busy Handling - style questions
Date: Mon, 6 Dec 2010 10:54:28 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF4E8@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF42A@MNEXMB1.qlogic.org>
 <4CFD1339.4050601@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Which is preferred?

        if ((!mad_send_wr) ||
           (busy && mad_send_wr->retries_left &&
           (mad_recv_wc->recv_buf.mad->mad_hdr.method != IB_MGMT_METHOD_TRAP_REPRESS))) {

Or

        if ((!mad_send_wr) ||
           (busy && mad_send_wr->retries_left &&
           (mad_recv_wc->recv_buf.mad->mad_hdr.method != 
           IB_MGMT_METHOD_TRAP_REPRESS))) {

?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
