From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/uverbs: Fix race between uverbs_close
 and remove_one
Date: Tue, 02 Aug 2016 14:31:46 -0400
Message-ID: <1470162706.18081.27.camel@redhat.com>
References: <1467548899-21923-1-git-send-email-leon@kernel.org>
	 <1467548899-21923-2-git-send-email-leon@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-sZlo6iBgM+7Z/Nkxy2fB"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467548899-21923-2-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--=-sZlo6iBgM+7Z/Nkxy2fB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2016-07-03 at 15:28 +0300, Leon Romanovsky wrote:
> From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
>=20
> Fixes an oops that might happen if uverbs_close races with
> remove_one.
>=20
> Both contexts may run ib_uverbs_cleanup_ucontext, it depends
> on the flow.
>=20
> Currently, there is no protection for a case that remove_one
> didn't make the cleanup it runs to its end, the underlying
> ib_device was freed then uverbs_close will call
> ib_uverbs_cleanup_ucontext and OOPs.
>=20
> Above might happen if uverbs_close deleted the file from the list
> then remove_one didn't find it and runs to its end.
>=20
> Fixes to protect against that case by a new cleanup lock so that
> ib_uverbs_cleanup_ucontext will be called always before that
> remove_one is ended.
>=20
> Fixes: 35d4a0b63dc0 ("IB/uverbs: Fix race between ib_uverbs_open and
> remove_one")
> Reported-by: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
> Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

The only reason I hadn't taken this patch before is because Jason said
it was totally untested and someone (Devesh in this case) needed to
test it to make sure it resolved their problem. =C2=A0I don't see a test-by
line here, so has this happened?

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
              GPG KeyID: 0E572FDD

--=-sZlo6iBgM+7Z/Nkxy2fB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAABCAAGBQJXoOcSAAoJELgmozMOVy/d0ZYP/Rryg/UXNUc9aNahktMb6F8M
tREsimOZWVkmi4tw4xgi9e3pb5uE0ZR0RwoikxOJmlqCIje+gbkmM8fMC2QQ10Ip
9JQN7RKvfgFErc8yczXWRRDxbFiMBbLcGkBATBz3j1lM8YV+J16GHmerXjCZ0fjL
eWAPLhzR904ZbuZqkLQf25Zya/l5WdVsZQk9pmkz46woX/q75wBlp32ZoZ9UjVZm
Q3g8fHmucj9bwhPiPhSXCdka5hWSfAbF2Wuo11O+VWvtdy5rH9FgNKqNl81oeETU
JYN20y0NFsP0j3VnmLyAT1iKszXq80h/H4jWFsRfMHavDH/FQHZjgs/SXAV+vAd4
Ln+7D1VcK5rjMcWyuPknr6M9yJ7SGwCT/Qux5NhOdcywXV24oBCEzd3Qfi/sefGA
IEdkMd8FoKNboPDFaX2ryKPda1jjcufi2QS7b4OGOcMmxC5rOn3+7M2hcnCcLiof
c9P85Uq60wiTJoBGcMGIqO+AzkHLpSvg8AHMaqIOfU9VeTSXji7SYUFa0IYHYBwE
VeQBVYBN1YW1XB3nvG2Znec4h4eBfypUcsop7RCDiBq8kLlmfXJCvOcLOSWnmluO
fcpyvQMksKkP6GbC0ABSQQuAm+XMgyIXN4sCWgcE++rGqudKBboubS2Sh0KygGv1
FnRRk5zmy2+GQNr2/Upe
=vmba
-----END PGP SIGNATURE-----

--=-sZlo6iBgM+7Z/Nkxy2fB--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
