From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v5 00/26] New fast registration API
Date: Thu, 29 Oct 2015 11:40:07 -0400
Message-ID: <56323DD7.6030107@redhat.com>
References: <1444752709-15429-1-git-send-email-sagig@mellanox.com>
 <56262676.7000403@dev.mellanox.co.il> <563185AC.10804@redhat.com>
 <CAJ3xEMjYd2WUzFxNNSvWCkedt0bczC3H2ySP0ACvEkaoUP2SGw@mail.gmail.com>
 <56322A41.9050004@redhat.com> <56322E39.6020602@dev.mellanox.co.il>
 <5632305A.6050800@redhat.com> <56323A10.7030103@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="l3jfe4R2K1MswHDPTorMx5Mq66NqHNX1W"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56323A10.7030103-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Alaa Hleihel <alaa-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--l3jfe4R2K1MswHDPTorMx5Mq66NqHNX1W
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 10/29/2015 11:24 AM, Sagi Grimberg wrote:
>=20
>>> I can provide a patch for hfi, anything else needed?
>>
>> It breaks all of them in staging, not just hgi1.  So, hfi1, amso1100,
>> ipath, and ehca.
>=20
> hfi1: Does not support FRWR at all, there are just some copy-paste
> sections that supposedly handle it - so I'll drop any sign of it from
> the code. We'll add this support to the generic for qib, hfi, softroce.=

>=20
> ipath: same
>=20
> amso1100 & ehca: it does not have FRWR at all - no sign of it in terms
> of code... did they really break?

I can't say for sure now.  The compile history has scrolled out of that
terminal.  I knew it was more than one driver, but I didn't write down
if it was all of them for sure.  But that's not really my point, it was
more that I needed you to look at them all and make sure the compile
won't break for any of them ;-)

> I'll send a patch for hfi1 and ipath.

Thanks!


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--l3jfe4R2K1MswHDPTorMx5Mq66NqHNX1W
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWMj3XAAoJELgmozMOVy/d6v4P/jib07kDOHIdhFOlIZu2p2NZ
cNcJgYIhG9mVGbtUqd3te5D+HMN7Wza+WZstin82V7/wPaaacxYEoGDxR2WgzMSH
ETd9oumWaDfrFbcbhaAc2Zu4DYZqeA/XKgSTsMaywzGJpJPiSAtyUibwVmVxOXzY
fzdZErvlSdsNwJX1UOjsle3sPy8gvMue/82pxtqkDrxHsgQDjdOYShvZoMrMEs1D
OnBpsijqQMIl6Q7B94k8cMcMKZiZjMCFvFnWLEnlTjy17hx4MaqTiZsqynr7VnW3
ud7v/Je52RpTfOigbxidywUwzozYiVBG/4pM3a10cVkV99hCN7JBFlGvAHRnj2QA
+o6hZTMjMglRQRfszz0CkIE7wgFk2VZQLbmwq3p7w6lpSJBILPsPuVwLKgrFahN/
63y9qllpSlHro0R91OYevtSC50elSJm1mmRYenkCKkF48VgL2VIxblgXkTQi+CQD
LqE5seV62ASm5MAZtrPRE14+NDl90sncdLm7MafEA0hp/XVJNRRAc+an/5pV0K9G
66SmvoJartCCQoHN0Uj0YoqIDH9FNsF/anO7PxQVLogJEDmC6UELrFPHNoUUxLQd
60ayVqNEhClaN8P5Tt+jaBgjC2Jl4vIyvRT2EMKn/KKJ6lETWSuKFbNYcTNhJagB
srLRSJQYBnDZItJoDdC4
=IY6n
-----END PGP SIGNATURE-----

--l3jfe4R2K1MswHDPTorMx5Mq66NqHNX1W--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
