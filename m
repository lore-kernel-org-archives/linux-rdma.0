From: Qing Huang <qing.huang@oracle.com>
Subject: Re: [PATCH net] mlx4_core: restore optimal ICM memory allocation
Date: Wed, 30 May 2018 16:03:09 -0700
Message-ID: <badc0256-14ef-231c-8d3f-59d01ac17be8@oracle.com>
References: <20180530041152.113393-1-edumazet@google.com>
 <c87db444-266d-eb76-d8d5-d8a0c11038b1@oracle.com>
 <CANn89i+KRHvsxH9Gs4QhtMt4Ex2OH2h120gxjYkBf1_27O27_g@mail.gmail.com>
 <2cd40c9e-16a5-ba96-db7c-3aafc5af0957@oracle.com>
 <CANn89i+K3LS7+idPBOkcaBPBdBwz9tWCLqkzbWZA10W2mmR9hA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CANn89i+K3LS7+idPBOkcaBPBdBwz9tWCLqkzbWZA10W2mmR9hA@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Eric Dumazet <edumazet@google.com>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>, John Sperbeck <jsperbeck@google.com>, Tarick Bedeir <tarick@google.com>, Daniel Jurgens <danielj@mellanox.com>, Zhu Yanjun <yanjun.zhu@oracle.com>, Tariq Toukan <tariqt@mellanox.com>, linux-rdma <linux-rdma@vger.kernel.org>, Santosh Shilimkar <santosh.shilimkar@oracle.com>
List-Id: linux-rdma@vger.kernel.org



On 5/30/2018 2:30 PM, Eric Dumazet wrote:
> On Wed, May 30, 2018 at 5:08 PM Qing Huang<qing.huang@oracle.com>  wrote:
>>
>> On 5/30/2018 1:50 PM, Eric Dumazet wrote:
>>> On Wed, May 30, 2018 at 4:30 PM Qing Huang<qing.huang@oracle.com>  wrote:
>>>> On 5/29/2018 9:11 PM, Eric Dumazet wrote:
>>>>> Commit 1383cb8103bb ("mlx4_core: allocate ICM memory in page size chunks")
>>>>> brought a regression caught in our regression suite, thanks to KASAN.
>>>> If KASAN reported issue was really caused by smaller chunk sizes,
>>>> changing allocation
>>>> order dynamically will eventually hit the same issue.
>>> Sigh, you have little idea of what your patch really did...
>>>
>>> The KASAN part only shows the tip of the iceberg, but our main concern
>>> is an increase of memory overhead.
>> Well, the commit log only mentioned KASAN and but the change here didn't
>> seem to solve
>> the issue.
> Can you elaborate ?
>
> My patch solves our problems.
>
> Both the memory overhead and KASAN splats are gone.

If KASAN issue was triggered by using smaller chunks, when under memory 
pressure with lots of fragments,
low order memory allocation will do the similar things. So perhaps in 
your test env, memory allocation
and usage is relatively static, that's probably why using larger chunks 
didn't really utilize low order
allocation code path hence no KASAN issue was spotted.

Smaller chunk size in the mlx4 driver is not supposed to cause any 
memory corruption. We will probably
need to continue to investigate this. Can you provide the test command 
that trigger this issue when running
KASAN kernel so we can try to reproduce it in our lab? It could be that 
upstream code is missing some other
fixes.


>>> Alternative is to revert your patch, since we are now very late in 4.17 cycle.
>>>
>>> Memory usage has grown a lot with your patch, since each 4KB page needs a full
>>> struct mlx4_icm_chunk (256 bytes of overhead !)
>> Going to smaller chunks will have some overhead. It depends on the
>> application though.
>> What's the total increased memory consumption in your env?
> As I explained, your patch adds 256 bytes of overhead per 4KB.
>
> Your changelog did not mentioned that at all, and we discovered this
> the hard way.

If you have some concern regarding memory usage, you should bring this 
up during code review.

Repeated failure and retry for lower order allocations could be bad for 
latency too. This wasn't
mentioned in this commit either.

Like I said, how much overhead really depends on the application. 256 
bytes x chunks may not be
significant on a server with lots of memory.

> That is pretty intolerable, and is a blocker for us, memory is precious.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message tomajordomo@vger.kernel.org
> More majordomo info athttp://vger.kernel.org/majordomo-info.html
