From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/7] IB/rxe: Allocate enough space for an IPv6 addr
Date: Tue, 22 Nov 2016 15:28:07 -0800
Message-ID: <f4365da6-6038-1187-3a10-491cfa8d12d4@sandisk.com>
References: <1479479809-10798-1-git-send-email-andrew.boyer@dell.com>
 <975a89bc-033e-14ab-72f2-4244c0205e59@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <975a89bc-033e-14ab-72f2-4244c0205e59-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 11/22/2016 07:21 AM, Yonatan Cohen wrote:
> On 11/18/2016 4:36 PM, Andrew Boyer wrote:
>> Avoid smashing the stack when an ICRC error occurs on an IPv6 network.
>>
>> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
>> ---
>>  drivers/infiniband/sw/rxe/rxe_recv.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c
>> b/drivers/infiniband/sw/rxe/rxe_recv.c
>> index 46f0628..b40ab8d 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_recv.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_recv.c
>> @@ -391,7 +391,7 @@ int rxe_rcv(struct sk_buff *skb)
>>                   payload_size(pkt));
>>      calc_icrc = cpu_to_be32(~calc_icrc);
>>      if (unlikely(calc_icrc != pack_icrc)) {
>> -        char saddr[sizeof(struct in6_addr)];
>> +        char saddr[64];
>>
>>          if (skb->protocol == htons(ETH_P_IPV6))
>>              sprintf(saddr, "%pI6", &ipv6_hdr(skb)->saddr);
>>
> you fixed a bug here but i think the following would be better
> than hard coding 64 bytes on the stack
>
> --- a/drivers/infiniband/sw/rxe/rxe_recv.c
> +++ b/drivers/infiniband/sw/rxe/rxe_recv.c
> @@ -391,16 +391,14 @@ int rxe_rcv(struct sk_buff *skb)
>                              payload_size(pkt));
>         calc_icrc = cpu_to_be32(~calc_icrc);
>         if (unlikely(calc_icrc != pack_icrc)) {
> -               char saddr[sizeof(struct in6_addr)];
>
>                 if (skb->protocol == htons(ETH_P_IPV6))
> -                       sprintf(saddr, "%pI6", &ipv6_hdr(skb)->saddr);
> +                       pr_warn_ratelimited("bad ICRC from %pI6\n",
> &ipv6_hdr(skb)->saddr);
>                 else if (skb->protocol == htons(ETH_P_IP))
> -                       sprintf(saddr, "%pI4", &ip_hdr(skb)->saddr);
> +                       pr_warn_ratelimited("bad ICRC from %pI4\n",
> &ip_hdr(skb)->saddr);
>                 else
> -                       sprintf(saddr, "unknown");
> +                       pr_warn_ratelimited("bad ICRC from unknown\n");
>
> -               pr_warn_ratelimited("bad ICRC from %s\n", saddr);
>                 goto drop;
>         }

Hello Yonatan,

Apparently our e-mails crossed. Anyway, have you considered to use %pIS 
instead of %pI4 / %pI6? See also 
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=1067964305df.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
