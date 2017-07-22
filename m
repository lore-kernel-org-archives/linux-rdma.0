From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resend] rxe: fix broken receive queue draining
Date: Sat, 22 Jul 2017 14:14:18 -0400
Message-ID: <03b71c7f-2dd4-afb6-5e17-a175983cbadf@redhat.com>
References: <1498555178-12106-1-git-send-email-sagi@grimberg.me>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="7VFtA0Ef1GDlGJ2rRkEXqMQXQaJPNPqMG"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1498555178-12106-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vijay Immanuel <vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--7VFtA0Ef1GDlGJ2rRkEXqMQXQaJPNPqMG
Content-Type: multipart/mixed; boundary="9mCB3AH4j1H1ARLjKq2T0NCJhVuSkHFGC";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Vijay Immanuel <vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org>,
 Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Message-ID: <03b71c7f-2dd4-afb6-5e17-a175983cbadf-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH resend] rxe: fix broken receive queue draining
References: <1498555178-12106-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
In-Reply-To: <1498555178-12106-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

--9mCB3AH4j1H1ARLjKq2T0NCJhVuSkHFGC
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 6/27/2017 5:19 AM, Sagi Grimberg wrote:
> From: Vijay Immanuel <vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org>
>=20
> If we modified the qp to ERROR state, and
> drained the recieve queue, post_recv must
> trigger the responder task to complete
> the drain work request.
>=20
> Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
> Signed-off-by: Vijay Immanuel <vijayi-R1PCaG5FPJG/3pe1ocb+swC/G2K4zDHf@public.gmane.org>
> Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

This was accepted into 4.13-rc, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: B826A3330E572FDD
    Key fingerprint =3D AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FD=
D


--9mCB3AH4j1H1ARLjKq2T0NCJhVuSkHFGC--

--7VFtA0Ef1GDlGJ2rRkEXqMQXQaJPNPqMG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJZc5X6AAoJELgmozMOVy/d3gQP/iLDSuZL9qJajmL07kSLLwbB
u4rIsB1UvBo9+hA6n5cmoO/it0rqcdo8AVPi4psarc+LxZUIbTP5of4v1NtIP3zh
tQuKqYA5NIns8ewjZ0ZNA0uguwvRycEVSB9zvz8WwDQiueTbINEsu20qzKOlLSBi
gNYqbyRTgbebud/Ki1/J63T9+HPn8WxeAxdZDIO+UH7aVpbz0iSVGXsVp2LjF+uA
GYam0S1GcuchxiU7jkaKN32UHO/OUqIt0/sc9ISW8kxGguDFrEDTNVJESTgnCiqx
MysaVZVdJzJaky960HkWDm3s7jXAKgPqi1SgIUWDry+kiqGE/gg4zuBcg5B8gb5I
9fTi8sHypd6qNN6k3YSzo2e/yyf1Z8vtugTDCHcqNKdunMxTxCib/17PPpjL60tu
AGt6fK4X2VPO8HnWEHGxPizAuB6Hnu+zgu6EeRU04iJ0PCnr6k9rfR6Jw6c3ARxn
O9uYS+W22Clla/Am+1iX8fPgyr+y2IC0G2yd2QdJPoL0YltlrXK805Wu5lOuzKeA
Qi72Oo/67coR7FqosIv4sm/umxxQ6f7/g9QK0sUxfa8WenYqCmDrRGmILe7Dj3bM
8O3q+IOgn1AyOdsMzpBrRGgDaHfEjnBlqv5JavVr7LadFuWt7/KU0vLw062yIHLJ
86QdPSh1yFXiBUQ8OJKv
=RBJm
-----END PGP SIGNATURE-----

--7VFtA0Ef1GDlGJ2rRkEXqMQXQaJPNPqMG--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
