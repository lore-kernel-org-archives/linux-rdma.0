From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V3
Date: Mon, 31 Aug 2015 20:24:13 -0400
Message-ID: <55E4F02D.4080701@redhat.com>
References: <1440579639-10684-1-git-send-email-hch@lst.de>
 <55E321D7.7000209@dev.mellanox.co.il> <20150831161116.GA24494@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="fuGkbUptwuKg7Po54Tbj00rAs4K6SPkUI"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150831161116.GA24494-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--fuGkbUptwuKg7Po54Tbj00rAs4K6SPkUI
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 08/31/2015 12:11 PM, Christoph Hellwig wrote:
> On Sun, Aug 30, 2015 at 06:31:35PM +0300, Sagi Grimberg wrote:
>>>   - patch 2 now explicitly replaces the weird overloading in the mlx5=

>>>     driver with an explicit embedding of struct ib_send_wr, similar
>>>     to what we do for all other MRs.
>>
>> That's nice,
>>
>> There is one non-trivial spot that was missed in mlx5_ib_post_send
>> though:
>=20
> Oh, that was a weird abuse of the old casts.
>=20
> I've foled both your fixes and force pushed to the wr-cleanup branch.
>=20
> I do not plan to resend the series until the merge window for 4.4
> is open.  Doug, any chance you could pick up the first patch in the
> series for 4.3-rc?  It's marked for stable as well.

Yes, I can do that.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--fuGkbUptwuKg7Po54Tbj00rAs4K6SPkUI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV5PAtAAoJELgmozMOVy/dSesP/RtgMWw3h8SvuhxYGvJlKwGy
v5yLfCyp+kRxIki4WVCj52zhs5QAsuP2HROcP7MJGhoiGRXfZk84eBeL+WWQxItK
ZpYBDtC04YcrwQtc1dDN8JuZPXeC5IpZpYA0R2Cnf31PnIQFGMxrB08sAVHw0G7Q
d+fnq6aJT9y2FMyGk/c7KqpOSfrHLEg5CnBR8crIphiBENLwB+ciEAiA42me5mkS
0RYC7H5d/PiFpgVEHDQpd5Ac2Cu2ciWG9Ba3LrUMuakKN1b8/1F/e4yPMfo9WC2N
lv6zvAfbCa94iShoBha9j0dhLpWTwMantnLdqywqucw7s+XnRCvBAMUMvx2xIvZa
CxCEg4g3OBQjYB0BMUjCnSJGJB2M/s5Zpw/0+1vxaPguMUob98F+Vkn2sBaEmXhg
t2p02cLZW1mLyR4a8Delkid+Fm0reyaeMVwYPOc+s5dE3Sgt8PyW8dvtf39WuoZR
0ZbyMhhReIalC1YDeMuSVy55ifncYFDHobjqTBIjpiSYDFszdVtCQJdxmugnvP77
IiPVduv79IPFshXCkg2vWR+Lxb1xA4NO7PMH3A8U0zQV9NpqPNewQauHpCFilKsq
oJAo8RZmwmu9Tgxeoi6Yvkvj4bidT0EiT1IDEzyGFizIk4hHY3KgybuHbapWib+9
8eM+EAFUiubmkDyWVjEC
=dYZn
-----END PGP SIGNATURE-----

--fuGkbUptwuKg7Po54Tbj00rAs4K6SPkUI--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
