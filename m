From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/6] IB/srp: Print "ib_srp: " prefix once
Date: Wed, 11 May 2016 08:15:18 -0700
Message-ID: <57334C86.9020903@sandisk.com>
References: <573278D9.4050908@sandisk.com> <57327904.1040102@sandisk.com>
 <35cb01d1ab88$64133f60$2c39be20$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <35cb01d1ab88$64133f60$2c39be20$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: 'Christoph Hellwig' <hch-jcswGhMUV9g@public.gmane.org>, 'Sagi Grimberg' <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, 'Laurence Oberman' <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/11/2016 06:24 AM, Steve Wise wrote:
>> pr_debug() already prints prefix PFX. Avoid that PFX is printed
>> twice if the debug statement in srp_add_target() is enabled.
>>
>> Fixes: 34aa654ecb8e ("IB/srp: Avoid that I/O hangs due to a cable pull during
>> LUN scanning")
>> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
>> Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
>> Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # v3.19+
>
> Is this really needed for stable?

Hello Steve,

Since this patch touches a debug statement only I'm fine with not CC-ing 
stable for this patch.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
