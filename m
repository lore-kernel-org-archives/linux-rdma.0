From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Infiniband stack allows references to freed memory
Date: Tue, 17 Apr 2012 11:02:40 +0300
Message-ID: <4F8D23A0.7000109@mellanox.com>
References: <CAG4TOxNNTOc0hwjOuEa-p2SBf5GBnEjVQyOERiTq5gkprLioYQ@mail.gmail.com> <20120201.171703.1299449838314569881.davem@davemloft.net> <CAG4TOxN75jXze4iy_nCBO1vwqvXnwKcqbAFAEFR=n-PdiG4moA@mail.gmail.com> <20120201.202128.703330634975191244.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120201.202128.703330634975191244.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/2/2012 3:21 AM, David Miller wrote:
> From: Roland Dreier<roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
>
>> I'm happy to do it but I'm still not quite sure I understand what the
>> end state is.  Is it just a matter of peeking into the skb contents
>> to get at the daddr, looking up the neigh based on that and then
>> continuing to handle neighs as we do now?
>
> Right, you also will now have a reference to the neigh so you must release it.
>
>> Does that also work for ARP packets?
>
> ARP packets have no dst_entry, so would need to be handled specially right now anyways.
>
>> Are there any examples in your tree I can crib off of?
>
> grep for dst_neigh_lookup() in the net-next tree.

Hi Dave, Roland,

As was indicated over the thread @ 
http://marc.info/?t=132812805900004&r=1&w=2 the current situation can 
surely lead to races, and I'd be happy to revive it, hopefully towards 
somehow addressing the issue.From my reading through the thread, I 
understand that more or less the following paths (...) were suggested:

#1 convert ipoib to use dst_neigh_lookup instead of dst_get_neighbour_noref
#2 do some RCU-ing where we don't actually free the ipoib_neigh 
immediately, etc

Dave commented that #1 conversion step will allow to merge a change 
where dst_entry objects will not have an attached neighbour any more. 
Alternatively, IPoIB could manage a data structure where ipoib_neighs 
are looked up the packet ipv4/ipv6 header and not from the neighbour.

Performance wise, it seems that the two suggestions should introduce the 
~same overhead, since in the ipv4 case for example, from 
dst_neigh_lookup we would land in __ipv4_neigh_lookup which does a hash 
lookup and we ipoib doesn't use the neighbours any more, some data 
structure lookup (e.g hash) will be used to resolve the ipoib_neigh from 
the destination address.

Dave, as for the conversion to dst_neigh_lookup, looking on net-next, I 
see about 30 hits for dst_get_neighbour_noref vs 13 hits for 
dst_neigh_lookup, so I wasn't sure about your comment re the ipoib 
conversion being what actually remains to make that change happen, can 
you elaborate here a little further?

Also, if ipoib moves to use that api, you made a comment that it will 
have a reference on the neighbour which will need to be released. I took 
a look on the net/atm use case which should to some extent be similar to 
ipoib, I see that neigh_release is called for neighbours retrieved by 
that API, okay.

Just for the sake of example, does the atm code free from the races you 
mention re ipoib? I see that it does stick its own object on the 
neighbour through the priv pointer but wasn't sure if it helps in that 
respect without further RCU-ing things.


Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
