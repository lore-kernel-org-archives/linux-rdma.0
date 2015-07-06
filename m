From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Mon, 6 Jul 2015 09:29:44 -0500
Message-ID: <001201d0b7f8$343056e0$9c9104a0$@opengridcomputing.com>
References: <20150705231831.12029.80307.stgit@build2.ogc.int> <20150705232158.12029.25472.stgit@build2.ogc.int> <559A2991.3040304@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <559A2991.3040304-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Haggai Eran' <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: Haggai Eran [mailto:haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org]
> Sent: Monday, July 06, 2015 2:09 AM
> To: Steve Wise; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> Cc: sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org; target-
> devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org; bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org
> Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
> 
> On 06/07/2015 02:22, Steve Wise wrote:
> > +int rdma_device_access_flags(struct ib_pd *pd, int roles, int attrs)
> > +{
> > +	int access_flags = attrs;
> > +
> > +	if (roles & RDMA_MRR_RECV)
> > +		access_flags |= IB_ACCESS_LOCAL_WRITE;
> > +
> > +	if (roles & RDMA_MRR_WRITE_DEST)
> > +		access_flags |= IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_WRITE;
> > +
> > +	if (roles & RDMA_MRR_READ_DEST) {
> > +		access_flags |= IB_ACCESS_LOCAL_WRITE;
> > +		if (rdma_protocol_iwarp(pd->device,
> > +					rdma_start_port(pd->device)))
> > +			access_flags |= IB_ACCESS_REMOTE_WRITE;
> > +	}
> > +
> > +	if (roles & RDMA_MRR_READ_SOURCE)
> > +		access_flags |= IB_ACCESS_REMOTE_READ;
> > +
> > +	if (roles & RDMA_MRR_ATOMIC_DEST)
> > +		access_flags |= IB_ACCESS_LOCAL_WRITE | IB_ACCESS_REMOTE_ATOMIC;
> 
> I think you need LOCAL_WRITE for ATOMIC_SOURCE in order to receive the
> results of the atomic operation.
> 

Ok.  I'm not familiar with atomics.  I'll verify with the IB spec and update the code as needed.


> > +
> > +	if (roles & RDMA_MRR_MW_BIND)
> > +		access_flags |= IB_ACCESS_MW_BIND;
> > +
> > +	return access_flags;
> > +}
> > +EXPORT_SYMBOL(rdma_device_access_flags);

--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
