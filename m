From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Thu, 23 Jul 2015 12:51:26 -0600
Message-ID: <20150723185126.GA31346@obsidianresearch.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722180203.GI26909@obsidianresearch.com>
 <55B0BFA4.4060509@dev.mellanox.co.il>
 <20150723161436.GC25174@obsidianresearch.com>
 <55B11A92.9040406@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55B11A92.9040406-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 23, 2015 at 07:47:14PM +0300, Sagi Grimberg wrote:

> >>>So we force ULPs to think about what they are doing properly, and we
> >>>get a chance to actually force lkey to be local use only for IB.
> >>
> >>The lkey/rkey decision is passed in the fastreg post_send().
> >
> >That is too late to check the access flags.
> 
> Why? the access permissions are kept in the mr context?

Sure, one could do if (key == mr->lkey) .. check lkey flags in the
post, but that seems silly considering we want the post inlined..

> I can move it to the post interface if it makes more sense.
> the access is kind of out of place in the mapping routine anyway...

All the dma routines have an access equivalent during map, I don't
think it is out of place..

To my mind, the map is the point where the MR should crystallize into
an rkey or lkey MR, not at the post.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
