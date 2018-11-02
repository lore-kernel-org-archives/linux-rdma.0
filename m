From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] net/mlx5e: fix high stack usage
Date: Fri, 2 Nov 2018 23:15:11 +0100
Message-ID: <CAK8P3a0ybuiu_dBfUDfMYUtKZ=yGdB7An0_wx_ZGhnS5rrD3_w@mail.gmail.com>
References: <20181102153316.1492515-1-arnd@arndb.de> <9f214f12ec89020ceb14c1aec25b3a0d968507aa.camel@mellanox.com>
 <2727f37b-1742-5532-317e-3be8a984266b@gmail.com> <4ebfc3aeb5335a1f671602f9a906f948c39a30da.camel@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <4ebfc3aeb5335a1f671602f9a906f948c39a30da.camel@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: "eric.dumazet@gmail.com" <eric.dumazet@gmail.com>, "davem@davemloft.net" <davem@davemloft.net>, "leon@kernel.org" <leon@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Moshe Shemesh <moshe@mellanox.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Boris Pismenny <borisp@mellanox.com>, Tariq Toukan <tariqt@mellanox.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, Eran Ben Elisha <eranbe@mellanox.com>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, Ilya Lesokhin <ilyal@mellanox.com>, Kamal Heib <kamalh@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 11/2/18, Saeed Mahameed <saeedm@mellanox.com> wrote:
> On Fri, 2018-11-02 at 14:39 -0700, Eric Dumazet wrote:
>>
>> On 11/02/2018 02:05 PM, Saeed Mahameed wrote:
>>
>> > temp will be mem copied to priv->stats.sw at the end,
>> > memcpy(&priv->stats.sw, &s, sizeof(s));
>> >
>> > one other way to solve this as suggested by Andrew, is to get rid
>> > of
>> > the temp var and make it point directly to priv->stats.sw
>> >
>>
>> What about concurrency ?
>>
>> This temp variable is there to make sure concurrent readers of stats
>> might
>> not see mangle data (because another 'reader' just did a memset() and
>> is doing the folding)
>>
>>
>> mlx5e_get_stats() can definitely be run at the same time by multiple
>> threads.
>>
>
> hmm, you are right, i was thinking that mlx5e_get_Stats will trigger a
> work to update stats and grab the state_lock, but for sw stats this is
> not the case it is done in place.
>
> BTW memcpy itself is not thread safe.

Before commit 6c63efe4cfab ("net/mlx5e: Remove redundant active_channels
indication"), there was a read_lock() in the function apparently intended to
made it thread safe. This got removed with the comment

commit 6c63efe4cfabf230a8ed4b1d880249875ffdac13
Author: Eran Ben Elisha <eranbe@mellanox.com>
Date:   Tue May 29 11:06:31 2018 +0300

    net/mlx5e: Remove redundant active_channels indication

    Now, when all channels stats are saved regardless of the channel's state
    {open, closed}, we can safely remove this indication and the stats spin
    lock which protects it.

    Fixes: 76c3810bade3 ("net/mlx5e: Avoid reset netdev stats on
configuration changes")

I don't really understand the reasoning, but maybe we can remove
the memcpy() if the code is thread safe, or we need the lock back if it's not.

         Arnd
