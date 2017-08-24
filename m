From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: =?UTF-8?B?UmU6IOOAkEFzayBmb3IgdXBzdHJlYW0gYnJhbmNo44CR?=
Date: Thu, 24 Aug 2017 16:34:03 +0800
Message-ID: <a6ed9854-46f0-77be-a708-de7b2100a58c@huawei.com>
References: <33078683-cf77-a116-4245-f561a29b114d@huawei.com>
 <546382b6-7cdc-9277-c0b8-130d58136a88@redhat.com>
 <599E81AF.5040901@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <599E81AF.5040901-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Chenxin (Charles)" <charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, weihaifeng <haifeng.wei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, liudongdong <liudongdong3-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

在 2017/8/24 15:35, Wei Hu (Xavier) 写道:
> 
> 
> On 2017/8/21 20:57, Doug Ledford wrote:
>> On 8/21/2017 2:16 AM, oulijun wrote:
>>> Hi,  Doug Ledford
>>>
>>>     We are preparing the hip08 RoCE driver for upstreaming.  I am found that
>>>
>>> you have create a new branch named net-next-base and this branch has
>>> included
>>>
>>> hns3 patchset.  If we generate patchset of hip08 RoCE driver, can
>>> directly based
>>>
>>> on this branch?
>> Yes.
>>
> Hi, Doug
> 
>    In the repo https://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git,
>    we found for-next-merged branch looks newer than k.o/net-next-base, right ?
>    please reconfirm which branch we should generate patcheset based on.
>    Thank you very much!
> 
> 
> 1. k.o/for-next-merged branch
> 
> git log --oneline drivers/infiniband/hw/hns/
> 
> b0e32e2 Merge branch 'k.o/for-4.13-rc' into k.o/for-next
> 5b59a39 IB/hns: fix memory leak on ah on error return path
> 3e5f088 IB/hns: Avoid compile test under non 64bit environments
> 8ccf098 Revert "RDMA/hns: fix build regression"
> 5db465f IB/hns: checking for IS_ERR() instead of NULL
> 967de35 IB/hns: include linux/interrupt.h
> ecd840f RDMA/hns: fix build regression
> d1d7149 IB/hns: fix semicolon.cocci warnings
> 87809f8 IB/hns: fix returnvar.cocci warnings
> 3756c7f IB/hns: fix boolreturn.cocci warnings
> e89bf46 IB/hns: Support compile test for hns RoCE driver
> 5f110ac4 IB/hns: Fix for checkpatch.pl comment style warnings
> d322f00 IB/hns: Fix the bug with modifying the MAC address without removing the driver
> 9de61d3 IB/hns: Fix the bug with rdma operation
> 58c4f0d IB/hns: Fix the bug with wild pointer when destroy rc qp
> 
> 2. k.o/net-next-base
> 
> git log --oneline drivers/infiniband/hw/hns/
> 
> 5db465f IB/hns: checking for IS_ERR() instead of NULL
> 5f110ac4 IB/hns: Fix for checkpatch.pl comment style warnings
> d322f00 IB/hns: Fix the bug with modifying the MAC address without removing the driver
> 9de61d3 IB/hns: Fix the bug with rdma operation
> 58c4f0d IB/hns: Fix the bug with wild pointer when destroy rc qp
> 
> 
>    Regards
> Wei Hu
> 
Please use net-next-base. Doug have comfirm. Please refer to his reply for this email.
> 
> 
> .
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
