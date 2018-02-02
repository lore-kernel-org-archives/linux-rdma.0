From: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 0/4] Fixes for hns
Date: Fri, 2 Feb 2018 10:07:18 +0800
Message-ID: <26b0806d-3cc7-7c5b-6517-584198e8483f@huawei.com>
References: <1517314845-126094-1-git-send-email-oulijun@huawei.com>
 <20180201224956.GB8590@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="gbk"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180201224956.GB8590-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ÔÚ 2018/2/2 6:49, Jason Gunthorpe Ð´µÀ:
> On Tue, Jan 30, 2018 at 08:20:41PM +0800, Lijun Ou wrote:
>> This patch series is small set of fixes for hns.
>> The first patch and the second patch mainly fix
>> the flowup reviews from Jason Gunthorpe and the
>> third patch mainly remove the checkpatch.pl warning
>> in order to the new checkpatch requirements and
>> the last patch fix the bug for cleaning mtt table.
>>
>> Lijun Ou (4):
>>   RDMA/hns: Fix the endian problem for hns
> 
> Please resend this one with a fix for Doug's comments on for loop
> optimization
> 
thanks.
Firstly, I need to discuss the first reviews with Doug. I think that the 64bit may
be wasted. I will send the next patch for Doug's reviews after Doug reply
>>   RDMA/hns: Remove unnecessary operator
>>   RDMA/hns: Fix the checkpatch.pl warning
>>   RDMA/hns: Remove repeated option for free mtt table
> 
> Applied these three to for-next, thanks
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
