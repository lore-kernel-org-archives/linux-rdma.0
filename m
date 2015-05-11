From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH RFC] IB/core, cma: Nice log-friendly string helpers
Date: Mon, 11 May 2015 09:50:46 +0200
Message-ID: <55505F56.4030907@sandisk.com>
References: <1431252274-27739-1-git-send-email-sagig@mellanox.com>
 <554F32F3.1070308@sandisk.com> <554F36BC.5070009@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <554F36BC.5070009-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 05/10/15 12:45, Sagi Grimberg wrote:
> On 5/10/2015 1:29 PM, Bart Van Assche wrote:
>> On 05/10/15 12:04, Sagi Grimberg wrote:
>>> +#define IB_EVENT(event)                        \
>>> +    ((event) < ARRAY_SIZE(ib_events) ?            \
>>> +        ib_events[(event)] : "UNRECOGNIZED_EVENT")
>>> +
>>
>> Since a compiler is allowed to use a signed type to implement an enum,
>> please cast "event" to an unsigned type before comparing it with the
>> array size. Additionally, please consider to define IB_EVENT() as an
>> inline function instead of a preprocessor macro.
>
> I can do that, any specific reason why to use inline over macro here?

Not really ... just a general preference for functions over macros. One 
of the advantages we all know is that using a function instead of a 
macro gives the compiler a chance to perform type checking on arguments.

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
