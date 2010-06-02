From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH] opensm: fixing compilation issues in some header files
Date: Wed, 02 Jun 2010 10:29:17 +0300
Message-ID: <4C06084D.3070101@dev.mellanox.co.il>
References: <4BAA34B2.9060808@dev.mellanox.co.il>
	<4C04F5E7.8030904@dev.mellanox.co.il> <20100601192205.GV28549@me>
	<4C057940.1020106@dev.mellanox.co.il> <20100602010314.GZ28549@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100602010314.GZ28549@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 02-Jun-10 4:03 AM, Sasha Khapyorsky wrote:
> On 00:18 Wed 02 Jun     , Yevgeny Kliteynik wrote:
>>>
>>> AFAIR (anytype *) to (void *) casting is not needed (doing implicitly)
>>> in C and this is already part of some basic standards.
>>
>> True, but the problem is not (anytype *) to (void *) casting.
>> It's the other way around: (void *) to (anytype *) casting.
>
> It is the same meaning. Otherwise it would be useless.

No, it's not.
Casting TO void* is not dangerous - void* is just a "place holder".
Casting FROM void* is more dangerous - it means your program would
actually be using this pointer's content.

Right now gcc allows you to do implicit casting in both ways, g++ doesn't.

Try compiling this code:

#include <stdlib.h>
int main()
{
         void * v = NULL;
         int * t = NULL;
         v = t;
         t = v;
         return 0;
}

try.cc:7: error: invalid conversion from 'void*' to 'int*'

Here are more details:

   http://www2.research.att.com/~bs/bs_faq2.html#void-ptr


-- Yevgeny
  
> Sasha
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
