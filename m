From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V3 1/5] RDMA/core: Transport-independent access flags
Date: Fri, 10 Jul 2015 10:11:08 -0600
Message-ID: <20150710161108.GA19042@obsidianresearch.com>
References: <20150707161751.GA623@obsidianresearch.com>
 <559BFE03.4020709@dev.mellanox.co.il>
 <20150707213628.GA5661@obsidianresearch.com>
 <559CD174.4040901@dev.mellanox.co.il>
 <20150708190842.GB11740@obsidianresearch.com>
 <20150708203205.GA21847@infradead.org>
 <20150709000337.GE16812@obsidianresearch.com>
 <559EF332.7060103@redhat.com>
 <20150709225306.GA30741@obsidianresearch.com>
 <559FC710.1050307@talpey.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <559FC710.1050307-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, 'Christoph Hellwig' <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org, bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jul 10, 2015 at 09:22:24AM -0400, Tom Talpey wrote:
> and it is enabled only when the RDMA Read is active.

??? How is that done? ib_get_dma_mr is defined to return a remote
usable rkey that is valid from when it it returns until the MR is
destroyed. NFS creates one mr early on, it does not seem to make one
per RDMA READ?

For the proposed iSER patch the problem is very acute, iser makes a
single PD and phys MR at boot time for each device. This means there
is a single machine wide unchanging rkey that allows remote physical
memory access. An attacker only has to repeatedly open QPs to iSER and
guess rkey values until they find it. Add in likely non-crypto
randomness for rkeys, and I bet it isn't even that hard to do.

So this seems to be a catastrophic security failing.

> > From there, it is a logical wish: If Steve is going to FRMR'ize iSER
> >to be acceptable security wise, I'd rather see that work done on in a
> >general way. Hence the API discussion.
> 
> Well, it's important to realize that NFS already does the Right Thing.
> So it isn't actually an urgent issue. There is time to discuss.

It depends on what is going on with iWarp iSER. If the iWarp community
thinks it should go ahead insecurely then fine, put a giant warning in
dmesg and go ahead, otherwise iWarp needs to address this difference
with a proper generic API, which appears, must wrapper
ib_post_send. Harder job :\

I'm sorry Steve for leading you down the wrong path with these flags,
I did not fully realize exactly what the iWarp difference was at the
start :(

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
