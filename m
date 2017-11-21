From: Leon Romanovsky <leon@kernel.org>
Subject: Re: [PATCH rdma-rc 1/2] IB/core: Only enforce security for InfiniBand
Date: Tue, 21 Nov 2017 15:22:15 +0200
Message-ID: <20171121132215.GU18825@mtr-leonro.local>
References: <20171121102618.31216-1-leon@kernel.org>
 <20171121102618.31216-2-leon@kernel.org>
 <4f5268b5-e5b6-a7d9-2096-70b4ae8facaf@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mE/Xa1AiRZ1EEZMN"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4f5268b5-e5b6-a7d9-2096-70b4ae8facaf@mellanox.com>
Sender: stable-owner@vger.kernel.org
To: Mark Bloch <markb@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>, linux-rdma@vger.kernel.org, Daniel Jurgens <danielj@mellanox.com>, Paul Moore <paul@paul-moore.com>, Don Dutile <ddutile@redhat.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org


--mE/Xa1AiRZ1EEZMN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 21, 2017 at 12:44:10PM +0200, Mark Bloch wrote:
> Hi,
>
> On 21/11/2017 12:26, Leon Romanovsky wrote:
> > From: Daniel Jurgens <danielj@mellanox.com>
> >
> > For now the only LSM security enforcement mechanism available is
> > specific to InfiniBand. Bypass enforcement for non-IB link types.
> > This fixes a regression where modify_qp fails for iWARP because
> > querying the PKEY returns -EINVAL.
> >
> > Cc: Paul Moore <paul@paul-moore.com>
> > Cc: Don Dutile <ddutile@redhat.com>
> > Cc: stable@vger.kernel.org
> > Reported-by: Potnuri Bharat Teja <bharat@chelsio.com>
> > Fixes: d291f1a65232("IB/core: Enforce PKey security on QPs")
> > Fixes: 47a2b338fe63("IB/core: Enforce security on management datagrams")
> > Signed-off-by: Daniel Jurgens <danielj@mellanox.com>
> > Reviewed-by: Parav Pandit <parav@mellanox.com>
> > Tested-by: Potnuri Bharat Teja <bharat@chelsio.com>
> > Signed-off-by: Leon Romanovsky <leon@kernel.org>
> > ---
> >  drivers/infiniband/core/security.c | 9 +++++++++
> >  1 file changed, 9 insertions(+)
> >
> > diff --git a/drivers/infiniband/core/security.c b/drivers/infiniband/core/security.c
> > index 23278ed5be45..314bf1137c7b 100644
> > --- a/drivers/infiniband/core/security.c
> > +++ b/drivers/infiniband/core/security.c
> > @@ -417,8 +417,17 @@ void ib_close_shared_qp_security(struct ib_qp_security *sec)
> >
> >  int ib_create_qp_security(struct ib_qp *qp, struct ib_device *dev)
> >  {
> > +	u8 i = rdma_start_port(dev);
> > +	bool is_ib = false;
> >  	int ret;
> >
> > +	while (i <= rdma_end_port(dev) && !is_ib)
> > +		is_ib = rdma_protocol_ib(dev, i++);
> > +
>
> What happens if we have mixed port types?

We will have is_ib set and qp_sec will be allocated on device layer and
not on port level, but because pkeys are IB specific term (at least, I
didn't find any mentioning in RoCE spec), the modify_qp won't query
for PKEYS.

> I believe mlx4 can expose two ports where each port uses a different ll protocol.
> Was that changed?

It is still true.

>
> > +	/* If this isn't an IB device don't create the security context */
> > +	if (!is_ib)
> > +		return 0;
> > +
> >  	qp->qp_sec = kzalloc(sizeof(*qp->qp_sec), GFP_KERNEL);
> >  	if (!qp->qp_sec)
> >  		return -ENOMEM;
> >
>
> Mark.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--mE/Xa1AiRZ1EEZMN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloUKIcACgkQ5GN7iDZy
WKcZrw/+Itt1ihYcFlb+1Q/xjKCJk1O/NVOt9IFFAptba+TbUR7KCc5ooq+volbK
Iq7Er2hbd3mK4uNQ94M+QzKAaUJY1YvYMuJcW9O0B3N9BbRFwuMb2LVPB2roBI66
6L4GVbAjVm0rFAtg0Rd+pCi2WimRAB+jshliXhyzLMfqfGI8dwkZ1O1EvjJjOTH+
DHjO35XFcYFgbhhk09rwFto6ZyTP6QLvulyW9T6m3VABMhY+d14z7Jzj9eHCrNBI
qT9hFYVIXSJSx/XsMkAEn098vaJOoSJJwTTkLA+bgRrXtfy9WWds6hQnkMKNOG8Y
aiqp1Q9pk+ZOVRDCiFWHVx+shoZapbS1k7U1TMCFibPEz63TNjGombQUxBhQXIC0
nhQDf3bhU2p3uUvhsVH5Itgzt8fSLuT+h/heq2vCyeQsV9Z5Q34c+px1ppjRlwMy
shZ5w+bW/+lIiBXWUoCYspXi7TCKJDjDD87hCsaIEqMIvFOajm0IJmiOCLUKXb9q
P7p2QjVHkimOa239Fq7Q3WA72DlDMWvzYzHd0Xe8Zu1BMVMYDInF9S7Frs7Ls9zc
aO9jWVsK00/LS8WSWDPPFFy3/+ZVzbbDfkcdXS1/LUNAArCSNyjNkcgAHduUhwKq
XnF7tHwVIaFJsH7FWJlS2sTKE3jYAND37bpBgP3X2UClFxWSoBY=
=/irZ
-----END PGP SIGNATURE-----

--mE/Xa1AiRZ1EEZMN--
