From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 0/6] Enhanced mode for IPoIB driver
Date: Wed, 12 Apr 2017 08:22:23 +0300
Message-ID: <20170412052223.GQ2269@mtr-leonro.local>
References: <20170404191732.31895-1-leon@kernel.org>
 <2807E5FD2F6FDA4886F6618EAC48510E67C8CAA0@CRSMSX101.amr.corp.intel.com>
 <20170404200335.GB20443@mtr-leonro.local>
 <2807E5FD2F6FDA4886F6618EAC48510E67C8DAB7@CRSMSX101.amr.corp.intel.com>
 <20170406052820.GB2269@mtr-leonro.local>
 <20170406151014.GA173962@knc-06.sc.intel.com>
 <20170410080228.GP2269@mtr-leonro.local>
 <20170410154039.GA7056@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="xNm6VWMD3PcA105u"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170410154039.GA7056-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Vishwanathapura, Niranjana" <niranjana.vishwanathapura-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Vesker <valex-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--xNm6VWMD3PcA105u
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Apr 10, 2017 at 09:40:39AM -0600, Jason Gunthorpe wrote:
> On Mon, Apr 10, 2017 at 11:02:28AM +0300, Leon Romanovsky wrote:
>
> > I just want to be sure that once any vendor in this susbsystem
> > will use the same magic sentence "it gives best performance for our
> > hardware and future devices will come". There will be no questions about
> > interoperability between various devices, no more questions about
> > standards, no more requests to implement for other drivers (hardware and
> > software).
>
> Don't be absurd..
>
> I repeatedly chewed out intel for having their driver act like a
> subsystem in of itself, keeping user-facing code that is not linked to
> hardware out of driver is the right thing to do.

Jason,

Yes, you did, however for many reasons hfi ended to be subsystem on its own,
and now we are moving this subsystem one layer up. I really failed to understand
your point of view, why hfi-vnic is not linked to specific hardware.

Thanks

>
> Jason

--xNm6VWMD3PcA105u
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljtuY8ACgkQ5GN7iDZy
WKfFXxAAmczQ93E0VNdSvDMfAOfG/hPDAFzixqJTXRubA8ekNW5vayUh/93BLwib
4vteMDkfL/T/5WECv14UxzqAdtZf8NGYYbeCzyyXkEbJoU96h+a/J9FzMp7Y4vun
wnsO9gLPM49C15YFC/zO+1N7beDRkNvY8fJ7ERIIj/eD0aHhaFrrWzuJ0xmY/Zy9
/FKsH3GW5awgrv7muoNqGCMLmAb/mxnhhZ8YgwgrmhPKXYkh1AlMqCzn9C7M3vQ0
BdYoNyKj/VXUubl8vLsTmgrgN4Ft0FG01thXhTlTkQTodkItIIxQLf94YStv17hN
1Xhku4iJiNnl8siW9mZ8cZ+zutyeHxXiv6zCbg1WSNDHmgCbzNBYfYKhIC4Eh5DS
7R7N53TONX5GLwyl5jVMeQSL/0mTSmaOcGy1wOEtoc87+EB9hVUxzjCom0j23aZc
hrOpr9tOdrHvJID6gSd4Js+kowfUlEkFyZ7rfqJQ5mqW3rMUDu6+fRwlUEJel0za
VCO88hgcWf6fAfsd74zYjjcS6jgK9zM6FojziPZA/k/Gkk7gs8ZlSulmFBULNwB0
XIegUjAQ20VgNrKNE9bPCF4euzPVYC28bx6apTvlD340dvj2AolTLNrWRCBJJOT8
6Fluif5y+CDm3puJUF420ZxrgSIBtUwGoUTK7yHMPfKOMjyqp2Y=
=+v3D
-----END PGP SIGNATURE-----

--xNm6VWMD3PcA105u--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
