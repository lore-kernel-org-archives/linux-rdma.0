From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] librdmacm: Remove unneeded condition
Date: Sun, 5 Nov 2017 09:26:58 +0200
Message-ID: <20171105072657.GF31774@mtr-leonro.local>
References: <20171102135134.5728-1-yuval.shaia@oracle.com>
 <1509635426.2484.9.camel@wdc.com>
 <20171102164528.GM18874@ziepe.ca>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="YToU2i3Vx8H2dn7O"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171102164528.GM18874-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org" <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org" <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--YToU2i3Vx8H2dn7O
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Nov 02, 2017 at 10:45:28AM -0600, Jason Gunthorpe wrote:
> On Thu, Nov 02, 2017 at 03:10:27PM +0000, Bart Van Assche wrote:
> > On Thu, 2017-11-02 at 15:51 +0200, Yuval Shaia wrote:
> > > The check makes no difference - remove it.
> >
> > Shouldn't the description have been "Passing zero as third argument to
> > memcpy() is allowed so the if-test is not necessary. Hence leave it out"?
>
> +1

Yuval ?

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--YToU2i3Vx8H2dn7O
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAln+vUEACgkQ5GN7iDZy
WKdEog//U8RfW80De9/5CLWd/+sXPiclKXn2PRmdbiSD4DpLQc3Nt7+fMxLsTSZ/
x9vUFAcafxrDbtTkqbJjTsIUmTjTpk434/sZTyCms/dCP0qELQ+CgjoGknjTGQPa
FAdDrCTCrEiMZKfCADNXsHHUu1Gkkx1nyKAVFSR5Ws5FMVDV03INR+e+/v2IkAff
G2RFv96qSlhoPN/E90LalpJXqh3FUmVDPiEUJeAXApM4yKUEwulfMbVukeczH2q/
MoD91BjSiCJJE+Y3FVPVBYM8tDgKQZdyRtKm1tBQMUZY1f/Rucny0KvUaSunsE9Y
2ON1yUOlVNcyYKVY6facLKFbaniwR3uPdqQ2IyczsiQk+MjEKEaW0sdvONt9/KpM
Y4fhY4X3UY/Y1fIAu/tCghBjZL68bTfxdoOH2p/pFc6ozYp9HCpFchZOsLUUs1mA
89pO8bzCsq0XiYu3BEb85UWQwDf1XEQOPf+XHpYoRfIt9+Z6T3gyV4HKxIJxux4U
Iw/ocep6LJIVQhuJpUGfXoPW3hAfFsQO06X2bplZItptBZVHnyb0edQ1aWIX1uqZ
VHLT3E+2GqjX1u71+qNl4AjKzDge87Y029k9E74K8+iZrXAsmj9OrcHUetwK3sMQ
U7+/z2EF60iGQpvx0c0S2iYkIpJwW8Nr1WB5pO/iqa4RJOYswJA=
=k3uC
-----END PGP SIGNATURE-----

--YToU2i3Vx8H2dn7O--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
