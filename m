From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH, resend 4/4] IB/srp: Add RDMA/CM support
Date: Fri, 05 Jan 2018 12:21:10 -0500
Message-ID: <1515172870.3403.11.camel@redhat.com>
References: <20180104222842.26756-1-bart.vanassche@wdc.com>
         <20180104222842.26756-5-bart.vanassche@wdc.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-rw6ljU0O4irCnl4KImu3"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180104222842.26756-5-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-rw6ljU0O4irCnl4KImu3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2018-01-04 at 14:28 -0800, Bart Van Assche wrote:
> Since the SRP_LOGIN_REQ defined in the SRP standard is larger than
> what fits in the RDMA/CM login request private data, introduce a new
> login request format for the RDMA/CM.

Ok up to here...

>  Add a kernel module parameter
> to the ib_srp kernel driver

Unless I missed it, there is no new ib_srp kernel module parameter here.
 Furthermore, if there were, I would probably think that was a bad idea.

>  that allows to specify the port on which
> to listen for RDMA/CM connections.

Obviously, a kernel module parameter for the listen port would be an
ib_srpt option, not an ib_srp option, so that makes sense why it's not
in the patch.  The commit log message needs updated.  But, a kernel
module parameter instead of a config file option for a listen port that
we set with the target infrastructure sounds wrong anyway.

>  The default value for this kernel
> module parameter is 0, which means not to listen for RDMA/CM
> connections.

Again, doesn't belong in this commit log.

>=20
> +static int srp_parse_in(struct sockaddr_storage *sa, const char *addr_po=
rt_str)
> +{
> +	char *addr =3D kstrdup(addr_port_str, GFP_KERNEL);
> +	char *port_str =3D addr;
> +	int ret;
> +
> +	if (!addr)
> +		return -ENOMEM;
> +	strsep(&port_str, ":");
> +	ret =3D inet_pton_with_scope(&init_net, AF_UNSPEC, addr, port_str, sa);
> +	kfree(addr);
> +	return ret;
> +}
> +
>=20

This particular function is problematic in that it adds new namespace
unaware code.  The namespace code in the RDMA stack is in a limbo state
of partially implemented, partially not.  I'm loathe to add any more
code that is not fully namespace aware as that just worsens the
hysteresis in the stack.  So we need to figure out how to do this in a
namespace aware manner.  I haven't previously been thinking about this
specific namespace issue, so I'm not prepared to even make suggestions
for a fix for this yet...

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD
--=-rw6ljU0O4irCnl4KImu3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEErmsb2hIrI7QmWxJ0uCajMw5XL90FAlpPtAYACgkQuCajMw5X
L93zYhAAkIRSy635PbonoizyvY7aSXk5Nriwlcq7BF09BZIPHqTWyZo1PC8jwoiC
YyELk9k7rcIFzaWtsWf5H2/CUnQ7xmxOsbixf8gH2rvaIZShfyr3KzbBjpUmgKtv
DPTYqWSzZ53hHSS4oyDwtQv4yf0pfuf6Ifn/LVSZsVIxd45r5a6dFRK7MF6NpGrN
ekgCZCvVpszvLHefzerTOG74R5jyeG+81Xqql0JO8JMFfN54id57w4nhi03/nyJE
ReTf9Lg3kuqTTxfGTgKxMC6In9PoUduD1F3tof9ld0Zybf32fRprwqMCyFde9eV8
r3Z/bhVhq2MJ/cS8D8URBDwXs7+u6Hj2Oexj67iKaIqnFhFX7jL3xFDkgepxYMgw
6LRC15zsbctxvXe35U5D1wUd09PZJexQOjkNMwq6/gRvHoy6UjO+XO4qwgxDVrWT
GW3i96uorG62+vzyj5qWBBkRsFyyA9pkVZGJsXU7moApKPzURlRpfPtHM2IpqWof
0Fc+IbYZdLm+TIMKwB/6wxdmYSvsNowKKMbIzE3kfJs4LhkXiQMfAxE5UlvYw3Ml
jm9fcLa+7vNV8hF+4wPA4wmyWD6/cBdhMKn854wyKz+5AQwIHI0p8RJQcO/QsjBI
s/1OTLtZm7tJXkte4yMuujgtrRVTNcrc9CBKmf9xl2UImrDc86Y=
=AJbL
-----END PGP SIGNATURE-----

--=-rw6ljU0O4irCnl4KImu3--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
