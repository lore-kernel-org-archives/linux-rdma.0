From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH RESEND] qib:Fix concurrent access in the function,
 qib_init_iba6120_funcs
Date: Tue, 8 Mar 2016 15:04:22 -0500
Message-ID: <56DF3046.20406@redhat.com>
References: <1457323126-19686-1-git-send-email-xerofoify@gmail.com>
 <32E1700B9017364D9B60AED9960492BC25A7C169@fmsmsx120.amr.corp.intel.com>
 <20160307204948.GI13396@leon.nu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="a33MwwMgQQTPQtU9PuXHpufRCtxVTsKSk"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160307204948.GI13396-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Nicholas Krause <xerofoify-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--a33MwwMgQQTPQtU9PuXHpufRCtxVTsKSk
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

[ Dropping linux-kernel, they already know what I'm going to write here,
this is mainly for the linux-rdma folks ]

On 03/07/2016 03:49 PM, Leon Romanovsky wrote:
> On Mon, Mar 07, 2016 at 04:34:04PM +0000, Marciniszyn, Mike wrote:
>>> This fixes concurrent access in the function, qib_init_iba6120_funcs =
by locking
>>> around the calls to when setting up f_sendctrl and f_set_armlauch fun=
ction
>>> pointers to the functions, sendctrl_6120_mod qib_set_6120_armlaunch d=
ue to
>>> these functions needing to have their caller to hold the spinlock tha=
t is part of
>>> the qib_ibport pointer they are using and due to the lock not being h=
eld by
>>> higher up functions in the caller stack we need to hold it in qib_ini=
t_iba6210 to
>>> avoid conncurrent access when setting up these function pointers.
>>>
>>
>> I'm not sure I agree.
>>
>> static struct pci_driver qib_driver =3D {
>>         .name =3D QIB_DRV_NAME,
>>         .probe =3D qib_init_one,
>>         .remove =3D qib_remove_one,
>>         .id_table =3D qib_pci_tbl,
>>         .err_handler =3D &qib_pci_err_handler,
>> };
>>
>> The only caller is the probe function, which naturally protects since =
the device cannot be used until the probe returns.
>>
>> Are you actually having an issue with this older version of a qib card=
?
>=20
> IMHO no,
> The author is famous developer - Nick Krause [1].
>=20
> [1]
> http://news.softpedia.com/news/Malevolent-Developer-Trolls-Linux-Kernel=
-Development-with-Lots-of-Broken-Patches-453709.shtml

Guys, please quit feeding the trolls.  I reviewed Nick's patches when I
first took this job.  After deciding that they had a > 50% wrongness
value (meaning, even though the patches are trivial, more than half of
them are *still* wrong on average), he is now in my killfile.  If you
truly feel the need to review his stuff, be aware you will have to
submit it yourself for me to even consider it as his patches aren't even
allowed on the patchworks server (not my doing, it was this way when I
took this job).


--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD



--a33MwwMgQQTPQtU9PuXHpufRCtxVTsKSk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJW3zBNAAoJELgmozMOVy/dKTkP/jtkukuyGB6l7OQpzFkoj1J5
jUmjqZjHwO4vQzJ3HDdQaRQIfSF7nEtgdkp+m6zo4yWQz1IPasb66ZOt+wjz8NHP
zQc187DN5pyP9/mobzlteawm63XDYapWi0jErmzB79eEncVSnYZOGhTjNXfzMgdk
nDFdAQEzUCdheistMQnWNRvyLnF5F8ql4r41An9x+IFSWf2Qk/aL7rtoHxBYmXif
rTIIs6lT+WfJHwGekF3IIGDVM+SNq3XNwu+zpEn7MvoAu1tTArgvdsFRFboriz4H
mzyJaGCX3aE0GoCJvQLPYeTzgzg8vJ5WLVHMzctRPS+UpYh74hP7v2HM//9VeZFo
jI2hlZlmEfhQ1nNjxeso5+Og1y6JZAoS0S6z8aGB0wMQAhLDtDedB2IgSIR1wBkh
XPU2BdCIdCV0lmTtv8vcMlq3z/fFENHYgoJdnUAFdn1Z1HPvww+fC2nzBIsKO3ha
f4dy+wQvZlTyxtmP9JHJw5y/6YUMcUFjzVgW5Qsgt0QHsuBP8By6eGZYk0LedpsC
oeE/wGeewD3sLgsTvfFN4NaF6kIS9D4vnBYvTDkPG0ibRQ384DF+g0E/C6JCufb8
1iZC6O9ebjBW6eLT3lEz+4dniJ6/W6ENLCT6EHtsi25ct2YKXQ+vyjGqeTkkracL
bKhvuRexfoqcySl5wMsV
=C7Sz
-----END PGP SIGNATURE-----

--a33MwwMgQQTPQtU9PuXHpufRCtxVTsKSk--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
