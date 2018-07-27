From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH] net/rds/Kconfig: RDS should depend on IPV6
Date: Fri, 27 Jul 2018 04:52:26 -0700
Message-ID: <68f68676-0d91-125f-5697-31cc459ab24e@gmail.com>
References: <20180725222008.32186-1-anders.roxell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180725222008.32186-1-anders.roxell@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Anders Roxell <anders.roxell@linaro.org>, davem@davemloft.net, santosh.shilimkar@oracle.com, ka-cheong.poon@oracle.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org



On 07/25/2018 03:20 PM, Anders Roxell wrote:
> Build error, implicit declaration of function __inet6_ehashfn shows up
> When RDS is enabled but not IPV6.
> net/rds/connection.c: In function ‘rds_conn_bucket’:
> net/rds/connection.c:67:9: error: implicit declaration of function ‘__inet6_ehashfn’; did you mean ‘__inet_ehashfn’? [-Werror=implicit-function-declaration]
>   hash = __inet6_ehashfn(lhash, 0, fhash, 0, rds_hash_secret);
>          ^~~~~~~~~~~~~~~
>          __inet_ehashfn
> 
> Current code adds IPV6 as a depends on in config RDS.
> 
> Fixes: eee2fa6ab322 ("rds: Changing IP address internal representation to struct in6_addr")
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---
>  net/rds/Kconfig | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/rds/Kconfig b/net/rds/Kconfig
> index 41f75563b54b..607128f10bcd 100644
> --- a/net/rds/Kconfig
> +++ b/net/rds/Kconfig
> @@ -1,7 +1,7 @@
>  
>  config RDS
>  	tristate "The RDS Protocol"
> -	depends on INET
> +	depends on INET && CONFIG_IPV6

You probably meant :

        depends on INET && IPV6


>  	---help---
>  	  The RDS (Reliable Datagram Sockets) protocol provides reliable,
>  	  sequenced delivery of datagrams over Infiniband or TCP.
> 
