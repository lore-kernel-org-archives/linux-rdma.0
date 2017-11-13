From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v2 4/8] IB/srpt: Change default behavior from using SRQ
 to using RC
Date: Mon, 13 Nov 2017 14:56:22 -0500
Message-ID: <1510602982.3735.27.camel@redhat.com>
References: <20171011172729.16984-1-bart.vanassche@wdc.com>
         <20171011172729.16984-5-bart.vanassche@wdc.com>
         <32E1700B9017364D9B60AED9960492BC6266931A@fmsmsx120.amr.corp.intel.com>
         <1509658914.2484.21.camel@wdc.com>
         <32E1700B9017364D9B60AED9960492BC6266E41A@fmsmsx120.amr.corp.intel.com>
         <1509725458.2473.23.camel@wdc.com>
          <32E1700B9017364D9B60AED9960492BC626708EE@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-XMCOTfOU48y83GsWBhAX"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <32E1700B9017364D9B60AED9960492BC626708EE-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-XMCOTfOU48y83GsWBhAX
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2017-11-03 at 19:53 +0000, Marciniszyn, Mike wrote:
> > I run run our more extensive tests.
> >=20
>=20
> Our more extensive tests have passed.
>=20
> I wonder if it is better to squash the move of the post receives with thi=
s patch to insure it bisects.
>=20
> Fixing up the fallback stuff can certainly be additional patches.
>=20
> Doug?

Sorry, the original patch has already been pushed to k.o, so it's in
stone at this point.  The break in bisectability is less egregious than
the break caused by a rebase of that code.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-XMCOTfOU48y83GsWBhAX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAloJ+OYACgkQuCajMw5X
L93zbA//Ygo1ST+/96v1cm7jPU8o2asmuL/k5o+NxGgjSMXcr/ESpCd266th/ua5
6jnZce+ZIGNZJedYgr/LHzmsNqsm7H5GEBuCZZ6vyhAnOuAxF7W7SKs6IdW/RbV5
ij1QfTxQSkW7NWUr61AlJ29zMTycmXPMhFM7p/YCp+Xdh0XIL3WoXJdxE9nLk1N0
WE3wdCcaOXTj+OS2uijoRVnliYZHkQNyl+SxfLYPKAT+4Q0z29KTvPwq+7gmOdFp
9ZvWo3YRkWsbQZx//XjWLhbyhltXybA1f3L59q7Rs0dJwHBX4TOLoWvMww2e8HRV
c5gemZmBR74/t7cs13A5aCqyC+btGQkmAi7ENngeWnV88WaJQtMDS2WcpCgqycoO
88ks5tzm3fpuRjNkKkTDWdeO40gjrvojCUQWeQQftoops476kPfZS6gyOqSF2Lvj
b2pJEpxtp2i4dZQiQ3lZQBuAlzhF0AGq400gykBR1qK7jzzlEO2E/RcJZLMDGQGY
xf3J0cieLqBemu3K7v7g+wQW7ATq+lUsLCZwmryeoNqeaSKLn2bi8qcthQpn3f7D
hAmwA/L79uu5RAiwtiFzR6jj/PFuGlZVEz5O0LYFJvLUriKSWRQ/LH7AAnubKodI
dHqUeqApfiQXkJF5E3g1gWQzjtgoX867ZS79yYZHdxo9lgRxPDY=
=8GyK
-----END PGP SIGNATURE-----

--=-XMCOTfOU48y83GsWBhAX--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
