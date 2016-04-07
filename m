From: "leon-2ukJVAZIZ/Y@public.gmane.org" <leon-2ukJVAZIZ/Y@public.gmane.org>
Subject: Re: [RFC PATCH v2 09/13] ib/core: Enforce PKey security when
 modifying QPs
Date: Fri, 8 Apr 2016 02:24:49 +0300
Message-ID: <20160407232449.GB20252@leon.nu>
References: <1459985638-37233-1-git-send-email-danielj@mellanox.com>
 <1459985638-37233-10-git-send-email-danielj@mellanox.com>
 <20160407163100.GA5808@leon.nu>
 <DB5PR05MB11113874870EBBE896E0D601C4900@DB5PR05MB1111.eurprd05.prod.outlook.com>
 <20160407211056.GD12844@leon.nu>
 <DB5PR05MB11115DF816F6CEAD7738201EC4900@DB5PR05MB1111.eurprd05.prod.outlook.com>
Reply-To: leon-2ukJVAZIZ/Y@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="WYTEVAkct0FjGQmd"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <DB5PR05MB11115DF816F6CEAD7738201EC4900-8IvNv+8VlcBJTpKhoUy7I9qRiQSDpxhJvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org" <selinux-+05T5uksL2qpZYMLLGbcSA@public.gmane.org>, "linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--WYTEVAkct0FjGQmd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Apr 07, 2016 at 09:23:04PM +0000, Daniel Jurgens wrote:
> I can change this patch to the common flow above, and then introduce "my
> flow" in the patch that requires it.  Another option would be to squash
> the two together.  They are both relatively large so I am hesitant to do
> that.

It is up to you. There are two things which you can take into account
while doing it: correct code and easy review.

Thanks.

--WYTEVAkct0FjGQmd
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXBuxBAAoJEORje4g2clinlu4P/2LYqVE3MLRZT+x9gjTFYwQS
22IBviafL/8mAXeORtE6Z4yMdaQ3eHhviBJ3j//t/byW9hS8Nn7cpD77Qpwsvdy5
cjoS36MwHK+6vWZJqeMsJl1hbSgeZkt+/yjQuB3sHZGK3jIt6Yp1Ksy46OpkZnH/
+W7YRB/Yw/RfesxkQCdSH11dtniIXQgvUCblofjWngKig7LyAkBP1krEkMpTFZI1
dcBKKTz0tF7W0HbQWx7LAAeRWJ22WZZ1tSlhZKf/Mr27LspWeesWGIQd7tc+dL8l
+K/xBQXIQ0yXbIw/puwfKX9cUYrdUZh+xVzecmTCG3W07w53iujoHTEth2EnQTHh
AAwT3WsMFjGU9hWy+u412X4DBDmUo3Q/7mEylWL9seO2ekhLyQCga+hj74hEBNXX
1flkTa5Ed7NwlEXIZwBSfYpTedGNbJL2E8Vvle6dY4tRHGLJc+iEQgOfceJJENDw
TOC6x7N7pEgvSavH4M5tZFv77xseyzzLRD2jcF1MtEZ63GmCv/AJtzaX5DIi4Nod
hmHPyTCOwZsS97ipTqdvRKDLLGqS9KVkT4/Nsyf2nZYiVo26TxzAssP0V9hVkkQT
qOxSCOFJb6TgYYNlHSYRxoEp0YlfugLiN5Pgfe8Mobwi5B0Pw8I73Wm9rm6snjxi
/9MMM0h2EjhyCTznB8Kg
=cnkz
-----END PGP SIGNATURE-----

--WYTEVAkct0FjGQmd--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
