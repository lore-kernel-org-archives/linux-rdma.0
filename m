From: Mike Heinz <michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH V5] SA Busy Handling
Date: Mon, 6 Dec 2010 10:52:35 -0600
Message-ID: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF4E6@MNEXMB1.qlogic.org>
References: <4C2744E8AD2982428C5BFE523DF8CDCB4A208DF42A@MNEXMB1.qlogic.org>
 <4CFD1339.4050601@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CFD1339.4050601-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This code is duplicated so it should be combined with if (!mad_send_w=
r)=20
> clause above to eliminate the duplication.
>
> -- Hal

I guess that's true - they used to be different but since we've reverte=
d to simply discarding the response, you're right the clauses can be me=
rged.

-----Original Message-----
=46rom: Hal Rosenstock [mailto:hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org]=20
Sent: Monday, December 06, 2010 11:46 AM
To: Mike Heinz
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH V5] SA Busy Handling

On 12/3/2010 4:57 PM, Mike Heinz wrote:
> The purpose of this patch is to cause the ib_mad driver to discard bu=
sy responses from the SA, effectively causing busy responses to become =
time outs.
>
> This ensures that na=EFve IB applications cannot overwhelm the SA wit=
h queries, which could happen when a cluster is being rebooted, or when=
 a large HPC application is started.
>
> Signed-Off-By: Michael Heinz<michael.heinz-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
>
> ----
>
>   drivers/infiniband/core/mad.c |   13 +++++++++++++
>   include/rdma/ib_mad.h         |    9 +++++++++
>   2 files changed, 22 insertions(+), 0 deletions(-)
> diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/=
mad.c
> index 64e660c..b322173 100644
> --- a/drivers/infiniband/core/mad.c
> +++ b/drivers/infiniband/core/mad.c
> @@ -1828,6 +1828,9 @@ static void ib_mad_complete_recv(struct ib_mad_=
agent_private *mad_agent_priv,
>
>   	/* Complete corresponding request */
>   	if (ib_response_mad(mad_recv_wc->recv_buf.mad)) {
> +		u16 busy =3D be16_to_cpu(mad_recv_wc->recv_buf.mad->mad_hdr.status=
)&
> +							   IB_MGMT_MAD_STATUS_BUSY;
> +
>   		spin_lock_irqsave(&mad_agent_priv->lock, flags);
>   		mad_send_wr =3D ib_find_send_mad(mad_agent_priv, mad_recv_wc);
>   		if (!mad_send_wr) {
> @@ -1836,6 +1839,16 @@ static void ib_mad_complete_recv(struct ib_mad=
_agent_private *mad_agent_priv,
>   			deref_mad_agent(mad_agent_priv);
>   			return;
>   		}
> +
> +		if (busy&&  mad_send_wr->retries_left&&
> +		   (mad_recv_wc->recv_buf.mad->mad_hdr.method !=3D IB_MGMT_METHOD_=
TRAP_REPRESS)) {
> +			/* Just let the query timeout and have it requeued later */
> +			spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
> +			ib_free_recv_mad(mad_recv_wc);
> +			deref_mad_agent(mad_agent_priv);
> +			return;
> +		}

This code is duplicated so it should be combined with if (!mad_send_wr)=
=20
clause above to eliminate the duplication.

-- Hal

> +
>   		ib_mark_mad_done(mad_send_wr);
>   		spin_unlock_irqrestore(&mad_agent_priv->lock, flags);
>
> diff --git a/include/rdma/ib_mad.h b/include/rdma/ib_mad.h
> index d3b9401..b901968 100644
> --- a/include/rdma/ib_mad.h
> +++ b/include/rdma/ib_mad.h
> @@ -77,6 +77,15 @@
>
>   #define IB_MGMT_MAX_METHODS			128
>
> +/* MAD Status field bit masks */
> +#define IB_MGMT_MAD_STATUS_SUCCESS                      0x0000
> +#define IB_MGMT_MAD_STATUS_BUSY                         0x0001
> +#define IB_MGMT_MAD_STATUS_REDIRECT_REQD                0x0002
> +#define IB_MGMT_MAD_STATUS_BAD_VERSION                  0x0004
> +#define IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD           0x0008
> +#define IB_MGMT_MAD_STATUS_UNSUPPORTED_METHOD_ATTRIB    0x000c
> +#define IB_MGMT_MAD_STATUS_INVALID_ATTRIB_VALUE         0x001c
> +
>   /* RMPP information */
>   #define IB_MGMT_RMPP_VERSION			1
>
>
>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
