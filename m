From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] RDMA/srp: Accept again source addresses that do not
 have a port number
Date: Tue, 26 Mar 2019 11:37:39 -0400
Message-ID: <bae975c8d5a4e256ba2987e5429b15333c1da0af.camel@redhat.com>
References: <20190321203428.128471-1-bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190321203428.128471-1-bvanassche@acm.org>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Leon Romanovsky <leonro@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 2019-03-21 at 13:34 -0700, Bart Van Assche wrote:
> The function srp_parse_in() is used both for parsing source address
> specifications and for target address specifications. Target
> addresses
> must have a port number. Having to specify a port number for source
> addresses is inconvenient. Make sure that srp_parse_in() supports
> again
> parsing addresses with no port number.
> 
> Cc: Laurence Oberman <loberman@redhat.com>
> Cc: <stable@vger.kernel.org>
> Fixes: c62adb7def71 ("IB/srp: Fix IPv6 address parsing") # v4.17.
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/infiniband/ulp/srp/ib_srp.c | 21 +++++++++++++++------
>  1 file changed, 15 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/infiniband/ulp/srp/ib_srp.c
> b/drivers/infiniband/ulp/srp/ib_srp.c
> index a669c10f7adf..0c46f0d7cb7f 100644
> --- a/drivers/infiniband/ulp/srp/ib_srp.c
> +++ b/drivers/infiniband/ulp/srp/ib_srp.c
> @@ -3487,13 +3487,14 @@ static const match_table_t srp_opt_tokens = {
>   * @net:	   [in]  Network namespace.
>   * @sa:		   [out] Address family, IP address and port
> number.
>   * @addr_port_str: [in]  IP address and port number.
> + * @has_port:	   [out] Whether or not @addr_port_str includes
> a port number.
>   *
>   * Parse the following address formats:
>   * - IPv4: <ip_address>:<port>, e.g. 1.2.3.4:5.
>   * - IPv6: \[<ipv6_address>\]:<port>, e.g. [1::2:3%4]:5.
>   */
>  static int srp_parse_in(struct net *net, struct sockaddr_storage
> *sa,
> -			const char *addr_port_str)
> +			const char *addr_port_str, bool *has_port)
>  {
>  	char *addr_end, *addr = kstrdup(addr_port_str, GFP_KERNEL);
>  	char *port_str;
> @@ -3502,9 +3503,12 @@ static int srp_parse_in(struct net *net,
> struct sockaddr_storage *sa,
>  	if (!addr)
>  		return -ENOMEM;
>  	port_str = strrchr(addr, ':');
> -	if (!port_str)
> -		return -EINVAL;
> -	*port_str++ = '\0';
> +	if (port_str && strchr(port_str, ']'))
> +		port_str = NULL;
> +	if (port_str)
> +		*port_str++ = '\0';
> +	if (has_port)
> +		*has_port = port_str != NULL;
>  	ret = inet_pton_with_scope(net, AF_INET, addr, port_str, sa);
>  	if (ret && addr[0]) {
>  		addr_end = addr + strlen(addr) - 1;
> @@ -3526,6 +3530,7 @@ static int srp_parse_options(struct net *net,
> const char *buf,
>  	char *p;
>  	substring_t args[MAX_OPT_ARGS];
>  	unsigned long long ull;
> +	bool has_port;
>  	int opt_mask = 0;
>  	int token;
>  	int ret = -EINVAL;
> @@ -3624,7 +3629,8 @@ static int srp_parse_options(struct net *net,
> const char *buf,
>  				ret = -ENOMEM;
>  				goto out;
>  			}
> -			ret = srp_parse_in(net, &target-
> >rdma_cm.src.ss, p);
> +			ret = srp_parse_in(net, &target-
> >rdma_cm.src.ss, p,
> +					   NULL);
>  			if (ret < 0) {
>  				pr_warn("bad source parameter '%s'\n",
> p);
>  				kfree(p);
> @@ -3640,7 +3646,10 @@ static int srp_parse_options(struct net *net,
> const char *buf,
>  				ret = -ENOMEM;
>  				goto out;
>  			}
> -			ret = srp_parse_in(net, &target-
> >rdma_cm.dst.ss, p);
> +			ret = srp_parse_in(net, &target-
> >rdma_cm.dst.ss, p,
> +					   &has_port);
> +			if (!has_port)
> +				ret = -EINVAL;
>  			if (ret < 0) {
>  				pr_warn("bad dest parameter '%s'\n",
> p);
>  				kfree(p);

This looks orrect to me, will test and report back.
Regards
Laurence
