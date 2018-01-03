From: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH iproute2-next 1/9] rdam: Add option to provide "-" sign
 for the port number
Date: Tue, 2 Jan 2018 19:46:38 -0700
Message-ID: <7e2cec33-0549-6dfc-c9fe-8be8a1261c7d@gmail.com>
References: <20180102093725.6172-1-leon@kernel.org>
 <20180102093725.6172-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180102093725.6172-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

a couple of nits

On 1/2/18 2:37 AM, Leon Romanovsky wrote:
> diff --git a/rdma/utils.c b/rdma/utils.c
> index 7b2001e2..7c920a5c 100644
> --- a/rdma/utils.c
> +++ b/rdma/utils.c
> @@ -10,6 +10,7 @@
>   */
>  
>  #include "rdma.h"
> +#include <ctype.h>
>  
>  static int rd_argc(struct rd *rd)
>  {
> @@ -50,13 +51,43 @@ bool rd_no_arg(struct rd *rd)
>  	return rd_argc(rd) == 0;
>  }
>  
> -uint32_t get_port_from_argv(struct rd *rd)
> +/*
> + * Possible input:output
> + * dev/port    | first port | is_dump_all
> + * mlx5_1      | 0          | true
> + * mlx5_1/     | 0          | true
> + * mlx5_1/0    | 0          | false
> + * mlx5_1/1    | 1          | false
> + * mlx5_1/-    | 0          | false
> + *
> + * In strict mode, /- will return error.
> + */
> +static int get_port_from_argv(struct rd *rd, uint32_t *port,
> +			      bool *is_dump_all, bool strict_port)
>  {
>  	char *slash;
>  
> +	*port = 0;
> +	*is_dump_all = true;
> +
>  	slash = strchr(rd_argv(rd), '/');
>  	/* if no port found, return 0 */
> -	return slash ? atoi(slash + 1) : 0;
> +	if (slash) {

++slash here would alleviate the need for all of the +1's.


> +		if (*(slash + 1) == '-') {
> +			if (strict_port)
> +				return -EINVAL;
> +			*is_dump_all = false;
> +			return 0;
> +		}
> +
> +		if (isdigit(*(slash + 1))) {
> +			*is_dump_all = false;
> +			*port = atoi(slash + 1);
> +		}
> +		if (!*port && strlen(slash + 1))
> +			return -EINVAL;
> +	}
> +	return 0;
>  }
>  
>  static struct dev_map *dev_map_alloc(const char *dev_name)
> @@ -152,7 +183,7 @@ void rd_free(struct rd *rd)
>  	dev_map_cleanup(rd);
>  }
>  
> -int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd))
> +int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd), bool strict_port)
>  {
>  	struct dev_map *dev_map;
>  	uint32_t port;
> @@ -163,7 +194,8 @@ int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd))
>  	if (rd_no_arg(rd)) {
>  		list_for_each_entry(dev_map, &rd->dev_map_list, list) {
>  			rd->dev_idx = dev_map->idx;
> -			for (port = 1; port < dev_map->num_ports + 1; port++) {
> +			port = (strict_port) ? 1 : 0;
> +			for (; port < dev_map->num_ports + 1; port++) {
>  				rd->port_idx = port;
>  				ret = cb(rd);
>  				if (ret)
> @@ -172,21 +204,22 @@ int rd_exec_link(struct rd *rd, int (*cb)(struct rd *rd))
>  		}
>  
>  	} else {
> +		bool is_dump_all;
>  		dev_map = dev_map_lookup(rd, true);

newline between declarations and code.

> -		port = get_port_from_argv(rd);
> -		if (!dev_map || port > dev_map->num_ports) {
> +		ret = get_port_from_argv(rd, &port, &is_dump_all, strict_port);
> +		if (!dev_map || port > dev_map->num_ports || (!port && ret)) {
>  			pr_err("Wrong device name\n");
>  			ret = -ENOENT;
>  			goto out;
>  		}
>  		rd_arg_inc(rd);
>  		rd->dev_idx = dev_map->idx;
> -		rd->port_idx = port ? : 1;
> +		rd->port_idx = port;
>  		for (; rd->port_idx < dev_map->num_ports + 1; rd->port_idx++) {
>  			ret = cb(rd);
>  			if (ret)
>  				goto out;
> -			if (port)
> +			if (!is_dump_all)
>  				/*
>  				 * We got request to show link for devname
>  				 * with port index.
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
