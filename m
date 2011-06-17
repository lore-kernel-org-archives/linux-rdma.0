From: Andi Kleen <andi-Vw/NltI1exuRpAAqCnN02g@public.gmane.org>
Subject: Re: [PATCH 05/14] SIWv2: User interface: siw_verbs.h, siw_verbs.c, siw_user.h, siw_ae.c
Date: Thu, 16 Jun 2011 17:14:46 -0700
Message-ID: <m2y611fh55.fsf@firstfloor.org>
References: <1308228127-22634-1-git-send-email-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1308228127-22634-1-git-send-email-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org> (Bernard
	Metzler's message of "Thu, 16 Jun 2011 14:42:07 +0200")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <public-bmt-OA+xvbQnYDHMbYB6QlFGEg-wOFGN7rlS/M9smdsby/KFg@public.gmane.org>
Cc: public-netdev-u79uwXL29TY76Z2rM5mHXA-wOFGN7rlS/M9smdsby/KFg@public.gmane.org, public-linux-rdma-u79uwXL29TY76Z2rM5mHXA-wOFGN7rlS/M9smdsby/KFg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg-XMD5yJDbdMReXY1tMh2IBg@public.gmane.org> writes:
> +
> +/*
> + * siw_async_ev()
> + *
> + * Report Asynchonous event to user.
> + */
> +void siw_async_ev(struct siw_qp *qp, struct siw_cq *cq,
> +		  enum ib_event_type etype)
> +{
> +	static struct ib_event	event;

Static? That looks scary, especially without a lock.


-Andi

-- 
ak-VuQAYsv1563Yd54FQh9/CA@public.gmane.org -- Speaking for myself only

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
