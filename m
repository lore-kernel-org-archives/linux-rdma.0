From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Back from PTO
Date: Mon, 18 Jan 2016 16:22:57 -0500
Message-ID: <569D57B1.2060205@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="FlGgXBCrpdjpqUMsHcpXAB8dLX8CwbojT"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--FlGgXBCrpdjpqUMsHcpXAB8dLX8CwbojT
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

As people know, I've had some paternity leave here as of late.  Then
there was the annual shutdown at Red Hat for the holidays, and then I
had some PTO on the back end of that.  As a result, I've been absent for
a while.  I don't like to pre-announce these things on public mailing
lists (nothing like telling the whole world when you will be away from
home to make you feel safe about your home while you're gone), but I
don't mind letting people know where I've been now that I'm back.

Obviously I'm behind.  I'm going to send in a pull request shortly with
the things that I had before I left on break.  I didn't get everything
into my for-next tag that I wanted to before I left on break, so I
expect there will be a second pull request that includes at least a
couple larger items I was working on when I left that should be about
the same now as they were before:

RoCEv2 support
mlx5 RoCE support
mlx4 RoCEv2 support
rdmavt
qib->rdmavt changes

Things that I intended to submit after the merge window opened and
Greg's merge was done:

Retake staging/rdma
Delete staging/rdma/{amso1100,ehca,ipath}
hfi1->rdmavt changes
Add staging/rdma/soft-rxe

Along the way, I may pick up some other commits too.  If you haven't
seen your desired commit(s) that you think should make it into 4.5 (like
the [v2] IB/core: sysfs.c: Fix PerfMgt ClassPortInfo handling patch that
isn't in yet but needs to be), please send me an email *offlist* (this
is important for my mail filtering that the list not be in the to/cc
address, you can bcc if you want) and include a link to the patch or
patches, preferably as a link to the latest version in patchworks versus
say a link to a mailing list archive of the submission email.

Thanks!

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--FlGgXBCrpdjpqUMsHcpXAB8dLX8CwbojT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWnVexAAoJELgmozMOVy/duT8P/1xPWLjmsu/9v5hgzH0WVyqh
Irnj33NH2PeSv8mBz0HrLQBS42CCVfWyO2m/pBp4jc4EvzmxE9VBtM6Ga6UpTXxH
HcsM3nXgc9u+MQWmOJ/5MAjzzmfLV8ovPlVzIMQPd9ONaWPSGzIHgFb3+6bIEwwf
8zWTczHqM2ha8ov1xU6qeYcELJNp5CqzFDzq5vT1TPw81opzY7X7S5oxTCbwu+jA
152wV2UL5H45qAh2pKcuBgbLLFtCwYGVqW9a+AgL/rvT8L/mM9/hsjhwvOKpzFBK
G11/X6DUpwZmFH11rez1KyHbSndy+hpvdODOhxjyXyOMeQwzhsIboI/JKTig5nae
wTkjBNUA/f9f8Fxs4V4sgpzxJil0ZcDa0E4w/63OkNGq/f0QQSXPJaKg9t0Vv+gC
E+DtbhTfmeTBRtD54ZhOBwn2umuBMoqK/poqRaBD+hLdl90+4xlPZSARVE24JUYs
uQoDy+VjX9BQRH4rLV6oQ512Xjerzf8XGySxsxJSmtvT9B5IvL5dNEHGItEB/vOF
LZ9slLRRGuJjINYwTm6hQzzuHu1I4LnCz7CsSpcKQCYvg5SXBxD7NuHJixp3Ha5b
qMR4wPa3y3A91/dBu4TF2yCQQNTLeE2nFwnAe00RtBw5hTYfeVETmGyRODJtbiQJ
sDPlodNHhhZgO/cVN2yB
=0tkv
-----END PGP SIGNATURE-----

--FlGgXBCrpdjpqUMsHcpXAB8dLX8CwbojT--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
