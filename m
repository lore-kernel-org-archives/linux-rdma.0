From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 27/37] add rxe_resp.c
Date: Sat, 20 Aug 2011 18:26:05 +0200
Message-ID: <CAO+b5-r+MM4MxSiC9nQUd4m2sZ4z+FBeDc=dUcXwZ5wYz-jLcg@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201229.464927217@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201229.464927217-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM,  <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> +static char *resp_state_name[] = {
> +	[RESPST_NONE]				= "NONE",

Shouldn't that be "const char * const" instead of "char *" ?

> +/* rxe_recv calls here to add a request packet to the input queue */
> +void rxe_resp_queue_pkt(struct rxe_dev *rxe, struct rxe_qp *qp,
> +			struct sk_buff *skb)
> +{
> +	int must_sched;

Shouldn't that be "bool" instead of "int" ?

> +	default:
> +		WARN_ON(1);
> +		break;

Shouldn't that be "__WARN()" instead of "WARN_ON(1)" ?

> +static struct sk_buff *prepare_ack_packet(struct rxe_qp *qp,
> +					  struct rxe_pkt_info *pkt,
> +					  int opcode,
> +					  int payload,
> +					  u32 psn,
> +					  u8 syndrome)
> +{
> +	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
> +	struct sk_buff *skb;
> +	struct rxe_pkt_info *ack;
> +	int paylen;
> +	int pad;
> +
> +	/*
> +	 * allocate packet
> +	 */
> +	pad = (-payload) & 0x3;

Something like "pad = ALIGN(payload, 4) - payload" is probably easier to read.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
