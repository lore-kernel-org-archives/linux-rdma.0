From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 06/13] SoftiWarp connection management
Date: Fri, 20 Oct 2017 07:49:44 -0500
Message-ID: <20171020124944.GA11604@ssaleem-MOBL4.amr.corp.intel.com>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-7-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171006122853.16310-7-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 06, 2017 at 08:28:46AM -0400, Bernard Metzler wrote:
> Signed-off-by: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
> ---
>  drivers/infiniband/sw/siw/siw_cm.c | 2270 ++++++++++++++++++++++++++++++++++++
>  drivers/infiniband/sw/siw/siw_cm.h |  156 +++
>  2 files changed, 2426 insertions(+)
>  create mode 100644 drivers/infiniband/sw/siw/siw_cm.c
>  create mode 100644 drivers/infiniband/sw/siw/siw_cm.h
> 
> diff --git a/drivers/infiniband/sw/siw/siw_cm.c b/drivers/infiniband/sw/siw/siw_cm.c
> new file mode 100644
> index 000000000000..1527c9ddfed8
> --- /dev/null
> +++ b/drivers/infiniband/sw/siw/siw_cm.c

> +static void siw_rtr_data_ready(struct sock *sk)
> +{
> +	struct siw_cep		*cep;
> +	struct siw_qp		*qp = NULL;
> +	read_descriptor_t	rd_desc;
> +
> +	read_lock(&sk->sk_callback_lock);
> +
> +	cep = sk_to_cep(sk);
> +	if (!cep) {
> +		WARN_ON(1);
> +		goto out;
> +	}
> +	qp = sk_to_qp(sk);
> +
> +	memset(&rd_desc, 0, sizeof(rd_desc));
> +	rd_desc.arg.data = qp;
> +	rd_desc.count = 1;
> +
> +	tcp_read_sock(sk, &rd_desc, siw_tcp_rx_data);
> +	/*
> +	 * Check if first frame was successfully processed.
> +	 * Signal connection full establishment if yes.
> +	 * Failed data processing would have already scheduled
> +	 * connection drop.
> +	 */
> +	if (qp->rx_ctx.rx_suspend == 0  && qp->rx_ctx.rx_suspend == 0)
> +		siw_cm_upcall(cep, IW_CM_EVENT_ESTABLISHED, 0);

Redundant condition in if. Also, its preferred to use !qp->rx_ctx.rx_suspend.

> + * siw_accept - Let SoftiWARP accept an RDMA connection request
> + *
> + * @id:		New connection management id to be used for accepted
> + *		connection request
> + * @params:	Connection parameters provided by ULP for accepting connection
> + *
> + * Transition QP to RTS state, associate new CM id @id with accepted CEP
> + * and get prepared for TCP input by installing socket callbacks.
> + * Then send MPA Reply and generate the "connection established" event.
> + * Socket callbacks must be installed before sending MPA Reply, because
> + * the latter may cause a first RDMA message to arrive from the RDMA Initiator
> + * side very quickly, at which time the socket callbacks must be ready.
> + */
> +int siw_accept(struct iw_cm_id *id, struct iw_cm_conn_param *params)
> +{
> +	struct siw_dev		*sdev = siw_dev_ofa2siw(id->device);
> +	struct siw_cep		*cep = (struct siw_cep *)id->provider_data;
> +	struct siw_qp		*qp;
> +	struct siw_qp_attrs	qp_attrs;
> +	int rv, max_priv_data = MPA_MAX_PRIVDATA;
> +	bool wait_for_peer_rts = false;
> +
> +	siw_cep_set_inuse(cep);
> +	siw_cep_put(cep);
> +
> +	/* Free lingering inbound private data */
> +	if (cep->mpa.hdr.params.pd_len) {
> +		cep->mpa.hdr.params.pd_len = 0;
> +		kfree(cep->mpa.pdata);
> +		cep->mpa.pdata = NULL;
> +	}

Can you not just check for cep->mpa.pdata?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
