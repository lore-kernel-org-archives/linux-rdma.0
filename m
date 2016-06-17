From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH -next] RDS: TCP: Fix non static symbol warnings
Date: Fri, 17 Jun 2016 11:33:56 -0700
Message-ID: <8135b60a-1dac-17fc-db4d-bb6586350388@oracle.com>
References: <1466187166-2549-1-git-send-email-weiyj_lk@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1466187166-2549-1-git-send-email-weiyj_lk@163.com>
Sender: netdev-owner@vger.kernel.org
To: weiyj_lk@163.com, "David S. Miller" <davem@davemloft.net>
Cc: Wei Yongjun <yongjun_wei@trendmicro.com.cn>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com
List-Id: linux-rdma@vger.kernel.org

On 6/17/2016 11:12 AM, weiyj_lk@163.com wrote:
> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>
> Fixes the following sparse warnings:
>
> net/rds/tcp.c:59:5: warning:
>  symbol 'rds_tcp_min_sndbuf' was not declared. Should it be static?
> net/rds/tcp.c:60:5: warning:
>  symbol 'rds_tcp_min_rcvbuf' was not declared. Should it be static?
>
> Signed-off-by: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
> ---
Look ok.
Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
