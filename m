From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Wed, 28 Oct 2015 22:57:59 -0400
Message-ID: <56318B37.20207@redhat.com>
References: <1442157215-22341-1-git-send-email-hch@lst.de>
 <5631839B.30300@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="4SR9UqmMuFAIpT969iR1imFqkBKO2gjcL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5631839B.30300-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--4SR9UqmMuFAIpT969iR1imFqkBKO2gjcL
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 10/28/2015 10:25 PM, Doug Ledford wrote:
> On 09/13/2015 11:13 AM, Christoph Hellwig wrote:
>> This series shrinks the WR size by splitting out the different WR
>> types.
>>
>> Patch number one is too large for the mailinglist, so if you didn't
>> get it grab it here:
>>
>> 	http://git.infradead.org/users/hch/rdma.git/commitdiff_plain/c752d809=
37ff2d71f25ae7fcdd1a151054fb2ceb
>>
>> or the full git tree at:
>>
>> 	git://git.infradead.org/users/hch/rdma.git wr-cleanup
>=20
> I had to do a minor hand merge to get this to apply, but it has been
> pulled in for 4.4.

This breaks all of the drivers in staging BTW.  That will need fixed up
before the pull request goes in during the merge window.



--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--4SR9UqmMuFAIpT969iR1imFqkBKO2gjcL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWMYs3AAoJELgmozMOVy/dnTYQALaAtuOhGBvqpFVtT8+Vu/wD
jWCXWMGf1dbi0szDuHiAoN8j/PlmYnvoDdM57f5t3ZGN3PvMdB4oxMy/U74B8dY+
+Jj6oOnTQRtOKWOypSUNYm7Y2dTssiS8JbR9uVXflKu6Ta7BqJ0r9GZdMlOJ/N/o
EtiGDRZOK/EflUkaphq8C9q9c7R5urThjxn13x2zbadAVsdkuJnEL7uKJAsIdn78
53kVFNILuXJ7WSPJEHtgCdtm1NzsEmarXmAe26LXMFfF4f+PtmdowbybFj7DCNQw
Xgt5R2bHISsSueYe5f0/3Sa/VTwjJJcZz1FOxrYp/lqV79ffWgwNBf/v3K4NyEhZ
aVGo1dEe9Ba/FEJ5lFXQDB8fPwpbhEtvW4oFS4sLgITos9s7oZM083l7mx6H8eTh
vWj5Kt8Y9b53823BGGTF7cRormpr2e1y2pmmHbx/DsZ6llV02dVGFfnu0sjMlbMH
hGuMAFKp/BcuwdOeXnZq/7UEo9GKb7mEF2rGptDeBIFmKqqnmuVTaARIVDQlR814
QJupSJVvWjrFZ3Bk2uIqY2N7eliRkKFdxkp4C57mTXIJeqU6wV0Q5l3IA2f6Fi+Z
7uSbuOmG6JM4kVvVMv7SjCkPp8ZTxlpmQw+MOjZ6v7fJPqYIEgLTGQZsNu0NCx1z
+sefBbMbH9XSrL2YuHR4
=zC51
-----END PGP SIGNATURE-----

--4SR9UqmMuFAIpT969iR1imFqkBKO2gjcL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
