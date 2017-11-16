From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-core 3/3] libhns: Fix endian format of payload and
 immediate
Date: Thu, 16 Nov 2017 11:12:16 -0700
Message-ID: <20171116181216.GA20056@ziepe.ca>
References: <1509530440-164400-1-git-send-email-oulijun@huawei.com>
 <1509530440-164400-4-git-send-email-oulijun@huawei.com>
 <20171101161328.GB7815@ziepe.ca>
 <8dbc8305-f154-3b8c-795a-b5f1a6b53c73@huawei.com>
 <20171102150655.GD18874@ziepe.ca>
 <b2e9430c-a801-bef1-a491-8f983a525cab@huawei.com>
 <20171110211818.GH17451@ziepe.ca>
 <ef20c38b-201c-a039-c7c4-c5878fd0ee1c@huawei.com>
 <20171115153436.GO25894@ziepe.ca>
 <2ff6455b-0ac4-3ca7-b780-8224bf00bc35@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2ff6455b-0ac4-3ca7-b780-8224bf00bc35-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Nov 16, 2017 at 01:52:17PM +0800, oulijun wrote:

>   My os is ubuntu 14.04
>  the print info by uname -a is:
> Linux a8d50a1f660b 4.2.0-27-generic #32~14.04.1-Ubuntu SMP Fri Jan 22 15:32:26 UTC 2016 x86_64 x86_64 x86_64 GNU/Linux

Urk, that is half your problem.

You will have a lot less trouble if you are able to use Ubuntu Xenial
16.04.

I think the best option for you will be to run sparse inside docker,
let me see if I have time to make that happen for you.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
