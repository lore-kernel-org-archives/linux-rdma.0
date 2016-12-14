From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IBcore/CM: Issue DREQ when receiving REQ/REP for stale QP
Date: Wed, 14 Dec 2016 12:55:41 -0500
Message-ID: <e4dad5d5-f9d7-e198-e53c-797a0d639d2c@redhat.com>
References: <1477653269-27359-1-git-send-email-hans.westgaard.ry@oracle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="c5Vu9d9vTBgf5X0rPpv011i7PnsoumBpd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1477653269-27359-1-git-send-email-hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hakon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--c5Vu9d9vTBgf5X0rPpv011i7PnsoumBpd
Content-Type: multipart/mixed; boundary="Wt9wuoMsfJftsxTlmu3qGPguoSJ7XwDFl";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock
 <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Ira Weiny
 <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>,
 Hakon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>,
 linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <e4dad5d5-f9d7-e198-e53c-797a0d639d2c-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IBcore/CM: Issue DREQ when receiving REQ/REP for stale QP
References: <1477653269-27359-1-git-send-email-hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <1477653269-27359-1-git-send-email-hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

--Wt9wuoMsfJftsxTlmu3qGPguoSJ7XwDFl
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/28/2016 7:14 AM, Hans Westgaard Ry wrote:
> from "InfiBand Architecture Specifications Volume 1":
>=20
>   A QP is said to have a stale connection when only one side has
>   connection information. A stale connection may result if the remote C=
M
>   had dropped the connection and sent a DREQ but the DREQ was never
>   received by the local CM. Alternatively the remote CM may have lost
>   all record of past connections because its node crashed and rebooted,=

>   while the local CM did not become aware of the remote node's reboot
>   and therefore did not clean up stale connections.
>=20
> and:
>=20
>    A local CM may receive a REQ/REP for a stale connection. It shall
>    abort the connection issuing REJ to the REQ/REP. It shall then issue=

>    DREQ with "DREQ:remote QPN=E2=80=9D set to the remote QPN from the R=
EQ/REP.
>=20
> This patch solves a problem with reuse of QPN. Current codebase, that
> is IPoIB, relies on a REAP-mechanism to do cleanup of the structures
> in CM. A problem with this is the timeconstants governing this
> mechanism; they are up to 768 seconds and the interface may look
> inresponsive in that period.  Issuing a DREQ (and receiving a DREP)
> does the necessary cleanup and the interface comes up.
>=20
> Signed-off-by: Hans Westgaard Ry <hans.westgaard.ry-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: H=C3=A5kon Bugge <haakon.bugge-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

Thanks, applied.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--Wt9wuoMsfJftsxTlmu3qGPguoSJ7XwDFl--

--c5Vu9d9vTBgf5X0rPpv011i7PnsoumBpd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJYUYedAAoJELgmozMOVy/dK9gQAJ/dlupiLj2KHodUJnMUmjQq
TOXRr7+WMDtelt9HXUZV52o4oOP6fRS9H17Cvdm32IehgVRPeH0sf4HuS5WhJO9T
H7Tm2SwrAwRPbjZdk8FaW3loFgroRJQi3lOzPG77uYSPi3lkfjwTn9ZH6etEbFe8
ohc3/pcIunuvze+uSi0tEMGpoBuXL05kmxAaiSGzj7ELB0e6bYZKUeIwuCeEo4Pi
+fPMi/bE/oRNq7mB2/hUXwfzi087W1BZcvyB/uet2DSfx67inkPfv+jeGrHLzl7X
DKiiu3sU34Lp0uwLqJNysRmBjAWezDjmIXccijBr0flsdG0Qihba4SWroU9rRblS
5A8PTCFsf1lPmsDVP7eU4eCj91+Nqy9zJ205D1X/EzFZKCcibh66pbi4lDAJUTS5
ow+n/+fEgr58hbZKIE6VDrJJHfUCkJ8wsAQrLQhGacPvTi4P1PdBYYJsAgKiToaI
LWhO4EgRZ0sLIcC9+TGf8u8dU2tG3gRJ8uKlF2dk8hS0I9zFWPaXaOQxpo9Y0oln
v96zNObSdIrMjGdLt7oHfQsenV0jkSC6h662bjwdCDFyldGxE/lVBZafZO+SRP/b
YV36rwXgXYN8jBXzuu+9vRI9nt4F9TfRw5XKHiYjOm96RN3GkSRBnSyd+X8yNDNy
ge/LcByq3TYcfv3P9sOD
=EBfF
-----END PGP SIGNATURE-----

--c5Vu9d9vTBgf5X0rPpv011i7PnsoumBpd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
