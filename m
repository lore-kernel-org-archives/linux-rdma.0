From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v1 ib-next 2/3] IB/core: IB/core: Allow legacy verbs
 through extended interfaces
Date: Tue, 10 Nov 2015 21:57:13 +0200
Message-ID: <20151110195713.GA21849@x-vnc01.mtx.labs.mlnx>
References: <1447178410-15360-1-git-send-email-eli@mellanox.com>
 <1447178410-15360-3-git-send-email-eli@mellanox.com>
 <20151110182107.GG12667@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151110182107.GG12667-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 10, 2015 at 11:21:07AM -0700, Jason Gunthorpe wrote:
> On Tue, Nov 10, 2015 at 08:00:09PM +0200, Eli Cohen wrote:
> > When an extended verbs is an extension to a legacy verb, the original
> > functionality is preserved. Hence we do not require each hardware driver
> > to set the extended capability. This will allow to use the extended verb
> > in its simple form with drivers that do not support the extended
> > capability.
> 
> Can we please get rid of uverbs_cmd_mask and uverbs_ex_cmd_mask ?
> 
> The driver should set the function pointers it does not support to
> NULL. We don't need the bitmask because we already know the answer.
> 
> For performance, I recommend having the core replace the NULL op
> pointers from the driver with a stub that returns ENOTSUP, and then
> drop all the checking in the fast path.
>

Yes, we can do this but I think this should be the subject for another
patch, agree?

Regarding using stabs, it may be nice but I don't think performance is
the issue here. Most verbs implementations involve relatively long i/o
operations anyway so the gain will not be noticable.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
