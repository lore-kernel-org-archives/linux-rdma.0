From: Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] drivers/rxe: improve rxe loopback
Date: Thu, 27 Jul 2017 12:49:17 +0300
Message-ID: <52aeac10-079f-5c3b-5987-14ead00e2646@redhat.com>
References: <20170726145248.21677-1-marcel@redhat.com>
 <20170727073635.GB13672@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170727073635.GB13672-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 27/07/2017 10:36, Leon Romanovsky wrote:
> On Wed, Jul 26, 2017 at 05:52:48PM +0300, Marcel Apfelbaum wrote:
>> Currently a packet is marked for loopback only if the source and
>> destination address match. This is not enough when multiple
>> gids are present in rxe's gid table and the traffic is
>> from one gid to another.
>>
>> Fix it by marking the packet for loopback if the destination
>> address appears in rxe's gid table.
>>
>> Signed-off-by: Marcel Apfelbaum <marcel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>> ---
>>   drivers/infiniband/sw/rxe/rxe_net.c | 47 +++++++++++++++++++++++++++++++++++--
>>   1 file changed, 45 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
>> index c3a140e..b76a9a3 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_net.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
>> @@ -351,6 +351,27 @@ static void prepare_ipv6_hdr(struct dst_entry *dst, struct sk_buff *skb,
>>   	ip6h->payload_len = htons(skb->len - sizeof(*ip6h));
>>   }
>>
>> +static inline bool addr4_same_rxe(struct rxe_dev *rxe, struct in_addr *daddr)
>> +{

Hi Leon,
Thanks for the review.

> 
> In addition to Moni's comment, no "inline" functions in *.c files, please.
> 

Sure, I simply followed the function on the same file:
   static inline int addr_same(struct rxe_dev *rxe, struct rxe_av *av)
I even borrowed the name...

>> +	struct in_device *in_dev;
>> +	bool same_rxe = false;
>> +
>> +	rcu_read_lock();
>> +	in_dev = __in_dev_get_rcu(rxe->ndev);
>> +	if (!in_dev)
>> +		goto out;
>> +
>> +	for_ifa(in_dev)
>> +		if (!memcmp(&ifa->ifa_address, daddr, sizeof(*daddr))) {
>> +			same_rxe = true;
>> +			goto out;
>> +		}
>> +	endfor_ifa(in_dev);
> 
> I'm afraid that it will decrease performance drastically. One of the
> possible solutions to overcome it, is to check the address of first packet
> only, but it will work for RC only.
> 

How do you know is "the first" packet?
And yes, for UD the performance would decrease, but only
if the netdev has multiple IPs, right?

I'll ask on Moni's response mail for alternatives.

Thanks,
Marcel

>> +out:
>> +	rcu_read_unlock();
>> +	return same_rxe;
>> +}
>> +
>>   static int prepare4(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
>>   		    struct sk_buff *skb, struct rxe_av *av)
>>   {
>> @@ -367,7 +388,7 @@ static int prepare4(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
>>   		return -EHOSTUNREACH;
>>   	}
>>
>> -	if (!memcmp(saddr, daddr, sizeof(*daddr)))
>> +	if (addr4_same_rxe(rxe, daddr))
>>   		pkt->mask |= RXE_LOOPBACK_MASK;
>>
>>   	prepare_udp_hdr(skb, htons(RXE_ROCE_V2_SPORT),
>> @@ -384,6 +405,28 @@ static int prepare4(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
>>   	return 0;
>>   }
>>
>> +static inline bool addr6_same_rxe(struct rxe_dev *rxe, struct in6_addr *daddr)
>> +{
> 
> Ditto
> 
>> +	struct inet6_dev *in6_dev;
>> +	struct inet6_ifaddr *ifp;
>> +	bool same_rxe = false;
>> +
>> +	in6_dev = in6_dev_get(rxe->ndev);
>> +	if (!in6_dev)
>> +		return false;
>> +
>> +	read_lock_bh(&in6_dev->lock);
>> +	list_for_each_entry(ifp, &in6_dev->addr_list, if_list)
>> +		if (!memcmp(&ifp->addr, daddr, sizeof(*daddr))) {
>> +			same_rxe = true;
>> +			goto out;
>> +		}
>> +out:
>> +	read_unlock_bh(&in6_dev->lock);
>> +	in6_dev_put(in6_dev);
>> +	return same_rxe;
>> +}
>> +
>>   static int prepare6(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
>>   		    struct sk_buff *skb, struct rxe_av *av)
>>   {
>> @@ -398,7 +441,7 @@ static int prepare6(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
>>   		return -EHOSTUNREACH;
>>   	}
>>
>> -	if (!memcmp(saddr, daddr, sizeof(*daddr)))
>> +	if (addr6_same_rxe(rxe, daddr))
>>   		pkt->mask |= RXE_LOOPBACK_MASK;
>>
>>   	prepare_udp_hdr(skb, htons(RXE_ROCE_V2_SPORT),
>> --
>> 2.9.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
