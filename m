From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] IB/ipoib: Enable pkey and device name decoupling
Date: Sat, 21 Oct 2017 13:42:15 -0600
Message-ID: <20171021194215.GA4094@obsidianresearch.com>
References: <20170927093248.3819-1-yuval.shaia@oracle.com>
 <20170928163406.GB17880@obsidianresearch.com>
 <20170928164735.GC2297@mtr-leonro.local>
 <20170928165305.GE17880@obsidianresearch.com>
 <20171015054745.GA2608@yuvallap>
 <20171017081837.GA19107@obsidianresearch.com>
 <20171017102121.GM2106@mtr-leonro.local>
 <20171019061100.GB6555@obsidianresearch.com>
 <20171019061405.GW2106@mtr-leonro.local>
 <c2f3b529-cc53-aef0-fdcf-e86e99360db0@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <c2f3b529-cc53-aef0-fdcf-e86e99360db0-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dasaratharaman.chandramouli-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, pabeni-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, kernel-6AxghH7DbtA@public.gmane.org, ferasda-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, shamir.rabinovitch-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, chien.yen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 19, 2017 at 09:28:31AM +0300, Alex Vesker wrote:
> On 10/19/2017 9:14 AM, Leon Romanovsky wrote:
> >On Thu, Oct 19, 2017 at 12:11:00AM -0600, Jason Gunthorpe wrote:
> >>On Tue, Oct 17, 2017 at 01:21:21PM +0300, Leon Romanovsky wrote:
> >>>>Yes, we should add a deprecation one shot printk to the kernel for the
> >>>>sysfs interface to encourage people to use ip
> >>>Please don't do that, it won't help for anyone, and especially for the people
> >>>who didn't hear about "ip" in 2017.
> >>This is the standard kernel way to encourage people to use the new
> >>interfaces...
> >>
> >>>IPoIB netlink doesn't support enhanced IPoIB device because child
> >>>device in netlink code was not allocated with rdma_alloc_netdev call
> >>>as it was done for other flows.
> >>I don't understand, isn't this just a (bad) bug to be fixed?
> >Yes and we want to fix it BEFORE adding discouraging warnings.

> We plan to block ipoib_netlink in the meanwhile until we fix it.

That isn't a good idea, don't break APIs for performance reasons..

> The fix is a little tricky since the netdev is allocated in
> rtnl_newlink and it should be allocated with the new logic
> introduced in enhanced IPoIB, setting rn_ops, allocating an
> rdma_netdev if possible.

Should get on it then .. :)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
