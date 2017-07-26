From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: Re: [PATCH] drivers/rxe: improve rxe loopback
Date: Wed, 26 Jul 2017 22:36:33 +0300
Message-ID: <20170726193632.GA2389@yuvallap>
References: <20170726145248.21677-1-marcel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170726145248.21677-1-marcel@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Marcel Apfelbaum <marcel@redhat.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, monis@mellanox.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
List-Id: linux-rdma@vger.kernel.org

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

The above endfor_ifa should move to below.

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
