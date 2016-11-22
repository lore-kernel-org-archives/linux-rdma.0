From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 1/7] IB/rxe: Allocate enough space for an IPv6 addr
Date: Tue, 22 Nov 2016 14:11:33 -0800
Message-ID: <eaf0e3cc-bae8-8cb6-436e-2f99ea035a61@sandisk.com>
References: <1479479809-10798-1-git-send-email-andrew.boyer@dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479479809-10798-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 11/18/2016 06:36 AM, Andrew Boyer wrote:
> Avoid smashing the stack when an ICRC error occurs on an IPv6 network.
>
> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
> ---
>  drivers/infiniband/sw/rxe/rxe_recv.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
> index 46f0628..b40ab8d 100644
> --- a/drivers/infiniband/sw/rxe/rxe_recv.c
> +++ b/drivers/infiniband/sw/rxe/rxe_recv.c
> @@ -391,7 +391,7 @@ int rxe_rcv(struct sk_buff *skb)
>  			     payload_size(pkt));
>  	calc_icrc = cpu_to_be32(~calc_icrc);
>  	if (unlikely(calc_icrc != pack_icrc)) {
> -		char saddr[sizeof(struct in6_addr)];
> +		char saddr[64];
>
>  		if (skb->protocol == htons(ETH_P_IPV6))
>  			sprintf(saddr, "%pI6", &ipv6_hdr(skb)->saddr);

Hello Andrew,

Since you are touching this code please also switch from sprintf() to 
snprintf().

Thanks,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
