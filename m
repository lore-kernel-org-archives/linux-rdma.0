From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v3] opensm: support routing engine update
Date: Sun, 14 Feb 2010 14:38:54 +0200
Message-ID: <4B77EEDE.4090503@dev.mellanox.co.il>
References: <4AED461B.5040302@Voltaire.COM><4B1BD5B6.6000005@dev.mellanox.co.il><39C75744D164D948A170E9792AF8E7CA01F6FA2F@exil.voltaire.com> <4B1CBB34.6070708@dev.mellanox.co.il> <39C75744D164D948A170E9792AF8E7CA01F6FA30@exil.voltaire.com> <4B77CDD8.2040900@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B77CDD8.2040900-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Eli Dorfman (Voltaire)" <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Slava Strebkov <slavas-smomgflXvOZWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 14/Feb/10 12:18, Eli Dorfman (Voltaire) wrote:
> Slava Strebkov wrote:
>> HI!
>> That was my misunderstanding - upon heavy sweep SM will try to load
>> routing engines as defined in the SM.conf file (ftree&  updn - in that
>> order).
>> So ftree will be loaded when switch comes back from reboot.
>>
>> Slava
>>
>> -----Original Message-----
>> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Yevgeny Kliteynik
>> Sent: Monday, December 07, 2009 10:22 AM
>> To: Slava Strebkov
>> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> Subject: Re: [PATCH v3] opensm: support routing engine update
>>
>> Slava,
>>
>> Slava Strebkov wrote:
>>> Hi Yevgeny,
>>> In that case SM will use updn and will not come back to ftree
>>> automatically.
>>
>> I think that this is a bad thing.
>>
>> I wouldn't want *temporary* change of fabric to cause
>> *permanent* change of SM mode of operation. Such changes
>> do happen, and I'd prefer SM to continue functioning
>> in accordance to the user's configuration once the
>> fabric is settled again.
>>
>> I do see the cases were the change that you propose is
>> beneficial - if fabric topology doesn't fits the chosen
>> routing, SM will waste time on retrying the wrong routing
>> at every heavy sweep, but this happens due to suboptimal
>> SM configuration and not as a result of some event that
>> user has no control of.
>
> For every heavy sweep the SM will try to configure the routing engines as specified in the conf file.
> So when a switch goes up and ftree configuration is valid, the SM will configure ftree instead of updn.

OK then, sounds good.

-- Yevgeny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
