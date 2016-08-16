From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next 6/6] RDMA/core: Unify style of IOCTL commands
Date: Tue, 16 Aug 2016 19:50:41 +0300
Message-ID: <20160816165041.GA5489@leon.nu>
References: <1471355123-6227-1-git-send-email-leon@kernel.org>
 <1471355123-6227-7-git-send-email-leon@kernel.org>
 <1471357887.2661.28.camel@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="3V7upXqbjpZ4EhLz"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1471357887.2661.28.camel-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--3V7upXqbjpZ4EhLz
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 16, 2016 at 02:31:32PM +0000, Dalessandro, Dennis wrote:
> On Tue, 2016-08-16 at 16:45 +0300, Leon Romanovsky wrote:
> > From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >=20
> > MAD and HFI1 have different naming convention, this patch
> > simplifies and unifies their defines and names.
>=20
> I don't know that I agree that it simplifies things. It changes a lot
> of code for not much real value in my opinion.=A0
>=20
> Was this something that was discussed in the verbs call? I have not
> been able to attend that the last few weeks.

It was discussed over mails, for example Jason's opinion [1],
Christopher Lameter's opinion [2], Christoph Hellwig's opinion [3].

>=20
> > As part of cleanup, the HFI1 _NUM() macro was removed and MAD
> > indexes were renamed. It has a potential to break application
> > which use these defines directly.
>=20
> Why do you want to remove the _NUM() macro that Doug just put in?

It is not used after refactoring and IMHO this macro doesn't
belong to UAPI, since it wouldn't in use by any users, but I'll be glad to
get an examples of its usage in real user space applications (libfabric???)=
, if any.

>=20
> -Denny

[1] http://marc.info/?l=3Dlinux-rdma&m=3D146835080018352&w=3D2
[2] http://marc.info/?l=3Dlinux-rdma&m=3D146897679911490&w=3D2
[3] http://marc.info/?l=3Dlinux-rdma&m=3D146908844509592&w=3D2

--3V7upXqbjpZ4EhLz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXs0RhAAoJEORje4g2clinCb0P/RPV5IKypJGcDJSuqdyCdmt8
Q7JA9TQGAeHz4vKZ3JfiQMMyZWgoIBVbyt/IUCcgdFt2eujWbrbFCR6lf6LXRvEG
UavlzucZVUc8cBjbEUhev+YoNOzt9/qwV0Tx7mr1j4HZdkvJ0e2tvlCiGKzEYghT
e19vYajqjsazOFpixHBaw8gZ8LSGv9CBh0hXQl28KGpECLUgD0rdCePI1TdPkw4C
M93C4D7jkGqXdUL9kKBJE+OaYb4E22f2NxLjqsY4Q/jcN5NHMSD5Jla4TwTX+sbi
enMlJ+7Dz2G5i862ImvVD06lDG43tNUn9WhHxMey09LcvfLvxISgUndHj1F4wa1a
YwOUcDkRxCSmdeYtm9B6cbBOMNtT6D+Sd0/Rkk2UV4dzSvS63zBBYo2cKYS7+2t8
aV1ZkBmeqBZIhR/a63+Ie6oM1qwUMQHQafOJaD+BNCkJLdANXfI2vCswhxOU/9wX
qAykBZhtWLOXr/pUvlK0yRxTcpjh7Lxf54sbOJQl+S5nlfLva/BFAm7/qQzNz0Du
RtjkW4qFFeXBDtO3E6k3ywrzpSttQ9Cwdx4ny7yNIwBhaI88XiuH5/vruiUQTosG
d2j7c3mulwTSko9gMBgcNciu14cgdLohh6kusNkDQjB3JNEquIIgQvySG/iOIy+L
uRMM0N/QstivRdQLjhA3
=/Z+j
-----END PGP SIGNATURE-----

--3V7upXqbjpZ4EhLz--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
