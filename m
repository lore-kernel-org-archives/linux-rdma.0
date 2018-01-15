From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [PATCH] net/mlx4_en: ensure rx_desc updating reaches HW before
 prod db updating
Date: Mon, 15 Jan 2018 13:50:34 +0800
Message-ID: <fea0aa1c-b68e-9485-3826-2dfad7824911@oracle.com>
References: <1515728542-3060-1-git-send-email-jianchao.w.wang@oracle.com>
 <20180112163247.GB15974@ziepe.ca> <1515775567.131759.42.camel@gmail.com>
 <a40e44f4-106b-1075-8f92-f7741508372c@oracle.com>
 <af562737-4a3e-0429-1fd6-fc25c3e3f867@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <af562737-4a3e-0429-1fd6-fc25c3e3f867@mellanox.com>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>, Eric Dumazet <eric.dumazet@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: junxiao.bi@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Hi Tariq

Thanks for your kindly response.

On 01/14/2018 05:47 PM, Tariq Toukan wrote:
> Thanks Jianchao for your patch.
> 
> And Thank you guys for your reviews, much appreciated.
> I was off-work on Friday and Saturday.
> 
> On 14/01/2018 4:40 AM, jianchao.wang wrote:
>> Dear all
>>
>> Thanks for the kindly response and reviewing. That's really appreciated.
>>
>> On 01/13/2018 12:46 AM, Eric Dumazet wrote:
>>>> Does this need to be dma_wmb(), and should it be in
>>>> mlx4_en_update_rx_prod_db ?
>>>>
>>> +1 on dma_wmb()
>>>
>>> On what architecture bug was observed ?
>> This issue was observed on x86-64.
>> And I will send a new patch, in which replace wmb() with dma_wmb(), to customer
>> to confirm.
> 
> +1 on dma_wmb, let us know once customer confirms.
> Please place it within mlx4_en_update_rx_prod_db as suggested.
Yes, I have recommended it to customer.
Once I get the result, I will share it here.
> All other calls to mlx4_en_update_rx_prod_db are in control/slow path so I prefer being on the safe side, and care less about bulking the barrier.
> 
> Thanks,
> Tariq
> 
