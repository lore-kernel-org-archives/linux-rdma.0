From: santosh.shilimkar@oracle.com
Subject: Re: [PATCHv2 1/1] net: rds: add per rds connection cache statistics
Date: Mon, 3 Jun 2019 10:02:09 -0700
Message-ID: <f90dcef6-aa80-b31a-c999-2b7224960600@oracle.com>
References: <1559536081-25401-1-git-send-email-yanjun.zhu@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1559536081-25401-1-git-send-email-yanjun.zhu@oracle.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Zhu Yanjun <yanjun.zhu@oracle.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

On 6/2/19 9:28 PM, Zhu Yanjun wrote:
> The variable cache_allocs is to indicate how many frags (KiB) are in one
> rds connection frag cache.
> The command "rds-info -Iv" will output the rds connection cache
> statistics as below:
> "
> RDS IB Connections:
>        LocalAddr RemoteAddr Tos SL  LocalDev            RemoteDev
>        1.1.1.14 1.1.1.14   58 255  fe80::2:c903:a:7a31 fe80::2:c903:a:7a31
>        send_wr=256, recv_wr=1024, send_sge=8, rdma_mr_max=4096,
>        rdma_mr_size=257, cache_allocs=12
> "
> This means that there are about 12KiB frag in this rds connection frag
> cache.
> Since rds.h in rds-tools is not related with the kernel rds.h, the change
> in kernel rds.h does not affect rds-tools.
> rds-info in rds-tools 2.0.5 and 2.0.6 is tested with this commit. It works
> well.
> 
> Signed-off-by: Zhu Yanjun <yanjun.zhu@oracle.com>
> ---
> V1->V2: RDS CI is removed.

Thanks for testing compatibility.

FWIW, Acked-by: Santosh Shilimkar <ssantosh@kernel.org>
