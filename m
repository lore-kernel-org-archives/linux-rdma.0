From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Mon, 27 Jul 2015 11:14:41 -0600
Message-ID: <20150727171441.GC18348@obsidianresearch.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722180203.GI26909@obsidianresearch.com>
 <55B0BFA4.4060509@dev.mellanox.co.il>
 <20150723161436.GC25174@obsidianresearch.com>
 <55B11A92.9040406@dev.mellanox.co.il>
 <20150723185126.GA31346@obsidianresearch.com>
 <55B4AC26.20405@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55B4AC26.20405-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 26, 2015 at 12:45:10PM +0300, Sagi Grimberg wrote:
> On 7/23/2015 9:51 PM, Jason Gunthorpe wrote:
> >On Thu, Jul 23, 2015 at 07:47:14PM +0300, Sagi Grimberg wrote:
> >
> >>>>>So we force ULPs to think about what they are doing properly, and we
> >>>>>get a chance to actually force lkey to be local use only for IB.
> >>>>
> >>>>The lkey/rkey decision is passed in the fastreg post_send().
> >>>
> >>>That is too late to check the access flags.
> >>
> >>Why? the access permissions are kept in the mr context?
> >
> >Sure, one could do if (key == mr->lkey) .. check lkey flags in the
> >post, but that seems silly considering we want the post inlined..
> 
> Why should we check the lkey/rkey access flags in the post?

Eh? It was your idea..

I just want to check the access flags and force lkey's to not have
ACCESS_REMOTE set without complaining loudly.

To do that you need to know if the mr is a lkey/rkey, and you need to
know the flags.

> >>I can move it to the post interface if it makes more sense.
> >>the access is kind of out of place in the mapping routine anyway...
> >
> >All the dma routines have an access equivalent during map, I don't
> >think it is out of place..
> >
> >To my mind, the map is the point where the MR should crystallize into
> >an rkey or lkey MR, not at the post.
> 
> I'm not sure I understand why the lkey/rkey should be set at the map
> routine. To me, it seems more natural to map_mr_sg and then either
> register the lkey or the rkey.

We need to check the access flags to put a stop to this remote access
lkey security problem. That means we need to label every MR as a lkey
or rkey MR.

No more MR's can be both nonsense.

Pick a place to do that and enforce that IB cannot have remote access
LKEYs.

My vote is to do that work in map, because I don't think it make any
sense in post (post should not fail)

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
