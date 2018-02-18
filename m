From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCHv2 1/1] IB/rxe: remove unnecessary skb_clone
Date: Sun, 18 Feb 2018 10:12:27 +0200
Message-ID: <9ae90bdd-3b40-4485-2a0e-0afa08200fed@mellanox.com>
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
To: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yanjun Zhu <yanjun.zhu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2/14/2018 12:36 PM, Yuval Shaia wrote:
>>>>    	}
>>>> -	skb_copy = skb_clone(skb, GFP_ATOMIC);
>>>> -	if (skb_copy)
>>>> -		rxe_add_ref(qp); /* for the new SKB */
>>> Are you sure we don't need this?
>>  From my stress tests and performance tests, it will get better performance
>> to remove skb_clone.
> 
> My concern is only with the above ref count.
I agree with yuval in case xmit fails.
	send_atomic_ack()
	{
	   rxe_xmit_packet()
	   {
	      rxe_send()
	      {
		 rxe_add_ref(pkt->qp)  <--- add qp ref
		 err = ip_local_out() <---- fail here
	      }
	
	   if (rxe_xmit_packet() fails) {
		rxe_drop_ref(qp) <--- you must deref here
	   }
	}
> 
>> And there is no memory leak.  The whole soft RoCE can work well.
>> So I think removing this function is a good choice.
>>
>> Zhu Yanjun
>>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
