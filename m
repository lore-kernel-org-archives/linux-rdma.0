From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] libhns: Update the size and member order of
 hns_roce_create_qp structure
Date: Sat, 30 Sep 2017 19:07:57 +0300
Message-ID: <20170930160757.GH2965@mtr-leonro.local>
References: <1506761477-47350-1-git-send-email-oulijun@huawei.com>
 <20170930154518.GA14152@obsidianresearch.com>
 <20170930160515.GG2965@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="FLPM4o+7JoHGki3m"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170930160515.GG2965-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--FLPM4o+7JoHGki3m
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Sep 30, 2017 at 07:05:15PM +0300, Leon Romanovsky wrote:
> On Sat, Sep 30, 2017 at 09:45:18AM -0600, Jason Gunthorpe wrote:
> > On Sat, Sep 30, 2017 at 04:51:17PM +0800, Lijun Ou wrote:
> > > In order to keep the size and member order with the
> > > hns_roce_ib_create_qp sturcture of the kernel driver,
> > > it need to update hns_roce_create_qp's structure
> > > members. Otherwise, it will run fail.
> >
> > What?
> >
> > Did you break the uapi? What kernel patch does this match with?
> >
> > Generally structs in the u_abi.h headers cannot be changed like this.
>
> Jason,
>
> It was my suggestion to change rdma-core, because before they tried to
> change kernel.
>
> https://patchwork.kernel.org/patch/9975329/
>

And according to the git log on providers/hns/hns_roce_u_abi.h and
include/uapi/rdma/hns-abi.h, it never worked.

>
> >
> > Jason
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html



--FLPM4o+7JoHGki3m
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnPwV0ACgkQ5GN7iDZy
WKfwhQ//RWV1ZEZoj6uSqNvsGHopEN0nUdSQrRJN/M7/0mf7+yZPbI0jJPbMlrl7
gJJYEGjqVFb4L1gVuZ2OMd3CkSYpG29VLazqZtYtF7LUxdxIWGdiJTm3Mpuh47+p
qO8nYzv+Y6OwebuZGm8SxPFJcHyHJpnF6hTz/L4Tq7s+laza5qMFYeQy3A7/17yz
IlzdtU18+PBDlALK5/HIkkfHz8bdmkScH4v9g1KAor9lG/G1wrUVy43SXhvG5USN
gj+dFpZGBFE0AB7RGwuWAyZ7Tjz5pakBay5y7kX6ukx0/3cHbggPQLl5VJnPYm0f
LbqzvEFf/uLgOXSZyhPDZbFzwGpNuFEjBC440FhwPWx45dD7EVzzO//QkG0XqyzF
bhvPOsEbqLxEXvXHFBIVmhgAbDtK8kNZIYXT+gW85g5RGO6O9OdQYFycLwBmcTlc
S1n/9lm4UCN72YCcnsYxALDd/QS1bc92BINK4B4LB1D9z0dHjMVwBV29l3WwBFrO
kqnLKcOO/xXt0plZ8xiAyVuRA58526FtiV9DwRVavUg8Ov92tBBXgmz3f5mXDFeN
7pMzElVRRT5Tzn4ClL+cbkw7NEL9fREdhiYiev5ql4z6lpPCnwMr27MjYSlH27xj
uAb0i5rYnC0g/Ul0QkhK5PYLXlW8o7aNNvXCl7P0yAuFmfUxR2c=
=6u9H
-----END PGP SIGNATURE-----

--FLPM4o+7JoHGki3m--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
