From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH for-next 07/10] iser-target: Declare correct flags when
 accepting a connection
Date: Tue, 17 Nov 2015 12:13:13 +0200
Message-ID: <564AFDB9.3070603@mellanox.com>
References: <1447691861-3796-1-git-send-email-sagig@mellanox.com>
 <1447691861-3796-8-git-send-email-sagig@mellanox.com>
 <564ADE63.3030901@mellanox.com> <564AF808.7010404@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <564AF808.7010404-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jenny Derzhavetz <jennyf-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/17/2015 11:48 AM, Sagi Grimberg wrote:
>>> iser target does not support zero based virtual addresses and
>>> send with invalidate, so it should declare that it doesn't.
>>>
>>>
>>
>> This better go to stable kernels too, however there's little ugliness
>> involved since struct iser_cm_hdr doesn't exist for LIO in those 
>> kernels, thoughts?
>
> Umm, I think older kernels will interop just fine as the initiator
> considers rdma_cm accepts with no private data as not supporting any
> features (remote invalidate, zbva).

mmm, maybe we can let it go as you want... so no stabling here.

>
>> did you get any complaints from probably not Linux initiators 
>> interop-ing with LIO
>> on that matter?
>
> Nope... Have you? 

no
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
