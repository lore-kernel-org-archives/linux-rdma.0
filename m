From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] infiniband: nes: return value of skb_linearize should
 be handled
Date: Wed, 14 Dec 2016 14:29:48 -0500
Message-ID: <a3cec1de-e6b2-6a57-ebb6-e74c688b9df7@redhat.com>
References: <1481095805-25010-1-git-send-email-zhouzhouyi@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="IQgFSMKhjdIGo6S9gLMfihsrTf75VIokD"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481095805-25010-1-git-send-email-zhouzhouyi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Zhouyi Zhou <zhouzhouyi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Zhouyi Zhou <yizhouzhou-6xnC4QlcT6v/PtFMR13I2A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--IQgFSMKhjdIGo6S9gLMfihsrTf75VIokD
Content-Type: multipart/mixed; boundary="I7OtAPjaE2EjbmgXcWqWSuLJgPlsIct62";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Zhouyi Zhou <zhouzhouyi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org,
 sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Zhouyi Zhou <yizhouzhou-6xnC4QlcT6v/PtFMR13I2A@public.gmane.org>
Message-ID: <a3cec1de-e6b2-6a57-ebb6-e74c688b9df7-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/1] infiniband: nes: return value of skb_linearize should
 be handled
References: <1481095805-25010-1-git-send-email-zhouzhouyi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1481095805-25010-1-git-send-email-zhouzhouyi-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--I7OtAPjaE2EjbmgXcWqWSuLJgPlsIct62
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 12/7/2016 2:30 AM, Zhouyi Zhou wrote:
> Return value of skb_linearize should be handled in function=20
> nes_netdev_start_xmit.
>=20
> Compiled in x86_64
> Signed-off-by: Zhouyi Zhou <yizhouzhou-6xnC4QlcT6v/PtFMR13I2A@public.gmane.org>
> Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>=20
> Reviewed-by: Eric Dumazet <eric.dumazet-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--I7OtAPjaE2EjbmgXcWqWSuLJgPlsIct62--

--IQgFSMKhjdIGo6S9gLMfihsrTf75VIokD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUZ2sAAoJELgmozMOVy/d73wP/R76/dVbkbnKlaBPixNZ/ks+
qVwwfpEEiuWT5hYa8jhYlvAAhkeXmRmjJ+/7fMAo0RLaXiwsbhaMvM/9I7F5I+s7
m57nbV2e49mH/GK65XEfbuIQVLm2C5ib9/v+U4nIDuFsp6IM8RiK39ceFKcmRXhu
we+LrmuWdq33iMH+vdkIyfuVdRWEj1WOR1qjN+453ptb2yt8Q57zh5v0DyyhB51U
sNXKldGV3ayP9HJZGn11f8pY5xVRqI4ikSZLBWp7cFDLEcdYkIojnvZlrIfShZrL
LI6k+cttioAjsI0qO9wfQttVj0edw9vdQhKKMvSO6cIsErUwk/LBlLNoH/kJ2RBw
iiCy3OjNxgQLJOMNGngzCMl271ITUXHBbMeZiPqleQHSdQ5rZzFAc53urTGPlsd6
4XyEmU49d7yyVElxFQaAovWQ8NQ0ocp40P71ARKRt28v3WZ3mHlkaFTwJ93KfxfB
4jK3kpHB4IosxpN8Q1ELjge9QH6AKTn7/nVOgmWim1dCdGmYYzz4K/idk2o6Ne+l
tDG3CkVje7BfxlFC9dv12r/DruYmw8aPl2yHrRKFNwbX/h8hCAnKKeYE4aj4Z+Yp
1JiZ2v4q1lPR3uZuMtHa/X0KyHiZOk163nXOnVVz+rAXrFK/WQmaJyZMe0nT+jYE
28GP5W+HIVvOavW4pKyR
=EMQv
-----END PGP SIGNATURE-----

--IQgFSMKhjdIGo6S9gLMfihsrTf75VIokD--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
