From: David Ahern <dsahern@gmail.com>
Subject: Re: [PATCH v2 iproute2-next 3/6] rdma: Add CM_ID resource tracking
 information
Date: Mon, 26 Mar 2018 09:40:39 -0600
Message-ID: <5e6c4b3c-03b2-aab2-d2e6-52f0edf960bb@gmail.com>
References: <cover.1520020530.git.swise@opengridcomputing.com>
 <743dc7a5306f9b3368fcd4c143cdd822250444a6.1520020530.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <743dc7a5306f9b3368fcd4c143cdd822250444a6.1520020530.git.swise@opengridcomputing.com>
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: leon@kernel.org, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On 2/27/18 9:07 AM, Steve Wise wrote:
> Sample output:
> 
> # rdma resource
> 2: cxgb4_0: pd 5 cq 2 qp 2 cm_id 3 mr 7
> 3: mlx4_0: pd 7 cq 3 qp 3 cm_id 3 mr 7
> 
> # rdma resource show cm_id
> link cxgb4_0/- lqpn 0 qp-type RC state LISTEN ps TCP pid 30485 comm rping src-addr 0.0.0.0:7174
> link cxgb4_0/2 lqpn 1048 qp-type RC state CONNECT ps TCP pid 30503 comm rping src-addr 172.16.2.1:7174 dst-addr 172.16.2.1:38246
> link cxgb4_0/2 lqpn 1040 qp-type RC state CONNECT ps TCP pid 30498 comm rping src-addr 172.16.2.1:38246 dst-addr 172.16.2.1:7174
> link mlx4_0/- lqpn 0 qp-type RC state LISTEN ps TCP pid 30485 comm rping src-addr 0.0.0.0:7174
> link mlx4_0/1 lqpn 539 qp-type RC state CONNECT ps TCP pid 30494 comm rping src-addr 172.16.99.1:7174 dst-addr 172.16.99.1:43670
> link mlx4_0/1 lqpn 538 qp-type RC state CONNECT ps TCP pid 30492 comm rping src-addr 172.16.99.1:43670 dst-addr 172.16.99.1:7174
> 
> # rdma resource show cm_id dst-port 7174
> link cxgb4_0/2 lqpn 1040 qp-type RC state CONNECT ps TCP pid 30498 comm rping src-addr 172.16.2.1:38246 dst-addr 172.16.2.1:7174
> link mlx4_0/1 lqpn 538 qp-type RC state CONNECT ps TCP pid 30492 comm rping src-addr 172.16.99.1:43670 dst-addr 172.16.99.1:7174
> 
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  rdma/rdma.h  |   2 +
>  rdma/res.c   | 258 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-
>  rdma/utils.c |   5 ++
>  3 files changed, 264 insertions(+), 1 deletion(-)
> 
> diff --git a/rdma/rdma.h b/rdma/rdma.h
> index 5809f70..e55205b 100644
> --- a/rdma/rdma.h
> +++ b/rdma/rdma.h
> @@ -18,10 +18,12 @@
>  #include <libmnl/libmnl.h>
>  #include <rdma/rdma_netlink.h>
>  #include <time.h>
> +#include <net/if_arp.h>
>  
>  #include "list.h"
>  #include "utils.h"
>  #include "json_writer.h"
> +#include <rdma/rdma_cma.h>
>  
>  #define pr_err(args...) fprintf(stderr, ##args)
>  #define pr_out(args...) fprintf(stdout, ##args)
> diff --git a/rdma/res.c b/rdma/res.c
> index 62f5c54..1ef4f20 100644
> --- a/rdma/res.c
> +++ b/rdma/res.c
> @@ -16,9 +16,11 @@ static int res_help(struct rd *rd)
>  {
>  	pr_out("Usage: %s resource\n", rd->filename);
>  	pr_out("          resource show [DEV]\n");
> -	pr_out("          resource show [qp]\n");
> +	pr_out("          resource show [qp|cm_id]\n");
>  	pr_out("          resource show qp link [DEV/PORT]\n");
>  	pr_out("          resource show qp link [DEV/PORT] [FILTER-NAME FILTER-VALUE]\n");
> +	pr_out("          resource show cm_id link [DEV/PORT]\n");
> +	pr_out("          resource show cm_id link [DEV/PORT] [FILTER-NAME FILTER-VALUE]\n");
>  	return 0;
>  }
>  
> @@ -433,6 +435,230 @@ static int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
>  	return MNL_CB_OK;
>  }
>  
> +static void print_qp_type(struct rd *rd, uint32_t val)
> +{
> +	if (rd->json_output)
> +		jsonw_string_field(rd->jw, "qp-type",
> +				   qp_types_to_str(val));
> +	else
> +		pr_out("qp-type %s ", qp_types_to_str(val));
> +}
> +
> +static const char *cm_id_state_to_str(uint8_t idx)
> +{
> +	static const char * const cm_id_states_str[] = { "IDLE", "ADDR_QUERY",
> +						      "ADDR_RESOLVED", "ROUTE_QUERY", "ROUTE_RESOLVED",
> +						      "CONNECT", "DISCONNECT",
> +						      "ADDR_BOUND", "LISTEN", "DEVICE_REMOVAL", "DESTROYING" };
> +

In general lines should stay under 80 columns. There are a few
exceptions to the rule (e.g., print strings), but most of the long lines
you have in this patch need to conform.

> @@ -457,11 +683,41 @@ filters qp_valid_filters[MAX_NUMBER_OF_FILTERS] = {{ .name = "link",
>  
>  RES_FUNC(res_qp,	RDMA_NLDEV_CMD_RES_QP_GET, qp_valid_filters, false);
>  
> +static const struct
> +filters cm_id_valid_filters[MAX_NUMBER_OF_FILTERS] = {{ .name = "link",
> +						   .is_number = false },
> +						   { .name = "lqpn",
> +						   .is_number = true },
> +						   { .name = "qp-type",
> +						   .is_number = false },
> +						   { .name = "state",
> +						   .is_number = false },
> +						   { .name = "ps",
> +						   .is_number = false },
> +						   { .name = "dev-type",
> +						   .is_number = false },
> +						   { .name = "transport-type",
> +						   .is_number = false },
> +						   { .name = "pid",
> +						   .is_number = true },
> +						   { .name = "src-addr",
> +						   .is_number = false },
> +						   { .name = "src-port",
> +						   .is_number = true },
> +						   { .name = "dst-addr",
> +						   .is_number = false },
> +						   { .name = "dst-port",
> +						   .is_number = true }};
> +

The above would be more readable as
	static const
	struct filters cm_id_valid_filters[MAX_NUMBER_OF_FILTERS] = {
		{ .name = "link", .is_number = false },
		{ .name = "lqpn", .is_number = true },
...

Definitely do not split between struct and filters.
