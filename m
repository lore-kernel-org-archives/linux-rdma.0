From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 38/43] iser-target: Port to new memory registration
 API
Date: Thu, 23 Jul 2015 12:53:34 -0600
Message-ID: <20150723185334.GB31346@obsidianresearch.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-39-git-send-email-sagig@mellanox.com>
 <20150722170413.GE6443@infradead.org>
 <55AFD3DC.8070508@dev.mellanox.co.il>
 <20150722175755.GH26909@obsidianresearch.com>
 <55B0C18B.4080901@dev.mellanox.co.il>
 <20150723163124.GD25174@obsidianresearch.com>
 <55B11D84.102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55B11D84.102-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 23, 2015 at 07:59:48PM +0300, Sagi Grimberg wrote:
> I don't mean to be negative about your ideas, I just don't think that
> doing all the work in the drivers is going to get us to a better place.

No worries, I'm hoping someone can put the peices together and figure
out how to code share all the duplication we seem to have in the ULPs.

The more I've look at them, the more it seems like they get basic
things wrong, like SQE accouting in NFS, dma flush ordering in NFS,
rkey security in SRP/iSER..

Sharing code means we can fix those problems for good.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
