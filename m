From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 28/43] IB/core: Introduce new fast registration API
Date: Thu, 23 Jul 2015 12:42:21 -0600
Message-ID: <20150723184221.GA30303@obsidianresearch.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-29-git-send-email-sagig@mellanox.com>
 <20150722165012.GC6443@infradead.org>
 <20150722174401.GG26909@obsidianresearch.com>
 <55B0BEB4.9080702@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55B0BEB4.9080702-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 23, 2015 at 01:15:16PM +0300, Sagi Grimberg wrote:
> On 7/22/2015 8:44 PM, Jason Gunthorpe wrote:
> >On Wed, Jul 22, 2015 at 09:50:12AM -0700, Christoph Hellwig wrote:
> >>>+/**
> >>>+ * ib_map_mr_sg() - Populates MR with a dma mapped SG list
> >>>+ * @mr:            memory region
> >>>+ * @sg:            dma mapped scatterlist
> >>>+ * @sg_nents:      number of entries in sg
> >>>+ * @access:        access permissions
> >>
> >>I know moving the access flags here was my idea originally, but I seem
> >>convinced by your argument that it might fit in better with the posting
> >>helper.  Or did someone else come up with a better argument that mine
> >>for moving it here?
> >
> >I was hoping we'd move the DMA flush and translate into here and make
> >it mandatory. Is there any reason not to do that?
> 
> The reason I didn't added it in was so the ULPs can make sure they meet
> the restrictions of ib_map_mr_sg(). Allow SRP to iterate on his
> SG list set partials and iSER to detect gaps (they need to dma map
> for that).

I would like to see the kdoc for ib_map_mr_sg explain exactly what is
required of the caller, maybe just hoist this bit from the
ib_sg_to_pages

Not entirely required if we are going to have an API to do the test..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
