From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v3 rdma-core 0/7] libhns: userspace library for hns
Date: Sun, 13 Nov 2016 18:21:35 +0800
Message-ID: <58283EAF.7020508@huawei.com>
References: <1478781977-116803-1-git-send-email-oulijun@huawei.com>
 <20161110161550.GD28957@leon.nu> <5825673A.1050109@huawei.com>
 <20161111124240.GG28957@leon.nu>
 <20161111160202.GA22935@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161111160202.GA22935-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

在 2016/11/12 0:02, Jason Gunthorpe 写道:
> On Fri, Nov 11, 2016 at 02:42:40PM +0200, Leon Romanovsky wrote:
> 
>>>   I have checked the patches and fixed it and send the patchv4. I think that
>>> the patchv4 will not have errors and warnings for travis CI testing, but
>>> I don't have the Travis CI environment for testing it.
>>> I have tried to install the test environment according to your test log and it
>>> is fail.
>>> In addtion that, I have tested it for  patchv1/patchv2/patch3 by use the following way and it
>>> is ok
>>>  1. directly use the default script file build.sh
>>>     ./build.sh
>>>  2. use CC=aarch64-linux-gnu-gcc build
>>>     mkdir build
>>>     cd build
>>>     CC=aarch64-linux-gnu-gcc cmake -Gninja -DENABLE_RESOLVE_NEIGH=0 ..
> 
> For the 32 bit bugs all you need to do is run on x86 with the 32 bit
> compiler support installed:
> 
> $ CFLAGS=-m32 cmake -GNinja ..
> $ ninja
> 
>> 4. Send pull request to rdma-core via github interface and it will check
>> automatically.
> 
> This is certainly a better option than having Leon test your patches,
> just keep force pushing to your own pull request until travis is
> happy.
> 
> Make sure the 32 bit problems are fixed properly, use inttypes.h,
> uintptr, and so forth.
> 
> Jason
> 
Thanks your guide. I have test it by travis CI successfully and sent tha patchV5

Lijun Ou

> .
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
