From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Infiniband stack allows references to freed memory
Date: Wed, 18 Apr 2012 08:58:16 +0300
Message-ID: <4F8E57F8.9050703@mellanox.com>
References: <CAG4TOxN75jXze4iy_nCBO1vwqvXnwKcqbAFAEFR=n-PdiG4moA@mail.gmail.com> <20120201.202128.703330634975191244.davem@davemloft.net> <4F8D23A0.7000109@mellanox.com> <20120417.230418.1898458010494189728.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120417.230418.1898458010494189728.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/18/2012 6:04 AM, David Miller wrote:
> It is the only major instance that I don't personally have plans for a 
> dst_neigh_lookup() conversion. I can't do some of those 
> transformations to dst_neigh_lookup() in net/ipv4 and net/ipv6 until 
> the others are out of the way. 

understood, thanks for clarifying this out.

>> Just for the sake of example, does the atm code free from the races you mention re ipoib? I see that it does stick its own object on the  neighbour through the priv pointer but wasn't sure if it helps in that respect without further RCU-ing things.
>
> I haven't audited ATM for races of any kind, and I have no plans to  do so, sorry. Please, I did fully audit and analyze the IPoIB case, so please use one of the approaches suggsted.

okay, so please let me phrase that differently, would it be correct to 
say that if we stick to the 1st approach of still somehow associating 
the ipoib_neigh with the neighbour - no matter through what means we do 
that - RCU-ing is must here. Specifically, the neighbour->priv 
mechanism  wouldn't get us a way from adding that protection? or maybe 
it could make our life easier if we turn to use it?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
