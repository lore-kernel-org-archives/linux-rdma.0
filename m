From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Prepared RDMA Tree for 4.7
Date: Thu, 12 May 2016 20:47:05 +0300
Message-ID: <20160512174705.GC11827@leon.nu>
References: <20160512174406.GB11827@leon.nu>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XWOWbaMNXpFDWE00"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160512174406.GB11827-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--XWOWbaMNXpFDWE00
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 12, 2016 at 08:44:06PM +0300, Leon Romanovsky wrote:
> Hi Doug,
>=20
> I prepared the base tree [1] with patches sent to RDMA mailing and passed=
 review.
>=20
> This base tree is part of linux-next and kbuild system, and it passed
> sanity checks.

Forgot to mention that it based on v4.6-rc7.

>=20
> I believe that it will save you a lot of work and time if you use it
> as a base for next merge window submission (4.7).
>=20
> The topics which were added:
>  * topic/fix-core
>  * topic/hfi1
>  * topic/i40iw
>  * topic/ipoib
>  * topic/iw_cxgb4
>  * topic/iwcm
>  * topic/nes
>  * topic/rdma-rw-api
>  * topic/srp
>=20
> [1]
> Git repository:
> git://git.kernel.org/pub/scm/linux/kernel/git/leon/linux-rdma.git rdma-ne=
xt
>=20
> Gitweb:
> https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=
=3Drdma-next
>=20
> Thanks.



--XWOWbaMNXpFDWE00
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXNMGZAAoJEORje4g2clinecMP/i6qZkxcrUKphaLKVQRTrN+w
7Vg5nyCm0kJ2NeYJgjbfpAxYqU7nSrfwEgUba3JyaUxS55g5TNhMEosA90EyImSF
5AKGSwN8KvSB/zUSzc3WUUSxtabzIthtlxOu0njY6l+hL0t5YEQzKqD2SH+ux5fd
qILKKpQj0pvb3jwxlEO+o3rPhxizR0IfWOxvynLEmN73HYA2f7H89TZp52kFm57Q
bOKRXkNltBW411JtEqC86rLZRvxr8VgoA4wsyBrrHLrygLUOKP81z54rYkRZ5lkj
0zBDXTLCJ6gcPIgfCHYCMu/v4pmzkVgWvcOIvWiUyt9rhxWBo/0XjESI/gPH8PBo
rq278cNriO5LO4+8heFJpd9PyTr5rZTdkGL2QAG78iYeJJRrjeT5iMO+2I1A9PBm
sYzUwNWCuX6pYrxcTknS0LCpzvYXsrp3A6C0ODyd2dlARSTGO6srjcxYd3mXQsUr
+B7rrOh7vkhXUy/Kv5vqWD16b5CNgokH6K9VxMP+8jUyJCVD/9ymLAkdcTyWYfDe
VeePysAtn6jwZmHmGSkgdAmRr+0FVoaQFL9+LswH/JmkYcF5RFn+fVtZHSMM5cOH
nfmDD1xBe2heNROW1WoD8lp7inWuXgN2wtyUzhmrcMPF8O1di2XEuKKrWKUpLDat
y2yv7DHnQSzUTayvRCed
=/Ko2
-----END PGP SIGNATURE-----

--XWOWbaMNXpFDWE00--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
