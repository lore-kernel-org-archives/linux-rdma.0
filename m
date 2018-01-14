From: Tariq Toukan <tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] net/mlx4_en: ensure rx_desc updating reaches HW before
 prod db updating
Date: Sun, 14 Jan 2018 11:47:13 +0200
Message-ID: <af562737-4a3e-0429-1fd6-fc25c3e3f867@mellanox.com>
References: <1515728542-3060-1-git-send-email-jianchao.w.wang@oracle.com>
 <20180112163247.GB15974@ziepe.ca> <1515775567.131759.42.camel@gmail.com>
 <a40e44f4-106b-1075-8f92-f7741508372c@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a40e44f4-106b-1075-8f92-f7741508372c-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "jianchao.wang" <jianchao.w.wang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: tariqt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, junxiao.bi-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks Jianchao for your patch.

And Thank you guys for your reviews, much appreciated.
I was off-work on Friday and Saturday.

On 14/01/2018 4:40 AM, jianchao.wang wrote:
> Dear all
> 
> Thanks for the kindly response and reviewing. That's really appreciated.
> 
> On 01/13/2018 12:46 AM, Eric Dumazet wrote:
>>> Does this need to be dma_wmb(), and should it be in
>>> mlx4_en_update_rx_prod_db ?
>>>
>> +1 on dma_wmb()
>>
>> On what architecture bug was observed ?
> This issue was observed on x86-64.
> And I will send a new patch, in which replace wmb() with dma_wmb(), to customer
> to confirm.

+1 on dma_wmb, let us know once customer confirms.
Please place it within mlx4_en_update_rx_prod_db as suggested.
All other calls to mlx4_en_update_rx_prod_db are in control/slow path so 
I prefer being on the safe side, and care less about bulking the barrier.

Thanks,
Tariq
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
