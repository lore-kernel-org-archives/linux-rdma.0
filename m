From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [RFC] Proposal to address hfi1 UI and EPROM devices
Date: Tue, 3 May 2016 19:24:57 +0300
Message-ID: <20160503162457.GB29160@leon.nu>
References: <20160502195502.GA31800@phlsvsds.ph.intel.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cvVnyQ+4j833TQvp"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160502195502.GA31800-W4f6Xiosr+yv7QzWx2u06xL4W9x8LtSr@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--cvVnyQ+4j833TQvp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 02, 2016 at 03:55:02PM -0400, Dennis Dalessandro wrote:
> We also should be able to use any of these schemes to handle our eprom
> reading/writing. Adding eprom to IPoIB as Doug suggested is a fine plan, =
but
> we technically don't need to do it right now when we could make do with t=
he
> "UI" functionality and hide the details in user space. In the future there
> may well be value in having an eprom capability in the rdma sub-system, b=
ut
> for now we believe we can avoid extending the kernel in this regard.

Just to understand better your RFC. Are you asking from the community
excuse do not implement core functionality just because you don't need
it? Am I right?

Thanks

>=20
> -Denny
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--cvVnyQ+4j833TQvp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXKNDZAAoJEORje4g2clinbQEQALeD1A8eFFrv6S5Rm7gLZylj
aLhBXY2e4Lerzmm6vAGm2mN/yoyWCUbkB5oGaeOUtG+BkrLaV/1droYoW3ilKszo
a/tHPzoUfa6ALJNcSoECFKANmUHMcybNBHUiCouhJpWfC5JOjc3FlH3QiAdzPaF5
aS5jPHNUJo5/Ud09mnOYJzJy9HrIFY+BX2aTQ+ypsaY49RbIQuvVGvXGmAOhtBob
jrWZ5GIEMg+UCHSmDn6k5XnL+/jjTTev0dPPhbd9QE1hLmfeeoXGzALjWTC86BJT
7BXRY+ma+MGU2LNKsV646yHQPCANptLvtc2mC/PvdixfPa6eLiSRxR4GL7cupHSZ
/aftFejQaB5kX3JfaaZAw54EtlAr5h8fuDco2sRfq/mjAHzJB+Yub4Mt6Us7M54B
VqTvE1LxadVtGBedRO0T7uqcMalfgTsI3G++oYN/LiFKlvMtfIRavoaWHZ6EpMZq
GhOvygiazwSs+PEgUsRYaLQISFr9zCD71zfAGj4f2JaoTyabiByafp0YXNJiYsxO
2D86pGh58GSKGarKuZPW9n+N2U8q22++tc2BaUwzVW1wA7lN10dG25u0+e4Unp1T
VWIDa3Ge2Wl959Nh/w0MGwfWJdKqsDJrj+fR9nYAXSyiFVN0czPaPsK5aBHD/AIe
PjtSPNQcShaAq5T6QlGH
=ApTj
-----END PGP SIGNATURE-----

--cvVnyQ+4j833TQvp--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
