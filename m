From: "Wei Hu (Xavier)" <xavier.huwei@huawei.com>
Subject: Re: [PATCH V2 rdma-next 0/4] Misc update for hns driver
Date: Sat, 26 May 2018 15:40:10 +0800
Message-ID: <5B090F5A.9020306@huawei.com>
References: <1527070590-94399-1-git-send-email-xavier.huwei@huawei.com>
 <20180524214342.GA13272@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180524214342.GA13272@ziepe.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: dledford@redhat.com, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 2018/5/25 5:43, Jason Gunthorpe wrote:
> On Wed, May 23, 2018 at 06:16:26PM +0800, Wei Hu (Xavier) wrote:
>> This patchset included fixing bug, some optimization, reset
>> process for hns driver.
>>
>> v1->v2: 1.pull the patch out of the series. The name of the patch is 
>> 	  RDMA/hns: Implement the disassociate_ucontext API.
>> 	2.Modify the fixes statement according to Leon's comment.
>> 	3.Address the Jason's comment in reset relevant patch.
>>
>> Wei Hu (Xavier) (4):
>>   RDMA/hns: Modify uar allocation algorithm to avoid bitmap exhaust
>>   RDMA/hns: Increase checking CMQ status timeout value
> I took these two to for-next , the others have to respun.
Hi, Jason
   
    I will send V3 for these two patches and about disassociate_ucontext
the according to your comments.
    By the way,  About this patch as follows will still be in this
series, and you and other experts can continue giving comment. Thanks
             RDMA/hns: Add reset process for RoCE in hip08for these two
patches and the refactored patches

    Regards
Wei Hu
>
>>   RDMA/hns: Add reset process for RoCE in hip08
>>   RDMA/hns: Fix the illegal memory operation when cross page
> Thanks,
> Jason
>
>
