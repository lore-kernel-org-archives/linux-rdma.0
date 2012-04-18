From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: Infiniband stack allows references to freed memory
Date: Wed, 18 Apr 2012 10:55:48 +0300
Message-ID: <4F8E7384.9000505@mellanox.com>
References: <4F8D23A0.7000109@mellanox.com> <20120417.230418.1898458010494189728.davem@davemloft.net> <4F8E57F8.9050703@mellanox.com> <20120418.021558.255251358104374047.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120418.021558.255251358104374047.davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/18/2012 9:15 AM, David Miller wrote:
> I would need to have to go back to the original thread and reread and 
> reabsorb the full analysis I did back then to answer this, and I 
> really don't have time to do that right now. You're going to have to 
> figure out how to fix this race properly on your own or with someone 
> else's help.

Sure, I didn't ask you to redo the analysis for the ipoib use case, its 
well understood.

I just wanted to see if you can spare few sentences regarding the 
neighbour priv mechanism you added in the below sequence, all are your 
patches from July 2011 which I think means they were introduced in 3.1.0

Specifically, is there an existing RCU neighbour related framework/call 
that a driver which uses neighbour_priv(n) and probably also the 
neigh_construct/destroy ndo callbacks, can use to make sure that 
modifying the private area isn't racy with readers of that area?

BTW I see that in commit 596b9b68ef118f7409afbc78487263e08ef96261 you 
changed IPoIB to set
dev->neigh_priv_len to be sizeof(ipoib_neigh), so you've started a 
possible porting here..

Or.

I took a look on the below series and also commit 
32092ecf0644e91070f9eff4f6e1edda8f90aecc
"atm: clip: Use device neigh support on top of "arp_tbl" " which made 
atm to use the neigh_construct call.


> commit da6a8fa0275e2178c44a875374cae80d057538d1
>
>     neigh: Add device constructor/destructor capability.
>
>     If the neigh entry has device private state, it will need
>     constructor/destructor ops.
>
> commit 869759b9e4160fb8a8d25bc3b4ce3b658523aebb
>
>     atm: clip: Convert over to neighbour_priv()
>
>
> commit 76cc714ed5fe6ed90aad5c52ff3030f1f4e22a48
>
>     neigh: Do not set tbl->entry_size in ipv4/ipv6 neigh tables.
>
>     Let the core self-size the neigh entry based upon the key length.
>
>
> commit 596b9b68ef118f7409afbc78487263e08ef96261
>
>     neigh: Add infrastructure for allocating device neigh privates.
>
>     netdev->neigh_priv_len records the private area length.
>
>     This will trigger for neigh_table objects which set tbl->entry_size
>     to zero, and the first instances of this will be forthcoming.
>
>
> commit 5b8b0060cbd6332ae5d1fa0bec0e8e211248d0e7
>
>     neigh: Get rid of neigh_table->kmem_cachep
>
>     We are going to alloc for device specific private areas for
>     neighbour entries, and in order to do that we have to move
>     away from the fixed allocation size enforced by using
>     neigh_table->kmem_cachep
>
>     As a nice side effect we can now use kfree_rcu().
>
>     Signed-off-by: David S. Miller <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>
>
> commit 1026fec8739663621d64216ba939c23bc1d089b7
>
>     neigh: Create mechanism for generic neigh private areas.
>
>     The implementation private sits right after the primary_key memory.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
