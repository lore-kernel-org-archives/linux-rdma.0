From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-rc] RDMA: Remove kernel private defines and reference
 to header from UAPI
Date: Wed, 8 Feb 2017 14:33:05 +0200
Message-ID: <fd3da941-6c50-50d5-cf93-1a06adb8def6@mellanox.com>
References: <20170207174600.27218-1-leon@kernel.org>
 <20170208082850.GA11087@infradead.org>
 <20170208100043.GC6005@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170208100043.GC6005-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 08/02/2017 12:00, Leon Romanovsky wrote:
> On Wed, Feb 08, 2017 at 12:28:50AM -0800, Christoph Hellwig wrote:
>>>  #include <linux/types.h>
>>> -#include <rdma/ib_verbs.h>
>>>
>>>  /*
>>>   * Increment this value if any changes that break userspace ABI
>>> @@ -548,11 +547,11 @@ enum {
>>>  };
>>>
>>>  enum {
>>> -	IB_USER_LEGACY_LAST_QP_ATTR_MASK = IB_QP_DEST_QPN
>>> +	IB_USER_LEGACY_LAST_QP_ATTR_MASK = 1ULL << 20,
>>>  };
>>>
>>>  enum {
>>> -	IB_USER_LAST_QP_ATTR_MASK = IB_QP_RATE_LIMIT
>>> +	IB_USER_LAST_QP_ATTR_MASK = 1ULL << 25,
>>
>> I disagree with the upendcoding.  These constant should be moved to
>> the user verbs header instead.
>
> These constants are part of much larger enum ib_qp_attr_mask. IMHO copy
> two values from that enum isn't good, but copy whole enum (mostly not
> needed for the users) is bad either. So I decided to open code it as a fix
> for -rc7.
>
> Thanks
>

IMHO, since these enum values are actually passed between user-space to 
kernel (attr_mask), it's acceptable to expose all enum values.
Otherwise, the user-space should define all these symbols by by itself, 
so why bother introduce only this explicit symbol?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
