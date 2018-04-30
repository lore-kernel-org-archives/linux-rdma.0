From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH RFC iproute2-next 2/2] rdma: print provider resource
 attributes
Date: Mon, 30 Apr 2018 08:25:24 -0700
Message-ID: <20180430082524.530eff32@xeon-e3>
References: <cover.1525100473.git.swise@opengridcomputing.com>
        <9dc07757af0a98c444c5a40131a7c54922361e03.1525100473.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <9dc07757af0a98c444c5a40131a7c54922361e03.1525100473.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, leon@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Mon, 30 Apr 2018 07:36:18 -0700
Steve Wise <swise@opengridcomputing.com> wrote:

> +#define nla_type(attr) ((attr)->nla_type & NLA_TYPE_MASK)
> +
> +void newline(struct rd *rd)
> +{
> +	if (rd->json_output)
> +		jsonw_end_array(rd->jw);
> +	else
> +		pr_out("\n");
> +}
> +
> +void newline_indent(struct rd *rd)
> +{
> +	newline(rd);
> +	if (!rd->json_output)
> +		pr_out("    ");
> +}
> +
> +static int print_provider_string(struct rd *rd, const char *key_str,
> +				 const char *val_str)
> +{
> +	if (rd->json_output) {
> +		jsonw_string_field(rd->jw, key_str, val_str);
> +		return 0;
> +	} else {
> +		return pr_out("%s %s ", key_str, val_str);
> +	}
> +}
> +
> +static int print_provider_s32(struct rd *rd, const char *key_str, int32_t val,
> +			      enum rdma_nldev_print_type print_type)
> +{
> +	if (rd->json_output) {
> +		jsonw_int_field(rd->jw, key_str, val);
> +		return 0;
> +	}
> +	switch (print_type) {
> +	case RDMA_NLDEV_PRINT_TYPE_UNSPEC:
> +		return pr_out("%s %d ", key_str, val);
> +	case RDMA_NLDEV_PRINT_TYPE_HEX:
> +		return pr_out("%s 0x%x ", key_str, val);
> +	default:
> +		return -EINVAL;
> +	}
> +}
> +

This code should get converted to json_print library that handles the
different output modes; rather than rolling it's own equivalent functionality.
