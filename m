From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V5] SA Busy Handling - style questions
Date: Mon, 06 Dec 2010 12:01:45 -0500
Message-ID: <4CFD16F9.1060109@dev.mellanox.co.il>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF42A@MNEXMB1.qlogic.org> <4CFD1339.4050601@dev.mellanox.co.il> <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF4E8@MNEXMB1.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF4E8-amwN6d8PyQWXx9kJd3VG2h2eb7JE58TQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/6/2010 11:54 AM, Mike Heinz wrote:
> Which is preferred?
>
>          if ((!mad_send_wr) ||
>             (busy&&  mad_send_wr->retries_left&&
>             (mad_recv_wc->recv_buf.mad->mad_hdr.method != IB_MGMT_METHOD_TRAP_REPRESS))) {
>
> Or
>
>          if ((!mad_send_wr) ||
>             (busy&&  mad_send_wr->retries_left&&
>             (mad_recv_wc->recv_buf.mad->mad_hdr.method !=
>             IB_MGMT_METHOD_TRAP_REPRESS))) {
>
> ?
>

More like the latter IMO:

	if (!mad_send_wr ||
	    (busy && mad_send_wr->retries_left &&
	     (mad_recv_wc->recv_buf.mad->mad_hdr.method !=
	      IB_MGMT_METHOD_TRAP_REPRESS))) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
