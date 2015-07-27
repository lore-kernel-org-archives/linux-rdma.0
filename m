From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Mon, 27 Jul 2015 14:29:57 -0600
Message-ID: <20150727202957.GA29619@obsidianresearch.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722180203.GI26909@obsidianresearch.com>
 <55B0BFA4.4060509@dev.mellanox.co.il>
 <20150723161436.GC25174@obsidianresearch.com>
 <55B11A92.9040406@dev.mellanox.co.il>
 <20150723185126.GA31346@obsidianresearch.com>
 <55B4AC26.20405@dev.mellanox.co.il>
 <20150727171441.GC18348@obsidianresearch.com>
 <55B69058.70403@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55B69058.70403-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Jul 27, 2015 at 03:11:04PM -0500, Steve Wise wrote:
> Well technically an MR with REMOTE_WRITE also has LOCAL_WRITE set. So you
> are proposing the core disallow a ULP from using the lkey for this type of
> MR?  Say in a RECV sge?

Yes, absolutely.

It is wrong anyhow, RECV isn't special, if you RECV into memory that
is exposed via a rkey MR, you have to invalidate that MR and fence DMA
before you can touch the buffer. Only very special, carefully
designed, cases could avoid that.

We don't have those cases, so lets just ban it. The only exception is
the iWarp RDMA READ thing.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
