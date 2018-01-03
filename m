From: David Ahern <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH iproute2-next 8/9] rdma: Add QP resource tracking
 information
Date: Tue, 2 Jan 2018 20:03:18 -0700
Message-ID: <84615db9-c63b-8381-8796-c04ff7b5bef9@gmail.com>
References: <20180102093725.6172-1-leon@kernel.org>
 <20180102093725.6172-9-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180102093725.6172-9-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, netdev <netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Stephen Hemminger <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/2/18 2:37 AM, Leon Romanovsky wrote:
> +	mnl_attr_for_each_nested(nla_entry, nla_table) {
> +		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
> +		uint32_t lqpn, rqpn = 0, rq_psn = 0, sq_psn;
> +		uint8_t type, state, path_mig_state = 0;
> +		uint32_t port = 0, pid = 0;
> +		bool ignore_value = false;
> +		char port_name[32];
> +		const char *comm;
> +		int err;
> +
> +		err = mnl_attr_parse_nested(nla_entry, rd_attr_cb, nla_line);
> +		if (err != MNL_CB_OK)
> +			return -EINVAL;
> +
> +		if (!nla_line[RDMA_NLDEV_ATTR_RES_LQPN] ||
> +		    !nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN] ||
> +		    !nla_line[RDMA_NLDEV_ATTR_RES_TYPE] ||
> +		    !nla_line[RDMA_NLDEV_ATTR_RES_STATE] ||
> +		    !nla_line[RDMA_NLDEV_ATTR_RES_PID_COMM]) {
> +			return -EINVAL;
> +		}
> +
> +		if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
> +			port = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_PORT_INDEX]);
> +
> +		if (port != rd->port_idx)
> +			continue;
> +
> +		if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
> +			snprintf(port_name, 32, "%s/%u", name, port);
> +		else
> +			snprintf(port_name, 32, "%s/-", name);
> +
> +		lqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_LQPN]);
> +		if (rd_check_is_filtered(rd, "lqpn", lqpn, false))
> +			continue;
> +
> +		if (nla_line[RDMA_NLDEV_ATTR_RES_RQPN])
> +			rqpn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_RQPN]);
> +		else
> +			ignore_value = true;
> +
> +		if (rd_check_is_filtered(rd, "rqpn", rqpn, ignore_value))
> +			continue;
> +
> +		if (nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN])
> +			rq_psn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN]);
> +
> +		sq_psn = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN]);
> +		if (nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE])
> +			path_mig_state = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE]);
> +		type = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_TYPE]);
> +		state = mnl_attr_get_u8(nla_line[RDMA_NLDEV_ATTR_RES_STATE]);
> +
> +		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> +			pid = mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PID]);
> +
> +		if (rd_check_is_filtered(rd, "pid", pid, false))
> +			continue;
> +
> +		comm = mnl_attr_get_str(nla_line[RDMA_NLDEV_ATTR_RES_PID_COMM]);
> +
> +		if (rd->json_output) {
> +			jsonw_start_array(rd->jw);
> +			jsonw_uint_field(rd->jw, "ifindex", idx);
> +			if (nla_line[RDMA_NLDEV_ATTR_PORT_INDEX])
> +				jsonw_uint_field(rd->jw, "port", port);
> +			jsonw_string_field(rd->jw, "ifname", port_name);
> +			jsonw_uint_field(rd->jw, "lqpn", lqpn);
> +			if (nla_line[RDMA_NLDEV_ATTR_RES_RQPN])
> +				jsonw_uint_field(rd->jw, "rqpn", rqpn);
> +			if (nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN])
> +				jsonw_uint_field(rd->jw, "rq-psn", rq_psn);
> +			if (nla_line[RDMA_NLDEV_ATTR_RES_SQ_PSN])
> +				jsonw_uint_field(rd->jw, "sq-psn", sq_psn);
> +			if (nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE])
> +				jsonw_string_field(rd->jw, "path-mig-state",
> +						   path_mig_to_str(path_mig_state));
> +
> +			jsonw_string_field(rd->jw, "type", qp_types_to_str(type));
> +			jsonw_string_field(rd->jw, "state", qp_states_to_str(state));
> +			if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> +				jsonw_uint_field(rd->jw, "pid", pid);
> +			jsonw_string_field(rd->jw, "comm", comm);
> +			jsonw_end_array(rd->jw);

Some newlines separating common fields goes a long way to make that
readable.

> +		} else {
> +			pr_out("%-10s", port_name);
> +			for (cidx = 0; cidx < ARRAY_SIZE(c); cidx++)
> +				if (show_column(rd, &c[cidx])) {
> +					if (!strcmpx(c[cidx].filter_name, "lqpn"))
> +						pr_out("%-11u", lqpn);
> +					if (!strcmpx(c[cidx].filter_name, "rqpn")) {
> +						if (nla_line[RDMA_NLDEV_ATTR_RES_RQPN])
> +							pr_out("%-11u", rqpn);
> +						else
> +							pr_out("%-11s", "---");
> +					}
> +					if (!strcmpx(c[cidx].filter_name, "type"))
> +						pr_out("%-6s", qp_types_to_str(type));
> +					if (!strcmpx(c[cidx].filter_name, "state"))
> +						pr_out("%-7s", qp_states_to_str(state));
> +					if (!strcmpx(c[cidx].filter_name, "rq-psn")) {
> +						if (nla_line[RDMA_NLDEV_ATTR_RES_RQ_PSN])
> +							pr_out("%-11d", rq_psn);
> +						else
> +							pr_out("%-11s", "---");
> +					}
> +					if (!strcmpx(c[cidx].filter_name, "sq-psn"))
> +						pr_out("%-11d", sq_psn);
> +					if (!strcmpx(c[cidx].filter_name, "path-mig")) {
> +						if (nla_line[RDMA_NLDEV_ATTR_RES_PATH_MIG_STATE])
> +							pr_out("%-16s", path_mig_to_str(path_mig_state));
> +						else
> +							pr_out("%-16s", "---");
> +					}
> +					if (!strcmpx(c[cidx].filter_name, "pid"))
> +						pr_out("%-11d", pid);
> +					if (!strcmpx(c[cidx].filter_name, "comm")) {
> +						if (nla_line[RDMA_NLDEV_ATTR_RES_PID]) {
> +							pr_out("%-16s ", comm);
> +						} else {
> +							char tmp[18];
> +
> +							snprintf(tmp, sizeof(tmp), "[%s]", comm);
> +							pr_out("%-16s", tmp);
> +						}
> +					}

same with this block. Can each be put into helpers to decrease the
indentation and then some newlines to put some whitespace on all the
strcmp's?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
