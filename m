From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH iproute2-next 08/10] rdma: Add QP resource tracking information
Date: Thu, 1 Feb 2018 14:05:08 -0600
Message-ID: <017501d39b97$f5931360$e0b93a20$@opengridcomputing.com>
References: <20180131081156.19607-1-leon@kernel.org> <20180131081156.19607-9-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180131081156.19607-9-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'David Ahern' <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'netdev' <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Stephen Hemminger' <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>, 'Leon Romanovsky' <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hey Leon,

> 
> From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> This patch adds ss-similar interface to view various resource
> tracked objects. At this stage, only QP is presented.
> 
> 1. Get all QPs for the specific device:
> $ rdma res show qp link mlx5_4
> link mlx5_4/- lqpn 8 type UD state RESET sq-psn 0 pid 0 comm [ib_ipoib]
> link mlx5_4/1 lqpn 7 type UD state RTS sq-psn 0 pid 0 comm [ib_core]
> link mlx5_4/1 lqpn 1 type GSI state RTS sq-psn 0 pid 0 comm [ib_core]
> link mlx5_4/1 lqpn 0 type SMI state RTS sq-psn 0 pid 0 comm [ib_core]
> 
> $ rdma res show qp link mlx5_4/
> link mlx5_4/- lqpn 8 type UD state RESET sq-psn 0 pid 0 comm [ib_ipoib]
> link mlx5_4/1 lqpn 7 type UD state RTS sq-psn 0 pid 0 comm [ib_core]
> link mlx5_4/1 lqpn 1 type GSI state RTS sq-psn 0 pid 0 comm [ib_core]
> link mlx5_4/1 lqpn 0 type SMI state RTS sq-psn 0 pid 0 comm [ib_core]
> 
> 2. Provide illegal port number (0 is illegal):
> $ rdma res show qp link mlx5_4/0
> Wrong device name
> 
> 3. Get QPs of specific port:
> $ rdma res show qp link mlx5_4/1
> link mlx5_4/1 lqpn 7 type UD state RTS sq-psn 0 pid 0 comm [ib_core]
> link mlx5_4/1 lqpn 1 type GSI state RTS sq-psn 0 pid 0 comm [ib_core]
> link mlx5_4/1 lqpn 0 type SMI state RTS sq-psn 0 pid 0 comm [ib_core]
> 
> 4. Get QPs which have not assigned port yet:
> link mlx5_4/- lqpn 8 type UD state RESET sq-psn 0 pid 0 comm [ib_ipoib]
> 
> 5. Limit to specific Local QPNs:
> $ rdma res show qp link mlx5_4/1 lqpn 1-3,7
> link mlx5_4/1 lqpn 7 type UD state RTS sq-psn 0 pid 0 comm [ib_core]
> link mlx5_4/1 lqpn 1 type GSI state RTS sq-psn 0 pid 0 comm [ib_core]
> link mlx5_4/1 lqpn 0 type SMI state RTS sq-psn 0 pid 0 comm [ib_core]
> 
> . Filter types (strings):
> $ rdma res show qp link mlx5_4/1 type UD,gSi
> link mlx5_4/1 lqpn 7 type UD state RTS sq-psn 0 pid 0 comm [ib_core]
> link mlx5_4/1 lqpn 1 type GSI state RTS sq-psn 0 pid 0 comm [ib_core]
> 
> Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> ---
>  rdma/res.c   | 325
> +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  rdma/utils.c |  11 ++
>  2 files changed, 336 insertions(+)
> 
> diff --git a/rdma/res.c b/rdma/res.c
> index bd97c58e..2a63e712 100644
> --- a/rdma/res.c
> +++ b/rdma/res.c
> @@ -16,6 +16,9 @@ static int res_help(struct rd *rd)
>  {
>  	pr_out("Usage: %s resource\n", rd->filename);
>  	pr_out("          resource show [DEV]\n");
> +	pr_out("          resource show [qp]\n");
> +	pr_out("          resource show qp link [DEV/PORT]\n");
> +	pr_out("          resource show qp link [DEV/PORT] [FILTER-NAME
FILTER-
> VALUE]\n");
>  	return 0;
>  }
> 
> @@ -129,12 +132,334 @@ static int _res_send_msg(struct rd *rd, uint32_t
> command, mnl_cb_t callback)
>  			return rd_exec_link(rd, _##name, strict_port); \
>  	}
> 
> +static const char *path_mig_to_str(uint8_t idx)
> +{
> +	static const char * const path_mig_str[] = { "MIGRATED",
> +						     "REARM", "ARMED" };
> +
> +	if (idx < ARRAY_SIZE(path_mig_str))
> +		return path_mig_str[idx];
> +	return "UNKNOWN";
> +}
> +
> +static const char *qp_states_to_str(uint8_t idx)
> +{
> +	static const char * const qp_states_str[] = { "RESET", "INIT",
> +						      "RTR", "RTS", "SQD",
> +						      "SQE", "ERR" };
> +
> +	if (idx < ARRAY_SIZE(qp_states_str))
> +		return qp_states_str[idx];
> +	return "UNKNOWN";
> +}
> +
> +static const char *qp_types_to_str(uint8_t idx)
> +{
> +	static const char * const qp_types_str[] = { "SMI", "GSI", "RC",
> +						     "UC", "UD", "RAW_IPV6",
> +						     "RAW_ETHERTYPE",
> +						     "UNKNOWN",
> "RAW_PACKET",
> +						     "XRC_INI", "XRC_TGT" };
> +
> +	if (idx < ARRAY_SIZE(qp_types_str))
> +		return qp_types_str[idx];
> +	return "UNKNOWN";
> +}
> +
> +static void print_lqpn(struct rd *rd, uint32_t val)
> +{
> +	if (rd->json_output)
> +		jsonw_uint_field(rd->jw, "lqpn", val);
> +	else
> +		pr_out("lqpn %u ", val);
> +}
> +
> +static void print_rqpn(struct rd *rd, uint32_t val, struct nlattr
**nla_line)
> +{
> +	if (!nla_line[RDMA_NLDEV_ATTR_RES_RQPN])
> +		return;
> +
> +	if (rd->json_output)
> +		jsonw_uint_field(rd->jw, "rqpn", val);
> +	else
> +		pr_out("rqpn %u ", val);
> +}
> +
> +static void print_type(struct rd *rd, uint32_t val)
> +{
> +	if (rd->json_output)
> +		jsonw_string_field(rd->jw, "type",
> +				   qp_types_to_str(val));
> +	else
> +		pr_out("type %s ", qp_types_to_str(val));
> +}
> +
> +static void print_state(struct rd *rd, uint32_t val)
> +{
> +	if (rd->json_output)
> +		jsonw_string_field(rd->jw, "state",
> +				   qp_states_to_str(val));
> +	else
> +		pr_out("state %s ", qp_states_to_str(val));
> +}
> +
> +static void print_rqpsn(struct rd *rd, uint32_t val, struct nlattr
**nla_line)
> +{
> +	if (!nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN])
> +		return;
> +
> +	if (rd->json_output)
> +		jsonw_uint_field(rd->jw, "rq-psn", val);
> +	else
> +		pr_out("rq-psn %u ", val);
> +}
> +
> +static void print_sqpsn(struct rd *rd, uint32_t val)
> +{
> +	if (rd->json_output)
> +		jsonw_uint_field(rd->jw, "sq-psn", val);
> +	else
> +		pr_out("sq-psn %u ", val);
> +}
> +
> +static void print_pathmig(struct rd *rd, uint32_t val,
> +			  struct nlattr **nla_line)
> +{
> +	if (!nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE])
> +		return;
> +
> +	if (rd->json_output)
> +		jsonw_string_field(rd->jw,
> +				   "path-mig-state",
> +				   path_mig_to_str(val));
> +	else
> +		pr_out("path-mig-state %s ", path_mig_to_str(val));
> +}
> +
> +static void print_pid(struct rd *rd, uint32_t val)
> +{
> +	if (rd->json_output)
> +		jsonw_uint_field(rd->jw, "pid", val);
> +	else
> +		pr_out("pid %u ", val);
> +}
> +
> +static void print_comm(struct rd *rd, const char *str,
> +		       struct nlattr **nla_line)
> +{
> +	char tmp[18];
> +
> +	if (rd->json_output) {
> +		/* Don't beatify output in JSON format */
> +		jsonw_string_field(rd->jw, "comm", str);
> +		return;
> +	}
> +
> +	if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> +		snprintf(tmp, sizeof(tmp), "%s", str);
> +	else
> +		snprintf(tmp, sizeof(tmp), "[%s]", str);
> +
> +	pr_out("comm %s ", tmp);
> +}
> +
> +static void print_link(struct rd *rd, uint32_t idx, const char *name,
> +		       uint32_t port, struct nlattr **nla_line)
> +{
> +	if (rd->json_output) {
> +		jsonw_uint_field(rd->jw, "ifindex", idx);
> +
> +		if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
> +			jsonw_uint_field(rd->jw, "port", port);
> +
> +		jsonw_string_field(rd->jw, "ifname", name);
> +	} else {
> +		if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
> +			pr_out("link %s/%u ", name, port);
> +		else
> +			pr_out("link %s/- ", name);
> +	}
> +}
> +
> +static char *get_task_name(uint32_t pid)
> +{
> +	char *comm;
> +	FILE *f;
> +
> +	if (asprintf(&comm, "/proc/%d/comm", pid) < 0)
> +		return NULL;
> +
> +	f = fopen(comm, "r");
> +	free(comm);
> +	if (!f)
> +		return NULL;
> +
> +	if (fscanf(f, "%ms\n", &comm) != 1)
> +		comm = NULL;
> +
> +	fclose(f);
> +
> +	return comm;
> +}
> +
> +static int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
> +{
> +	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
> +	struct nlattr *nla_table, *nla_entry;
> +	struct rd *rd = data;
> +	const char *name;
> +	uint32_t idx;
> +
> +	mnl_attr_parse(nlh, 0, rd_attr_cb, tb);
> +	if (!tb[RDMA_NLDEV_ATTR_DEV_INDEX] ||
> +	    !tb[RDMA_NLDEV_ATTR_DEV_NAME] ||
> +	    !tb[RDMA_NLDEV_ATTR_RES_QP])
> +		return MNL_CB_ERROR;
> +
> +	name = mnl_attr_get_str(tb[RDMA_NLDEV_ATTR_DEV_NAME]);
> +	idx =  mnl_attr_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
> +	nla_table = tb[RDMA_NLDEV_ATTR_RES_QP];
> +
> +	mnl_attr_for_each_nested(nla_entry, nla_table) {
> +		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
> +		uint32_t lqpn, rqpn = 0, rq_psn = 0, sq_psn;
> +		uint8_t type, state, path_mig_state = 0;
> +		uint32_t port = 0, pid = 0;
> +		char *comm = NULL;
> +		int err;
> +
> +		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb,
nla_line);
> +		if (err != MNL_CB_OK)
> +			return MNL_CB_ERROR;
> +
> +		if (!nla_line[RDMA_NLDEV_ATTR_RES_LQPN] ||
> +		    !nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN] ||
> +		    !nla_line[RDMA_NLDEV_ATTR_RES_TYPE] ||
> +		    !nla_line[RDMA_NLDEV_ATTR_RES_STATE] ||
> +		    (!nla_line[RDMA_NLDEV_ATTR_RES_PID] &&
> +		     !nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])) {
> +			return MNL_CB_ERROR;
> +		}
> +
> +		if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
> +			port =
> mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
> +
> +		if (port != rd->port_idx)
> +			continue;
> +
> +		lqpn =
> mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
> +		if (rd_check_is_filtered(rd, "lqpn", lqpn))
> +			continue;
> +
> +		if (nla_line[RDMA_NLDEV_ATTR_RES_RQPN]) {
> +			rqpn =
> mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_RQPN]);
> +			if (rd_check_is_filtered(rd, "rqpn", rqpn))
> +				continue;
> +		} else {
> +			if (rd_check_is_key_exist(rd, "rqpn"))
> +				continue;
> +		}
> +
> +		if (nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN]) {
> +			rq_psn =
> mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN]);
> +			if (rd_check_is_filtered(rd, "rq-psn", rq_psn))
> +				continue;
> +		} else {
> +			if (rd_check_is_key_exist(rd, "rq-psn"))
> +				continue;
> +		}
> +
> +		sq_psn =
> mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN]);
> +		if (rd_check_is_filtered(rd, "sq-psn", sq_psn))
> +			continue;
> +
> +		if (nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE]) {
> +			path_mig_state =
> mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE]);
> +			if (rd_check_is_string_filtered(rd,
"path-mig-state",
> path_mig_to_str(path_mig_state)))
> +				continue;
> +		} else {
> +			if (rd_check_is_key_exist(rd, "path-mig-state"))
> +				continue;
> +		}
> +
> +		type =
> mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
> +		if (rd_check_is_string_filtered(rd, "type",
> qp_types_to_str(type)))
> +			continue;
> +
> +		state =
> mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_STATE]);
> +		if (rd_check_is_string_filtered(rd, "state",
> qp_states_to_str(state)))
> +			continue;
> +
> +		if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> +			pid =
> mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> +			comm = get_task_name(pid);
> +		}
> +
> +		if (rd_check_is_filtered(rd, "pid", pid))
> +			continue;

Is comm leaked here when ATTR_RES_PID is present?


> +
> +		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
> +			/* discard const from mnl_attr_get_str */
> +			comm = (char
> *)mnl_attr_get_str(nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);

And also here if the kernel ever passes up both PID and KERN_NAME (which it
isn't supposed to).


Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
