From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] RDMA/isert: Support iWARP transport
Date: Mon, 29 Jun 2015 11:46:31 -0600
Message-ID: <20150629174631.GA31823@obsidianresearch.com>
References: <20150625153754.13272.432.stgit@build.ogc.int>
 <20150625153922.13272.41789.stgit@build.ogc.int>
 <558C317E.4010402@mellanox.com>
 <005401d0af69$53f5a9e0$fbe0fda0$@opengridcomputing.com>
 <558E68EB.9040205@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <558E68EB.9040205-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Or Gerlitz' <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Roi Dayan' <roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'target-devel' <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Jun 27, 2015 at 12:12:11PM +0300, Sagi Grimberg wrote:

> >Also since we have the new rdma_cap_read_multi_sge() helper, I
> >thought I should use it. :)
> 
> I think that reading the exact device caps max_sge, max_sge_is better
> and more straight forward...

Right, rdma_cap_read_multi_sge was just a stand in wanting something
better to expose asymmetric read/write sge caps.

If iwarp can get what it needs via max_sge_rd then lets drop
rdma_cap_read_multi_sge.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
