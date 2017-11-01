From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: How far back does rdma-core X supports the kernel Y?
Date: Wed, 1 Nov 2017 10:39:15 -0600
Message-ID: <20171101163915.GB1030@ziepe.ca>
References: <BN3PR07MB2578883C85DD3855C496F367F85F0@BN3PR07MB2578.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BN3PR07MB2578883C85DD3855C496F367F85F0-EldUQEzkDQfpW3VS/XPqkOFPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 01, 2017 at 12:07:07PM +0000, Amrani, Ram wrote:
> Hi All,
> I've installed rdma-core-15 on kernel 4.3 and ran into issues.
> 
> It seems this kernel doesn't include the following patch:
> https://github.com/torvalds/linux/commit/aa744cc01fe0f21dfbe2744d3fd5f2fb3244c9b3
> 
> So IB_QP_SMAC is present in kernel 4.3 but not in rdma-core-15.

> This caused a failure here:
>
> int ibv_cmd_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
>                       int attr_mask,
>                       struct ibv_modify_qp *cmd, size_t cmd_size)
> {
>         /*
>          * Masks over IBV_QP_DEST_QPN are only supported by
>          * ibv_cmd_modify_qp_ex.
>          */
>         if (attr_mask & ~((IBV_QP_DEST_QPN << 1) - 1))
>                 return EOPNOTSUPP;

WTF is this?

Based on the comment it should be:

         if (attr_mask & ~((1ULL << (IBV_QP_DEST_QPN + 1)) - 1))

To match the comment. And other places have the same mistake.

This was broken recently by 3ca7a1031486b588a7fbe0d262f8f89738215b58

Bodong??

> Do we expect these versions to operate?
> If not, from what version do we support backward compatibility?
> Are there any other backward compatibility issues you are aware of?

rdma-core should work with all kernel versions, anything else is a bad
bug.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
