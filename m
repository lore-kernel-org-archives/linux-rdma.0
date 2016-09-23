From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: move unsafe global rkey handling to the RDMA core V2
Date: Fri, 23 Sep 2016 13:48:01 -0400
Message-ID: <060990ad-7937-ad43-f1e9-d807b62049c8@redhat.com>
References: <1473072981-2035-1-git-send-email-hch@lst.de>
 <20160919155459.GA5547@infradead.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="abBv3aEvcq9FxruRk7I6dVbGwx0R762SL"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160919155459.GA5547-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--abBv3aEvcq9FxruRk7I6dVbGwx0R762SL
Content-Type: multipart/mixed; boundary="P949l4bQgAM8htXNM71iNm9TxQeVF5ncT";
 protected-headers="v1"
From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Message-ID: <060990ad-7937-ad43-f1e9-d807b62049c8-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: move unsafe global rkey handling to the RDMA core V2
References: <1473072981-2035-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
 <20160919155459.GA5547-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
In-Reply-To: <20160919155459.GA5547-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>

--P949l4bQgAM8htXNM71iNm9TxQeVF5ncT
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable

On 9/19/2016 11:54 AM, Christoph Hellwig wrote:
> Doug, any comments on this series?  I'd really like to get it in for
> this merge window.
>=20

Series applied, thanks.

--=20
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG Key ID: 0E572FDD


--P949l4bQgAM8htXNM71iNm9TxQeVF5ncT--

--abBv3aEvcq9FxruRk7I6dVbGwx0R762SL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBCAAGBQJX5WrRAAoJELgmozMOVy/d3roQALTS87H87gKOHq25jkbv3hwQ
lRu4k+znF04A4vx4FSqH73JO+++mclArEjh5cyp2uC7TYWX3/lvLKjKPTvwKNeX+
R0al1E/aQiIphOM+d+td81eTwDVCE0bMQ4buag/DCh6RKiaFtPUgKXV2jDZATrx4
DX00DVAgqfRasgoFdMwLSpiUxaZ8EIcKdclrXMWDS9ddkK0sIL0JoFkNNThJyXyI
TZW0Ldj2Ft2WKEXswOKonzVwq1CXU/PtLJPOUbw8UwlpoSJLr1UKLcTPUhHDI1oF
wxz6AU+u+f+AZlb9BPzgZkJa2a1hvBYyHj8xitwJGUS7i4ekY8TSYwjFc+vGGrsK
kZbuJ7vfkkhxbqC2FDLEkFSLS2hRJscga+cZLD6VEXmhqEWpNEEhhIP6xSY0EFpL
nTWoK3LoXXebI/K9uiK50vaQCA3WHtgv++vK+ALHt+jQlYyFs2olPmN7D3fsAW7X
1yTcGKlXTjCnorTuohS4OXwxK7u0S0Cu8maE0z/R+0yzNX92wqH0qeKTLT6bt8fK
FHMm3KGbaRyfVEmqlL7YXaI77fvHRGsgIP5pP6Ee+2PEulbo7zx6leoiG2W4yp+c
deou1A+eZRH6sgMSDzzn5s7w8/HElmI9e+7eC3PmLT6A4P9/Cb43kWEVeYpyMcun
i9s65Mc8yGQyOIi+h4TN
=twiM
-----END PGP SIGNATURE-----

--abBv3aEvcq9FxruRk7I6dVbGwx0R762SL--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
