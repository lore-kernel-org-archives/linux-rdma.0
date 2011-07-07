From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V1 7/9] ib/pma: add include file for IBA performance counters
 definitions
Date: Thu, 7 Jul 2011 09:55:14 +0300
Message-ID: <4E155852.5070500@mellanox.com>
References: <alpine.LRH.2.00.1106151733410.15844@ogerlitz.voltaire.com> <alpine.LRH.2.00.1106151747390.15844@ogerlitz.voltaire.com> <alpine.LRH.2.00.1106161119120.12552@ogerlitz.voltaire.com> <4DFA10CC.5080002@mellanox.com> <35AAF1E4A771E142979F27B51793A4888838E71F03@AVEXMB1.qlogic.org> <BANLkTikpMWYaXB8Ne+FaLGHi2L5TUCNDkQ@mail.gmail.com> <35AAF1E4A771E142979F27B51793A4888838FEE740@AVEXMB1.qlogic.org> <4E133575.8040105@mellanox.com> <CAL1RGDX7U=PMjWadeS3Gp+xST56xJiK=qydwu1PMcvkfb7DcnA@mail.gmail.com> <CAJZOPZK3tT9gXP46ek-tO3xyvj7=eKyGJXBoim9uOMbJc4BtfQ@mail.gmail.com> <35AAF1E4A771E142979F27B51793A4888838FEE894@AVEXMB1.qlogic.org> <CAL1RGDWHYMQHbZWwkysqZ7TLrB_ZDJWSTC4YCqk1wpme_3+BrQ@mail.gmail.com> <4E14940A.9080700@dev.mellanox.co.il> <CAL1RGDVpuwsgfVRxNw098W_wRECGn0uinQR+8txE96n5KtDXgw@m
 ail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVpuwsgfVRxNw098W_wRECGn0uinQR+8txE96n5KtDXgw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
>> I can rereview the patch intoto if this is needed.
> If you wouldn't mind, that would be great. I would like to get a solution for
> qib in the tree but as I said I don't like stealing reserved bits, and I'm
> not confident I know the tradeoffs here.

Roland, MiKe

Reading further on this thread the posts made by Ira, Hal and Jason, it 
seems
that there's still way to go with the other qib / mad related patch. I think
that at this point, this patch can be accepted 1st, and we'll take it 
from there,
makes sense?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
