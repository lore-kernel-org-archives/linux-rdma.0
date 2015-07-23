From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 38/43] iser-target: Port to new memory registration
 API
Date: Thu, 23 Jul 2015 10:31:24 -0600
Message-ID: <20150723163124.GD25174@obsidianresearch.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-39-git-send-email-sagig@mellanox.com>
 <20150722170413.GE6443@infradead.org>
 <55AFD3DC.8070508@dev.mellanox.co.il>
 <20150722175755.GH26909@obsidianresearch.com>
 <55B0C18B.4080901@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55B0C18B.4080901-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 23, 2015 at 01:27:23PM +0300, Sagi Grimberg wrote:
> >ib_post_fastreg_wr would be a function that needs 3 register passed
> >arguments and does a simple copy to the driver's actual sendq
> 
> That will require to take the SQ lock and write a doorbell for each
> registration and post you want to do. I'm confident that constructing
> a post chain with a single sq lock acquire and a single doorbell will
> be much much better even with conditional jumps and memsets.

You are still thinking at a micro level, the ULP should be working at
a higher level and requesting the MR(s) and the actual work together
so the driver can run the the whole chain of posts without extra stack
traffic, locking or doorbells.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
