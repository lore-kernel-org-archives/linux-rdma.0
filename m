From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: multipath IB/srp fail-over testing lands up in dump stack in
 swiotlb_alloc_coherent()
Date: Tue, 14 Jun 2016 15:08:33 +0300
Message-ID: <20160614120833.GO5408@leon.nu>
References: <19156300.41876496.1465771227395.JavaMail.zimbra@redhat.com>
 <2d316ddf-9a2a-3aba-cf2d-fcdaafbaa848@sandisk.com>
 <20160613140747.GL5408@leon.nu>
 <946373818.41993264.1465827597452.JavaMail.zimbra@redhat.com>
 <887623939.42004497.1465831339845.JavaMail.zimbra@redhat.com>
 <450384210.42057823.1465857004662.JavaMail.zimbra@redhat.com>
 <1964187258.42093298.1465869387551.JavaMail.zimbra@redhat.com>
 <11e680c4-84b3-1cd6-133c-36f71bd853d0@sandisk.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Sr6hGnsCY8KeifOY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <11e680c4-84b3-1cd6-133c-36f71bd853d0-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--Sr6hGnsCY8KeifOY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 14, 2016 at 11:24:28AM +0200, Bart Van Assche wrote:
> On 06/14/2016 03:56 AM, Laurence Oberman wrote:
> >Tracing [ ... ]
>=20
> Hello Laurence,
>=20
> Can you try to set the kernel command line parameter swiotlb to a value t=
hat
> is a multiple of its default (64MB), reboot and see whether that helps? S=
ee
> also Documentation/kernel-parameters.txt in the kernel tree.

Do you think that 64MB is not enough for this scenario?

>=20
> Thanks,
>=20
> Bart.
>=20
>=20

--Sr6hGnsCY8KeifOY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXX/PBAAoJEORje4g2clinQtYP/1g3RoO1pcRNQpyXipPBdGz6
qC6fqh6TEsLmeCbpubiPUqPDBfR8ZpNTMqPJNQ0dprzjtvijoLU0egz29N2aN2EW
soal1MENXU+vvGw3EDJrxVArvwOgkQ7etgU8hbWjvrD62io+oFdV13Qvmc+/O7h4
ZkCNbsGmgwJYa6Cx39hXPRei8vKS6s8jzIN0VmYCbZBRWJMIwuZWv0oVg+vQCmQK
Hnxn4Hiq6w2ZYdio26dIoYDl+sPYBxHHEKr+kernIOdMVhOzEIpA4JMVZmeV75d5
iZZv/+3GoSC+0vwu9+oHaND0mlIY6ltGJOnXbPnWWZQUwxMvVhOZP35dqcqypyjX
Em1J2yz5fCFY3ZAajOauYCCq4ESh5SPV5HvmzbPHt6BEws7dJvFbDtPGOlcc2j1i
5bJpojPw+9oeYhNaLDfGGBKbrx/w8ZA62uHqTV96IrlLPCiQ76iZoJ6IzBaIZrL+
gIWoMDuC4CqI+TqylkJgruLmJQbkQtkzXkJ34Y8LrWwP4gW0HxOIKfi0ZakBwjy8
4Au2rlksbFUSdUQ2F47TXLALXf2UQvWlQNvMFVcMz0G0vVkUpW2X4uzZ07OFLvBh
5sQCabziBUl40nCjAG4k9l8p9luYu7ooRn0+q0DGii+UGF95FZhxCSv9hFoaXbGu
dM8C9dKUSeCOWic++uk0
=4jr7
-----END PGP SIGNATURE-----

--Sr6hGnsCY8KeifOY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
