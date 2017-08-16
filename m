From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [rdma-next v2 07/23] RDMA/core: Remove unimplemented node_types
 and node transport
Date: Wed, 16 Aug 2017 21:53:45 +0300
Message-ID: <20170816185345.GZ24282@mtr-leonro.local>
References: <20170815085452.3546-1-leon@kernel.org>
 <20170815085452.3546-8-leon@kernel.org>
 <SN1PR0301MB2127376FC9B3D170C878A47BDE8D0@SN1PR0301MB2127.namprd03.prod.outlook.com>
 <20170816053744.GD24282@mtr-leonro.local>
 <SN1PR0301MB21274177B67EE02B96F14424DE820@SN1PR0301MB2127.namprd03.prod.outlook.com>
 <20170816162103.GT24282@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="gA19+fZe+9B2YWyg"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170816162103.GT24282-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Suri Shelvapille <suri-lFb5ksp6isWhEniVeURVKkEOCMrvLtNR@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--gA19+fZe+9B2YWyg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Aug 16, 2017 at 07:21:03PM +0300, Leon Romanovsky wrote:
> On Wed, Aug 16, 2017 at 02:30:05PM +0000, Suri Shelvapille wrote:
> > Leon:
> > Our Drivers are not in Kernel (being a small company we don't have resources to make it in-kernel). When I and Hal worked on adding the switch capability into the kernel, we thought it would be useful for the community (as there was interest in a few others besides us). Philosophically, since SWITCH and ROUTER definitions are part of the IB spec, don't you think having these definitions makes the kernel close to spec and hence useful? I know these definitions can be easily added into our drivers.
> > Just treat this as a request, if it is not an onus to the community, please keep the SWITCH and ROUTER (only) definitions. If you have strong reasons I have no objections to your patches.
>
> It looks like I need to explain the rationale why I did this patch.
>
> RDMAtool presents various information from the kernel, one of such info
> is the node_type. In order to correctly present it, I was asked to expose
> possible node_types through UAPI files.
>
> These files are done with extra care and my goal was to provide the minimal
> set and the most cleanest exposure, so I cleaned everything in those paths,
> from the lowest possible layer to highest possible layer.
>
> One of such cleanups were removal of node_types fields, which don't have
> in-kernel users and against software development principles - don't
> leave dead code.
>
> So for now, I'm leaving this patch as is.
>
> It is far below my lowest quality bar to leave those fields in place,
> but if members of RDMA community prefer to go such low, they should
> speak and explain publicly why RDMA subsystem is different from the
> rest of the kernel.

I found the elegant way how to code the RDMAtool without dependency on
those UAPI files. I'll post tomorrow morning new version of the tool,
and we will end with exposing of two enums only - rdma_dev_cap and
rdma_port_cap.

Thanks

>
> Thanks



--gA19+fZe+9B2YWyg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmUlLgACgkQ5GN7iDZy
WKfjNhAAy1emGKQ6XHGqfDck4HaNqYyqrgq5bSWiaVen85BTe21C+i1UX/CY/4Er
c52KYN5VscpbhETMzfi/chZDpUjli9hv8tSkhwiRTEb3XQ61lTfZggT9QCMlasoi
6AoBO20aDBaHeEfKsfN7oVCYwrO5DcISiBlNC3Xuo3Ce3QVWxwOznv7SWGJmlx66
R8K6wb6DTxKS7Sl6NAlrYZskMn011u0KTn0CeOLvIXFd1HUxNziY+LKy5iOsgOFF
VxOlXHcd8oPgW60G8+TfsqZBuDlHimMgp52JukWM1+M5s238P9f9GZTEo0pUo/cA
0vQPKAK98nBj0dk/kJ3Nw3Eeohz9PFjytnLng+GAgG8M8Ufi2LN3rc/BtF3oISkC
uCjPPuYGn8eTd+Bu5zfu2rGLGmso1RNTUE1msk7a4PjBYlGwCnVGhj265wNZUXdG
BbtbZqUDNgdHZuHcKaP+Uvy1CF7vQIcXA5U13MTJEENnpIv7onIS71B1ZFgilKON
avOYj/zxZ7syZSw+EqFxObDkjkSoqkr2FP61s4Cfn8SN+iaAZRBiXsQn9EiYY363
xUUPYVG2eqRvOmyVo4b7U2XuyyDYHMWDYAWJvH/Geppqx0JNPiRjeJAfn66BpzOa
vkH7j9Q7rAXSL74sWaerV8UyLGVNkIOFu0pcUoZxzzz08ypC3MA=
=MLuK
-----END PGP SIGNATURE-----

--gA19+fZe+9B2YWyg--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
