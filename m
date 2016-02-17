From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH v4 1/4] IB: new common API for draining queues
Date: Wed, 17 Feb 2016 15:35:44 -0800
Message-ID: <56C503D0.7060402@sandisk.com>
References: <cover.1455741336.git.swise@chelsio.com>
 <5b4799151723516ec440191b3f0ae98a46b356f0.1455741336.git.swise@chelsio.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5b4799151723516ec440191b3f0ae98a46b356f0.1455741336.git.swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+p6NamaJ0bNTAL8bYrjMMd8@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 02/17/2016 08:15 AM, Steve Wise wrote:
> +static void __ib_drain_sq(struct ib_qp *qp)
> +{
> +	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
> +	struct ib_drain_cqe sdrain;
> +	struct ib_send_wr swr = {}, *bad_swr;
> +	int ret;
> +
> +	if (qp->send_cq->poll_ctx == IB_POLL_DIRECT) {
> +		WARN_ONCE(qp->send_cq->poll_ctx == IB_POLL_DIRECT,
> +			  "IB_POLL_DIRECT poll_ctx not supported for drain\n");
> +		return;
> +	}
> +
> +	swr.wr_cqe = &sdrain.cqe;
> +	sdrain.cqe.done = ib_drain_qp_done;
> +	init_completion(&sdrain.done);
> +
> +	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to drain send queue: %d\n", ret);
> +		return;
> +	}
> +
> +	ret = ib_post_send(qp, &swr, &bad_swr);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to drain send queue: %d\n", ret);
> +		return;
> +	}
> +
> +	wait_for_completion(&sdrain.done);
> +}
> +
> +/*
> + * Post a WR and block until its completion is reaped for the RQ.
> + */
> +static void __ib_drain_rq(struct ib_qp *qp)
> +{
> +	struct ib_qp_attr attr = { .qp_state = IB_QPS_ERR };
> +	struct ib_drain_cqe rdrain;
> +	struct ib_recv_wr rwr = {}, *bad_rwr;
> +	int ret;
> +
> +	if (qp->recv_cq->poll_ctx == IB_POLL_DIRECT) {
> +		WARN_ONCE(qp->recv_cq->poll_ctx == IB_POLL_DIRECT,
> +			  "IB_POLL_DIRECT poll_ctx not supported for drain\n");
> +		return;
> +	}
> +
> +	rwr.wr_cqe = &rdrain.cqe;
> +	rdrain.cqe.done = ib_drain_qp_done;
> +	init_completion(&rdrain.done);
> +
> +	ret = ib_modify_qp(qp, &attr, IB_QP_STATE);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to drain recv queue: %d\n", ret);
> +		return;
> +	}
> +
> +	ret = ib_post_recv(qp, &rwr, &bad_rwr);
> +	if (ret) {
> +		WARN_ONCE(ret, "failed to drain recv queue: %d\n", ret);
> +		return;
> +	}
> +
> +	wait_for_completion(&rdrain.done);
> +}

Hello Steve,

I only have one comment about this patch: are you aware that the six 
invocations of WARN_ONCE() can be made less verbose by rewriting if (c) 
{ WARN_ONCE(c, m); ... } as if (WARN_ONCE(c, m)) { ... } ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
