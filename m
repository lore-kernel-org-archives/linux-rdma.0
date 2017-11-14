From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core stable-v15] verbs: Do not block QP attr_masks
 used by older kernels
Date: Tue, 14 Nov 2017 11:58:42 -0700
Message-ID: <20171114185842.GE4263@ziepe.ca>
References: <636b5412-e41e-40ed-46da-a0e83bd5b049@suse.de>
 <20171114180451.GB18825@mtr-leonro.local>
 <20171114184912.GD4263@ziepe.ca>
 <0a24c63b-c108-3301-e78f-7e38d58f5bdb@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0a24c63b-c108-3301-e78f-7e38d58f5bdb-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 14, 2017 at 07:50:45PM +0100, Nicolas Morey-Chaisemartin wrote:
> 
> 
> Le 14/11/2017 à 19:49, Jason Gunthorpe a écrit :
> > On Tue, Nov 14, 2017 at 08:04:51PM +0200, Leon Romanovsky wrote:
> >> On Tue, Nov 14, 2017 at 03:40:25PM +0100, Nicolas Morey-Chaisemartin wrote:
> >>> At least the RDMA CM in 4.3 will give user space structs with these bits
> >>> set. Those kernels require user space to pass those set bits back to the
> >>> kernel. Blocking them causes RDMA CM to be unusable on older kernels.
> >>>
> >>> Stable-fix: Drop changes to verbs.h of the original fix,
> >>>  that are not needed for the fix itself.
> >>>
> >>> Fixes: 3ca7a1031486 ("ibverbs: Add support for packet pacing")
> >>> Commit-id: ce88cef301b ("verbs: Do not block QP attr_masks used by older kernels")
> >>> Reported-by: Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
> >>> Signed-off-by: Jason Gunthorpe <jgunthorpe-uk2M96/98Pc@public.gmane.org>
> >>>
> >> You need to add your Signed-off-by.
> Yep. Will do when applying.
> 
> > And please add something like
> >
> >     commit 9276717b9e297a62d1151a43d1cd286213f68eb7 upstream.
> >
> > after the subject line for all patches ...
> 
> That's what the Commit-id is for :)
> Do you prefer Upstream-commit-id ?

Oh! Yes, that seems fine as is then

Jason


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
