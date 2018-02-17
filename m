From: Yanjun Zhu <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCHv2 1/1] IB/rxe: remove unnecessary skb_clone
Date: Sat, 17 Feb 2018 08:48:10 +0800
Message-ID: <8dcaddf9-120d-a718-ac1e-ab131d9a8377@oracle.com>
References: <1515140391-24752-1-git-send-email-yanjun.zhu@oracle.com>
 <1518508786-3204-1-git-send-email-yanjun.zhu@oracle.com>
 <20180213112124.GA6991@yuvallap>
 <5779a11b-d0f2-3231-a63f-009b1f080fb8@oracle.com>
 <20180214103630.GB4282@yuvallap>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180214103630.GB4282@yuvallap>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



On 2018/2/14 18:36, Yuval Shaia wrote:
>>>>    	}
>>>> -	skb_copy = skb_clone(skb, GFP_ATOMIC);
>>>> -	if (skb_copy)
>>>> -		rxe_add_ref(qp); /* for the new SKB */
>>> Are you sure we don't need this?
>>  From my stress tests and performance tests, it will get better performance
>> to remove skb_clone.
> My concern is only with the above ref count.
Hi, Yuval

Thanks for your code review.

 From the function send_atomic_ack, the variable skb is used in the 
following 2 places.
"
...
         res->type = RXE_ATOMIC_MASK;
         res->atomic.skb = skb;           <----One is here.
         res->first_psn = ack_pkt.psn;
         res->last_psn  = ack_pkt.psn;
         res->cur_psn   = ack_pkt.psn;

         rc = rxe_xmit_packet(rxe, qp, &ack_pkt, skb); <---The other is 
here.
...
"
The 2 will call kfree_skb after skb is used.

void kfree_skb(struct sk_buff *skb)
{
         if (!skb_unref(skb))
                 return;

         trace_kfree_skb(skb, __builtin_return_address(0));
         __kfree_skb(skb);
}

In the function kfree_skb, user ref is decreased and checked. To make 
sure in the 2 places, skb can be used.
I increased user ref.

Best Regards,
Zhu Yanjun
>
>> And there is no memory leak.  The whole soft RoCE can work well.
>> So I think removing this function is a good choice.
>>
>> Zhu Yanjun

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
