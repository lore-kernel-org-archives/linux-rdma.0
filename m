From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Tue, 3 May 2016 21:42:18 +0300
Message-ID: <20160503184218.GC29160@leon.nu>
References: <20160502195502.GA31800@phlsvsds.ph.intel.com>
 <20160503162457.GB29160@leon.nu>
 <20160503165403.GA11903@phlsvsds.ph.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="0vzXIDBeUiKkjNJl"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160503165403.GA11903-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--0vzXIDBeUiKkjNJl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 03, 2016 at 12:54:05PM -0400, Dennis Dalessandro wrote:
> On Tue, May 03, 2016 at 07:24:57PM +0300, Leon Romanovsky wrote:
> >On Mon, May 02, 2016 at 03:55:02PM -0400, Dennis Dalessandro wrote:
> >>We also should be able to use any of these schemes to handle our eprom
> >>reading/writing. Adding eprom to IPoIB as Doug suggested is a fine plan=
, but
> >>we technically don't need to do it right now when we could make do with=
 the
> >>"UI" functionality and hide the details in user space. In the future th=
ere
> >>may well be value in having an eprom capability in the rdma sub-system,=
 but
> >>for now we believe we can avoid extending the kernel in this regard.
> >
> >Just to understand better your RFC. Are you asking from the community
> >excuse do not implement core functionality just because you don't need
> >it? Am I right?
>=20
> The purpose of the RFC is to get the community's feedback on our plans to
> solve our UI/EPROM issue. The paragraphs [1] not snipped in your response
> focus on that. It comes down to:
>=20
> Use resource0 which does not support locking vs use a file in
> /sys/kernel/debug.

I didn't quote the whole email because I didn't see any question in
these 3 options:
* First option - doesn't meet the requirements and hard to extend.
* Second option - doesn't meet the requirements and HW limitations
* Third option - presented as one possible option and looks like the
  correct one.

And the real question is "where" do you need to implement third option.

>=20
> The point of the particular paragraph you are questioning is that I don't
> think we should add more code and complexity to the kernel for something
> that is not needed.
>=20
> [1] http://marc.info/?l=3Dlinux-rdma&m=3D146221891012428&w=3D2
>=20
> -Denny

--0vzXIDBeUiKkjNJl
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXKPEKAAoJEORje4g2clinhm4P/2dA5DFK7JI+32XnQ9vSJQMg
DK6rbI2CtpkELd3WG+yJ/dng44HyQuDx+HRDLzNEp0eTPvod87x0ShhYPrM+lkNf
1uuCk7b3GpPCVMwVFZfI4zD94PW77wwOzHI/5CVkI2rL25RhHCRYoy/BQUqU9UQL
skkq06AJgmz5SbIjo+12GthxZhzbfwOvtV3c10bgOOYixe+boEljNa75JMQYLAiM
cyvLM4G1Q+Nse/B9oDnK89XxkKPo7K3+Yb1GArcul+2gfiDRbrXyc/+1Bw0qQlLp
TLnWA8pQZ1S0DJuOOiCssDYuzP2I4dPO3EyJVDZLSUnoQEDiphJkk4fbuylUu0Cz
wWsAWPLYWeefHZvaIixMPxIYg8R07lXNH4Z4/dj5HEqlnQo9RFNYz15xVQujwwGh
DzqCPmyIMaJM6OPdPTauuTy3ypxDh91P1d/FBEKuZuQ1ewVYDNom854oTJ6gOYDo
iSTN2awC01gt/xvjK0/jQ3yi7Lqv6LnzDZHruF6WUUlozXVosFb5VSnv70oauCZa
iUtlQ6HDk7lIJdVlXz/pPgQyNmxdYLVgQMUtKGJvG737dZtNmgpSYOXhikHfKXEZ
/8/FCU+Q4JFhwT7LwM2GgqD9pnhDq72e8H/6Lu0HVc9lH39qy3GU0nzexrWDEp1R
0gfcJKfi28G7Br+J191y
=Pphi
-----END PGP SIGNATURE-----

--0vzXIDBeUiKkjNJl--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
