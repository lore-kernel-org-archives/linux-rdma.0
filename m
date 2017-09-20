From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] ibacm: Close MAD port when umad_register fails
Date: Thu, 21 Sep 2017 01:53:15 +0300
Message-ID: <20170920225314.GA12595@yuvallap>
References: <20170918215158.27597-1-yuval.shaia@oracle.com>
 <20170918215547.GB17476@obsidianresearch.com>
 <20170920223030.GA11703@yuvallap>
 <20170920225012.GC20974@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170920225012.GC20974-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Sep 20, 2017 at 04:50:12PM -0600, Jason Gunthorpe wrote:
> On Thu, Sep 21, 2017 at 01:30:30AM +0300, Yuval Shaia wrote:
> > On Mon, Sep 18, 2017 at 03:55:47PM -0600, Jason Gunthorpe wrote:
> > > On Tue, Sep 19, 2017 at 12:51:58AM +0300, Yuval Shaia wrote:
> > > > Cleanup of the open port is needed when program fails to register MAD
> > > > port.
> > > > 
> > > > Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > > >  ibacm/src/acm.c | 4 +++-
> > > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > > 
> > > Yuval, can you send this patch against rdma-core please? ibacm is not
> > > longer separate.
> > > 
> > > https://github.com/linux-rdma/rdma-core
> > 
> > You mean as PR to rdma-core or just that subject should say rdma-core?
> > (or both?)
> 
> Yes both/either will help it get picked up.
> 
> When I looked at the patch I wondered if it may have been against the
> original pre-rdma-core ibacm tree, since it didn't mention rdma-core
> or cc a rdma-core maintainer.... but I guess the ibacm/srcm/acm.c path
> means it is against rdma-core, right?

Yes.

> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
