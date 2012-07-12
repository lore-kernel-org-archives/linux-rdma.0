From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH] IB/ipoib: break linkage to neighbouring system
Date: Thu, 12 Jul 2012 20:13:28 +0000
Message-ID: <36F7E4A28C18BE4DB7C86058E7B607241DC0E3A6@MTLDAG01.mtl.com>
References: <1341914495-32730-1-git-send-email-ogerlitz@mellanox.com>,<32E1700B9017364D9B60AED9960492BC0D47265A@FMSMSX108.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC0D47265A-AtyAts71sc88Ug9VwtkbtrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Marciniszyn, Mike [mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org]
Sent: Thursday, July 12, 2012 7:48 PM
To: Or Gerlitz; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org; Erez Shitrit; Shlomo Pongratz
Subject: RE: [PATCH] IB/ipoib: break linkage to neighbouring system

ipoib_path_lookup(skb, n, dev);
> +struct ipoib_neigh *ipoib_neigh_get(struct net_device *dev, u8 *daddr)
>  {
> +     struct ipoib_dev_priv *priv = netdev_priv(dev);
> +     struct ipoib_hash_table *htbl = &priv->neigh_htbl;
>       struct ipoib_neigh *neigh;
> -     struct ipoib_dev_priv *priv = netdev_priv(n->dev);
> +
> +     read_lock_bh(&htbl->rwlock);
> +     neigh = ipoib_neigh_lookup(htbl, daddr);
> +     read_unlock_bh(&htbl->rwlock);
> +
> +     return neigh;
> +}
> +
I'm surprised a bit to see a reader lock when the routine being called used RCU with a reference count...

The RCU and reference count protect the individual entries in the hash.
The R/W lock protects the hash table itself. e.g. deleting the hash table itself, or in the future re-sizing it.
S.P.--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
