From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next 3/9] rdma: Add filtering infrastructure
Date: Tue, 2 Jan 2018 19:47:34 -0700
Message-ID: <8380b3a6-54f3-851c-f059-5f37d377d3f0@gmail.com>
References: <20180102093725.6172-1-leon@kernel.org>
 <20180102093725.6172-4-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180102093725.6172-4-leon@kernel.org>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leon@kernel.org>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: RDMA mailing list <linux-rdma@vger.kernel.org>, Leon Romanovsky <leonro@mellanox.com>, netdev <netdev@vger.kernel.org>, Stephen Hemminger <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org

On 1/2/18 2:37 AM, Leon Romanovsky wrote:
> +/*
> + * Check if string entry is filtered:
> + *  * key doesn't exist -> user didn't request -> not filtered
> + */
> +bool rd_check_is_string_filtered(struct rd *rd, const char *key, char *val)
> +{
> +	bool key_is_filtered = false;
> +	struct filter_entry *fe;
> +	char *p = NULL;
> +	char *str;
> +
> +	list_for_each_entry(fe, &rd->filter_list, list) {
> +		if (!strcmpx(fe->key, key)) {
> +			/* We found the key */
> +			p = strdup(fe->value);

if (p == NULL) ...

> +
> +			/*
> +			 * Need to check if value in range
> +			 * It can come in the following formats
> +			 * and their permutations:
> +			 * str
> +			 * str1,str2
> +			 */
> +			str = strtok(p, ",");
> +			while (str) {
> +				if (!strcmpx(str, val)) {
> +					key_is_filtered = true;
> +					goto out;
> +				}
> +				str = strtok(NULL, ",");
> +			}
> +			goto out;
> +		}
> +	}
> +
> +out:
> +	free(p);
> +	return key_is_filtered;
> +}
> +
