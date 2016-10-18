From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: =?utf-8?B?44CQRm9yIGhlbHDjgJEgc29t?= =?utf-8?Q?e?= tips for
 upstream the userspace driver code of hns_roce
Date: Tue, 18 Oct 2016 08:03:49 +0300
Message-ID: <20161018050349.GE25013@leon.nu>
References: <57FF414A.3000200@huawei.com>
 <20161013093659.GA9282@leon.nu>
 <5804B615.2010002@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Ns7jmDPpOpCD+GE/"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5804B615.2010002-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Linuxarm <linuxarm-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Ns7jmDPpOpCD+GE/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 17, 2016 at 07:29:25PM +0800, oulijun wrote:
> =E5=9C=A8 2016/10/13 17:36, Leon Romanovsky =E5=86=99=E9=81=93:
> > On Thu, Oct 13, 2016 at 04:09:46PM +0800, oulijun wrote:
> >> Hi, Doug Ledford
> >>    Now, I am preparing for upstreaming the userspace driver code of hn=
s_roce.  But, we have
> >> some difficulty how to upstream it. for example,
> >>    i) which branch of ofed should we upstream ?
> >>    ii) if want to upstream the userspace driver of hns_roce successful=
ly, how we should do?
> >>
> >>   Can you give me some guides?
> >
> > Hi Lijun,
> >
> > Our main library for all user-space stack is located at github [1].
> > Please see similar question from Ram [2] and Jason's response [3] to it.
> >
> > [1] github.com/linux-rdma/rdma-core
> > [2[ http://marc.info/?l=3Dlinux-rdma&m=3D147574131706820&w=3D2
> > [3] http://marc.info/?l=3Dlinux-rdma&m=3D147577168016989&w=3D2
> >
> > Thanks.
> >
> >>
> >> thanks
> >> Lijun Ou
> >>
> Hi, leon
>   if i will upstream the patch for user-space code, how to guarantee the =
code format satisfied the rdma-core.git?
> As is known to all, the kernel driver code will be checked by checkpatch.=
pl,  the rdma-core.git also use the
> checkpatch.pl script?

There is no strict enforcement for specific coding style in this
package and we don't have checkpatch-like utility for rdma-core.

I would be happy to see kernel coding style in this repository, but
won't prevent acceptance for code which is written in other adequate style
(constant across new code and clear to read).

It can be changed in the future, once we decide to unify coding style in
rdma-core, but we are not there yet.

>
> thanks
>
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-rdma" =
in
> >> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

--Ns7jmDPpOpCD+GE/
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYBa01AAoJEORje4g2clinkesQAKHex7IA1/tNxJ/eg4ZPPjIP
yBGPByi+v9/pt29CWlvbfqfBN8Qq2vAdZcTFIOcjfW4TObSH2gW0tIi+CKSx/6N0
41s5/Uj6nRpMzG/0N+k5GtJtVFWuaCjCy5Pj9u1enK9LoDN3q0Bltua3VyGiuiOi
r6d8iviVhkYHdHe8zzR1J+CXUFDAeEFvEKYP8JP48E9gbFIs7W7jipaSMZagSYDC
e2mn4gRLdKF5/B4HlcECp86AhBctvqkwiQHnqAhk9ZMb+UPr9Jjh0sx8cvSlJm2t
Gpwdk98uzjlaII7FyqgJxkbq3wZ2j2m1/trC2CuNKdavqfugnePjIznIeM1ZZF58
dGTpD7s2iYyOuiPv9q9l6ZrVvIT1+u9/i1QkigPhPhSdIZBZcmr5d3IJ5xSCTv1v
77KjCcrQVfAiXugRbkro6p2n4WWmZQXrR5Dy9lapGIFtwfXhwR9x7ZFqGzjhQBV4
X6ocheOfu/FSQ7b1GSJaGagV+JgrAHbykMXnm0p31clIMSjjwZSIn0HaBoLMe4HK
taMuSJIGDvKOLWw4BQCSL6FOTu08TYxETIGFhMKQwy3TP4GX2NaGBbCoAlV0AWZf
9O6yXA5LpatxhYX0g9HEslPQboXBUoHPof0T9GfdtQG3ZdqUfxzWKmbxUeyNvhRK
bpn8xdcpTbeT13xjp5qN
=CJ3l
-----END PGP SIGNATURE-----

--Ns7jmDPpOpCD+GE/--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
