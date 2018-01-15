From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v3 3/7] RDMA: Annotate create QP callers
Date: Mon, 15 Jan 2018 16:31:25 +0200
Message-ID: <20180115143125.GB15760@mtr-leonro.local>
References: <20180111153132.11143-1-leon@kernel.org>
 <20180111153132.11143-4-leon@kernel.org>
 <20180114212704.GE9088@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="z3Nkz3fRLNVT9Ca+"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20180114212704.GE9088-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--z3Nkz3fRLNVT9Ca+
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jan 14, 2018 at 02:27:04PM -0700, Jason Gunthorpe wrote:
> On Thu, Jan 11, 2018 at 05:31:28PM +0200, Leon Romanovsky wrote:
> > @@ -1538,6 +1537,7 @@ int ib_destroy_qp(struct ib_qp *qp)
> >  	if (!qp->uobject)
> >  		rdma_rw_cleanup_mrs(qp);
> >
> > +	rdma_restrack_del(&qp->res, RDMA_RESTRACK_QP);
> >  	ret = qp->device->destroy_qp(qp);
> >  	if (!ret) {
> >  		if (pd)
>
> This hunk belongs in a different patch right?

In this patch, I changed call from device->create_qp() to
the _ib_create_qp() and it is under the hood called to
the rdma_restrack_add(). There was a need to add
rdma_restrack_del() to balance refounts.

>
> Jason

--z3Nkz3fRLNVT9Ca+
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlpcuz0ACgkQ5GN7iDZy
WKfNVQ/+I/BvEPUQC5BWfrRVPrWuM7Hgu0PtaFlXvwkHZkYCJqpYrWmcM+snegJ9
HaOajPDpxxwyW/LD1Icu2dQW3H0A92Edq/BqLNitTZoU5m4piZOMqWn04HeiLX/d
MTsk6XqbIqYpgI37iuUBPgt7I1m2uMcJhqKNVrHw6fhSEr9ZDVkvZbvrUy9BsThj
7y9M7BecYaQCWRjL62Ph39L2x0/6bKHrU5zoXooixn7oc28DKSZa2Qhs+on+ySKB
gYMjVDu/fIw+6h/XMcIUn888DB7QlVk3yRVsPuOHcm19HBFSvGvyw+hU5ZS2F82Y
0TB6SGZPvt40ib3irlGyrXlV7eHb5Agz9eLNkrkvxpsrmwRtzt7sCCsoDugh6Hc2
WIpmwj+xmkByRKZM1+VRRfM2i53EwxMhzbHCzpTNtI9obwEIlT3hNmu31vPfIYju
4I+72hPt7v3juOuJMvxPq4TG3I/hsZFb9eNh+i9rPbw1xEd3t7gfGiAC89DK9xVU
8TbhluwAvQuIww9yrvx76hUAQASA/X12a3DZRhhV2Mi7Bfp3WLpmAIsD+cYgBz4A
nMGM4ALxqyAfVFcZz3yPde4CI+Em5qzcFEAnIBG+EcUTUA8d5t3G2vJTwIj+aL5z
B5+ar1FyX/zqjcVbpYPXB1RpmKxeMADgGji94wfsDKwP0/0gijw=
=Ly11
-----END PGP SIGNATURE-----

--z3Nkz3fRLNVT9Ca+--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
