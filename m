From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH] drivers/rxe: improve rxe loopback
Date: Thu, 27 Jul 2017 10:36:35 +0300
Message-ID: <20170727073635.GB13672@mtr-leonro.local>
References: <20170726145248.21677-1-marcel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="VS++wcV0S1rZb1Fb"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170726145248.21677-1-marcel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marcel Apfelbaum <marcel@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, monis@mellanox.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, yuval.shaia@oracle.com
List-Id: linux-rdma@vger.kernel.org


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 26, 2017 at 05:52:48PM +0300, Marcel Apfelbaum wrote:
> Currently a packet is marked for loopback only if the source and
> destination address match. This is not enough when multiple
> gids are present in rxe's gid table and the traffic is
> from one gid to another.
>
> Fix it by marking the packet for loopback if the destination
> address appears in rxe's gid table.
>
> Signed-off-by: Marcel Apfelbaum <marcel@redhat.com>
> ---
>  drivers/infiniband/sw/rxe/rxe_net.c | 47 +++++++++++++++++++++++++++++++++++--
>  1 file changed, 45 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> index c3a140e..b76a9a3 100644
> --- a/drivers/infiniband/sw/rxe/rxe_net.c
> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> @@ -351,6 +351,27 @@ static void prepare_ipv6_hdr(struct dst_entry *dst, struct sk_buff *skb,
>  	ip6h->payload_len = htons(skb->len - sizeof(*ip6h));
>  }
>
> +static inline bool addr4_same_rxe(struct rxe_dev *rxe, struct in_addr *daddr)
> +{

In addition to Moni's comment, no "inline" functions in *.c files, please.

> +	struct in_device *in_dev;
> +	bool same_rxe = false;
> +
> +	rcu_read_lock();
> +	in_dev = __in_dev_get_rcu(rxe->ndev);
> +	if (!in_dev)
> +		goto out;
> +
> +	for_ifa(in_dev)
> +		if (!memcmp(&ifa->ifa_address, daddr, sizeof(*daddr))) {
> +			same_rxe = true;
> +			goto out;
> +		}
> +	endfor_ifa(in_dev);

I'm afraid that it will decrease performance drastically. One of the
possible solutions to overcome it, is to check the address of first packet
only, but it will work for RC only.

> +out:
> +	rcu_read_unlock();
> +	return same_rxe;
> +}
> +
>  static int prepare4(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
>  		    struct sk_buff *skb, struct rxe_av *av)
>  {
> @@ -367,7 +388,7 @@ static int prepare4(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
>  		return -EHOSTUNREACH;
>  	}
>
> -	if (!memcmp(saddr, daddr, sizeof(*daddr)))
> +	if (addr4_same_rxe(rxe, daddr))
>  		pkt->mask |= RXE_LOOPBACK_MASK;
>
>  	prepare_udp_hdr(skb, htons(RXE_ROCE_V2_SPORT),
> @@ -384,6 +405,28 @@ static int prepare4(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
>  	return 0;
>  }
>
> +static inline bool addr6_same_rxe(struct rxe_dev *rxe, struct in6_addr *daddr)
> +{

Ditto

> +	struct inet6_dev *in6_dev;
> +	struct inet6_ifaddr *ifp;
> +	bool same_rxe = false;
> +
> +	in6_dev = in6_dev_get(rxe->ndev);
> +	if (!in6_dev)
> +		return false;
> +
> +	read_lock_bh(&in6_dev->lock);
> +	list_for_each_entry(ifp, &in6_dev->addr_list, if_list)
> +		if (!memcmp(&ifp->addr, daddr, sizeof(*daddr))) {
> +			same_rxe = true;
> +			goto out;
> +		}
> +out:
> +	read_unlock_bh(&in6_dev->lock);
> +	in6_dev_put(in6_dev);
> +	return same_rxe;
> +}
> +
>  static int prepare6(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
>  		    struct sk_buff *skb, struct rxe_av *av)
>  {
> @@ -398,7 +441,7 @@ static int prepare6(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
>  		return -EHOSTUNREACH;
>  	}
>
> -	if (!memcmp(saddr, daddr, sizeof(*daddr)))
> +	if (addr6_same_rxe(rxe, daddr))
>  		pkt->mask |= RXE_LOOPBACK_MASK;
>
>  	prepare_udp_hdr(skb, htons(RXE_ROCE_V2_SPORT),
> --
> 2.9.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--VS++wcV0S1rZb1Fb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAll5mAMACgkQ5GN7iDZy
WKfXNw//W2r3eHM69b8uP8g5yCPvlwjtuNlplSpkJl8Cu1MZq7kJhVtj9+klrhUN
iaP0Idi9krNLJNqcLTHzfG2BFi6VeXTxuEMXOtq5tKBFYAbTh9masvigdgn/xjl5
/9unxymytFM8b/PKvRm/PV4aGaUaTQD3HHHeauEaqNek1chIncysLhMeKIjb4bDR
S2ihdYwL3hXTX4FsfN+6byoDk39dZL7E+HKoJn2D8WX58g6q/FhY89uH4pJkxfjw
xU07WpHf1dMOJ9QVJksKcXx2BM8cyVAWh/oF5h5tetuG3nvW1dL9xCzJwKH7AbSB
gn9CKWhb40mea8ofpEe+TTHMgoz2gsZYd0VzhSI8NzE+F/KnsH4cQLVm28coU8+v
DliV1OHeZL5s+WyGfZrZwGONG4yOEovRnTMoP2zA/CwHQSym1nIqrkb8KvHPRvZd
gfT51quOO0VKVOR6MOV9wsrGjr0UwiQsV+wl6usNNjae2clDvw9qxe982fXXZqLE
V7KdfJvkfqboWhkrvv6QJcvRo7bFvclXtVnforlbnscqHfXkOfM4PQ1dOqDS6MF2
Ltj1fDvDg1bVPmmlK60YIzZSwDKwBr9mTD/txL9UWjmAHyh8hxyieQUly29SSBme
mqWcnzcjXiuH/4jrzZwYC3FbP+taKpgRJxfaesT7bz9jzR9VqwQ=
=hSxO
-----END PGP SIGNATURE-----

--VS++wcV0S1rZb1Fb--
