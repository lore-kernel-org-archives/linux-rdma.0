From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] IB/srp: Fix possible use-after-free
Date: Thu, 3 Sep 2015 16:00:57 -0400
Message-ID: <55E8A6F9.9040707@redhat.com>
References: <1439216574-25936-1-git-send-email-sagig@mellanox.com>
 <55C8BB38.1060808@sandisk.com> <55CA09E5.2070208@dev.mellanox.co.il>
 <55CA1BC1.3060609@sandisk.com> <55CAE85D.7010602@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Ss70jqHkxUA3CreH4SgE5qWRERgw75eTV"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55CAE85D.7010602-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Ss70jqHkxUA3CreH4SgE5qWRERgw75eTV
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 08/12/2015 02:31 AM, Sagi Grimberg wrote:

>=20
> Looks better, I'll resubmit.

For some reason I don't have the email for the v1 of this patchset in my
mail.  It must have gotten accidentally deleted.  In any case, v1 was
applied.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Ss70jqHkxUA3CreH4SgE5qWRERgw75eTV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV6Kb5AAoJELgmozMOVy/dI+wP/j/nf+nCR+ZERlKycAA+pm4z
PuBSSsM6CaKtEGI708OLw0jwGEkxhFSiWMwL1Ic1IDXh3gMVOG3Tv/qtFtUDbeS9
cnopv1K1SmBmn8V1bxaiQSt/+5Kug1DYLU70FUW3OghWo0Cz0GtwCzjlkTmrhaUx
Mmqc6xGUxEdgwwkdXE0De4xjm3bK6Myu6nqQ3Ihtgd4sdWI/QUSH4H098tVcpeCE
9n/Hy9gjmBHIqpRjzavsI6hcYsndc/HKbqiv/5T2Tn0/IVknu6I3CROIud1ACL8U
WpxFeCeCra1BL6GeKYb09fbt4T9D3q6ZJXi996Txt6ktePIAhHUrHlAEvCsVF/5d
ymlJ3AK27iWCD3rRB6xQU9RkeiP6SdrhLismTZ4vnlxG3RfZP4L56KFCHmp9rT+Z
ROCNObO7R6NxpCmRs/lVduIZ4XMv1qaaHIrS4HVDKmaV+dSg4OYcBl+l8UMRtrEL
d/D86rJkUfLGsGCA0RbJYbmKNgrv90LUe/kNjQqUYwq3+99SQScMnXTjjmtfsnTZ
iBLsZ+WdOn2zY9SN9YbPWvPvok6VR24y5UjMGlMbPSImy/NszhpEr3LXDJbtGXOm
r6s25GKRH9JqdgT9stQVAp5saE/1WHqn9C4GUj/QdyVVB7PoUxENIfBflp2fz3Ff
8obiIVJse4R5Z4iqGqWJ
=DAwT
-----END PGP SIGNATURE-----

--Ss70jqHkxUA3CreH4SgE5qWRERgw75eTV--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
