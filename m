From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: consult//Fwd: [RESEND PATCH v7 00/21] Add HiSilicon RoCE driver
Date: Fri, 13 May 2016 22:32:21 +0300
Message-ID: <20160513193221.GF11827@leon.nu>
References: <1462849483-67927-1-git-send-email-oulijun@huawei.com>
 <5735B5D9.2030903@huawei.com>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JcvBIhDvR6w3jUPA"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <5735B5D9.2030903-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Wei Hu (Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: jiri-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, charles.chenxin-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, haifeng.wei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--JcvBIhDvR6w3jUPA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 13, 2016 at 07:09:13PM +0800, Wei Hu (Xavier) wrote:
> Hi leon, jiri, ogerlitz
>=20
> We developed the driver for Hisilicon RoCE engine referring to the mellan=
ox
> driver.
> Now we want upstream the driver to kernel to support our hardware.
>=20
> Maybe we should  declare this code refered to the mlx4 driver in the
> beggining of the code file.

It is known to reviewers.

> Can you give advices? Thanks

I suggest you to ask from IB maintainer (Doug Ledford) to review this patch=
 set,
at the end it is his decision to accept or not.

>  28 files changed, 10539 insertions(+), 16 deletions(-)

--JcvBIhDvR6w3jUPA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXNivFAAoJEORje4g2clinbmwQAKtDr9nh5MUXOIFsK/4kBSs/
UjXGA+D+gvL4r5Nw3A8GYM2c6ohxkhXvaGy1No7Z8FrHpf0BHXKGFl45fLvxwLFx
M6UDqYIGeUJDVww4cc1gsUpHIrUVw78oj4gAsmfNv1VmFS10EugOGp3VwlR+j+MS
flPh0AMcEXf9ZtZi0Z/u6x4IBbW7trWFYcVgnIfMU3RD4lN8g+7PkuIDLib+vAB7
9NHi1ToyeBRJSgchh5Srnqchu3kBmeY/cg+ANmTDz/MsOPPmeW21lb8BovM/FlN3
Hah8x/zxqEu3ye0PpapkhH5FEIDFk5wzMzWdC2o/IvY2kktWGIHs2LKkg2zizY+9
REmO3xrQgrjHKysiyzC1aqT84vZgPoOINvzQ8cFFUeYSMuA7BOeXqCEyqAttKMbu
N5AyqM+iyuT+Q8Rn/LCYWcCCAP2QCkDMlJJo7rk1DSgEtPLLgv7VSBh0fl0baJMV
NsI50uX5KXiBNLJ81xMCPg5N8FZ80LvBm3sE9o5oMUTx37hMWRGZn8BWm1v2yLtO
0xMsYBNfH7owoAl8nicULysrNcLr0BBG53iQg0Dqz9ZKtG8MLA40VxlEq/mpnXp9
pwHJYjVouC/o1JMFLRhcmD8ghNuT86LCuBuQOe2NBO4CeF7Tweg7rk1sa+lHPY/h
nZ5RcX35BMcYEVct4hJg
=feYS
-----END PGP SIGNATURE-----

--JcvBIhDvR6w3jUPA--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
