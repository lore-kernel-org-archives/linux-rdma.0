From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 00/14] IB/srpt: Add RDMA/CM support
Date: Tue, 30 Jan 2018 12:43:26 -0500
Message-ID: <1517334206.27592.291.camel@redhat.com>
References: <20180117001418.7852-1-bart.vanassche@wdc.com>
         <1516230870.3403.292.camel@redhat.com> <1517271807.2687.65.camel@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-HxMtumO1V/Ocmdf/3iJR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1517271807.2687.65.camel-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-HxMtumO1V/Ocmdf/3iJR
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2018-01-30 at 00:23 +0000, Bart Van Assche wrote:
> On Wed, 2018-01-17 at 18:14 -0500, Doug Ledford wrote:
> > On Tue, 2018-01-16 at 16:14 -0800, Bart Van Assche wrote:
> > > Hello Jason and Doug,
> > >=20
> > > This patch series not only adds RDMA/CM support to the SRP target dri=
ver but
> > > also fixes a number of race conditions in that driver.
> > >=20
> > > The RDMA/CM listener port number has to be specified as an ib_srpt ke=
rnel
> > > module parameter. The default value for that parameter is zero which =
means
> > > that RDMA/CM support is disabled.
> >=20
> > Since srpt is already configured via the lIO framework, wouldn't that b=
e
> > a better place for the listen port?  In fact, shouldn't it be part of a
> > portal like you have for iSERt?
>=20
> Wouldn't that be overkill to have one listen port per RDMA port? I think
> it will be easier for users if they have to configure the RDMA/CM port on=
ce
> instead of one time per RDMA port. How about using the following location=
 in
> configfs for the RDMA/CM port:
>=20
> /sys/kernel/config/target/srpt/discovery_auth/rdma_cm_port

Hmmm...maybe the real answer here is to start considering how serious we
are about the RDMA_CM support in SRP.  If we're serious, should someone
contact IANNA about a reserving port number and just use whatever they
give us?  If we want to do the simple thing, a module option is fine,
while we decide on this issue, then I can see that being OK.  I'm more
OK with using configfs if there's a chance we won't get a well known
reserved port and the config option will stick around long term.  And I
tend to agree, per interface port configuration is probably not that
interesting.  But the ability to specify something other than the
wildcard IP address to listen on, and the ability to specify more than
one IP address to listen on, are.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-HxMtumO1V/Ocmdf/3iJR
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpwrr4ACgkQuCajMw5X
L91XYg/+J9esqZXRNU7G0yeCMsEKnmEf9EXhDr+PocZmwN27/jmNptG5g0Rz2RIp
Ot206bWuXaGOWndwsi0lxS3FqbmasZ6SkUwmj56udY81eZXRBxbYkrvnoBDAfjkO
Az7uftthBKFw9Ij7e3hfOGQ8CpyNmE10MVQrs2JNQhWUSG1YvU4rTGWaD+Kr30Al
1xCoQLomtIpBlBGQSvH1/nnOgGEjbLogtuE6FpseziAgh4dq6WnYV2NM7Huya52N
ayo2vpsbAWaLa5TpcX5GL6/O0UUv1yW8YxQI3xjXf1+EvVqcBHehjpluOjZL6lmy
nIW5DGUui2U3eZ7wPe+UnNQC8Dw3pdwegamyDKuicW4lDrUD2WObHouedd0hJUfZ
mDJLmbSSAE5EWI0rmv//QG1sWC5m6stRSoHRDK6Wr8UlVZW1FRA0Wggpqmtf+hYo
OhpAHACHMoxMDpDR/g7449VEqya43/tvhNVRqPKhSkxwkNY/dfPYqvwZ6F2VK5UH
s89UXq69XinoqXKIHRg6nk9NZfO3eFvLHBjss9vllUfHlOz9VIG9tIjonOJvfpCd
fqvNAjSwwOsa0SmGF8ppAeMLCEvMbNvNDBJhvuwF3Pu0CcPALFz2+AJc2BBH8qSS
Uhzp5TCHQS82/w0I9JNPSVUmsMvO3Hs559u9z2lohWTl0UToar8=
=T1U9
-----END PGP SIGNATURE-----

--=-HxMtumO1V/Ocmdf/3iJR--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
