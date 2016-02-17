From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] RDMA/ocrdma: Fix arm logic to align with new cq API
Date: Wed, 17 Feb 2016 10:57:35 -0500
Message-ID: <56C4986F.7050808@redhat.com>
References: <1455168112-12803-1-git-send-email-devesh.sharma@broadcom.com>
 <CAG53R5UnRqq9Gf5fFZJr+e_3DQvz7ViveJJAz6FBFYBaADtMJA@mail.gmail.com>
 <CANjDDBgH-4Foq02f8wE2bdg7OprvT84gLNY6-9uPNgYWEFKLPg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="Cq4JT418G7pN9P7QnEVXSvrPewh0wgV3g"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CANjDDBgH-4Foq02f8wE2bdg7OprvT84gLNY6-9uPNgYWEFKLPg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--Cq4JT418G7pN9P7QnEVXSvrPewh0wgV3g
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 02/11/2016 10:46 PM, Devesh Sharma wrote:
> Hi Parav,
>=20
> I have tested this patch with nfsrdma + linux-4.4 (i.e. without
> Chuck's patches to use new CQ API)
> iozone on nfsrdma mount point passed.
>=20
> -Regards
> Devesh
>=20
> On Fri, Feb 12, 2016 at 2:43 AM, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> =
wrote:
>> On Thu, Feb 11, 2016 at 10:51 AM, Devesh Sharma
>> <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org> wrote:
>>> CQ is never armed before calling poll on it. Most of the kernel
>>> ULPs have already moved to use this new API or have a code where
>>> poll is called before arming the CQ.
>>
>> You might want to wait for NFS whose patches are in pipe to migrate to=

>> newer APIs before merging this?

Thanks, I've picked this up for 4.5-rc.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--Cq4JT418G7pN9P7QnEVXSvrPewh0wgV3g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJWxJhvAAoJELgmozMOVy/dBGAQAJs9+wXCd9xuvTMjaNYZh6Ex
/egEaULNbLRJf2Ik/lPJmUIWRJkFz1GVqVBRqjLNgpZgwdO3JUD45L7mZxV17XgM
g0k3IBqZu3F+L9vu5uKlEowqtVTSUZByRhVBo6Y5dzQ/5PmjQeBxN0B/9w76hhou
LAC1dArGNj7XFj8U2rg/FQ5Eaobb60ABPGCrlQ2MBATlsJ94Kz6u7PSqPDeny7g7
FcrrD/Wk/Ato+LlS8wGnclHsSNQxnAX7BxA8XHZCu3i1VQfnqcA+nmOWZ9DHaKlf
LxowAHTNBtKhoa1Z+xNcCMnm2c2FwFgYbSEike5E8QuEyQO46+qJK6yTIZaoU/HX
D66F6OkoL4ayqGKpU/xAunf/e0xJ5IV5/6V/P6jWcAzZqqAdgQyvHC85HvOcQZF8
pzrNki7YHmVGq2THEVC7gyg8ACzMPR9fBYAafoiNI93t9+35m+tMOc6O8C4mvdtq
YrSy6j1wi7qQp3Kv/fR6zCU2j6RrhAbqfhHcdWJ/mowRtOO3pBHMKvuoX0Lg/eV5
u6NeJueEbqdlp7K6NI0TBg06QfkA/JaqmsAFAM1PBsOAHDuupqNLVenhPQs/GlAd
a16DRVFF3KDu4dqArVzofpSdvRuk/GqusLOyIxSFEXxkRvciGlYzhFUmuCtLhdQN
RzOcTsilKw7ZQKEqHpoz
=YnWs
-----END PGP SIGNATURE-----

--Cq4JT418G7pN9P7QnEVXSvrPewh0wgV3g--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
