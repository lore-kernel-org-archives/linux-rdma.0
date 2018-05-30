From: Qing Huang <qing.huang@oracle.com>
Subject: Re: [PATCH net] mlx4_core: restore optimal ICM memory allocation
Date: Wed, 30 May 2018 14:08:47 -0700
Message-ID: <2cd40c9e-16a5-ba96-db7c-3aafc5af0957@oracle.com>
References: <20180530041152.113393-1-edumazet@google.com>
 <c87db444-266d-eb76-d8d5-d8a0c11038b1@oracle.com>
 <CANn89i+KRHvsxH9Gs4QhtMt4Ex2OH2h120gxjYkBf1_27O27_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <CANn89i+KRHvsxH9Gs4QhtMt4Ex2OH2h120gxjYkBf1_27O27_g@mail.gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Eric Dumazet <edumazet@google.com>
Cc: David Miller <davem@davemloft.net>, netdev <netdev@vger.kernel.org>, Eric Dumazet <eric.dumazet@gmail.com>, John Sperbeck <jsperbeck@google.com>, Tarick Bedeir <tarick@google.com>, Daniel Jurgens <danielj@mellanox.com>, Zhu Yanjun <yanjun.zhu@oracle.com>, Tariq Toukan <tariqt@mellanox.com>, linux-rdma@vger.kernel.org, "santosh.shilimkar@oracle.com" <santosh.shilimkar@oracle.com>
List-Id: linux-rdma@vger.kernel.org



On 5/30/2018 1:50 PM, Eric Dumazet wrote:
> On Wed, May 30, 2018 at 4:30 PM Qing Huang <qing.huang@oracle.com> wrote:
>>
>>
>> On 5/29/2018 9:11 PM, Eric Dumazet wrote:
>>> Commit 1383cb8103bb ("mlx4_core: allocate ICM memory in page size chunks")
>>> brought a regression caught in our regression suite, thanks to KASAN.
>> If KASAN reported issue was really caused by smaller chunk sizes,
>> changing allocation
>> order dynamically will eventually hit the same issue.
> Sigh, you have little idea of what your patch really did...
>
> The KASAN part only shows the tip of the iceberg, but our main concern
> is an increase of memory overhead.

Well, the commit log only mentioned KASAN and but the change here didn't 
seem to solve
the issue.

>
> Alternative is to revert your patch, since we are now very late in 4.17 cycle.
>
> Memory usage has grown a lot with your patch, since each 4KB page needs a full
> struct mlx4_icm_chunk (256 bytes of overhead !)

Going to smaller chunks will have some overhead. It depends on the 
application though.
What's the total increased memory consumption in your env?

>
> Really we have no choice here, your patch went too far and increased
> memory consumption quite a lot.



>
> My patch is simply the best way to address your original concern, and
> not increase overall overhead.
>
> ( each struct mlx4_icm_chunk should be able to store
> MLX4_ICM_CHUNK_LEN pages, instead of one page of 4KB )
