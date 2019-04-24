From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH 1/1] net: rds: exchange of 8K and 1M pool
Date: Wed, 24 Apr 2019 09:59:42 -0700
Message-ID: <b005573c-1dfe-649d-dcc3-c5e72c82d22c@oracle.com>
References: <20190424065642.28630-1-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190424065642.28630-1-yanjun.zhu@oracle.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Zhu Yanjun <yanjun.zhu@oracle.com>, davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 4/23/2019 11:56 PM, Zhu Yanjun wrote:
> Before the commit 490ea5967b0d ("RDS: IB: move FMR code to its own file"),
> when the dirty_count is greater than 9/10 of max_items of 8K pool,
> 1M pool is used, Vice versa. After the commit 490ea5967b0d ("RDS: IB: move
> FMR code to its own file"), the above is removed. When we make the
> following tests.
> 
> Server:
>    rds-stress -r 1.1.1.16 -D 1M
> 
> Client:
>    rds-stress -r 1.1.1.14 -s 1.1.1.16 -D 1M
> 
> The following will appear.
> "
> connecting to 1.1.1.16:4000
> negotiated options, tasks will start in 2 seconds
> Starting up..header from 1.1.1.166:4001 to id 4001 bogus
> ..
> tsks  tx/s  rx/s tx+rx K/s  mbi K/s  mbo K/s tx us/c  rtt us
> cpu %
>     1    0    0     0.00     0.00     0.00    0.00 0.00 -1.00
>     1    0    0     0.00     0.00     0.00    0.00 0.00 -1.00
>     1    0    0     0.00     0.00     0.00    0.00 0.00 -1.00
>     1    0    0     0.00     0.00     0.00    0.00 0.00 -1.00
>     1    0    0     0.00     0.00     0.00    0.00 0.00 -1.00
> ...
> "
> So this exchange between 8K and 1M pool is added back.
> 
> Fixes: commit 490ea5967b0d ("RDS: IB: move FMR code to its own file")
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> ---
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
