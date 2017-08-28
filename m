From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH v1 01/11] IB/rxe: Move refcounting earlier in rxe_send()
Date: Mon, 28 Aug 2017 13:05:09 +0000
Message-ID: <D5C98CC4.1DF95%Andrew.Boyer@emc.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
 <1503687956-7110-1-git-send-email-andrew.boyer@dell.com>
 <1503687956-7110-2-git-send-email-andrew.boyer@dell.com>
 <20170827120128.GB10450@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170827120128.GB10450@yuvallap>
Content-Language: en-US
Content-ID: <75CA631F25814843AAC4BD1FE567F565-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 8/27/17, 8:01 AM, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of Yuval
Shaia" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of
yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:

>On Fri, Aug 25, 2017 at 03:05:46PM -0400, Andrew Boyer wrote:
>> The network stack will call nskb's destructor, rxe_skb_tx_dtor(), if the
>> packet gets dropped by ip_local_out()/ip6_local_out(). Thus we need to
>>add
>> the QP ref before output to avoid extra dereferences during network
>> congestion. This could lead to unwanted destruction of the QP.
>>=20
>> Fix up the skb_out accounting, too.
>>=20
>> Fixes: fda85ce91240 ("IB/rxe: Fix kernel panic from skb destructor")
>> Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
>> Acked-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>> ---
>>  drivers/infiniband/sw/rxe/rxe_net.c | 8 +++++---
>>  1 file changed, 5 insertions(+), 3 deletions(-)
>>=20
>> diff --git a/drivers/infiniband/sw/rxe/rxe_net.c
>>b/drivers/infiniband/sw/rxe/rxe_net.c
>> index 08f3f90..0810f38 100644
>> --- a/drivers/infiniband/sw/rxe/rxe_net.c
>> +++ b/drivers/infiniband/sw/rxe/rxe_net.c
>> @@ -460,12 +460,17 @@ int rxe_send(struct rxe_dev *rxe, struct
>>rxe_pkt_info *pkt, struct sk_buff *skb)
>>  	nskb->destructor =3D rxe_skb_tx_dtor;
>>  	nskb->sk =3D pkt->qp->sk->sk;
>> =20
>> +	rxe_add_ref(pkt->qp);
>> +	atomic_inc(&pkt->qp->skb_out);
>> +
>>  	if (av->network_type =3D=3D RDMA_NETWORK_IPV4) {
>>  		err =3D ip_local_out(dev_net(skb_dst(skb)->dev), nskb->sk, nskb);
>>  	} else if (av->network_type =3D=3D RDMA_NETWORK_IPV6) {
>>  		err =3D ip6_local_out(dev_net(skb_dst(skb)->dev), nskb->sk, nskb);
>>  	} else {
>>  		pr_err("Unknown layer 3 protocol: %d\n", av->network_type);
>> +		atomic_dec(&pkt->qp->skb_out);
>> +		rxe_drop_ref(pkt->qp);
>>  		kfree_skb(nskb);
>>  		return -EINVAL;
>>  	}
>> @@ -475,10 +480,7 @@ int rxe_send(struct rxe_dev *rxe, struct
>>rxe_pkt_info *pkt, struct sk_buff *skb)
>>  		return -EAGAIN;
>>  	}
>
>Shouldn't we also dec and drop ref in case that net_xmit_eval returns
>error?

That=B9s the catch. net_xmit_eval() is just looking for error codes; it=B9s
not doing the actual transmit. The transmit already started back in
ip_local_out()/ip6_local_out(), and if those end up failing the destructor
will be called. Any cleanup we do in this error path would be duplicated
in the destructor.

-Andrew

>
>> =20
>> -	rxe_add_ref(pkt->qp);
>> -	atomic_inc(&pkt->qp->skb_out);
>>  	kfree_skb(skb);
>> -
>>  	return 0;
>>  }
>> =20
>> --=20
>> 1.8.3.1
>>=20
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>--
>To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
