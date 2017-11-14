From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: rdma-core stable releases
Date: Tue, 14 Nov 2017 13:05:58 +0200
Message-ID: <20171114110558.GX18825@mtr-leonro.local>
References: <CY1PR0701MB2012C57AB3FDE0232D72F70688500@CY1PR0701MB2012.namprd07.prod.outlook.com>
 <20171106182756.GD18802@ziepe.ca>
 <6012d1c3-cd18-25e8-c5ae-3d678142177b@suse.de>
 <54347E5A035A054EAE9D05927FB467F9B61778A9@ORSMSX101.amr.corp.intel.com>
 <20171110202455.GP18825@mtr-leonro.local>
 <20171110211448.GF17451@ziepe.ca>
 <1eba9063-80a4-ad9d-4adf-93770b9ed7c9@suse.de>
 <20171113070856.GZ18825@mtr-leonro.local>
 <ab4f8a20-8b32-ff5d-cf82-97e69a660cce@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ggaE+NbZN3iv6/Hi"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <ab4f8a20-8b32-ff5d-cf82-97e69a660cce-l3A5Bk7waGM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Nicolas Morey-Chaisemartin <NMoreyChaisemartin-l3A5Bk7waGM@public.gmane.org>
Cc: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, "Davis, Arlin R" <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Rahman, Ameen" <Ameen.Rahman-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Radzi, Amit" <Amit.Radzi-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ggaE+NbZN3iv6/Hi
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 14, 2017 at 11:27:40AM +0100, Nicolas Morey-Chaisemartin wrote:
>
>
> Le 13/11/2017 =E0 08:08, Leon Romanovsky a =E9crit :
> > On Mon, Nov 13, 2017 at 08:01:48AM +0100, Nicolas Morey-Chaisemartin wr=
ote: >> >> >> Le 10/11/2017 =E0 22:14, Jason Gunthorpe a =E9crit : >>> On F=
ri, Nov 10, 2017 at 10:24:55PM +0200, Leon Romanovsky wrote: >>>> More or l=
ess, you wrote everything that I expected, just need to post it >>>> as a p=
atch so I can apply it to rdma-core. >>> Also please describe how to get pa=
tches into -stable, eg similar to >>> the kernel, mark with fixes and cc th=
e stable maintainer. >>> >>> There should also be absolutely no ABI changes=
 in the -stable branchs. >> >> Agreed. Ideally we would add something to CI=
 so that it detects ABI breake on stable branches. >> I know SUSE has somet=
hing like this for maintenance fixes. I'll look into it. > > DPDK runs ABI =
compliance checker. > http://ispras.linuxbase.org/index.php/ABI_compliance_=
checker > > I would love to see it running for rdma-core. > > Thanks >
> Got the scripts ready for this BUT the versions available in docker of ab=
i-dump/abi-compliance-checker are not compatible.
> As both are GPLv2, could I import them into buildlib ?

I'm not a lawyer,
Our dual license policy is relevant for source code and build scripts only.=
 The tools for our CI can be GPLv2-only.

Thanks

>
> Nicolas
>

--ggaE+NbZN3iv6/Hi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloKzhYACgkQ5GN7iDZy
WKdqcQ/9HdbRe3SEGcGX6F3nJs7YpaeDciv6BRdX9LpnaL1TULpSuq5QY9rjQIJ1
3lwciiv0qLWwFykHOjKxT5FwaXHDm8qj/StvgB+YKugQrPzxiVmbmP3uwnwYGwZh
A7KfRV24XmW/6rcaiOF2k5Ul0kf7uoWZbDAzJHZC2E9E+jdJfNImwq6ExxZwAd1E
7+zZYVXugwWPG9RvPUFGKae5ksZrfrwRjmf51xMIRd1mDa876ZiRUiLaIQYRM5tM
/hoOYfKkIdMPNnx+wcLZTHrIybDVwo2Hrvdo8Eu/Gfd1h40O8zWqx71W8iDIKY5H
uws1xxhJmts8vBNAf9WScM0efErHLGi+SJmS5HmzQSvgmdUkhjYFti7zImzzaVmc
eKNPNRZgshMjV0MzCDOm3tvd1WFWAoYKvaWQU+s19GHax1BGcv1joPNBHSwZdu9X
CTFgRuvAi7x9C4oOoXwjZxOfwBGLh5GZ/mRxD75Uig/dQerWX8T+oToZVTxaO1w2
tU1EDjdL+/B9JYEM9vKsjq+mOHpqWJCYSj5HtspYjkLEKtkMSiAhDo5b7zXI9ISn
XLR6KAPJB6fSQLpuLpxIwl4+MXT4Y4B3R3S61Ikd9z99qOjDaaa/h5fJSgPe6DCY
M+PdBeO1Klbd/f5H1SnCy9PqyItfjxu6rw4MzITW4EgN9oeMXUU=
=niSk
-----END PGP SIGNATURE-----

--ggaE+NbZN3iv6/Hi--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
