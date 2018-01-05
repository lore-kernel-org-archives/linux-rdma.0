From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next v1 3/9] rdma: Add filtering infrastructure
Date: Thu, 4 Jan 2018 20:29:31 -0700
Message-ID: <b7ad60c5-a1c5-ff79-113d-d6c57baf1c40@gmail.com>
References: <20180104070150.15625-1-leon@kernel.org>
 <20180104070150.15625-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180104070150.15625-4-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

On 1/4/18 12:01 AM, Leon Romanovsky wrote:
> diff --git a/rdma/utils.c b/rdma/utils.c
> index af2b374d..446c23da 100644
> --- a/rdma/utils.c
> +++ b/rdma/utils.c
> @@ -114,6 +114,225 @@ static void dev_map_cleanup(struct rd *rd)
>  	}
>  }
>  
> +static int add_filter(struct rd *rd, char *key, char *value,
> +		      const char * const valid_filters[])
> +{
> +	char cset[] = "1234567890,-";
> +	struct filter_entry *fe;
> +	bool key_found = false;
> +	int idx = 0;
> +	int ret;
> +
> +	fe = calloc(1, sizeof(*fe));
> +	if (!fe)
> +		return -ENOMEM;
> +
> +	while (valid_filters[idx]) {
> +		if (!strcmpx(key, valid_filters[idx])) {
> +			key_found = true;
> +			break;
> +		}
> +		idx++;
> +	}
> +	if (!key_found) {
> +		pr_err("Unsupported filter option: %s\n", key);
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	/*
> +	 * Check the filter validity, not optimal, but works
> +	 *
> +	 * Actually, there are three types of filters
> +	 *  numeric - for example PID or QPN
> +	 *  string  - for example states, currently only "display"
> +	 *            is from this type
> +	 *  link    - user requested to filter on specific link
> +	 *            e.g. mlx5_1/1, mlx5_1/-, mlx5_1 ...
> +	 */
> +	if (strcmpx(key, "link") && strcmpx(key, "display") &&
> +	    strspn(value, cset) != strlen(value)) {
> +		pr_err("%s filter accepts \"%s\" characters only\n", key, cset);
> +		ret = -EINVAL;
> +		goto err;
> +	}
> +
> +	fe->key = strdup(key);
> +	fe->value = strdup(value);
> +

Missed this the other day. 2 more strdup's that should be checked.
