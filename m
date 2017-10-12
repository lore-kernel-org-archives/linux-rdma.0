From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 06/13] SoftiWarp connection management
Date: Thu, 12 Oct 2017 11:27:58 -0400
Message-ID: <6697be2f-0dee-8e01-2010-7a397730f0ea@intel.com>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
 <20171006122853.16310-7-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006122853.16310-7-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 10/6/2017 8:28 AM, Bernard Metzler wrote:
> +static bool mpa_crc_strict = true;
> +module_param(mpa_crc_strict, bool, 0644);
> +bool mpa_crc_required;
> +module_param(mpa_crc_required, bool, 0644);
> +static bool tcp_nodelay = true;
> +module_param(tcp_nodelay, bool, 0644);
> +static u_char  mpa_version = MPA_REVISION_2;
> +module_param(mpa_version, byte, 0644);
> +static bool peer_to_peer;	/* default false: no need for P2P mode */
> +module_param(peer_to_peer, bool, 0644);
> +
> +MODULE_PARM_DESC(mpa_crc_required, "MPA CRC required");
> +MODULE_PARM_DESC(mpa_crc_strict, "MPA CRC off enforced");
> +MODULE_PARM_DESC(tcp_nodelay, "Set TCP NODELAY and TCP_QUICKACK");
> +MODULE_PARM_DESC(mpa_version, "MPA version number");
> +MODULE_PARM_DESC(peer_to_peer, "MPAv2 Peer-to-Peer RTR negotiation");

These seem like they should be in sysfs or something. Not module params.

> +static void siw_cm_llp_state_change(struct sock *);

I think this is frowned upon. Give your sock a name here and every 
elsewhere.

> +static void siw_sk_save_upcalls(struct sock *sk)
> +{
> +	struct siw_cep *cep = sk_to_cep(sk);
> +
> +	BUG_ON(!cep);

You aren't going to like Linus' response if he sees this.
> +		if (cep) {
> +			siw_sk_restore_upcalls(sk, cep);
> +			siw_cep_put(cep);
> +		} else
> +			pr_warn("cannot restore sk callbacks: no ep\n");

If the "if" part has braces the "else" part needs them too.

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

Perhaps WARN_ON_ONCE? Or do we really need it each time?

> +
> +static inline int kernel_peername(struct socket *s, struct sockaddr_in *addr)
> +{
> +	int unused;
> +
> +	return s->ops->getname(s, (struct sockaddr *)addr, &unused, 1);

Can you just pass NULL instead of creating a weird variable?

> +	while (num--) {
> +		work = kmalloc(sizeof(*work), GFP_KERNEL);
> +		if (!work) {
> +			if (!(list_empty(&cep->work_freelist)))
> +				siw_cm_free_work(cep);
> +			dprint(DBG_ON, " Failed\n");

No need for a print here, the kmalloc will handle making the failure known.

> +void siw_send_terminate(struct siw_qp *qp, u8 layer, u8 etype, u8 ecode)
> +{
> +	struct iwarp_terminate	pkt;
> +
> +	memset(&pkt, 0, sizeof(pkt));
> +	pkt.term_ctrl = (layer & 0xf) | ((etype & 0xf) << 4) |
> +			((u32)ecode << 8);
> +	pkt.term_ctrl = cpu_to_be32(pkt.term_ctrl);
> +
> +	/*
> +	 * TODO: send TERMINATE
> +	 */
> +	dprint(DBG_CM, "(QP%d): Todo\n", QP_ID(qp));
> +}

Don't know that we really want to see TODOs in the code. Since we aren't 
using the staging tree these days the code should probably be ready for 
prime time when it goes in. So if you need to send terminate, probably 
should do that. Or at least offer an explanation of why it needs to be 
done but can wait?


> +static int siw_proc_mpareq(struct siw_cep *cep)
> +{
> +	struct mpa_rr	*req;
> +	int		version, rv;
> +	u16		pd_len;
> +
> +	rv = siw_recv_mpa_rr(cep);
> +	if (rv)
> +		goto out;

Just return, same comment below for other goto statements.

> +	req = &cep->mpa.hdr;
> +
> +	version = __mpa_rr_revision(req->params.bits);
> +	pd_len = be16_to_cpu(req->params.pd_len);
> +
> +	if (version > MPA_REVISION_2) {
> +		/* allow for 0, 1, and 2 only */
> +		rv = -EPROTO;
> +		goto out;
> +	}
> +	if (memcmp(req->key, MPA_KEY_REQ, 16)) {
> +		rv = -EPROTO;
> +		goto out;
> +	}
> +	/* Prepare for sending MPA reply */
> +	memcpy(req->key, MPA_KEY_REP, 16);

What is this magical and mystical value 16? Perhaps a #define that gives 
some clue as to why we want to only copy this many bytes.


> +	if (version == MPA_REVISION_2 &&
> +	    (req->params.bits & MPA_RR_FLAG_ENHANCED)) {
> +		/*
> +		 * MPA version 2 must signal IRD/ORD values and P2P mode
> +		 * in private data if header flag MPA_RR_FLAG_ENHANCED
> +		 * is set.
> +		 */
> +		if (pd_len < sizeof(struct mpa_v2_data))
> +			goto reject_conn;

Now this goto is fine.
> +
> +
> +static int siw_proc_mpareply(struct siw_cep *cep)
> +{
> +	struct siw_qp_attrs	qp_attrs;
> +	enum siw_qp_attr_mask	qp_attr_mask;
> +	struct siw_qp		*qp = cep->qp;
> +	struct mpa_rr		*rep;
> +	int			rv;
> +	u16			rep_ord;
> +	u16			rep_ird;
> +	bool			ird_insufficient = false;
> +	enum mpa_v2_ctrl	mpa_p2p_mode = MPA_V2_RDMA_NO_RTR;
> +
> +	rv = siw_recv_mpa_rr(cep);
> +	if (rv != -EAGAIN)
> +		siw_cancel_mpatimer(cep);
> +	if (rv)
> +		goto out_err;
> +
> +	rep = &cep->mpa.hdr;
> +
> +	if (__mpa_rr_revision(rep->params.bits) > MPA_REVISION_2) {
> +		/* allow for 0, 1,  and 2 only */
> +		rv = -EPROTO;
> +		goto out_err;
> +	}
> +	if (memcmp(rep->key, MPA_KEY_REP, 16)) {
> +		rv = -EPROTO;
> +		goto out_err;
> +	}
> +	if (rep->params.bits & MPA_RR_FLAG_REJECT) {
> +		dprint(DBG_CM, "(cep=0x%p): Got MPA reject\n", cep);
> +		(void)siw_cm_upcall(cep, IW_CM_EVENT_CONNECT_REPLY,
> +				    -ECONNRESET);
> +
> +		rv = -ECONNRESET;
> +		goto out;

Same comments as above, just return.

> +
> +	if (!rv) {
> +		rv = siw_cm_upcall(cep, IW_CM_EVENT_CONNECT_REPLY, 0);
> +		if (!rv)
> +			cep->state = SIW_EPSTATE_RDMA_MODE;
> +
> +		goto out;
	Again, just return.

> +	}
> +
> +out_err:
> +	(void)siw_cm_upcall(cep, IW_CM_EVENT_CONNECT_REPLY, -EINVAL);
> +out:

Label is not needed.

> + * siw_accept_newconn - accept an incoming pending connection
> + *
> + */
> +static void siw_accept_newconn(struct siw_cep *cep)
> +{
> +	struct socket		*s = cep->llp.sock;
> +	struct socket		*new_s = NULL;
> +	struct siw_cep		*new_cep = NULL;
> +	int			rv = 0; /* debug only. should disappear */
> +
> +	if (cep->state != SIW_EPSTATE_LISTENING)
> +		goto error;
> +
> +	new_cep = siw_cep_alloc(cep->sdev);
> +	if (!new_cep)
> +		goto error;
> +
> +	if (siw_cm_alloc_work(new_cep, 4) != 0)

Why 4?

> +
> +static void siw_cm_llp_data_ready(struct sock *sk)
> +{
> +	struct siw_cep	*cep;
> +
> +	read_lock(&sk->sk_callback_lock);
> +
> +	cep = sk_to_cep(sk);
> +	if (!cep) {
> +		WARN_ON(1);
> +		goto out;
> +	}
> +
> +	dprint(DBG_CM, "(): cep 0x%p, state: %d\n", cep, cep->state);
> +
> +	switch (cep->state) {
> +
> +	case SIW_EPSTATE_RDMA_MODE:
> +	case SIW_EPSTATE_LISTENING:

Make sure to annotate these fall throughs. Bart just submitted a patch 
[1] that does this tree wide. Let's keep the same bar for new code too 
if we can.

> +static int kernel_bindconnect(struct socket *s,
> +			      struct sockaddr *laddr, int laddrlen,
> +			      struct sockaddr *raddr, int raddrlen, int flags)
> +{
> +	int err, s_val = 1;
> +	/*
> +	 * XXX
> +	 * Tentative fix. Should not be needed but sometimes iwcm
> +	 * chooses ports in use
> +	 */

Is this a hack to keep user space happy? If so I don't think that's the 
right thing to do.

> +	err = kernel_setsockopt(s, SOL_SOCKET, SO_REUSEADDR, (char *)&s_val,
> +				sizeof(s_val));
> +	if (err < 0)
> +		goto done;

Usual comment here.

> +
> +	/*
> +	 * TODO: Do we really need the copies of local_addr and remote_addr
> +	 *	 in CEP ???
> +	 */
Well can we find out before merging the driver?

> +
> +#define MPAREQ_TIMEOUT	(HZ*10)
> +#define MPAREP_TIMEOUT	(HZ*5)

Seems kinda strange for time out values, why were these chosen?

> +/*
> + * With kernel 3.12, OFA ddressing changed from sockaddr_in to
> + * sockaddr_storage
> + */
> +#define to_sockaddr_in(a) (*(struct sockaddr_in *)(&(a)))

I don't think this is required. Who cares what OFA did, that has no 
meaning for this Linux kernel driver.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
