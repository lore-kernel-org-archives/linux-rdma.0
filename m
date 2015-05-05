From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ib_ipoib: Scatter-Gather support in connected mode
Date: Tue, 5 May 2015 15:23:25 +0300
Message-ID: <20150505122324.GA2356@yuval-lab>
References: <1422357682-8934-1-git-send-email-yuval.shaia@oracle.com>
 <1422444987.3133.81.camel@opteya.com>
 <20150201070941.GA4778@yuval-lab>
 <20150315151616.GA3546@yuval-lab>
 <20150322092149.GA5229@yuval-lab>
 <20150323171749.GA3580@obsidianresearch.com>
 <20150401171708.GA21266@phlsvsds.ph.intel.com>
 <20150401200844.GE8024@yuval-lab>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150401200844.GE8024@yuval-lab>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi All,
If there are no more comments and no rejections can we take this patch to next stage and merge it?
Who maintain this part?

Yuval

On Wed, Apr 01, 2015 at 11:08:45PM +0300, Yuval Shaia wrote:
> On Wed, Apr 01, 2015 at 01:17:19PM -0400, ira.weiny wrote:
> > On Mon, Mar 23, 2015 at 11:17:49AM -0600, Jason Gunthorpe wrote:
> > > On Sun, Mar 22, 2015 at 11:21:50AM +0200, Yuval Shaia wrote:
> > > > On Sun, Mar 15, 2015 at 05:16:16PM +0200, Yuval Shaia wrote:
> > > > > Hi,
> > > > > I didn't got any further comments on this one.
> > > > > Any idea why SG in CM is un-welcome?
> > > > By mistake I sent a private mail only.
> > > > Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> > > > Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > > > Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
> > > > 
> > > > Your advice would be very appreciated.
> > > 
> > > I haven't looked in detail at the patch, but in principle, using S/G
> > > when ever possible should be the default, even if this creates a
> > > performance regression.
> > > 
> > > It is well known that high order allocations are problematic in Linux
> > > and should be avoided, and I also have seen systems blow up because of
> > > high order IPoIB allocations.
> > > 
> > > That said, there may be cases where S/G is not possible, you should
> > > try and get Mellanox to comment if all their offloads work on all
> > > their cards when S/G is used. Work may be required to resolve any of
> > > these constraints. I'd like to belive there is some reason why we've
> > > been doing high order allocations for so many years.
> > > 
> > > FWIW, I would probably choose to default S/G over any other offload
> > > acceleration.
> > 
> > I concur with Jason's assessment.
> > 
> > As Yann asked before:
> > 
> > What hardware have you tested this on?  Do you have any performance
> > measurements?  Or do you have a reproducer for some of the allocation issues
> > which have been seen?
> Tested on Mellanox MT26428. Have here also CX3, will update if there will be an issue.
> No impact on performances.
> I did not try to reproduce the issue but people that do got this dump:
> pr  7 09:33:30 dbnode kernel: Call Trace:
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff810ddf74>] __alloc_pages_nodemask+0x524/0x595
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff8110da3f>] kmem_getpages+0x4f/0xf4
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff8110dc12>] fallback_alloc+0x12e/0x1ce
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff8110ddd3>] ____cache_alloc_node+0x121/0x134
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff8110e3f3>] kmem_cache_alloc_node_notrace+0x84/0xb9
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff8110e46e>] __kmalloc_node+0x46/0x73
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff813b9aa8>] ? __alloc_skb+0x72/0x13d
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff813b9aa8>] __alloc_skb+0x72/0x13d
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff813f2364>] sk_stream_alloc_skb+0x3d/0xaf
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff813f35b5>] tcp_sendmsg+0x176/0x6cf
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff813b0d5f>] __sock_sendmsg+0x5e/0x67
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff813b1644>] sock_sendmsg+0xcc/0xe5
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff810b4d09>] ? delayacct_end+0x7d/0x88
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff8104a3b0>] ? delayacct_blkio_end+0x26/0x40
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff81077030>] ? autoremove_wake_function+0x0/0x3d
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff81456f1d>] ? __wait_on_bit+0x6c/0x7c
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff810d7b70>] ? sync_page+0x0/0x4d
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff8111656e>] ? __pfn_to_section+0x12/0x14
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff811165a2>] ? lookup_page_cgroup+0x32/0x48
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff81100a61>] ? swap_entry_free+0x7a/0xf3
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff8111c239>] ? fget_light+0x34/0x73
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff813b0fcb>] ? sockfd_lookup_light+0x20/0x58
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff813b22cf>] sys_sendto+0x12f/0x171
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff810a9d23>] ? audit_syscall_entry+0x103/0x12f
> Apr  7 09:33:30 dbnode kernel:  [<ffffffff81011db2>] system_call_fastpath+0x16/0x1b
> > 
> > I can't comment on how this may affect Mellanox Hardware but it seems like it
> > will work fine with Qib hardware.
> > 
> > Ira
> > 
> > 
> > > 
> > > Jason
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
