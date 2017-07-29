From: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [bug report] IB/hns: Fix the bug of polling cq failed for
 loopback Qps
Date: Sat, 29 Jul 2017 15:28:57 +0800
Message-ID: <597C3939.2060407@huawei.com>
References: <20170719114829.sctq34wns6h6zvxz@mwanda>
 <59769D18.4020400@huawei.com> <20170725071118.3erfnxyiqi7ittl3@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170725071118.3erfnxyiqi7ittl3@mwanda>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2017/7/25 15:11, Dan Carpenter wrote:
> This is a Smatch check.https://lwn.net/Articles/629250/
>
> regards,
> dan carpenter
Hi, Dan Carpenter

Thanks,
I have another question,
We use "make ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- " to compile 
kernel with cross compiler.
If we want check only some files in some directories, how to use this 
smatch tool to check them?

Regards
Wei Hu

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
