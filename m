From: Salil Mehta <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: RE: [PATCH for-next 0/8] Bug Fixes and Code Improvement in HNS
 driver
Date: Thu, 29 Sep 2016 17:16:50 +0000
Message-ID: <F4CC6FACFEB3C54C9141D49AD221F7F91A73749F@lhreml503-mbx>
References: <20160910040930.25988-1-salil.mehta@huawei.com>
 <57EBDA43.3010708@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57EBDA43.3010708-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "Huwei (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Zhuangyuzeng (Yisen)" <yisen.zhuang-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <mehta.salil.lnk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Hi Salil,
> 
> I've chatted with Dave Miller about this series.  Here's where we
> stand.
> 
> First, the review feedback from Dave:
> 
> ---
> 
> In patch #7, their comments are mis-formatted and these
> hns guys do this a lot.
> 
> 	/*fix hardware broadcast/multicast packets queue loopback */
> 
> They seem to have a hard time putting an initial space in the comment,
> and properly capitalizing and punctuating their sentences.
> 
> Also in that new function, they need to order local variables from
> longest to shortest line (reverse christmas tree format).
> 
> Patch #6 has the local variable ordering issue as well as does patch
> #3.

Hi Doug,
I have refloated PATCH V2 with reworked 6/8 and 7/8 patches.

I scanned [PATCH V1 3/8] but could not find any ordering issue amongst
local variables there. I hope I have not missed anything.

Best regards
Salil
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
