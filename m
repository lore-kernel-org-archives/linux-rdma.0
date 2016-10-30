From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-core] qede: fix general protection fault may occur
 on probe
Date: Sun, 30 Oct 2016 22:50:26 +0200
Message-ID: <20161030205026.GR3617@leon.nu>
References: <1477400039-16925-1-git-send-email-Ram.Amrani@cavium.com>
 <20161027140509.GH3617@leon.nu>
 <SN1PR07MB22076D8F67AB8C78A9565CB6F8AF0@SN1PR07MB2207.namprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Kuk/n493crKO4rgR"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <SN1PR07MB22076D8F67AB8C78A9565CB6F8AF0-mikhvbZlbf8TSoR2DauN2+FPX92sqiQdvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Amrani, Ram" <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Elior, Ariel" <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Kalderon, Michal" <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "Mintz, Yuval" <Yuval.Mintz-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Kuk/n493crKO4rgR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Oct 30, 2016 at 09:25:09AM +0000, Amrani, Ram wrote:
> > The rdma-core word in the subject is misleading.
>
> Yeah it is. The location of the code (qede) is somewhat different from the content (qedr).
> I don't know how you would have done it, but at least you'll see in a future patch that we've
> changed this  to be fully qedr.

We use "rdma-core" notations for patches intended to consolidated
library, while your patch is for the kernel.

>
> Ram
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--Kuk/n493crKO4rgR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJYFl0RAAoJEORje4g2clineOMQAJRljDr7yRKyIfsKlBRI1ezI
YcWYp2YEPUF140V9s3VmD4VAlseeOPPRsMr5q1PYMQET8DUSx/fyPP7lNwlhm4+V
Ll3yyje+0aT4ZUbx/M3e6RfqR4hG4lIWzALcPnIKmG3GA4FVcaPKyivenRDHsYzW
nFDzq3V9AokwcxQGgQcGQeJROx7lrZe7AX5Mu1bOK/Rr4flWsCin62ZDSt43SfcF
qTz2C9Hyx5HELDxP/w/6fTQuyl6pBdn+yFpWnnORsxYzO26XZb7myvw0EOKPlLu9
fNwUj3Q/eo8ea5CBhl/VmKSvRGSoNEADEwo627A9FuyUFFHq6ok4V8+7FRtLLLG3
C2K0+oY6BFajB3y+d/4bShc06MPguI+rG5GLVNzfEedHb20zO+XlbXlQSSHOq9hk
JDcxkSLdK6qUAnoj2jm2aHrmNwzWzXfqzd38nL1CJzsQL3xl9ZsjzpuqZJ9yd6Ce
l61mdthtQjrSpz4q5a77N3pl1RsQzenLcalyXeDXT7PYCi46YOftEZCGdV0Nmwrr
o3t6cO+dEp8C5Ken4y/QhgFDDJDPii7WuSK1PmOwDzhNDn43CJe4glMY3ZVPoyrc
HemtD9W/LNU0Cp/yAIAVcDIW0XOqgf1F2+GSRzjhcwmygmExAVAolidcwTLy7rOu
Hs2D91qz5lrL17wtRMSH
=cwDw
-----END PGP SIGNATURE-----

--Kuk/n493crKO4rgR--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
