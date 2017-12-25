From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 0/3] IB/hfi1,core: Driver updates for 12/22/2017
Date: Mon, 25 Dec 2017 12:46:15 +0200
Message-ID: <20171225104615.GH2942@mtr-leonro.local>
References: <20171222164036.29731.43475.stgit@scvm10.sc.intel.com>
 <20171222233738.GB17198@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="F1UMmCLUB5xxGl5w"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171222233738.GB17198-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--F1UMmCLUB5xxGl5w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Dec 22, 2017 at 04:37:38PM -0700, Jason Gunthorpe wrote:
> On Fri, Dec 22, 2017 at 08:45:35AM -0800, Dennis Dalessandro wrote:
> > Don Hiatt (2):
> >       IB/core: Use rdma_cap_opa_mad to check for OPA
> >       IB/hfi1: Change slid arg in ingress_pkey_table_fail to 32bit
>
> For now I took these two to for-next the other should sit on the list
> for a bit.

Just to emphasize how easy to add new field in nldev:

diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index 6b22f1f2d084..ca07f845a6ae 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -70,6 +70,7 @@ static const struct nla_policy nldev_policy[RDMA_NLDEV_ATTR_MAX] = {
 	[RDMA_NLDEV_ATTR_RES_PID]		= { .type = NLA_U32 },
 	[RDMA_NLDEV_ATTR_RES_PID_COMM]	= { .type = NLA_NUL_STRING,
 						    .len = TASK_COMM_LEN },
+	[RDMA_NLDEV_ATTR_RES_RNR_TIMEOUT]	= { .type = NLA_U8 },
 };

 static int fill_nldev_handle(struct sk_buff *msg, struct ib_device *device)
@@ -283,6 +284,9 @@ static int fill_res_qp_entry(struct sk_buff *msg,
 			   RDMA_NLDEV_ATTR_RES_PID_COMM, qp->res.task_comm))
 		goto err;

+	if (nla_put_u8(msg, RDMA_NLDEV_ATTR_RES_RNR_TIMEOUT, qp_attr.min_rnr_timer))
+		goto err;
+
 	nla_nest_end(msg, entry_attr);

 	return 0;
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 9a90cd9f614e..241a9184a9f7 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -357,6 +357,8 @@ enum rdma_nldev_attr {
 	 */
 	RDMA_NLDEV_ATTR_RES_PID_COMM,		/* string */

+	RDMA_NLDEV_ATTR_RES_RNR_TIMEOUT,	/* u8 */
+
 	RDMA_NLDEV_ATTR_MAX
 };
 #endif /* _UAPI_RDMA_NETLINK_H */

>
> Thanks
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--F1UMmCLUB5xxGl5w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpA1vcACgkQ5GN7iDZy
WKcmOA//UYF2mJg9peWJmiGG1/YK7oPVhV2k1voP4p7LQE7rCZpAXeJt6OHGX9HZ
0XUqMN64fJe4t+LjNzDbC1/SjAJrs74epGoiODz9G/WUxYPUdvk50wMWXl8voDpL
hZFVLn9YEF7rEl16MEHUYlccxYnqu/PItVk8FIVm4SD5SYTPJ1ebZsv/smHf4DEv
cyjDwmhVRVnt2gkoyj9611bawrfEq7SKNk33HFbXLbE0BDPYnMZmzPZ+ITpZPMOu
pfXHsPa3h+5DNnuQeUR6AV7hsUfeT4V0Cf0Kh6jwq+cyoTePIqdk/FguprIfBxkR
9rQenRiRgGxe9g2jGUwmGRXOde171Othl/rnamb93H9X1pmAiFIxHNt1P2adZyDl
nPyP+lteMUaPdNUgi7GmC2fLT9qtNj+w7XlAx30PpTw3BH11CobTxX2YO6xl+O5d
+NR44qXPK/ikVGInDEpo1NPZkZhlXI4CWYzyBmgrP/S5IP4560cVIABsMhGNpnsC
dL+y4qWG645tkkSO9Gn/EOYc0f3whnIlbaTf4W7llDYRE2ALpgq/b7fbLfYqI8aa
MUa80gQhH7JA04XMQxShRwCuDiQcLlw3B3QH6uwTmDS/hf6MWL196u4W7/3/oahe
Tm/RpcFbR2im8Uwcly8A6YSA6HgY4GB3O3Xz/TY4o3neP+SyKjE=
=ZvR7
-----END PGP SIGNATURE-----

--F1UMmCLUB5xxGl5w--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
