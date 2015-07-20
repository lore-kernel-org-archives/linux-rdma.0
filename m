From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v3 05/15] xprtrdma: Remove last ib_reg_phys_mr() call site
Date: Mon, 20 Jul 2015 16:34:27 -0500
Message-ID: <015301d0c333$da8bae40$8fa30ac0$@opengridcomputing.com>
References: <20150720185624.10997.51574.stgit@manet.1015granger.net> <20150720190311.10997.12636.stgit@manet.1015granger.net> <55AD5B48.3010906@talpey.com> <20150720210544.GA9655@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: 
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, 'Tom Talpey' <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: 'Chuck Lever' <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


> 
> > Based on that, should we remove the cxgb3 driver as well? Or at least
> > can you fix it up to at least fail get_dma_mr if there is too much
> > ram?
> >
> 
> I would like to keep cxgb3 around.  I can add code to fail if the memory is > 32b.  Do you know how I get the amount of available
ram?
>

Something like this?

@@ -736,6 +736,9 @@ static struct ib_mr *iwch_get_dma_mr(struct ib_pd *pd, int acc)
        /*
         * T3 only supports 32 bits of size.
         */
+       if ((totalram_pages << PAGE_SHIFT) > 0xffffffff)
+               return -ENOTSUPP;
+
        bl.size = 0xffffffff;
        bl.addr = 0;
        kva = 0;
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
