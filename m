From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] IB/iser: fix connection teardown race condition
Date: Thu, 1 Jun 2017 23:57:27 +0300
Message-ID: <20170601205727.GW5406@mtr-leonro.local>
References: <1495113381-15564-1-git-send-email-vladimirn@mellanox.com>
 <1495113381-15564-2-git-send-email-vladimirn@mellanox.com>
 <18c0959d-af48-6db6-68df-ebbe2ef68731@intel.com>
 <20170519034836.GF3616@mtr-leonro.local>
 <1496348542.7171.53.camel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="qgEfXXHyyarqcYJd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1496348542.7171.53.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Vladimir Neyelov <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--qgEfXXHyyarqcYJd
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 01, 2017 at 04:22:22PM -0400, Doug Ledford wrote:
> On Fri, 2017-05-19 at 06:48 +0300, Leon Romanovsky wrote:
> > On Thu, May 18, 2017 at 04:12:33PM -0400, Dennis Dalessandro wrote:
> > >
> > > On 5/18/2017 9:16 AM, Vladimir Neyelov wrote:
> > > >
> > > > From: root <vladimirn-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> > >
> > > root? Might want to check your git config.
> >
> > It is not the only one issue, I counted 6 violations of our internal
> > policy/guidelines.
>
> Is Mellanox planning to address the internal policy issues and
> resubmit, or do you want me to munge out the root entry and take this
> patch as it is?

Doug,

I resubmitted it a long time ago. It was already reviewed by Sagi and Max.
https://patchwork.kernel.org/patch/9739179/

Thanks

>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> =A0 =A0 GPG KeyID: B826A3330E572FDD
> =A0 =A0
> Key fingerprint =3D AE6B 1BDA 122B 23B4 265B =A01274 B826 A333 0E57 2FDD
>

--qgEfXXHyyarqcYJd
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlkwf7YACgkQ5GN7iDZy
WKcAThAAtn5rGXihFofuwjC+AmnCNwcTsVHsEUEt9DeVoIB8/m/FOQfKU4NeCJ94
mIcv8MOlozRbh4nSJXbH+zi7r6nKPF9msFtS7buEL9CVUJoyCY1UzZMgZExhkHAq
BSUReRCvRadGz4xxWlkFtZq5RvpoZ5/IcSMv8ZQgb1fQ0T69SSwRjSDlEGGrKrTl
ehiqe0OgaAC7mvuvcJHB7+DMhMI07S7WNq3jjk/RAAYvFbyTl/dzotmoiODjC2RQ
15nqXtlZZHTo9WeYprgFpG2dvwxazAS5CKnBzRVApUkf3DRxPhRH8S86NpvoZ3Iv
S9Xk8WgU6SLa/Jw40epKHpFKdjWOSgGcVBU1qrL6pmtdwTH99RFmmj74qTMZ+bR1
iufdyU1V+lxY4xkzXdxBvAkuOz7hRn4Z/jVXL6JoPoNJ4TLwRNeNXvAjKjk7H8mF
8fBH9d/+0rE6ndAz4ObgQpXXv5wLQ7xvRmU2u9hIp9U3CisDZqcaia4IhH8JrBLQ
fCuXpzyVj8BrtKtKjwpdg36BLnbs46I5+d5bvhSTff1PmTF6TZ9QqdOe5vLIA/qz
D/6zUtcdYIHBSZfF31KBYJd3cmEENtKQYBygBUhSxoouVlqbta1HboQzhTu72Hoq
g1XuFomO+coK11P/viaYzB3tUwCec+ECLuByY7+yMR30/U4D+qQ=
=z9XY
-----END PGP SIGNATURE-----

--qgEfXXHyyarqcYJd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
