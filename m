From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH V1 7/9] ib/pma: add include file for IBA performance counters
 definitions
Date: Wed, 06 Jul 2011 14:53:29 -0400
Message-ID: <4E14AF29.7000104@dev.mellanox.co.il>
References: <35AAF1E4A771E142979F27B51793A4888838FEE740@AVEXMB1.qlogic.org> <4E133575.8040105@mellanox.com> <CAL1RGDX7U=PMjWadeS3Gp+xST56xJiK=qydwu1PMcvkfb7DcnA@mail.gmail.com> <CAJZOPZK3tT9gXP46ek-tO3xyvj7=eKyGJXBoim9uOMbJc4BtfQ@mail.gmail.com> <35AAF1E4A771E142979F27B51793A4888838FEE894@AVEXMB1.qlogic.org> <CAL1RGDWHYMQHbZWwkysqZ7TLrB_ZDJWSTC4YCqk1wpme_3+BrQ@mail.gmail.com> <4E14940A.9080700@dev.mellanox.co.il> <CAL1RGDVpuwsgfVRxNw098W_wRECGn0uinQR+8txE96n5KtDXgw@mail.gmail.com> <20110706181507.GC1162@obsidianresearch.com> <4E14A87B.2070405@dev.mellanox.co.il> <20110706184511.GD1162@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110706184511.GD1162-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/6/2011 2:45 PM, Jason Gunthorpe wrote:
> On Wed, Jul 06, 2011 at 02:24:59PM -0400, Hal Rosenstock wrote:
> 
>>> Vendor specific stuff must be placed into a vendor specific class and
>>> not put into the classes controlled by IBA.
>>
>> Either that or modify that compliance to allow for (optional) vendor
>> specific attributes in the PerfMgt class as is already done for the SM
>> class.
> 
> Just adding vendor usable attributes doesn't really address the
> problem of discoverability. With the SM class it is at least
> imaginable there is some kind of out of band discovery before the
> attributes are used, can't see that for PM. 

There are other ways to deal with this issue IMO. Moving it to a vendor
class doesn't make the issue necessarily go away either.

> Plus, there is no defined SMP vendor specific MAD, only GMP, 

True.

> so it makes a little more sense..

I think it could be done either way.

-- Hal

> Jason
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
