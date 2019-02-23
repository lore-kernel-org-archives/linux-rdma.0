From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH iproute2-next v1 04/19] rdma: Provide parent context
 index for all objects except CM_ID
Date: Sat, 23 Feb 2019 11:03:43 +0200
Message-ID: <20190223090343.GK23561@mtr-leonro.mtl.com>
References: <20190220072136.3840-1-leon@kernel.org>
 <20190220072136.3840-5-leon@kernel.org>
 <01d401d4ca21$bfad6390$3f082ab0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="bpVaumkpfGNUagdU"
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <01d401d4ca21$bfad6390$3f082ab0$@opengridcomputing.com>
Sender: netdev-owner@vger.kernel.org
To: Steve Wise <swise@opengridcomputing.com>
Cc: 'David Ahern' <dsahern@gmail.com>, 'netdev' <netdev@vger.kernel.org>, 'RDMA mailing list' <linux-rdma@vger.kernel.org>, 'Stephen Hemminger' <stephen@networkplumber.org>
List-Id: linux-rdma@vger.kernel.org


--bpVaumkpfGNUagdU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 21, 2019 at 02:12:19PM -0600, Steve Wise wrote:
>
>
> > -----Original Message-----
> > From: linux-rdma-owner@vger.kernel.org <linux-rdma-
> > owner@vger.kernel.org> On Behalf Of Leon Romanovsky
> > Sent: Wednesday, February 20, 2019 1:21 AM
> > To: David Ahern <dsahern@gmail.com>
> > Cc: Leon Romanovsky <leonro@mellanox.com>; netdev
> > <netdev@vger.kernel.org>; RDMA mailing list <linux-
> > rdma@vger.kernel.org>; Stephen Hemminger
> > <stephen@networkplumber.org>
> > Subject: [PATCH iproute2-next v1 04/19] rdma: Provide parent context index
> > for all objects except CM_ID
> >
> > From: Leon Romanovsky <leonro@mellanox.com>
> >
> > Allow users to correlate allocated object with relevant parent
> >
> > [leonro@server ~]$ rdma res show pd
> > dev mlx5_0 users 5 pid 0 comm [ib_core] pdn 1
> > dev mlx5_0 users 7 pid 0 comm [ib_ipoib] pdn 2
> > dev mlx5_0 users 0 pid 0 comm [mlx5_ib] pdn 3
> > dev mlx5_0 users 2 pid 548 comm ibv_rc_pingpong ctxn 0 pdn 4
> >
> > [leonro@server ~]$ rdma res show cq cqn 0-100
> > dev mlx5_0 cqe 2047 users 6 poll-ctx UNBOUND_WORKQUEUE pid 0 comm
> > [ib_core] cqn 2
> > dev mlx5_0 cqe 255 users 2 poll-ctx SOFTIRQ pid 0 comm [mlx5_ib] cqn 3
> > dev mlx5_0 cqe 511 users 1 poll-ctx DIRECT pid 0 comm [ib_ipoib] cqn 4
> > dev mlx5_0 cqe 255 users 1 poll-ctx DIRECT pid 0 comm [ib_ipoib] cqn 5
> > dev mlx5_0 cqe 255 users 0 poll-ctx SOFTIRQ pid 0 comm [mlx5_ib] cqn 6
> > dev mlx5_0 cqe 511 users 2 pid 548 comm ibv_rc_pingpong cqn 7 ctxn 0
> >
> > [leonro@server ~]$ rdma res show mr
> > dev mlx5_0 mrlen 4096 pid 548 comm ibv_rc_pingpong mrn 4 pdn 0
> >
> > [leonro@nps-server-14-015 ~]$ /images/leonro/src/iproute2/rdma/rdma res
> > show qp
> > link mlx5_0/1 lqpn 0 type SMI state RTS sq-psn 0 pid 0 comm [ib_core]
> > link mlx5_0/1 lqpn 1 type GSI state RTS sq-psn 0 pid 0 comm [ib_core]
> > link mlx5_0/1 lqpn 7 type UD state RTS sq-psn 0 pid 0 comm [ib_core]
> > link mlx5_0/1 lqpn 8 type UD state RTS sq-psn 0 pid 0 comm [ib_ipoib]
> > link mlx5_0/1 lqpn 9 pdn 4 rqpn 0 type RC state INIT rq-psn 0 sq-psn 0
> path-
> > mig-state MIGRATED pid 548 comm ibv_rc_pingpong
> >
> > Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
> > ---
> >  rdma/res.c | 110 +++++++++++++++++++++++++++++++++++----------------
> > --
> >  1 file changed, 72 insertions(+), 38 deletions(-)
> >
> > diff --git a/rdma/res.c b/rdma/res.c
> > index f941de5c..308f66c0 100644
> > --- a/rdma/res.c
> > +++ b/rdma/res.c
> > @@ -320,6 +320,22 @@ static char *get_task_name(uint32_t pid)
> >  	return comm;
> >  }
> >
> > +static void print_key(struct rd *rd, const char *name, uint64_t val)
> > +{
> > +	if (rd->json_output)
> > +		jsonw_xint_field(rd->jw, name, val);
> > +	else
> > +		pr_out("%s 0x%" PRIx64 " ", name, val);
> > +}
> > +
> > +static void res_print_uint(struct rd *rd, const char *name, uint64_t val)
> > +{
> > +	if (rd->json_output)
> > +		jsonw_uint_field(rd->jw, name, val);
> > +	else
> > +		pr_out("%s %" PRIu64 " ", name, val);
> > +}
> > +
> >  static int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
> >  {
> >  	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
> > @@ -343,6 +359,7 @@ static int res_qp_parse_cb(const struct nlmsghdr
> > *nlh, void *data)
> >  		uint32_t lqpn, rqpn = 0, rq_psn = 0, sq_psn;
> >  		uint8_t type, state, path_mig_state = 0;
> >  		uint32_t port = 0, pid = 0;
> > +		uint32_t pdn = 0;
> >  		char *comm = NULL;
> >  		int err;
> >
> > @@ -369,6 +386,11 @@ static int res_qp_parse_cb(const struct nlmsghdr
> > *nlh, void *data)
> >  		if (rd_check_is_filtered(rd, "lqpn", lqpn))
> >  			continue;
> >
> > +		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
> > +			pdn =
> > mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
> > +		if (rd_check_is_filtered(rd, "pdn", pdn))
> > +			continue;
> > +
> >  		if (nla_line[RDMA_NLDEV_ATTR_RES_RQPN]) {
> >  			rqpn =
> > mnl_attr_get_u32(nla_line[RDMA_NLDEV_ATTR_RES_RQPN]);
> >  			if (rd_check_is_filtered(rd, "rqpn", rqpn))
> > @@ -428,6 +450,8 @@ static int res_qp_parse_cb(const struct nlmsghdr
> > *nlh, void *data)
> >  		print_link(rd, idx, name, port, nla_line);
> >
> >  		print_lqpn(rd, lqpn);
> > +		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
> > +			res_print_uint(rd, "pdn", pdn);
> >  		print_rqpn(rd, rqpn, nla_line);
> >
> >  		print_type(rd, type);
> > @@ -549,22 +573,6 @@ static int ss_ntop(struct nlattr *nla_line, char
> > *addr_str, uint16_t *port)
> >  	return 0;
> >  }
> >
> > -static void print_key(struct rd *rd, const char *name, uint64_t val)
> > -{
> > -	if (rd->json_output)
> > -		jsonw_xint_field(rd->jw, name, val);
> > -	else
> > -		pr_out("%s 0x%" PRIx64 " ", name, val);
> > -}
> > -
> > -static void res_print_uint(struct rd *rd, const char *name, uint64_t val)
> > -{
> > -	if (rd->json_output)
> > -		jsonw_uint_field(rd->jw, name, val);
> > -	else
> > -		pr_out("%s %" PRIu64 " ", name, val);
> > -}
> > -
> >  static int res_cm_id_parse_cb(const struct nlmsghdr *nlh, void *data)
> >  {
> >  	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX] = {};
> > @@ -768,6 +776,7 @@ static int res_cq_parse_cb(const struct nlmsghdr *nlh,
> > void *data)
> >  		char *comm = NULL;
> >  		uint32_t pid = 0;
> >  		uint8_t poll_ctx = 0;
> > +		uint32_t ctxn = 0;
> >  		uint32_t cqn = 0;
> >  		uint64_t users;
> >  		uint32_t cqe;
> > @@ -815,6 +824,12 @@ static int res_cq_parse_cb(const struct nlmsghdr
> > *nlh, void *data)
> >  		if (rd_check_is_filtered(rd, "cqn", cqn))
> >  			continue;
> >
> > +		if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
> > +			ctxn = mnl_attr_get_u32(
> > +				 nla_line[RDMA_NLDEV_ATTR_RES_CTXN]);
> > +		if (rd_check_is_filtered(rd, "ctxn", ctxn))
> > +			continue;
> > +
> >  		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
> >  			/* discard const from mnl_attr_get_str */
> >  			comm = (char *)mnl_attr_get_str(
> > @@ -833,6 +848,8 @@ static int res_cq_parse_cb(const struct nlmsghdr *nlh,
> > void *data)
> >
> >  		if (nla_line[RDMA_NLDEV_ATTR_RES_CQN])
> >  			res_print_uint(rd, "cqn", cqn);
> > +		if (nla_line[RDMA_NLDEV_ATTR_RES_CTXN])
> > +			res_print_uint(rd, "ctxn", ctxn);
> >
> >  		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> >  			free(comm);
> > @@ -866,6 +883,7 @@ static int res_mr_parse_cb(const struct nlmsghdr
> > *nlh, void *data)
> >  		uint32_t rkey = 0, lkey = 0;
> >  		uint64_t iova = 0, mrlen;
> >  		char *comm = NULL;
> > +		uint32_t pdn = 0;
> >  		uint32_t mrn = 0;
> >  		uint32_t pid = 0;
> >  		int err;
> > @@ -911,6 +929,12 @@ static int res_mr_parse_cb(const struct nlmsghdr
> > *nlh, void *data)
> >  		if (rd_check_is_filtered(rd, "mrn", mrn))
> >  			continue;
> >
> > +		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
> > +			pdn = mnl_attr_get_u32(
> > +				nla_line[RDMA_NLDEV_ATTR_RES_PDN]);
> > +		if (rd_check_is_filtered(rd, "pdn", pdn))
> > +			continue;
> > +
> >  		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
> >  			/* discard const from mnl_attr_get_str */
> >  			comm = (char *)mnl_attr_get_str(
> > @@ -933,6 +957,9 @@ static int res_mr_parse_cb(const struct nlmsghdr
> > *nlh, void *data)
> >  		if (nla_line[RDMA_NLDEV_ATTR_RES_MRN])
> >  			res_print_uint(rd, "mrn", mrn);
> >
> > +		if (nla_line[RDMA_NLDEV_ATTR_RES_PDN])
> > +			res_print_uint(rd, "pdn", pdn);
> > +
> >  		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
> >  			free(comm);
> >
> > @@ -964,6 +991,7 @@ static int res_pd_parse_cb(const struct nlmsghdr
> > *nlh, void *data)
> >  		uint32_t local_dma_lkey = 0, unsafe_global_rkey = 0;
> >  		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
> >  		char *comm = NULL;
> > +		uint32_t ctxn = 0;
> >  		uint32_t pid = 0;
> >  		uint32_t pdn = 0;
> >  		uint64_t users;
> > @@ -997,7 +1025,13 @@ static int res_pd_parse_cb(const struct nlmsghdr
> > *nlh, void *data)
> >  			comm = get_task_name(pid);
> >  		}
> >
> > -		if (rd_check_is_filtered(rd, "pid", pid))
> > +                if (rd_check_is_filtered(rd, "pid", pid))
>
> Did this add some whitespace problem?

It is how git prepared patch :(, i tried to remove this change now, but
it didn't work.

>
> Reviewed-by: Steve Wise <swise@opengridcomputing.com>
>
>

--bpVaumkpfGNUagdU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBAgAGBQJccQxvAAoJEORje4g2clin72gQAKBvO0EQkU34009HeGrHUtA5
TnyKXmORVqmupzAFnsNt2/4Bn2prem8vj7u7KMQcpPllaBGLFtx9G0OjPc28V5Qr
399/qKSyN8Rp9wQ53ddv2TqkYBHjzWjQH3wqOpw+OOyyw6kdWBBdWdX7phBugFc1
bxSStUBAYx/RfClYxyjTiW5/xHE4nuQqUK/r1uune9faYFAZ2zbfVeBbkLj/kvBd
eao6YKHzU6LPTVAt2MHvbrRwEK4RdD96cB8abXKnU8G8cbxOdloQvqi6GKQJTJk8
drQ22lvxJ/MmOA2g3JPMLFa0Bv0d9VlbcyzYH+pLfFrxrvyoK+Bs1v4HIcDz3u4s
mY+ztkpiPIh4A6xrtwGxpIguxYk/fg2XfsV33W9esVZd2nsFYT3sCLCIMleEkfXs
EM8Bo/jYUWIl26+Mq0nxqHBnpNXnGYPsRJbI3wtTcfHXNmtl1BiiCK/xoJNTxWpB
qSZQUzeTctdM96m9npSV75E7O0aXHx+Zk+z7RZAN9DGV0bbqBqmFb74DtnY6oLqL
weskmkSXDwz+A9PWJSyL3VKs4ZivMWVIipAKimbmTJmeMP3NRhhB+lNG4MdUtLac
eMo+ECq/h+wNb+F+YMsYbsXAha1a1Wak+9umqXbYP4U/Hqzxiy2MIK9WJQmeykw2
5r9vecRlhhgMqMLksISr
=viz8
-----END PGP SIGNATURE-----

--bpVaumkpfGNUagdU--
