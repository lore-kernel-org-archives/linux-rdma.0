From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] mlx4: allow for 4K mtu configuration of IB ports
Date: Wed, 25 May 2011 16:07:05 -0600
Message-ID: <20110525220705.GG12525@obsidianresearch.com>
References: <alpine.LRH.2.00.1105251507140.16147@ogerlitz.voltaire.com>
 <BANLkTi=bKdVXm+f+HVeg2tBzT4RBJDCN_w@mail.gmail.com>
 <BANLkTinDCbPXi8zS46wcVW_Yn0fxzbSikw@mail.gmail.com>
 <BANLkTikrJ_3f+LwN_R=-AcwCde-KdHJhOQ@mail.gmail.com>
 <BANLkTinT5OJdP38Xq=PCtx1wgxDhjVfndA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BANLkTinT5OJdP38Xq=PCtx1wgxDhjVfndA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, May 26, 2011 at 12:46:20AM +0300, Or Gerlitz wrote:

> > I mean is there anyone who really uses >4 VLs? ?Presumably the
> > HW designers didn't think so, because they limited HW to 4 VLs with 4K MTU.
> 
> I'm not sure if 4 VLs are enough for all the topologies / algorithms I
> mentioned above, so I do prefer to leave an option to run with eight
> VLs. As for the HW designers comment, its always good to look
> forward

Routing algorithms only need VLs on interswitch links, not on HCA to
switch links. The only use of the HCA to switch VLs is for QoS. Mesh
topologies can usually be routed with only two VLs, but you need alot
of SLs to make that work.

IMHO it would be much nicer if the SM could control and set this
choice, but since the spec doesn't have a provision for this I'm not
sure what to suggest there..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
