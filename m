From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V1 7/9] ib/pma: add include file for IBA performance
 counters definitions
Date: Wed, 6 Jul 2011 12:15:07 -0600
Message-ID: <20110706181507.GC1162@obsidianresearch.com>
References: <35AAF1E4A771E142979F27B51793A4888838E71F03@AVEXMB1.qlogic.org>
 <BANLkTikpMWYaXB8Ne+FaLGHi2L5TUCNDkQ@mail.gmail.com>
 <35AAF1E4A771E142979F27B51793A4888838FEE740@AVEXMB1.qlogic.org>
 <4E133575.8040105@mellanox.com>
 <CAL1RGDX7U=PMjWadeS3Gp+xST56xJiK=qydwu1PMcvkfb7DcnA@mail.gmail.com>
 <CAJZOPZK3tT9gXP46ek-tO3xyvj7=eKyGJXBoim9uOMbJc4BtfQ@mail.gmail.com>
 <35AAF1E4A771E142979F27B51793A4888838FEE894@AVEXMB1.qlogic.org>
 <CAL1RGDWHYMQHbZWwkysqZ7TLrB_ZDJWSTC4YCqk1wpme_3+BrQ@mail.gmail.com>
 <4E14940A.9080700@dev.mellanox.co.il>
 <CAL1RGDVpuwsgfVRxNw098W_wRECGn0uinQR+8txE96n5KtDXgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAL1RGDVpuwsgfVRxNw098W_wRECGn0uinQR+8txE96n5KtDXgw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 06, 2011 at 10:50:46AM -0700, Roland Dreier wrote:
> On Wed, Jul 6, 2011 at 9:57 AM, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> > I can rereview the patch intoto if this is needed.

> If you wouldn't mind, that would be great.  I would like to get a
> solution for qib in the tree but as I said I don't like stealing
> reserved bits, and I'm not confident I know the tradeoffs here.

It isn't just using a reserved bit in the cap mask, it is using a
reserved PM attribute ID as well (C16-2.1.2), and there is no way
around that..

Vendor specific stuff must be placed into a vendor specific class and
not put into the classes controlled by IBA.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
