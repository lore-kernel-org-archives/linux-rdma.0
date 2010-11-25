From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: ibv_post_send/recv kernel path optimizations (was:  uverbs: handle
 large number of entries)
Date: Thu, 25 Nov 2010 17:00:50 +0200
Message-ID: <4CEE7A22.2040706@voltaire.com>
References: <20101007161649.GD21206@obsidianresearch.com>	<20101007165947.GD11681@bicker>	<20101009231607.GA24649@obsidianresearch.com> <20101012113117.GB6742@bicker>	<20101012210118.GR24268@obsidianresearch.com> <20101013091312.GB6060@bicker>	<20101123071025.GI1522@bicker> <adahbf6gytv.fsf@cisco.com>	<20101124221845.GH2369@obsidianresearch.com> <adad3pugi90.fsf@cisco.com> <20101125041337.GA11049@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101125041337.GA11049-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Walukiewicz, Miroslaw" <Miroslaw.Walukiewicz-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Jason Gunthorpe wrote:
> Hmm, considering your list is everything but Mellanox, maybe it makes much more sense to push the copy_to_user down into the driver - ie a ibv_poll_cq_user - then the driver can construct each CQ entry on the stack and copy it to userspace, avoid the double copy, allocation and avoid any fixed overhead of ibv_poll_cq.
>
> A bigger change to be sure, but remember this old thread:
> http://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg05114.html
> 2x improvement by removing allocs on the post path..
Hi Mirek,

Any updates on your findings with the patches?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
