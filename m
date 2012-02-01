From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Infiniband stack allows references to freed memory
Date: Wed, 1 Feb 2012 15:26:39 -0700
Message-ID: <20120201222638.GA24483@obsidianresearch.com>
References: <20120201.152213.433850213028883896.davem@davemloft.net>
 <CAG4TOxPrAhac1y-TzA=x47sm88JfQdkrpWW4Em_mBD=KbyRo+g@mail.gmail.com>
 <20120201.161333.2203265702893105548.davem@davemloft.net>
 <CAG4TOxMHG04_REzB9faBcjgUS43845qG5CgDYCUfLDYC6sEjmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG4TOxMHG04_REzB9faBcjgUS43845qG5CgDYCUfLDYC6sEjmw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 01, 2012 at 01:42:30PM -0800, Roland Dreier wrote:

> > RCU could be used to fix the race, but the difficulty in converting
> > this code over to dst_lookup_neigh() would remain and the latter is
> > more important to me than the former right now :-)
> 
> OK.  So do you have any thoughts about what the generic key available
> at transmit time (as you alluded to in your first message) might be?

I thought a big reason the IPoIB stuff was setup this way was to fit
in with older kernels (eg we cannot change the neigh structures)?

Would making the allocation of the neigh structure returned by
dst_lookup_neigh() large enough to hold the ARP/ND HW addr and also
the IB path record solve these problems? At least for UD?

Haven't looked at the dst_lookup_neigh work from David though, so I
could be way off :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
