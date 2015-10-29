From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/core, cma: Make __attribute_const__ declarations
 sparse-friendly
Date: Thu, 29 Oct 2015 14:16:10 -0700
Message-ID: <56328C9A.1030105@sandisk.com>
References: <55BF9E80.3030306@sandisk.com> <55CE410C.7080002@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55CE410C.7080002-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/14/2015 12:27 PM, Doug Ledford wrote:
> On 08/03/2015 01:01 PM, Bart Van Assche wrote:
>> Move the __attribute_const__ declarations such that sparse understands
>> that these apply to the function itself and not to the return type.
>> This avoids that sparse reports error messages like the following:
>>
>> drivers/infiniband/core/verbs.c:73:12: error: symbol 'ib_event_msg' redeclared with different type (originally declared at include/rdma/ib_verbs.h:470) - different modifiers
>>
>> Fixes: 2b1b5b601230 ("IB/core, cma: Nice log-friendly string helpers")
>> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>> Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> Thanks, applied.

(replying to an e-mail of two months ago)

Hi Doug,

On which branch has this patch been applied ? I couldn't find it in your 
k.o/for-4.4 branch.

Thanks,

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
