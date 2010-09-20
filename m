From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: WRITE_WITH_IMMEDIATE target semantic
Date: Mon, 20 Sep 2010 11:23:47 -0600
Message-ID: <20100920172347.GA11157@obsidianresearch.com>
References: <OF2575B7D8.9367EBA3-ONC12577A4.0057C50D-C12577A4.005AD45D@ch.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <OF2575B7D8.9367EBA3-ONC12577A4.0057C50D-C12577A4.005AD45D-Xeyd2O9EBijQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <BMT-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 20, 2010 at 06:32:05PM +0200, Bernard Metzler wrote:

> while currently only supported by the InfiniBand transport,
> the libibverbs define a IBV_WR_RDMA_WRITE_WITH_IMM work request.
> Could someone please explain what the action at the peer side would be
> if a WRITE with immediate data comes in? One possible action would be
> to:

I've used this feature and according to my notes this is broadly
correct. A RWQE is consumed, the HCA doesn't use it for anything, and
the WC has the imm_data set, and the wr_id corrisponds to the RWQE.
The IBA notes the RWQE could be zero length.

The app needs to check for:
        if (wc.opcode & IBV_WC_RECV)
To see if the completion consumed a RWQE.
 
>     (3) set the WC's 'byte_len' to the received WRITE payload,

Hmm, I'm surprised by this, but, yep! pg 632 of the IBA.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
