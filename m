From: Santosh Shilimkar <santosh.shilimkar@oracle.com>
Subject: Re: [PATCH] net/rds/Kconfig: RDS should depend on IPV6
Date: Wed, 25 Jul 2018 15:36:10 -0700
Message-ID: <cefa5c0b-7935-a6b5-1796-1d5a3da5dd87@oracle.com>
References: <20180725222008.32186-1-anders.roxell@linaro.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180725222008.32186-1-anders.roxell@linaro.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Anders Roxell <anders.roxell@linaro.org>, ka-cheong.poon@oracle.com
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, rds-devel@oss.oracle.com, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 7/25/2018 3:20 PM, Anders Roxell wrote:
> Build error, implicit declaration of function __inet6_ehashfn shows up
> When RDS is enabled but not IPV6.
> net/rds/connection.c: In function ‘rds_conn_bucket’:
> net/rds/connection.c:67:9: error: implicit declaration of function ‘__inet6_ehashfn’; did you mean ‘__inet_ehashfn’? [-Werror=implicit-function-declaration]
>    hash = __inet6_ehashfn(lhash, 0, fhash, 0, rds_hash_secret);
>           ^~~~~~~~~~~~~~~
>           __inet_ehashfn
> 
> Current code adds IPV6 as a depends on in config RDS.
> 
> Fixes: eee2fa6ab322 ("rds: Changing IP address internal representation to struct in6_addr")
> Signed-off-by: Anders Roxell <anders.roxell@linaro.org>
> ---
>   net/rds/Kconfig | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/rds/Kconfig b/net/rds/Kconfig
> index 41f75563b54b..607128f10bcd 100644
> --- a/net/rds/Kconfig
> +++ b/net/rds/Kconfig
> @@ -1,7 +1,7 @@
>   
>   config RDS
>   	tristate "The RDS Protocol"
> -	depends on INET
> +	depends on INET && CONFIG_IPV6
This should build without CONFIG_IPV6 too.

Hi Ka-cheong,
Can you please loot at it ? I know you modified
lookup function to take always in6_addr now, but
probably hashing with '__inet_ehashfn' should
work too for non IPV6 address(s).

Regards,
Santosh
