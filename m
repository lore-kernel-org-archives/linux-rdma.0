From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: I/O error on dd commands
Date: Wed, 7 Dec 2016 12:47:00 +0200
Message-ID: <03797229-696a-3eba-6074-ab55e7fb213f@mellanox.com>
References: <0980d1e6e7d34e098900ee293aa0e487@TGXML382.toshiba.local>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-2022-jp"; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <0980d1e6e7d34e098900ee293aa0e487-DqNMWkYM789gYsFYm0uEO7jjLBE8jN/0@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Tomita.Haruo-IGagC74glE2s6Rmoc/2Z03gSJqDPrsil@public.gmane.org, monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Any interesting logs in dmesg ?

On 12/6/2016 7:55 AM, Tomita.Haruo-IGagC74glE2s6Rmoc/2Z03gSJqDPrsil@public.gmane.org wrote:
> Hi Max,
>
> Thank you for your reply.
> This issue reproduced vanilla 4.9-rc8.
>
>> can you try to repro it with iSER ?
>
> I'm sorry. I can't try iSER.
>
>> what is your backing store device ?
>
> I do now using TOSHIBA Enterprise SSD PX04PMB160.
> https://toshiba.semicon-storage.com/ap-en/product/storage-products/enterprise-ssd.html
>
>> is this happens in 1k bs only or in different bs as well ?
>
> This issue is confirming the reproduction in 512k/1024k/2048k/4096k/8192k bs.
> It occurs by more than one machine, so it isn't a failed of a NIC.
> LAN is a connection directly (It isn't a failed of a hub.)
>
>> rxe_req.c |    9 +++++----
>> 1 file changed, 5 insertions(+), 4 deletions(-)
>> --- linux-4.9-rc7/drivers/infiniband/sw/rxe/rxe_req.c.orig      2016-12-05 10:11:38.000000000 +0900
>> +++ linux-4.9-rc7/drivers/infiniband/sw/rxe/rxe_req.c   2016-12-05 10:15:43.000000000 +0900
>> @@ -705,12 +705,12 @@ next_wqe:
>>         skb = init_req_packet(qp, wqe, opcode, payload, &pkt);
>>         if (unlikely(!skb)) {
>>                 pr_err("qp#%d Failed allocating skb\n", qp_num(qp));
>> -               goto err;
>> +               goto err1;
>>         }
>>
>>         if (fill_packet(qp, wqe, &pkt, skb, payload)) {
>>                 pr_debug("qp#%d Error during fill packet\n", qp_num(qp));
>> -               goto err;
>> +               goto err2;
>>         }
>>
>>         /*
>> @@ -734,15 +734,16 @@ next_wqe:
>>                         goto exit;
>>                 }
>>
>> -               goto err;
>> +               goto err1;
>>         }
>>
>>         update_state(qp, wqe, &pkt, payload);
>>
>>         goto next_wqe;
>>
>> -err:
>> +err2:
>>         kfree_skb(skb);
>> +err1:
>>         wqe->status = IB_WC_LOC_PROT_ERR;
>>         wqe->state = wqe_state_error;
>>
>
> It's unrelated to this issue, please apply this patch.
>
> thanks,
> Haruo.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
