From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Wed, 19 Aug 2015 09:58:31 -0700
Message-ID: <20150819165831.GA14027@infradead.org>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722165012.GC6443@infradead.org>
 <20150722174401.GG26909@obsidianresearch.com>
 <55B0BEB4.9080702@dev.mellanox.co.il>
 <20150723175535.GE25174@obsidianresearch.com>
 <55D46EE8.4060701@dev.mellanox.co.il>
 <20150819125253.GB24746@infradead.org>
 <55D4AA2E.7090204@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55D4AA2E.7090204-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Wengang Wang <wen.gang.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 19, 2015 at 07:09:18PM +0300, Sagi Grimberg wrote:
> Ok, I was also thinking on moving the access flags
> to the work request again.

Yes, with the current code I don't think we need it in the MR.

> I'd prefer to get this right with a different helper like Steve
> suggested:
> int rdma_access_flags(int mr_roles);

We can start with that.  In the long run we really want to have
two higher level helpers to RDMA READ a scatterlist:

 - one for iWARP that uses an FR and RDMA READ WITH INVALIDATE
 - one of IB-like transports that just uses a READ with the
   local lkey

Right now every ULP that wants to support iWarp needs to duplicate
that code.  This leads to some curious situations like the NFS
server apparently always using FRs if available for this if my
reading of svc_rdma_accept() is correct, or the weird parallel
code pathes for IB vs iWarp in RDS:

hch@brick:~/work/linux/net/rds$ ls ib*
ib.c  ib_cm.c  ib.h  ib_rdma.c  ib_recv.c  ib_ring.c  ib_send.c
ib_stats.c  ib_sysctl.c
hch@brick:~/work/linux/net/rds$ ls iw*
iw.c  iw_cm.c  iw.h  iw_rdma.c  iw_recv.c  iw_ring.c  iw_send.c
iw_stats.c  iw_sysctl.c

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
