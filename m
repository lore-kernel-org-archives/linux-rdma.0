From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH iproute2-next 1/4] rdma: Add an option to query,set net
 namespace sharing sys parameter
Date: Wed, 29 May 2019 10:12:32 -0600
Message-ID: <014b3e56-9aa0-4b20-158c-d4907078d224@gmail.com>
References: <20190521142244.8452-1-parav@mellanox.com>
 <20190521142244.8452-2-parav@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190521142244.8452-2-parav@mellanox.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Parav Pandit <parav@mellanox.com>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, stephen@networkplumber.org, leonro@mellanox.com
List-Id: linux-rdma@vger.kernel.org

On 5/21/19 8:22 AM, Parav Pandit wrote:
> diff --git a/rdma/sys.c b/rdma/sys.c
> new file mode 100644
> index 00000000..78e5198f
> --- /dev/null
> +++ b/rdma/sys.c
> @@ -0,0 +1,143 @@
> +/*
> + * sys.c	RDMA tool
> + *
> + *              This program is free software; you can redistribute it and/or
> + *              modify it under the terms of the GNU General Public License
> + *              as published by the Free Software Foundation; either version
> + *              2 of the License, or (at your option) any later version.
> + */

Please use the SPDX line like the other rdma files.

> +
> +#include "rdma.h"
> +
> +static int sys_help(struct rd *rd)
> +{
> +	pr_out("Usage: %s system show [ netns ]\n", rd->filename);
> +	pr_out("       %s system set netns { shared | exclusive }\n", rd->filename);
> +	return 0;
> +}
> +
> +static const char *netns_modes_str[] = {
> +	"exclusive",
> +	"shared",
> +};
> +
> +static int sys_show_parse_cb(const struct nlmsghdr *nlh, void *data)
> +{
> +	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
> +	struct rd *rd = data;
> +
> +	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
> +
> +	if (tb[RDMA_NLDEV_SYS_ATTR_NETNS_MODE]) {
> +		const char *mode_str;
> +		uint8_t netns_mode;
> +
> +		netns_mode =
> +			mnl_attr_get_u8(tb[RDMA_NLDEV_SYS_ATTR_NETNS_MODE]);
> +
> +		if (netns_mode <= ARRAY_SIZE(netns_modes_str))
> +			mode_str = netns_modes_str[netns_mode];
> +		else
> +			mode_str = "unknown";
> +
> +		if (rd->json_output)
> +			jsonw_string_field(rd->jw, "netns", mode_str);
> +		else
> +			pr_out("netns %s\n", mode_str);
> +	}
> +	return MNL_CB_OK;
> +}
> +
> +static int sys_show_no_args(struct rd *rd)
> +{
> +	uint32_t seq;
> +	int ret;
> +
> +	rd_prepare_msg(rd, RDMA_NLDEV_CMD_SYS_GET,
> +		       &seq, (NLM_F_REQUEST | NLM_F_ACK));
> +	ret = rd_send_msg(rd);
> +	if (ret)
> +		return ret;
> +
> +	ret = rd_recv_msg(rd, sys_show_parse_cb, rd, seq);
> +	return ret;

since you are fixing the header, why not just
	return rd_recv_msg(rd, sys_show_parse_cb, rd, seq);

like the other functions?
