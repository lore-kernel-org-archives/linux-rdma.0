From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 for-next 1/2] IB/core: Report LSO capabilities when
 querying device
Date: Wed, 11 May 2016 13:20:03 -0600
Message-ID: <20160511192003.GA27843@obsidianresearch.com>
References: <20160506225523.GA21309@obsidianresearch.com>
 <alpine.DEB.2.20.1605090926440.6128@east.gentwo.org>
 <20160509163537.GA15479@obsidianresearch.com>
 <20160509191613.GS29160@leon.nu>
 <20160509195734.GA22669@obsidianresearch.com>
 <20160510044107.GU29160@leon.nu>
 <20160510170739.GA2879@obsidianresearch.com>
 <alpine.DEB.2.20.1605101928280.2103@east.gentwo.org>
 <20160511020429.GA32766@obsidianresearch.com>
 <HE1PR05MB164274F171401FC5B21B2474AA720@HE1PR05MB1642.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <HE1PR05MB164274F171401FC5B21B2474AA720-eBadYZ65MZ/fuMsuuuQLTtqRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 11, 2016 at 03:47:14AM +0000, Bodong Wang wrote:

> > I still don't understand why this is being forced into
> > libibverbs. dpdk would seem to be the prefered way to access these
> > sorts of features and there is no technical reason why the mlx
> > dpdk provider needs to use libibverbs. Talk directly to /dev/uverbs0
> > and use udata to enable the universe of nic specific features.

> There are other user space libraries which are build on top of
> libibverbs rather than DPDK. E.g, VMA.

I looked at the VMA manual a bit, and honestly, it looks a lot like
DPDK. It could hook into the kernel the same way (via udata and
/dev/uverbs0)

> The patches from kernel are purely for hardware capabilities
> report. The policy and logic about how to implement the LSO are
> living in libibverbs and hardware related libraies(e.g,
> libmlx5). Review these patches together might make things more
> clear. They're not pushed to community for review yet because we
> still can't reach the agreement from this very first step.

That seems like a great argument that this doesn't belong in the
common api. If it is just driver capabilities, and they are not well
defined, then put them in mlx4's udata.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
