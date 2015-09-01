From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: mlx4 problems with 4.2-rc8
Date: Tue, 1 Sep 2015 09:54:46 -0400
Message-ID: <55E5AE26.8090904@redhat.com>
References: <55E142DC.8060205@redhat.com>
 <CAJ3xEMj5By11L3qbSKxcEiMarB6CeyeERMnuK_vvH11VLLFypw@mail.gmail.com>
 <55E385DB.2@redhat.com> <55E3FDAB.10706@mellanox.com>
 <55E45058.1070105@redhat.com>
 <CAJ3xEMjp+3Y0y2d-K-zi9SnBSshN_C5x5KLY3oCpD_XriDCsWw@mail.gmail.com>
 <55E4D1A1.3060608@redhat.com>
 <CAJ3xEMh-EXsoWsMhSf2ho_U_tz5tCUz2iWK+YZ3d76j5B7HJxg@mail.gmail.com>
 <CAAKD3BCbZpzG3g+H3xkuBM+Y9G14DZ=tJXeaGe5_ccQpiqWmCQ@mail.gmail.com>
 <CAJ3xEMg1qoCrkMoymnbe_ww50Cg7yjOf4y3fTSb7ngoqbCZ1Hg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="G3GUr3iAEe28I35oEJdtbXcxHpF95nmbJ"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMg1qoCrkMoymnbe_ww50Cg7yjOf4y3fTSb7ngoqbCZ1Hg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--G3GUr3iAEe28I35oEJdtbXcxHpF95nmbJ
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On 09/01/2015 05:50 AM, Or Gerlitz wrote:
> On Tue, Sep 1, 2015 at 11:42 AM, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org=
> wrote:
>=20
>> If I recall, this code was sent through linux-net mailing list. So
>> it's possible the different branches weren't rebased, isn't it?
>=20
> but the code was merged for 4.2-rc1 -- so Doug, this means that when
> you did the 4.2-rc work you haven't rebased to 4.2-rc1 -- if this is
> indeed the case,
> such practice is problematic, agree?

That depends.  Early on in the rc series, I don't rebase for testing.
Later on in the rc series, I do.  However, that's all moot because it
isn't why I didn't see this in the 4.2 rc series.  I only have one
machine with > 32 CPUs, and it's intended to be a highly reliable/stable
machine.  I don't always use it for testing new kernels.  In this
particular case, I needed to move it from a RHEL kernel to an upstream
kernel to isolate a different issue, and hence I ran across this
problem.  My more common test machines would have never seen the issue I
reported.


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--G3GUr3iAEe28I35oEJdtbXcxHpF95nmbJ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJV5a4mAAoJELgmozMOVy/d46cQALGp9aZT4+/wwAvYp2Ov/uBI
/7qSInJo905PjVl6jrMUSssD+CXuDFdNv6h039FIgnsArU+NwDh6C8hArb7lA33d
ED8u9e5JQSMFXk5Bnkpe4pbCVI+6sBZGM1ZJAMsxM2Dx5wBOuZQvLmCqSxWSML7L
dxNZYpvwu20qXIK+bcilyxobo74BYMb9tV+kss+yhyVckgnvcatBv8xl4NySCgI3
10JfWktUQzzDwVMTW7AnRusqVCvi0dDSItIWHG7u4LPSZxLibAo1pizEoLO/M8gg
/CKl+wfW8URfZ7IIrg5gqg/zDfd8bMfQxgBYxwupBFYskpwQ5rViK2CCg+Sj3F9X
dtviZyrACDMrhmoFStiuZswREEZgeaXl+JHW+bjUIYOKzIOsS/6uq4B6f2GpWFHE
EREmgV4//yizu46g6xuwpUhUT3ASUKVjKDYoFASj7RGVJ3jj/ISl/yD/Y+QP4a45
ASwKSoH8LfJPik9/ey5vkVebZDf8YkmtaqYOWsMwFIN7nVclar/nyePBol9uNF2c
NRYqs4CfHZuGN7QJnXE5xzE7W4ClKuL5AkSelRbolDDXomIBl079ShoczoPOa8Bu
oqfjuDYqDwewC+CH7chU7fjooqLlDZOtF3wVhCYe8ezxsy9a3LnZyB3pLtu/zAGi
RUDkXb3m5VyYj/d1uCmH
=D4VH
-----END PGP SIGNATURE-----

--G3GUr3iAEe28I35oEJdtbXcxHpF95nmbJ--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
