From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm: fixing compilation issues in some header files
Date: Wed, 02 Jun 2010 00:18:56 +0300
Message-ID: <4C057940.1020106@dev.mellanox.co.il>
References: <4BAA34B2.9060808@dev.mellanox.co.il>
	<4C04F5E7.8030904@dev.mellanox.co.il> <20100601192205.GV28549@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100601192205.GV28549@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01-Jun-10 10:22 PM, Sasha Khapyorsky wrote:
> Hi Yevgeny,
>
> On 14:58 Tue 01 Jun     , Yevgeny Kliteynik wrote:
>>
>> On 24-Mar-10 5:50 PM, Yevgeny Kliteynik wrote:
>>> All the compilation issues refer to implicit casting
>>> from "void*" to "some_struct_t*"
>>
>> This was detected when compiling a code that includes these
>> headers with g++ compiler. The headers should be able to compile
>> by g++ (they have 'extern "C"').
>
> Well let's apply the patch since we have 'extern "C"'.
>
> But this raises another question. All affected header files are OpenSM
> internals and OpenSM is written in C (not C++). So why 'extern "C"'
> should be here at all? Do you know?
>
>> But the problem is not only
>> with g++ - it is with typing in general. I may be wrong, but I
>> feel that every new gcc version is more strongly typed.
>
> AFAIR (anytype *) to (void *) casting is not needed (doing implicitly)
> in C and this is already part of some basic standards.

True, but the problem is not (anytype *) to (void *) casting.
It's the other way around: (void *) to (anytype *) casting.

-- Yevgeny
  
> Sasha
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
