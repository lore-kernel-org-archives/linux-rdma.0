From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: Potential lost receive WCs (was "[PATCH WIP 38/43]")
Date: Thu, 30 Jul 2015 10:00:13 -0600
Message-ID: <20150730160013.GA16659@obsidianresearch.com>
References: <7824831C-3CC5-49C4-9E0B-58129D0E7FFF@oracle.com>
 <20150724204604.GA28244@obsidianresearch.com>
 <E855E210-F640-4104-9B35-2A75DF1BF2E3@oracle.com>
 <20150729211557.GA16284@obsidianresearch.com>
 <DC5354A4-3EB4-46FF-AA34-9AE26DD25031@oracle.com>
 <55B9CB78.9040501@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55B9CB78.9040501-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 10:00:08AM +0300, Sagi Grimberg wrote:

> I still think that draining the CQ without respecting a quota is
> wrong, even if driverX has a glitch there.

Sure, but you can't just return from the CQ upcall after doing a
budget and expect to be called again in the future. That is absolutely
wrong.

It is very difficult to mix and match processing in the CQ upcall and
in another context.

So, either you drain the whole thing in the CQ upcall, or delegate to
another context and process it there, possibly sleeping during
processing when the budget is hit.

Overall, the process is the same, drain entirely before calling
ib_req_notify_cq, don't expect any CQ upcalls until ib_req_notify_cq
is called.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
