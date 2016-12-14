From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] qedr: Fix possible memory leak in qedr_create_qp()
Date: Wed, 14 Dec 2016 11:29:22 -0500
Message-ID: <eec69050-0690-1820-b12c-27346637e506@redhat.com>
References: <1477672427-31575-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="ggO1suAwIbeAAaiV6oIuB84bbXwOx8FTh"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477672427-31575-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--ggO1suAwIbeAAaiV6oIuB84bbXwOx8FTh
Content-Type: multipart/mixed; boundary="PTtQNxaE3rFPEKPM2MB62u4SIsjHGKTn5";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>,
 Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ram Amrani
 <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <eec69050-0690-1820-b12c-27346637e506-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] qedr: Fix possible memory leak in qedr_create_qp()
References: <1477672427-31575-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
In-Reply-To: <1477672427-31575-1-git-send-email-weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

--PTtQNxaE3rFPEKPM2MB62u4SIsjHGKTn5
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/28/2016 12:33 PM, Wei Yongjun wrote:
> From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
>=20
> 'qp' is malloced in qedr_create_qp() and should be freed before leaving=

> from the error handling cases, otherwise it will cause memory leak.
>=20
> Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

Thanks, applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--PTtQNxaE3rFPEKPM2MB62u4SIsjHGKTn5--

--ggO1suAwIbeAAaiV6oIuB84bbXwOx8FTh
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUXNiAAoJELgmozMOVy/dapIP/2I7YKlpamn7tYOsr+ScAbuS
85ofMmWO8A47gxjwich6F6qOfSjTLUBix75YFgdC+SVqpxP5QHlMc3joE6tP7cri
0YS0hWFWVZV9jxAo7haKZn79yaxs/lO2pv+MAcK1nf3P3Ds4+yO3F2Otk/qJSruW
5J4LI5aaYJnmpIdIMn5KMqZXR+vyYw01KgwgqJgVLCtf5BNXigXHvOjFnfltp9PT
7gdbP78scqqpVMRbBmJwM1Oe3UyDo9+tagBw2YeW2zZ7NAhbbhME53807cWtD+LA
qnNPhNB1Ra4rktLvbfmI0rJCisxhLrPEYAXrQ8swoFgnLM3lLNjF++DSfZjQi89I
TMXdyHPiQCmFgIo2sSZiH8X6vBRO+WIQIcjoD5gB2Pw7OkXVRfVAfEVDE3ggh3p8
7nYn4YTSdJ7Qi1yuibWLU6Q0o63Uqf88I9VnI5cW9XOimj4/CnyTOB6kO8GySzt4
/bkokq2V0U9vCyLnFKwJA/qaBJ1zYNl5bEnfcHfvFp2Fj+fC8cc0EsNEadYPyMQ8
4CpEi2NlFELQRj9lW0TP2UTIiOkTCmynvJqFu6Gi6KOGJLkR5m+co7R5/Ijq8acO
9RPsTPjy+EHSRXuiFH2WvvQS2ENcECI4l9tQexlXI2IYeAwd2vJFnVW0xPddIS4A
ZAAgcUn66fexPQfb9KZg
=tIGC
-----END PGP SIGNATURE-----

--ggO1suAwIbeAAaiV6oIuB84bbXwOx8FTh--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
