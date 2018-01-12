From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] net/mlx4_en: ensure rx_desc updating reaches HW before
 prod db updating
Date: Fri, 12 Jan 2018 13:21:59 -0800
Message-ID: <1515792119.131759.52.camel@gmail.com>
References: <1515728542-3060-1-git-send-email-jianchao.w.wang@oracle.com>
         <20180112163247.GB15974@ziepe.ca> <1515775567.131759.42.camel@gmail.com>
         <85116e56-52b1-944d-6ee2-916ccfc3a7a6@mellanox.com>
         <1515788191.131759.48.camel@gmail.com>
         <e902138a-3508-3504-51e5-46152cc2fb31@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <e902138a-3508-3504-51e5-46152cc2fb31@mellanox.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jianchao Wang <jianchao.w.wang@oracle.com>
Cc: tariqt@mellanox.com, junxiao.bi@oracle.com, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2018-01-12 at 13:01 -0800, Saeed Mahameed wrote:

> which is better to grasp ?:
> 
> update_doorbell() {
>     dma_wmb();
>     ring->db = prod;
> }

This one is IMO the most secure one (least surprise)

Considering the time it took to discover this bug, I would really play
safe.

But obviously I do not maintain mlx4.
