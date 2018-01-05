From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 02/11] IB/hfi1: Check return value of strchr
 before using it
Date: Fri, 05 Jan 2018 12:39:10 -0500
Message-ID: <1515173950.3403.13.camel@redhat.com>
References: <20171219034753.2126.78386.stgit@scvm10.sc.intel.com>
         <20171219035621.2126.23093.stgit@scvm10.sc.intel.com>
         <20171220082555.GN2942@mtr-leonro.local>
         <f5849e2b-c8cd-b93b-f32f-f423bff9ae31@intel.com>
         <20180103152721.GT10145@mtr-leonro.local>
         <4555c08f-a568-48ea-e183-2d49ebd36c7c@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-+48TgeS/7srE8fu2kJ3J"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4555c08f-a568-48ea-e183-2d49ebd36c7c-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: jgg-uk2M96/98Pc@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Michael J. Ruhl" <michael.j.ruhl-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-+48TgeS/7srE8fu2kJ3J
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2018-01-03 at 10:42 -0500, Dennis Dalessandro wrote:
> On 1/3/2018 10:27 AM, Leon Romanovsky wrote:
> > On Wed, Jan 03, 2018 at 10:05:56AM -0500, Dennis Dalessandro wrote:
> > > On 12/20/2017 3:25 AM, Leon Romanovsky wrote:
> > > > On Mon, Dec 18, 2017 at 07:56:23PM -0800, Dennis Dalessandro wrote:
> > > > > The call to strchr in our counter initialization does not check t=
he return
> > > > > value before attempting to use the pointer. In theory this should=
 not
> > > > > happen given the way the code is structured but do the smart thin=
g and
> > > > > check the value anyway to harden the code.
> > > >=20
> > > > The smartest way is to get rid of the whole "\n"<->"\0" logic and
> > > > copy/paste mlx5 implementation which does the same thing but static=
ally
> > > > and much safer than here.
> > > >=20
> > > > Thanks
> > > >=20
> > >=20
> > > Not sure I'd agree. Is there something unsafe about the code here? Th=
e hole
> > > is plugged. Changing the entire implementation for a copy/paste job d=
oesn't
> > > seem like a good thing to me.
> >=20
> > The names are static and can't be changed. IMHO, the whole
> > implementation is overkill.
>=20
> Now that I do agree with. It is certainly an area that needs improved upo=
n.

As there is a better solution on the table, and, as you point out in the
original patch, this shouldn't happen, I'm dropping this patch and will
wait for the better solution to come along.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-+48TgeS/7srE8fu2kJ3J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpPuD4ACgkQuCajMw5X
L92B+BAAuzlN9pzMhtHxGQN9D6tB8hUb11HX/cPCdD8KV8VpSBa4M37ujilYD7pO
nXt4z6+F4YvkOjmxWj4DYQQmfdFmFuNEfCI92azk4xH0yWhKKOEDY9Hkc/Bje6vt
sAVDi3MFSUNDNKPUIUOiyE9PKjjGX3UBSB7Hsc6YGoKx9/hjXWf8R32az7i6BCnz
Icq/Na7H0fMkrhK3lV1V5Kc06GDV1DS1fdudtwudjFWTDUzluPdS9VJnwLnFx39Z
p+jzy1zZ05jDFWCs5tPi8eK0I6LtTa/MjsV+tEbqnhKuTNyt+x+umIuJt7OB/nri
1fhkJhjkRvo00fF8gZZbGSdeuPanwAAmcpf8BZZBA8QmlzGzB5K2sslanBQuOCvx
QdSv9pT0jJe7Fs+OVINzp7QKIh3CsRwSKmhsQPOm35l4iV+5ONsVihQKAWs0fwMz
EWlDjsl4hPrCKwJcWB8DDbCksrsO2rDLBqsCqAE3JCAcA0wO9cvqOzr2eC/Wzpfp
mdKZCaXxovHuXsVAYlJuR/FQto1DPtpXGZHv1W91+27aPAiGgjjmOnfID9gCVAhi
zJnnanzCZQ/0aAtnGtwzj1Hoxh/8O7LyoxqAqNtM2caaAFd3rlmT8n2PWcFnakzq
EdeK8PBSV0MvO4ckqm6x5MrQvr42GhiOhvFOqv0sXH0iMbOs990=
=fh+V
-----END PGP SIGNATURE-----

--=-+48TgeS/7srE8fu2kJ3J--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
