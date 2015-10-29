From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: shrink struct ib_send_wr V4
Date: Wed, 28 Oct 2015 22:25:31 -0400
Message-ID: <5631839B.30300@redhat.com>
References: <1442157215-22341-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="MVwegaPDAlqBVRDt6x29Wu8jtKVTfL4WM"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1442157215-22341-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--MVwegaPDAlqBVRDt6x29Wu8jtKVTfL4WM
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 09/13/2015 11:13 AM, Christoph Hellwig wrote:
> This series shrinks the WR size by splitting out the different WR
> types.
>=20
> Patch number one is too large for the mailinglist, so if you didn't
> get it grab it here:
>=20
> 	http://git.infradead.org/users/hch/rdma.git/commitdiff_plain/c752d8093=
7ff2d71f25ae7fcdd1a151054fb2ceb
>=20
> or the full git tree at:
>=20
> 	git://git.infradead.org/users/hch/rdma.git wr-cleanup

I had to do a minor hand merge to get this to apply, but it has been
pulled in for 4.4.

>=20
> Now that we have 4.3-rc1 out it might be a good idea to get the rdma tr=
ee
> for 4.4 started with it.  Both I and others have additional large patch=
es
> pending that build ontop of this.
>=20
> Changes since V3:
>   - dropped the old first patch as it has been merged
>   - rebase to 4.3-rc1
>=20
> Changes since V2:
>  - fixed patch one to accept SEND - note that this was alredy fixed by
>    patch 2
>  - added a CC: stable for patch 1
>  - added additional review tags
>=20
> Changes since V1:
>  - new patch 1 which rejects invalid opcodes.  Patch 2 was doing
>    this implicitly except for UD QPs, but I think we should a)
>    do this explicitly and b) ensure this goes into 4.2 and -stable
>    as I can see quite a lot of harm from submitting such malformed
>    operations
>  - patch 2 now covers all drivers including those in staging to
>    side step any sort of discussions on the staging tree.
>  - patch 2 now explicitly replaces the weird overloading in the mlx5
>    driver with an explicit embedding of struct ib_send_wr, similar
>    to what we do for all other MRs.
>  - new patch to drop another unused send_wr field.
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--MVwegaPDAlqBVRDt6x29Wu8jtKVTfL4WM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWMYObAAoJELgmozMOVy/d2BoP/jr7TIgTMIKluIU/JAq9JO17
cWKdmTTzMiLlYgFl80w3+hCYESWrTwimOua1E2oLC0TkkNzevyEJ0dwjSN79+Zxk
1wyNFIgflR9ReCjYN9q3XkdLpr+/ZB5jecsBBaJHfoxKoBk9HIExeyJa4A6hxC0F
71B+1ecD8y3SYt4wrYdxZLjIO8lpnCoXzj89TXcCDL+o4mNg/65qwuPqj/nIg1kI
lkFCrp7j5s4X4zaIJOJSJGZywy25frG5mNLlMvRbs2eaPTaTXBdpsAxT3cmFdKpK
opCZXkXTJeWwRTh2tSRS/21Y5dOIR6TRPdU2B+qP6+/uXzjcHZk7STOIdao0MXCX
cSMbdg3Y77QLpCslndQn5n3T2jBy1p7heW2rE8jznCyxnKoBcz9drUs/JBCdy7Nu
cBUs0YHT2NJANQINKTo5Y16uwlRwtYAAIAKR2TQ86cCEtucz8duiLQyhf4k87NFH
othnk+YoqrXQsFylYLWNxz5rcIVLxotjWn2UMJmXNcrkk0e0LT7UCdij+r63L2ql
k0vMOX1LwsbWH8aChrXrzdNnKdZwxl4VgoluYCZEnXKNONxakRJjj0Pamz/owZqj
fQw2ccR0qpFO5Syc70+413itCBHHkKKppdqw+QrilhgFh2EJDWbk2l+KTcZIt1Rb
AbcTt1JqAfOOt9K0TJ7z
=FjcW
-----END PGP SIGNATURE-----

--MVwegaPDAlqBVRDt6x29Wu8jtKVTfL4WM--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
