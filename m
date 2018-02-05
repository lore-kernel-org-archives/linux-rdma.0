From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH iproute2-next 08/10] rdma: Add QP resource tracking
 information
Date: Mon, 5 Feb 2018 16:00:37 +0200
Message-ID: <20180205140037.GF2567@mtr-leonro.local>
References: <20180131081156.19607-1-leon@kernel.org>
 <20180131081156.19607-9-leon@kernel.org>
 <017501d39b97$f5931360$e0b93a20$@opengridcomputing.com>
 <20180205132231.GD2567@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JwB53PgKC5A7+0Ej"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180205132231.GD2567-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'David Ahern' <dsahern-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, 'RDMA mailing list' <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, 'Stephen Hemminger' <stephen-OTpzqLSitTUnbdJkjeBofR2eb7JE58TQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--JwB53PgKC5A7+0Ej
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 05, 2018 at 03:22:31PM +0200, Leon Romanovsky wrote:
> On Thu, Feb 01, 2018 at 02:05:08PM -0600, Steve Wise wrote:
> > Hey Leon,
>
> <...>
>
> >
> > > +static int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
> > > +{
>
> <...>
>
> > > +
> > > +	mnl_attr_for_each_nested(nla_entry, nla_table) {
> > > +		struct nlattr *nla_line[RDMA_NLDEV_ATTR_MAX] = {};
> > > +		uint32_t lqpn, rqpn = 0, rq_psn = 0, sq_psn;
> > > +		uint8_t type, state, path_mig_state = 0;
> > > +		uint32_t port = 0, pid = 0;
> > > +		char *comm = NULL;
>
> <...>
>
> > > +
> > > +		if (rd_check_is_filtered(rd, "pid", pid))
> > > +			continue;
> >
> > Is comm leaked here when ATTR_RES_PID is present?
> >
> >
> > > +
> > > +		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
> > > +			/* discard const from mnl_attr_get_str */
> > > +			comm = (char
> > > *)mnl_attr_get_str(nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME]);
> >
> > And also here if the kernel ever passes up both PID and KERN_NAME (which it
> > isn't supposed to).
>
> Yes, you are right, and the bad thing that I prepared everything to call
> free() unconditionally by setting comm to be NULL.

Stephen, David,

How do you want me to proceed?

The actual change is pretty minor:

diff --git a/rdma/res.c b/rdma/res.c
index 2a63e712..31d0c4a7 100644
--- a/rdma/res.c
+++ b/rdma/res.c
@@ -395,8 +395,10 @@ static int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
 			comm = get_task_name(pid);
 		}

-		if (rd_check_is_filtered(rd, "pid", pid))
+		if (rd_check_is_filtered(rd, "pid", pid)) {
+			free(comm);
 			continue;
+		}

 		if (nla_line[RDMA_NLDEV_ATTR_RES_KERN_NAME])
 			/* discard const from mnl_attr_get_str */
@@ -420,8 +422,7 @@ static int res_qp_parse_cb(const struct nlmsghdr *nlh, void *data)
 		print_pid(rd, pid);
 		print_comm(rd, comm, nla_line);

-		if (nla_line[RDMA_NLDEV_ATTR_RES_PID])
-			free(comm);
+		free(comm);

 		if (rd->json_output)
 			jsonw_end_array(rd->jw);

>
> Thanks
>
> >
> >
> > Steve.
> >



--JwB53PgKC5A7+0Ej
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlp4Y4UACgkQ5GN7iDZy
WKd7Ug/+OUAi9WdXGH2iCIbLMhhAYeWhq1XPrk0yOuzfSkn3RXhxm2cmQvn2Ca4W
lJgctaEyovzvzuqfgvWuaPzZcpEoN2J1oV2Ei296KEY+KzAFSlplCVcc03i4C3Sj
x97XKLxaeX4SH9zbYlXopGFaF8Sr+e6tGcl9F+FJI3GyCKpoxJyGzQtem4W266ZU
y8QjjOffEH7Q5rwZqWDhCqdcVREef/8nKVHwVY4VI/27f+r26GIRGmNn1dfBoOKd
d0ZHkzRAjzqN2mlxsD5rAJybsJnE4276aTURlkP5GyB33V77YlSVf8422zevq1Jv
NmThCbOB8aKJ9GjdRdLlnJSSICvZkUxO8ZdmTO1ZWBaYKHSgqRrrf22PvReAlQ+/
8xl4oQU+G/DReVjCej27YaPKc2HbsrWcFQvOmnR7M7/buWcS8uBdPFmYqi1nHBuX
JtVnxP28miLkR+OOeUyJH/yBnMdxADPlzOoHpzphs3gesi6flEZVzCYh/v2T9ZWc
C7x+VCHG69nDM3w7vBm54V75hWd/xsFEhfeNoF2tyYdZsvkVuD5uOq9uqYgufcLu
Ue4VmQut517QnntRYUhNM8lvmONVALqwyXK/7JnzVQlYCUlOIvNH3oIkzmmJznv/
oSGVH5c+/5opShoE4wwCo3/+ek0iSp/znOt5nSUo59xnvbwUsQA=
=qkz6
-----END PGP SIGNATURE-----

--JwB53PgKC5A7+0Ej--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
