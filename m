From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ib_ipoib: Scatter-Gather support in connected mode
Date: Wed, 1 Apr 2015 23:33:15 +0300
Message-ID: <20150401203314.GF8024@yuval-lab>
References: <1422357682-8934-1-git-send-email-yuval.shaia@oracle.com>
 <1422444987.3133.81.camel@opteya.com>
 <20150201070941.GA4778@yuval-lab>
 <20150315151616.GA3546@yuval-lab>
 <20150322092149.GA5229@yuval-lab>
 <20150323171749.GA3580@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150323171749.GA3580-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Mar 23, 2015 at 11:17:49AM -0600, Jason Gunthorpe wrote:
> On Sun, Mar 22, 2015 at 11:21:50AM +0200, Yuval Shaia wrote:
> > On Sun, Mar 15, 2015 at 05:16:16PM +0200, Yuval Shaia wrote:
> > > Hi,
> > > I didn't got any further comments on this one.
> > > Any idea why SG in CM is un-welcome?
> > By mistake I sent a private mail only.
> > Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > 
> > Your advice would be very appreciated.
> 
> I haven't looked in detail at the patch, but in principle, using S/G
> when ever possible should be the default, even if this creates a
> performance regression.
Per my testings - no impact on performance.
> 
> It is well known that high order allocations are problematic in Linux
> and should be avoided, and I also have seen systems blow up because of
> high order IPoIB allocations.
Yes, snapshot from oops:
Call Trace:
 [<ffffffff810ddf74>] __alloc_pages_nodemask+0x524/0x595
 [<ffffffff8110da3f>] kmem_getpages+0x4f/0xf4
 [<ffffffff8110dc12>] fallback_alloc+0x12e/0x1ce
 [<ffffffff8110ddd3>] ____cache_alloc_node+0x121/0x134
 [<ffffffff8110e3f3>] kmem_cache_alloc_node_notrace+0x84/0xb9
 [<ffffffff8110e46e>] __kmalloc_node+0x46/0x73
 [<ffffffff813b9aa8>] ? __alloc_skb+0x72/0x13d
> 
> That said, there may be cases where S/G is not possible, you should
> try and get Mellanox to comment if all their offloads work on all
> their cards when S/G is used. Work may be required to resolve any of
> these constraints. I'd like to belive there is some reason why we've
> been doing high order allocations for so many years.
Old kernels (2.6.39) restrict the usage of S/G only to H/W which supports CSUM offload.
Mellanox HCA supports CSUM offload only for UD and this is why we can find S/G support for UD but not for CM.
With the introduction of commit ec5f061 this limitation is no longer there so no reason not to add this support.
> 
> FWIW, I would probably choose to default S/G over any other offload
> acceleration.
> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
