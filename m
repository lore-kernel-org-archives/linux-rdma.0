From: "jianchao.wang" <jianchao.w.wang@oracle.com>
Subject: Re: [PATCH] net/mlx4_en: ensure rx_desc updating reaches HW before
 prod db updating
Date: Sun, 14 Jan 2018 10:40:10 +0800
Message-ID: <a40e44f4-106b-1075-8f92-f7741508372c@oracle.com>
References: <1515728542-3060-1-git-send-email-jianchao.w.wang@oracle.com>
 <20180112163247.GB15974@ziepe.ca> <1515775567.131759.42.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1515775567.131759.42.camel@gmail.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: tariqt@mellanox.com, junxiao.bi@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Dear all

Thanks for the kindly response and reviewing. That's really appreciated.

On 01/13/2018 12:46 AM, Eric Dumazet wrote:
>> Does this need to be dma_wmb(), and should it be in
>> mlx4_en_update_rx_prod_db ?
>>
> +1 on dma_wmb()
> 
> On what architecture bug was observed ?
This issue was observed on x86-64.
And I will send a new patch, in which replace wmb() with dma_wmb(), to customer
to confirm.

Thanks
Jianchao
