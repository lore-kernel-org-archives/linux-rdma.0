From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH] rds: fix building with IPV6=m
Date: Tue, 14 Aug 2018 09:53:11 -0700
Message-ID: <73b656f7-ce61-b4f7-a76d-cc099bb3820f@oracle.com>
References: <20180814090752.1681486-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180814090752.1681486-1-arnd@arndb.de>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>
Cc: Anders Roxell <anders.roxell@linaro.org>, Greg Thelen <gthelen@google.com>, Ka-Cheong Poon <ka-cheong.poon@oracle.com>, Stephen Hemminger <stephen@networkplumber.org>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 8/14/2018 2:07 AM, Arnd Bergmann wrote:
> When CONFIG_RDS_TCP is built-in and CONFIG_IPV6 is a loadable
> module, we get a link error agains the modular ipv6_chk_addr()
> function:
> 
> net/rds/tcp.o: In function `rds_tcp_laddr_check':
> tcp.c:(.text+0x3b2): undefined reference to `ipv6_chk_addr'
> 
> This adds back a dependency that forces RDS_TCP to also be
> a loadable module when IPV6 is one.
> 
> Fixes: e65d4d96334e ("rds: Remove IPv6 dependency")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>   net/rds/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/net/rds/Kconfig b/net/rds/Kconfig
> index 41f75563b54b..01b3bd6a3708 100644
> --- a/net/rds/Kconfig
> +++ b/net/rds/Kconfig
> @@ -16,6 +16,7 @@ config RDS_RDMA
>   config RDS_TCP
>   	tristate "RDS over TCP"
>   	depends on RDS
> +	depends on IPV6 || !IPV6
>   	---help---
>   	  Allow RDS to use TCP as a transport.
>   	  This transport does not support RDMA operations.
> 
Its weird depends on but probably ok since we get to module
to be enabled with or without IPV6.

Thanks for the patch Arnd !!

Acked-by: Santosh Shilimkar <santosh.shilimkar@oracle.com>
