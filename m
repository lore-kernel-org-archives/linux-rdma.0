From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/srpt: Accept GUIDs as port names
Date: Tue, 24 Jan 2017 16:37:11 -0500
Message-ID: <1485293831.43764.89.camel@redhat.com>
References: <1b20f44a-0378-7b53-65bd-e079e9fa87ff@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-Dc6Qq/XwydCTlmXHSfpr"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1b20f44a-0378-7b53-65bd-e079e9fa87ff-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-Dc6Qq/XwydCTlmXHSfpr
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2016-12-09 at 11:00 -0800, Bart Van Assche wrote:
> Port and ACL information must be configured before an initiator
> logs in.=C2=A0=C2=A0Make it possible to configure this information before
> a subnet prefix has been assigned to a port by not only accepting
> GIDs as target port and initiator port names but by also accepting
> port GUIDs.
>=20
> Add a 'priv' member to struct se_wwn to allow target drivers to
> associate their own data with struct se_wwn.
>=20
> Reported-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> References: http://www.spinics.net/lists/linux-rdma/msg39505.html
> Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>

Ping? =C2=A0Do the target folks have any input on this patch? =C2=A0I'd lik=
e to
take it for 4.11 as it should resolve an issue we see regularly in our
test lab...

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
=C2=A0 =C2=A0 GPG KeyID: B826A3330E572FDD
=C2=A0 =C2=A0
Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =C2=A01274 B826 A333 0E57 2FDD

--=-Dc6Qq/XwydCTlmXHSfpr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJYh8kHAAoJELgmozMOVy/dfTQP/Rcal2vhsv3kpXsCwj6sAovb
sIUisPv66sZwy+W/AoP7vtBrzLVKAoxOr8Ez+W42gi1SMaKeXL0SqLeU72VyrRve
A+t7w3hLLt4lwUNgMq+VpRfa0mwZvrXMu2KSpTIJwCACMnCmejf+t7kw6Uik2wCN
i85jcKZSCLrirPLkdCfGgBzpuJAdv8XmikRU/eYFHhKf30GD056xPekmThFltWVx
aJZpz+V3in7B0MDC3AymK6Jlx829lUa/L4KyPy4SJt6hxPFIh69hjr1cZGA2qJfP
JeOnlHE3HzUMFXoZN4ayqY4P8EXhgdU9PBu757f7IHvd+6VbFHiiVRjX9A1Qrhxp
pKHLl68eB/S8JjiPVVB1KSzIjV4DZ5Hm3jiN6gFuls97tTpwxnEJtVcPf5PnlVfn
tdStHeowEwzW2ifESWlZvqDmu5WTnj7Kb/xwVyGA79W09pH+Ci0yOvrqhfy40Hmk
YDkmG2LzEAe/cwZwFGqq89geCGtlGbSSiLtWr0YYSvrvLc/70omW1upKMnQgdwRY
69qm+tK0KtsCSbiem7ia5j7BjjtPerpRIMBeMYD5CXY9P+rxbkaMxXZ2mGoYgvT+
OwGfHH7xGSbDgVFWJqRdMOnaYraO4aF0BbMPyTJ3SEl3XDp9QejeS3tp1uJG5K05
aTSebOEAc7NSbuLrG3NO
=4N2b
-----END PGP SIGNATURE-----

--=-Dc6Qq/XwydCTlmXHSfpr--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
