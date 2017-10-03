From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH for-next 5/8] IB/core: Use __be32 for LIDs in
 opa_is_extended_lid
Date: Tue, 3 Oct 2017 20:01:40 +0300
Message-ID: <20171003170140.GD25829@mtr-leonro.local>
References: <20171002180204.31117.12254.stgit@scvm10.sc.intel.com>
 <20171002180431.31117.33069.stgit@scvm10.sc.intel.com>
 <20171003061657.GA13648@mtr-leonro.local>
 <20171003160059.GB30753@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="2Z2K0IlrPCVsbNpk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171003160059.GB30753-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--2Z2K0IlrPCVsbNpk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Oct 03, 2017 at 10:00:59AM -0600, Jason Gunthorpe wrote:
> On Tue, Oct 03, 2017 at 09:16:57AM +0300, Leon Romanovsky wrote:
>
> > > -static inline bool opa_is_extended_lid(u32 dlid, u32 slid)
> > > +static inline bool opa_is_extended_lid(__be32 dlid, __be32 slid)
> > >  {
> > >  	if ((be32_to_cpu(dlid) >=
> > >  	     be16_to_cpu(IB_MULTICAST_LID_BASE)) ||
> > >  	    (be32_to_cpu(slid) >=
> > >  	     be16_to_cpu(IB_MULTICAST_LID_BASE)))
> >
> > You can drop be32_to_cpu and be16_to_cpu now.
> > The dlid is __be32 and IB_MULTICAST_LID_BASE is __be16. The direct
> > comparison will work.
>
> It won't order properly for >=, the swap is still needed...

Jason,
Do you have reference for that?

I tried to find any information about comparison of values from one
endianess on machine with another endianess and didn't find anything
relevant.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--2Z2K0IlrPCVsbNpk
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlnTwnMACgkQ5GN7iDZy
WKcIgQ/7BQjfi3gVzcIMTKBjycv3EnUjy6nV622Ymir89bI8lmnxy433IKhTaZPB
UbNTuLEWl/6gdvUFYOtjwMtM5PMFHB9HVsZRe7hcXM0vFa3LUu3FX0LZ/QEgdIkH
GDoOnZt4mqgR+zzjzgHBZk6H0ZxLncZjbtMbr3F+QInfL7xCd59HOJtDdOR43dBF
crrZvsuFxNxru6A83kZH9e5u5i5FggyNaKuS4tfLp2k7En24Q8Aw/VcX8zAoCi8n
CNcf/kiw8dIIRuEL902Oonth8cMUZcUWKTtM0VhqyAbBxuz/EK7cdLQvPAZfT8ww
8DW1qBksVwBRchmFN4jmEgOIjFQp7R3aKdqdtFlhe+HWr8vykYqtho5eNMo6jkHT
tIKP487Niq+0z8L/DHXxpbhA7ejUKPjK3f45GNFPoZbJepuwpcdkFTDxSDft8u55
Da4vIdDpfoPEWiOm1FllXqr7r6xvbj6I7BkA13rTehFHBcl/ZqL34k6vmLyl7PVV
/6xzszCEfyzz1XxbNgKidL4RjXhrwFDxrmwRmYrtHq8jJYg0/fx1nUXZXkQGm9e0
UqwMUwqQVEULK1YU57oTCFiw33u4+x0ACCtu331Ow3Fa28aXMkfDQPKGTdNUVJr0
wv1gjU+XzU3XsfF1hWXtwEaKKFJt5YMOMPpb+ZCzhDs8JpLpUzk=
=lQbL
-----END PGP SIGNATURE-----

--2Z2K0IlrPCVsbNpk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
