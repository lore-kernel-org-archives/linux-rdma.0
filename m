From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 4/8] mlx5: Avoid sparse complaints about !!
Date: Thu, 13 Jul 2017 11:20:35 -0600
Message-ID: <20170713172035.GB11069@obsidianresearch.com>
References: <1499894262-10761-1-git-send-email-jgunthorpe@obsidianresearch.com>
 <1499894262-10761-5-git-send-email-jgunthorpe@obsidianresearch.com>
 <20170713075116.GA11233@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170713075116.GA11233-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 13, 2017 at 12:51:16AM -0700, Christoph Hellwig wrote:
> >  			if (qp->qp_cap_cache & MLX5_RX_CSUM_VALID)
> > -				wc->wc_flags |= (!!(cqe->hds_ip_ext & MLX5_CQE_L4_OK) &
> > -						 !!(cqe->hds_ip_ext & MLX5_CQE_L3_OK) &
> > -						(get_cqe_l3_hdr_type(cqe) ==
> > -						MLX5_CQE_L3_HDR_TYPE_IPV4)) <<
> > -						IBV_WC_IP_CSUM_OK_SHIFT;
> > +				wc->wc_flags |=
> > +				    ((bool)(cqe->hds_ip_ext & MLX5_CQE_L4_OK) &
> > +				     (bool)(cqe->hds_ip_ext & MLX5_CQE_L3_OK) &
> > +				     (get_cqe_l3_hdr_type(cqe) ==
> > +				      MLX5_CQE_L3_HDR_TYPE_IPV4))
> > +				    << IBV_WC_IP_CSUM_OK_SHIFT;
> 
> Meh.  This code is complete crap.  Please factor it out into a little
> helper that mere humans can read first.  And then replace the odd ^ used
> as && with proper if constructs and all should make much more sense.

Leon/Christoph:

As far as I could make out, this ugly thing is designed like this for
performance.

The choice of & vs && avoids branching (since && is short circuiting)
and the above boils down to some bitwise maths with no branches.

Other easier to read alternatives have branching and many more
instructions.

I don't want to argue with Mellanox on performance just to fix a
sparse warning, and they use the same construct in their kernel
driver, IIRC.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
