From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH WIP 38/43] iser-target: Port to new memory registration
 API
Date: Wed, 22 Jul 2015 11:57:55 -0600
Message-ID: <20150722175755.GH26909@obsidianresearch.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
 <1437548143-24893-39-git-send-email-sagig@mellanox.com>
 <20150722170413.GE6443@infradead.org>
 <55AFD3DC.8070508@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55AFD3DC.8070508-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 22, 2015 at 08:33:16PM +0300, Sagi Grimberg wrote:
> >>  	memset(&fr_wr, 0, sizeof(fr_wr));
> >>+	ib_set_fastreg_wr(mr, mr->lkey, ISER_FASTREG_LI_WRID,
> >>+			  false, &fr_wr);
> >
> >Shouldn't ib_set_fastreg_wr take care of this memset?  Also it seems
> >instead of the singalled flag to it we might just set that or
> >other flags later if we really want to.

Seems reasonable.

If you want to micro optimize then just zero the few items that are
defined to be accessed for fastreg, no need to zero the whole
structure. Infact, you may have already done that, so just drop the
memset entirely.

> The reason I didn't put it in was that ib_send_wr is not a small struct
> (92 bytes IIRC). So I'm a bit reluctant to add an unconditional memset.
> Maybe it's better that the callers can carefully set it to save some
> cycles?

If you want to optimize this path, then Sean is right, move the post
into the driver and stop pretending that ib_post_send is a performance
API.

ib_post_fastreg_wr would be a function that needs 3 register passed
arguments and does a simple copy to the driver's actual sendq

No 96 byte structure memset, no stack traffic, no conditional
jumps.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
