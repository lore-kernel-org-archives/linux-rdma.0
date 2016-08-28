From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-rc 3/9] Revert "IB/mlx4: Return EAGAIN for any error
 in mlx4_ib_poll_one"
Date: Sun, 28 Aug 2016 12:28:13 -0600
Message-ID: <20160828182813.GB12783@obsidianresearch.com>
References: <1472371118-8260-1-git-send-email-leon@kernel.org>
 <1472371118-8260-4-git-send-email-leon@kernel.org>
 <20160828171758.GA11719@obsidianresearch.com>
 <20160828182613.GP594@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160828182613.GP594-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Aug 28, 2016 at 09:26:13PM +0300, Leon Romanovsky wrote:
> On Sun, Aug 28, 2016 at 11:17:58AM -0600, Jason Gunthorpe wrote:
> > On Sun, Aug 28, 2016 at 10:58:32AM +0300, Leon Romanovsky wrote:
> > > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >
> > > By Mellanox HW design and SW implementation poll_cq never
> > > fails and returns errors, so all these prints are to catch ULP bugs.
> >
> > Eh? How can a ULP cause poll_cq to get errors?
> >
> > Are you sure these are not driver bugs?
> >
> > Why can't you just print and discard the broken CQ entry?
> >
> > What should use ULP do when it get EINVAL? You say poll again is
> > not correct, so you suggest a full QP tear down?
> 
> See patches 4 and 6, they completely removed these EINVALs.

So the commit message is still wrong.

Why do we need this revert? Just squash it and mark it fixup the
original.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
