From: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 0/2] Add support for enhanced atomic operations
Date: Sun, 14 Feb 2010 15:24:19 +0200
Message-ID: <4B77F983.5040201@dev.mellanox.co.il>
References: <4B66FA54.6030408@dev.mellanox.co.il>	 <52BD554704A742B18E3F2F8F2B00B9FE@amr.corp.intel.com>	 <4B68020D.4080401@dev.mellanox.co.il>	 <f0e08f231002020754h482ba0f7xe35a78a72cc165e8@mail.gmail.com>	 <F1F846D4754246DC862643839C4CB216@amr.corp.intel.com>	 <4B692D67.5040006@dev.mellanox.co.il> <f0e08f231002110608y3a70c132r813d3472f82382d2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <f0e08f231002110608y3a70c132r813d3472f82382d2-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hal Rosenstock wrote:
> On Wed, Feb 3, 2010 at 3:01 AM, Vladimir Sokolovsky
> <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
>> Sean Hefty wrote:
>>>> Will Mellanox be adding this option to the IB spec rather than keep it
>>>> as vendor proprietary ?
>>> Along with that question, what is the use case for this feature?  The only
>>> benefit mentioned was saving a few bytes of memory, at the cost of
>>> carrying
>>> extra network headers.  Atomics are only 64-bits to begin with...
>>>
>>
>> For some applications the memory savings are very significant. One
>> example is fine grain lock implementations for huge data sets. In other
>> cases, the benefit is the ability to update multiple fields with a
>> single io operation.
> 
> What happens when the other end doesn't support this feature (new
> opcodes) ? How can that be determined remotely ? Is some CM related
> change also needed ?
> 
> -- Hal
> 

In this case the responder (the other end) will return a NAK-Invalid Request
to the requester.
There is no need to extend the CM protocol. This can be done as part of
application negotiation. Atomic is an optional feature and the CM is not
involved in negotiation of this. Application to application should decide
if they want and they can use atomic. The same should be done for extended
atomics.

Regards,
Vladimir
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
