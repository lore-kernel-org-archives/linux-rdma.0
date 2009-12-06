From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 3/3 v2] opensm: connect switches in tree - implemented
 in up/down
Date: Sun, 06 Dec 2009 11:08:43 +0200
Message-ID: <4B1B749B.3000506@dev.mellanox.co.il>
References: <4AF160D8.9040801@dev.mellanox.co.il> <20091126154643.GA13817@me> <4B1B6CE1.4050802@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B1B6CE1.4050802-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Yevgeny Kliteynik wrote:
> Hi Sasha,
> 
> Sasha Khapyorsky wrote:
>> On 13:09 Wed 04 Nov     , Yevgeny Kliteynik wrote:
>>> This patch implements connect_switches option in up/down
>>> routing. Also, connect_roots is now handled as a special
>>> case of connect_switches.
>>>
>>> The idea is the following: when clearing hops, preserve
>>> the entries for switches that are above the highest leaf
>>> in the tree.
>>> So if the highest leaf in the tree has rank N, preserve
>>> hops to all the switches with ranks 0 to (N-1).
>>> When connecting roots (--connect_roots option), just set
>>> N to 1.
>>
>> Would this affect multicast routing in sense of a credit loop
>> generation?
> 
> Since I sent these patches, I had it running in various
> simulations and setups, and there are couple of fundamental
> issue with this approach. Basically, what I did here (in up/dn)
> is wrong. Not only for multicast, but for unicast too.
> It interferes with the usual up/down paths routing.
> 
> I will issue V3 of the patches, and it will be only
> connect_roots implementation for fat-tree with the
> two small remarks that you found.

It won't be V3 - it's just one patch that implements
connect_roots in ftree routing.

-- Yevgeny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
