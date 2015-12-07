From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 0/6] SRP initiator related bug fixes
Date: Mon, 7 Dec 2015 16:07:14 -0500
Message-ID: <5665F502.5020305@redhat.com>
References: <565DE3EC.2070002@sandisk.com> <5665DD50.5090906@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="t5AO8xWg1dFSr29O9dUC6PGsLOQKDE5ir"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5665DD50.5090906-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sebastian Parschauer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--t5AO8xWg1dFSr29O9dUC6PGsLOQKDE5ir
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 12/07/2015 02:26 PM, Bart Van Assche wrote:
> On 12/01/2015 10:16 AM, Bart Van Assche wrote:
>> This patch series contains six bug fixes either for the SRP initiator
>> itself or for IB core functionality used by the SRP initiator. The ord=
er
>> of these patches matches the order in which the corresponding bugs hav=
e
>> been introduced. The patches in this series are:
>>
>> 0001-IB-srp-Fix-a-memory-leak.patch
>> 0002-IB-srp-Fix-possible-send-queue-overflow.patch
>> 0003-IB-srp-Initialize-dma_length-in-srp_map_idb.patch
>> 0004-IB-srp-Fix-indirect-data-buffer-rkey-endianness.patch
>> 0005-IB-core-Fix-ib_sg_to_pages.patch
>> 0006-IB-srp-Fix-srp_map_sg_fr.patch
>=20
> (replying to my own e-mail)
>=20
> Hello Doug,
>=20
> A consensus has been achieved about this patch series. Since one of the=

> patches in this series fixes a data corruption bug that has been
> introduced during the latest (v4.4) merge window I'd like to see these
> patches upstream soon. Please recommend how I should proceed. When I
> repost this patch series, should I send it to you, to Linus or perhaps
> to someone else ?

I was just getting ready to pull this set in.  The only one you actually
changed, and therefore needs either a resubmit or I have to be careful
to get the follow-on version in Patchworks is 5/6, yes?


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--t5AO8xWg1dFSr29O9dUC6PGsLOQKDE5ir
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWZfUCAAoJELgmozMOVy/d8EgP/iENvLc46A56QHbhEbyUinm1
Wr3z/1zJQuCaqfpEdWfRvTi/ymEFRGXOxEPoSHNIxz7c22scHtoS3ezQMp46EyEc
0ArtAXYbReH3LRhfgNAfJtyO+K74QyKcz5gZaLRjveTny8thZwnDey7iUXVeMOXY
YJrVWoo0PXP4i5h51N0LnOtJ4rzWq1HPi9HYENm975r4mUrOFlrly2ySGXS5INcJ
YOq0xDtPD4zfxKjPpvYgpa1dcTknTPBDpYWqAKI8RvOUDCJuzZ6N0l0s4QyGqLSs
DFHyp7i290Zijqnc1pYn2ZackhGihz97vp0liYRBjA9XSme5Rp5x0piN4H3t3FbS
7G3t0+7TLo5Zj49wcaAt8hasGO/aj5vq3zDTQaL30TZWAFT9MLOecguZnTCx4J0+
oJZjD39ZgNZDKbrZlO6nEIpDCVk9QLkaTF55p9PiHEjBM6e885JmlMTRuYjQg/42
SctD5Xt8av5Ahat4Wt4548x6koj3p5Y80cYWhHmt4bKS1W1iAemoDdZtIZiKfQw3
yXd8HhybZqB89Tbczn9re6p6oSfaVs7Mzp2Y0KklbJyPofSYDOJb2didIrT71/5c
YKVEpbLUfommco++bPPfn8JwtKONq8qEPh+4LVkYj9WLH1bhcJqRqt03R9Jk1C6l
jIDWVeH76AJ+6iDiUe3m
=ZpM4
-----END PGP SIGNATURE-----

--t5AO8xWg1dFSr29O9dUC6PGsLOQKDE5ir--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
