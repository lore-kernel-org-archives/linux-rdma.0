From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 1/9] IB/ipoib: factor out ah flushing
Date: Mon, 16 Mar 2015 09:06:02 -0700
Message-ID: <ADC46FD9-3179-4182-949D-1884C9D31757@redhat.com>
References: <cover.1424562072.git.dledford@redhat.com> <b06eb720c2f654f5ecdb72c66f4e89149d1c24ec.1424562072.git.dledford@redhat.com> <54EF1F67.4000001@dev.mellanox.co.il> <1424968046.2543.18.camel@redhat.com> <54F2B61C.9080308@dev.mellanox.co.il> <1425308967.2354.19.camel@redhat.com> <54F585E9.7070704@dev.mellanox.co.il> <CAJ3xEMgxxHu5BQdADaRe-Grtf4rm1LMfsCRiDyF6ToPdV_62OA@mail.gmail.com> <3A0A417D-BFE4-475C-BAB3-C3FB1D313022@redhat.com> <5506F5B2.1080900@dev.mellanox.co.il>
Mime-Version: 1.0 (Mac OS X Mail 8.2 \(2074.6\))
Content-Type: multipart/signed; boundary="Apple-Mail=_8B0E3D85-ADF8-4828-B8FB-DE86698E9F18"; protocol="application/pgp-signature"; micalg=pgp-sha512
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5506F5B2.1080900-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Erez Shitrit <erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Apple-Mail=_8B0E3D85-ADF8-4828-B8FB-DE86698E9F18
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
	charset=utf-8


> On Mar 16, 2015, at 8:24 AM, Erez Shitrit <erezsh-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> =
wrote:
>=20
> On 3/15/2015 8:42 PM, Doug Ledford wrote:
>>=20
>>> Doug, ten days and no response from you... lets finalize the review =
on
>>> this series so we have it safely done for 4.1 -- on top of it Erez
>>> prepares a set of IPoIB fixes from our internal tree and we want =
that
>>> for 4.1 too. Please address.
>> I didn=E2=80=99t have much to say here.  I said that mthca can have =
card resources freed by this call, which is backed up by this code in =
mthca_ah.c
>>=20
>> int mthca_destroy_ah(struct mthca_dev *dev, struct mthca_ah *ah)
>> {
>>         switch (ah->type) {
>>         case MTHCA_AH_ON_HCA:
>>                 mthca_free(&dev->av_table.alloc,
>>                            (ah->avdma - dev->av_table.ddr_av_base) /
>>                            MTHCA_AV_SIZE);
>>                 break;
>>=20
>>=20
>> I=E2=80=99m not entirely sure how Erez missed that, but it=E2=80=99s =
there and it=E2=80=99s what gets called when we destroy an ah (depending =
on the card of course).  So, that represents one case where freeing the =
resources in a non-lazy fashion has a direct benefit.  And there is no =
cited drawback to freeing the resources in a non-lazy fashion on a net =
event, so I don=E2=80=99t see what there is to discuss further on the =
issue.
> sorry, but i still don't see the connection to the device type.
> It will be deleted/freed with the regular flow, like it does in the =
rest of the life cycle cases of the ah (in neigh_dtor, path_free, etc.), =
so why here it should be directly after the event?

Because it=E2=80=99s the right thing to do.  The only reason to do lazy =
deletion is when there is a performance benefit to batching.  There is =
no performance benefit to batching here.  And because on certain =
hardware the action frees resources on the card, which are limited, =
doing non-lazy deletion can be beneficial.  Given that there is no =
downside to doing the deletions in a non-lazy fashion, and that there =
can be an upside depending on hardware, there is no reason to stick with =
the lazy deletions.

=E2=80=94
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
	GPG Key ID: 0E572FDD






--Apple-Mail=_8B0E3D85-ADF8-4828-B8FB-DE86698E9F18
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename=signature.asc
Content-Type: application/pgp-signature;
	name=signature.asc
Content-Description: Message signed with OpenPGP using GPGMail

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJVBv9qAAoJELgmozMOVy/dURkP/RmkxDxaQFDTaTVlqMlGm5bd
sQjekuhvLkNLLwGevAXjeJijKKM9mokcjfOqg0osENN9hJjNiskP4zo/BnrSTKRQ
QuTn53GpEJMIPuz3GWvmANr2vMJ1WSeEYghAqcLAA89lBQM5Nj3RUH2fRulcMDpN
nor0WiBEOy3PVvTW/eDhA80upOGI2koAdkL4y9nXEmAnr/kcjjPfEtXjcpFvrF5u
LqJsxM12RjRPGgcHcOuKcP1K56dSsVLZ30RhxWgZOnZ0RcVhD9w8ykE15HAGlecW
aZWVBGNGlv1aa4Av8+xsTh7iXoNwyd8B68ziq+9eQlk5rv8yq0oEljAPfcME+5Op
lE8Bl7QFAjcnvrHRhWc6G7DRPciLiZwdCdonvoSIv8Hls6aPQFQu3a1RA3kxtbWv
HbTkfjxUGfdKwGPbRCMBrOJFo6GPaOny3Fhl0s22vne22nxNGhisUeN5rEasKN8j
1lhbYUHkhzhQYwOvSXBDIH4/MpMlOW+STg68TY9x0Nm0OAE+xZyMzx6Y8fqj5ihS
8lkveqqp3cLkhRv31fJjr11atb2POs+RPbu6ZSrSiMZxctUYf84tFCwnIXh4D7Pj
jDj/AbAC+ok8qd0UzTocgY1cemIas5WAHcuRCn7pFK3KSjVUF0b5fjRHZjGunmCb
K+KYSKiWvdIXW6afhF82
=L/TN
-----END PGP SIGNATURE-----

--Apple-Mail=_8B0E3D85-ADF8-4828-B8FB-DE86698E9F18--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
