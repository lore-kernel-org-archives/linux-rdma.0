From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 12/12] IB/isert: convert to the generic RDMA READ/WRITE
 API
Date: Thu, 28 Apr 2016 17:04:28 -0400
Message-ID: <57227ADC.80000@redhat.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
 <1460410360-13104-13-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="3FUnsm8Wg5lFhOEkCEcjJCv4U9cAgFhvu"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460410360-13104-13-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--3FUnsm8Wg5lFhOEkCEcjJCv4U9cAgFhvu
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 04/11/2016 05:32 PM, Christoph Hellwig wrote:
> Replace the homegrown RDMA READ/WRITE code in isert with the generic AP=
I,
> which also adds iWarp support to the I/O path as a side effect.  Note
> that full iWarp operation will need a few additional patches from Steve=
=2E
>=20
> Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
> ---
>  drivers/infiniband/ulp/isert/ib_isert.c | 841 ++++--------------------=
--------
>  drivers/infiniband/ulp/isert/ib_isert.h |  69 +--
>  2 files changed, 85 insertions(+), 825 deletions(-)

Hi Sagi,

I've seen your reviews on the smaller patches in this series, but this
one in particular has your name all over it.  If you could review it, I
would appreciate it ;-)

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--3FUnsm8Wg5lFhOEkCEcjJCv4U9cAgFhvu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJXInrcAAoJELgmozMOVy/dHWwQALQO30ptFA/Krd8MwA+Te3OD
DFPALkAhTf59ub8sHYk0cOCRVOxWFB2p7p97fcMJFqwZL1vd22Uz3M61Z7z310zK
wP0uY4RkIDCHZVEUZr7jIN+/VMLZYTJOrphQcDwAwlpYAq0Ro7ogiYR0gKtUGtkb
Eo5xIKYg3gNI+mZjfH/R4rbrBGhMy3jfCFN3deqf0lkBiUcZ3s8O9DSy6OfktD7g
O+PL9ly3hpDyc1lZKwKj8xxRRsP/wLzZAjASVcNZ4lIfzrnQ+AO4XylGTElcWDNb
nVo5r6OYuFCIzJCBJFyx2Gkrdtb3am3lEiy5RUi7qCx8iCiSbhIoUOfsRCw8YHkR
9MlDdChrAhmE7WWL+H9ET2qlzYHvZtiegRFg/bklyuhwiky7tWduf28ah94O4Hcw
bMnCmyEyfL/wAVIJtP4iIq0s6kNrsPff8dL3bQf19QXNhCUR8dyJ3m4l10PsHJy5
M7eAgM+nql+CbciE7hRMWBoVs1c3Pcr+ohbggrysPcvEy6ErokzgLp4A4edFu3Ib
ujQ0NA1xHmKplT06VzQ9JN4WbQXVnuSVxfJRBgHaCnshrhqPt7E0Q7BPHQKt8doW
qn2cGD1b4RCzT0xu9XXhxws5hyjOfVnfRfh57X4TA03tjcmZW7JLZjAayo1yV2EE
NcviPoaapCCV1Aq+/ZTX
=d29/
-----END PGP SIGNATURE-----

--3FUnsm8Wg5lFhOEkCEcjJCv4U9cAgFhvu--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
