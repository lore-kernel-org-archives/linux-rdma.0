From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 26/37] add rxe_req.c
Date: Wed, 10 Aug 2011 20:44:07 +0200
Message-ID: <CAO+b5-p+fM+e9=usnfZ0JLHu3kwWE8Zey6Q2St6jYKaRaFg20g@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201229.415319539@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201229.415319539-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> +	/* heuristic sliding window algorithm to keep
> +	   sender from overrunning receiver queues */
> +	if (qp_type(qp) == IB_QPT_RC)  {
> +		if (psn_compare(qp->req.psn, qp->comp.psn +
> +				rxe_max_req_comp_gap) > 0) {
> +			qp->req.wait_psn = 1;
> +			goto exit;
> +		}
> +	}

Shouldn't the rxe_max_req_comp_gap parameter be negotiated via the
Priority-based Flow Control protocol (IEEE 802.1 Qbb) instead of using
a single parameter for all queue pairs ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
