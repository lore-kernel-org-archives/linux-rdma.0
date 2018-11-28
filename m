From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH RFC iproute2-next 1/2] rdma: add 'link add/delete'
 commands
Date: Wed, 28 Nov 2018 20:26:45 +0200
Message-ID: <20181128182645.GJ4559@mtr-leonro.mtl.com>
References: <cover.1543422310.git.swise@opengridcomputing.com>
 <7026be07534b14fd74e592c315523c57fde05a0a.1543422310.git.swise@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="PGNNI9BzQDUtgA2J"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <7026be07534b14fd74e592c315523c57fde05a0a.1543422310.git.swise@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: dsahern@gmail.com, stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, BMT@zurich.ibm.com
List-Id: linux-rdma@vger.kernel.org


--PGNNI9BzQDUtgA2J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Sep 13, 2018 at 10:19:21AM -0700, Steve Wise wrote:
> Add new 'link' subcommand 'add' and 'delete' to allow binding a soft-rdma
> device to a netdev interface.
>
> EG:
>
> rdma link add rxe_eth0 type rxe dev eth0
> rdma link delete rxe_eth0
>
> Signed-off-by: Steve Wise <swise@opengridcomputing.com>
> ---
>  rdma/link.c  | 106 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  rdma/rdma.h  |   1 +
>  rdma/utils.c |   2 +-
>  3 files changed, 108 insertions(+), 1 deletion(-)
>
> diff --git a/rdma/link.c b/rdma/link.c
> index 7a6d4b7e356d..d4f76b0ce11f 100644
> --- a/rdma/link.c
> +++ b/rdma/link.c
> @@ -14,6 +14,8 @@
>  static int link_help(struct rd *rd)
>  {
>  	pr_out("Usage: %s link show [DEV/PORT_INDEX]\n", rd->filename);
> +	pr_out("Usage: %s link add NAME type TYPE dev DEV\n", rd->filename);

I suggest to rename "dev" to be "netdev", because we are using "dev" for
ib devices.

> +	pr_out("Usage: %s link delete NAME type TYPE\n", rd->filename);

Why do you need "type" for "delete" command?

>  	return 0;
>  }
>
> @@ -315,10 +317,114 @@ static int link_show(struct rd *rd)
>  	return rd_exec_link(rd, link_one_show, true);
>  }
>
> +static int link_add_parse_cb(const struct nlmsghdr *nlh, void *data)
> +{
> +	return MNL_CB_OK;
> +}
> +
> +static int link_add(struct rd *rd)
> +{
> +	char *name;
> +	char *type = NULL;
> +	char *dev = NULL;
> +	uint32_t seq;
> +	int ret;
> +
> +	if (rd_no_arg(rd)) {
> +		pr_err("No link name was supplied\n");
> +		return -EINVAL;
> +	}
> +	name = rd_argv(rd);
> +	rd_arg_inc(rd);
> +	while (!rd_no_arg(rd)) {
> +		if (rd_argv_match(rd, "type")) {
> +			rd_arg_inc(rd);
> +			type = rd_argv(rd);
> +		} else if (rd_argv_match(rd, "dev")) {
> +			rd_arg_inc(rd);
> +			dev = rd_argv(rd);
> +		} else {
> +			pr_err("Invalid parameter %s\n", rd_argv(rd));
> +			return -EINVAL;
> +		}
> +		rd_arg_inc(rd);
> +	}
> +	if (!type) {
> +		pr_err("No type was supplied\n");
> +		return -EINVAL;
> +	}
> +	if (!dev) {
> +		pr_err("No net device was supplied\n");
> +		return -EINVAL;
> +	}
> +
> +	rd_prepare_msg(rd, RDMA_NLDEV_CMD_NEWLINK, &seq,
> +		       (NLM_F_REQUEST | NLM_F_ACK));
> +	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_DEV_NAME, name);
> +	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_LINK_TYPE, type);
> +	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_NDEV_NAME, dev);
> +	ret = rd_send_msg(rd);
> +	if (ret)
> +		return ret;
> +
> +	ret = rd_recv_msg(rd, link_add_parse_cb, rd, seq);
> +	if (ret)
> +		perror(NULL);

Why do you need rd_recv_msg()? I think that it is not needed, at least
for rename, I didn't need it.
https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/tree/rdma/dev.c#n244

> +	return ret;
> +}
> +
> +static int link_del_parse_cb(const struct nlmsghdr *nlh, void *data)
> +{
> +	return MNL_CB_OK;
> +}
> +
> +static int link_del(struct rd *rd)
> +{
> +	char *name;
> +	char *type = NULL;
> +	uint32_t seq;
> +	int ret;
> +
> +	if (rd_no_arg(rd)) {
> +		pr_err("No link type was supplied\n");
> +		return -EINVAL;
> +	}
> +	name = rd_argv(rd);
> +	rd_arg_inc(rd);
> +	while (!rd_no_arg(rd)) {
> +		if (rd_argv_match(rd, "type")) {
> +			rd_arg_inc(rd);
> +			type = rd_argv(rd);
> +		} else {
> +			pr_err("Invalid parameter %s\n", rd_argv(rd));
> +			return -EINVAL;
> +		}
> +		rd_arg_inc(rd);
> +	}
> +	if (!type) {
> +		pr_err("No type was supplied\n");
> +		return -EINVAL;
> +	}
> +	rd_prepare_msg(rd, RDMA_NLDEV_CMD_DELLINK, &seq,
> +		       (NLM_F_REQUEST | NLM_F_ACK));
> +	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_DEV_NAME, name);
> +	mnl_attr_put_strz(rd->nlh, RDMA_NLDEV_ATTR_LINK_TYPE, type);
> +	ret = rd_send_msg(rd);
> +	if (ret)
> +		return ret;
> +
> +	ret = rd_recv_msg(rd, link_del_parse_cb, rd, seq);
> +	if (ret)
> +		perror(NULL);
> +	return ret;

The same question as above.

> +}
> +
>  int cmd_link(struct rd *rd)
>  {
>  	const struct rd_cmd cmds[] = {
>  		{ NULL,		link_show },
> +		{ "add",	link_add },
> +		{ "delete",	link_del },
>  		{ "show",	link_show },
>  		{ "list",	link_show },
>  		{ "help",	link_help },
> diff --git a/rdma/rdma.h b/rdma/rdma.h
> index 547bb5749a39..b5271e423c10 100644
> --- a/rdma/rdma.h
> +++ b/rdma/rdma.h
> @@ -79,6 +79,7 @@ struct rd_cmd {
>   */
>  bool rd_no_arg(struct rd *rd);
>  void rd_arg_inc(struct rd *rd);
> +bool rd_argv_match(struct rd *rd, const char *pattern);
>
>  char *rd_argv(struct rd *rd);
>
> diff --git a/rdma/utils.c b/rdma/utils.c
> index 61f4aeb1bcf2..41f8f7391279 100644
> --- a/rdma/utils.c
> +++ b/rdma/utils.c
> @@ -32,7 +32,7 @@ int strcmpx(const char *str1, const char *str2)
>  	return strncmp(str1, str2, strlen(str1));
>  }
>
> -static bool rd_argv_match(struct rd *rd, const char *pattern)
> +bool rd_argv_match(struct rd *rd, const char *pattern)
>  {
>  	if (!rd_argc(rd))
>  		return false;
> --
> 1.8.3.1
>

--PGNNI9BzQDUtgA2J
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJb/t3lAAoJEORje4g2clin7CIP/2ry6roWSs7GtNHadwpCNOss
LTdIWP0G4zgzSu2tkGz3XXQh7hpa2VMdhqgt4t5m7Yt+f5G8AxoCLhsG9H0sP0od
tZNsKVphJzvLXXedTVo+f2W+Svcgxk6+IRmAG41xUn2N2+Cq/mfoc7+mlJ/mG/fz
HhbIqelCZPp7KLRuHb09MLPC/ibZwqXCYL3IrOztom39sWnAaHlaU7kDCTEqLxID
isZ6R3rECKWljqhQG3QLP5tCO0PhwBn+hL4GNaxfPzmoifqlR+XxkK2r5SGDL1YY
bZlCUnl4cO7TNU1p/2KP0Wf5cJRNT3/kKHiWHl+cYd01d/N8E2rchTzfCbE2oT10
oH6TiheEDFvZM+b0+KL+aYbFwZ0FwHjW57vsYxm2cxjegI2s7ZHpyM7obWbwxODI
moo3DCoDEEXZsybwwIYEQ31ysCeHqFi7q2nz4oTGPOT3Hd7H33Fm7uet8fNTnqlk
BfLUoVejMXYqPUNE6AcDUavc4lbdKhD7azWRWUuQD5RnbhrvDfGbnnvYM/oGObpp
fpJaoWRT7CCecSsGB/MYHYizyIvKG8kcIRSJLTPdtt1sUP7j4H0HmCofKBf0jzib
JO/8PrXRohNbBog4PAV6C3xaWvmZFv+RV1lEOYCe7PgXS4QCVAE99RVj721en091
3tifYq+BQisjPHVxe0Xi
=0ye9
-----END PGP SIGNATURE-----

--PGNNI9BzQDUtgA2J--
