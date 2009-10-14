From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [ofa-general][PATCH 1/4] SRP fail-over faster
Date: Wed, 14 Oct 2009 11:04:08 -0700
Message-ID: <adaaaztam3r.fsf@cisco.com>
References: <4AD3B433.7040803@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4AD3B433.7040803-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> (Vu Pham's message of "Mon, 12
	Oct 2009 15:56:51 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

One meta comment: when sending a series of 4 patches, please choose a
descriptive subject for each one.  We don't want the same headline in
the kernel log for all 4 patches.

 > -	qp_attr.qp_state = IB_QPS_RESET;
 > -	ret = ib_modify_qp(target->qp, &qp_attr, IB_QP_STATE);
 > -	if (ret)
 > -		goto err;
 > -
 > -	ret = srp_init_qp(target, target->qp);
 > -	if (ret)
 > +	old_qp = target->qp;
 > +	old_cq = target->cq;
 > +	ret = srp_create_target_ib(target);

I don't understand why this is any faster?  Is creating a new QP really
any different from modifying an old QP to reset state?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
