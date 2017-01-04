From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 04/15] IB/rxe: Remove an unused variable
Date: Wed, 4 Jan 2017 14:29:18 +0200
Message-ID: <20170104122918.GO12077@mtr-leonro.local>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353498.3592.20.camel@sandisk.com>
 <CAG53R5WnJy1cLdEZOpzk03aAE2L6v86n_-qEBpoaG+arymCxPw@mail.gmail.com>
 <1483526210.3048.6.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="hABqaeELJqnDDeDE"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1483526210.3048.6.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--hABqaeELJqnDDeDE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jan 04, 2017 at 10:37:07AM +0000, Bart Van Assche wrote:
> On Tue, 2017-01-03 at 12:39 -0600, Parav Pandit wrote:
> > Additionally, since struct rxe_send_wqe is not used in get_mtu() function,
> > Can you please update signature to just have rxe_qp* as input argument?
>
> Thanks for the feedback Leon and Parav. BTW, feedback for the other patches
> of this series would also be welcome.

I will try to do my best.
Thanks

>
> Bart.--
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--hABqaeELJqnDDeDE
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlhs6p4ACgkQ5GN7iDZy
WKeLfhAAwN6I8KsrjzEdWc0ad4Z80oNMMp86L1KBneYZyDBWUCA3k/A7Hmc+YwD2
1BK9EVoiEvYd+iOcXshUgORW9F11OOeft4ZckhPWrm1eKC0SVC0Q9UlpPNiicKh1
mG807ArBOh3fAiaHHYI4CRNCsb5YtYQnKSTC5CC1Hc8WEmF/Ywqb9S9q3NAPKpC8
s/wy8i6TgpebfV/lj7cwsjF40MC3RULIOxCFjQf5a/PtVvwH3Dvg4Gom3hd/lXoh
AK+lRGsHyWxmFswX6H5zVa1k9H5gimIIMEcbo59X3bskn3/BrySRCTwYDDmNKL5L
F0Hci0hFC81XepP3DfpLc9wrbg+XAz80e5OluZ42OphiMxgMv9OuWneEb9uifK0c
zt0IMKWiwP+YFCXlmN3UfZzaij++s8kieewQDf/phqUHc5YJklABoIkz/QuaS3hT
aSReF1mYtzgSuVfgvY0DiHsKaHsDjGpeKSppzaA79gT4XrPxnmW5mFTcnMQ1qMc+
SdhbT12nh1mbrlICbKAXU1u6gWFZeImnZFDx4jLkdLCCl6uoGuuiwDNI+nw9S7wk
EDrQeW2hseGL4f9DILjtm5lqnopzoZgpKZtdatvHdn20lFJGrhbv5XK7ZnVhRvJ7
9Uw97SJ33URuBSM6odtSwarVGZ+HcUoYKV4Q7hHhX9s5HmOGkZA=
=yn8s
-----END PGP SIGNATURE-----

--hABqaeELJqnDDeDE--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
