From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Mon, 5 Feb 2018 17:43:51 +0200
Message-ID: <20180205154351.GG2567@mtr-leonro.local>
References: <cover.1517418595.git.swise@opengridcomputing.com>
 <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise@opengridcomputing.com>
 <20180201084944.GH2055@mtr-leonro.local>
 <00ce01d39b76$bd374ac0$37a5e040$@opengridcomputing.com>
 <20180204150553.GH27780@mtr-leonro.local>
 <015301d39e96$9f5e0b60$de1a2220$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Yb+qhiCg54lqZFXW"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <015301d39e96$9f5e0b60$de1a2220$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Yb+qhiCg54lqZFXW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 05, 2018 at 09:33:07AM -0600, Steve Wise wrote:
> Hey Leon,
>
> >
> > It is opposite, cm_id is a unique number, but other objects don't have
> > such. What about PD and CQ?
> >
> > We can declare that access to QP .doit willbe based on QPN, PD .doit
> > will be based on local_dma_lkey, but what will be CQ identifier?
> >
>
> Now that I've thought about this more, I realize the core verbs data
> structures don't have identifiers for most objects.  I'm not sure why the
> qp_num is exposed, but I guess it is because the qp num values must be
> exchanged between both ends of an IB connection to setup the connection.
>
> The  local_dma_lkey  value will not be unique for each PD.  For all iwarp
> devices the local_dma_lkey is 0.  (I think the same is true for IB devices).
> So PD has the same issue as CQ.
>
> I suppose we can use rkey for MRs, but if the MR is not in the VALID state,
> the rkey isn't necessarily accurate (the LSB of the rkey can be changed by
> the application with each REG_MR operation).
>
> The cm_id doesn't have any unique identifier either, except maybe the
> combination of src/dst addresses and port space.
>
> With iw_cxgb4, CQs, PDs, and MRs all have a unique identifier just like a QP
> does.  I expect all hw implementations of rdma have numeric identifiers for
> CQs, PDs, QPs, etc.    They aren't exposed to the core API though.
>
> Perhaps we add a device-unique (or globally unique) identifier as part of
> the restrack struct and use that for GET/SET?

+1,
I like it, it is very clean.

Thanks

>
> Steve.
>

--Yb+qhiCg54lqZFXW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlp4e7YACgkQ5GN7iDZy
WKc4xhAApemk183DJiyaXenOYQM2my+gONiU0UK6AOF1MH8cNCf2lfAgTimqRkOW
tMFBpdrIjS7dwpVcBrqLx3Gyn+AyZnYnq3UO+oqkwLotIoFmJDNCP01GwZnHQUT8
sYolP+TQPkSLp7hJJ7vfct+t5lZfLNBjnEfJS5J9Y7N16lbtVkH7Q0pLWPyLtU9S
aC00h3O4okj3hRO2U08uJOLB6BLbNxEPa+rrcHP2xNNKr0nD7YoXQfpHA+2Ddgh3
tNwkDYUVv8WmzsHGrfkPc3VX17852X6nsdOv71oU93mtluNRgxCS4UtIFMRX2VjZ
+5WuLEgl5ch5v1RkJXc4JPsax2s/oswbO16ViaPOSaQ8K5TKsq8Cv5By21sPCfJf
cFrvnRmlzAoa6Kj6pfxRS1MHXAz3gFRHISlkvRzc5R0HNUVDHp7wccPjuZgegdhX
+24Xsj3FhctSJHbx5niSYCyiGVJSTNWo7qJr4YocVlB9Y/EBty0Vxiwaq8IVSfrg
PwoKYEmdGZ583IiughjClYQlArRnHA2Gl7zum45PFL7zRWeQwYrTYfrDOgsTIuGB
a15fN1S48GPC5V/bVlyHhXwP409CbxvEYkgUAvvf7B59rR2nLqKzt5NOZ1wIbHHy
MGREl0A95yhJWLEzMXDy0iwAXVzr8wH3+gOE4AGL7DirTcY3QoA=
=CIOl
-----END PGP SIGNATURE-----

--Yb+qhiCg54lqZFXW--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
