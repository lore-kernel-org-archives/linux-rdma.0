From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-rc 1/4] IB/rxe: Fix kernel panic in udp_setup_tunnel
Date: Mon, 5 Sep 2016 17:04:16 +0300
Message-ID: <20160905140416.GB21847@leon.nu>
References: <1473077359-11546-1-git-send-email-leon@kernel.org>
 <1473077359-11546-2-git-send-email-leon@kernel.org>
 <e0399c1c-567c-4996-a454-4ebefbe6e665@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="YYM4jLJxzFJ63wjS"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <e0399c1c-567c-4996-a454-4ebefbe6e665-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--YYM4jLJxzFJ63wjS
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Sep 05, 2016 at 09:32:42AM -0400, Doug Ledford wrote:
> On 9/5/2016 8:09 AM, Leon Romanovsky wrote:
> > From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >
>
> > diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
> > index 0b8d2ea..e0866b4 100644
> > --- a/drivers/infiniband/sw/rxe/rxe_net.c
> > +++ b/drivers/infiniband/sw/rxe/rxe_net.c
> > @@ -249,8 +249,8 @@ static struct socket *rxe_setup_udp_tunnel(struct net *net, __be16 port,
> >  	memset(&udp_cfg, 0, sizeof(udp_cfg));
> >
> >  	if (ipv6) {
> > -		udp_cfg.family = AF_INET6;
> > -		udp_cfg.ipv6_v6only = 1;
> > +	udp_cfg.family = AF_INET6;
> > +	udp_cfg.ipv6_v6only = 1;
> >  	} else {
> >  		udp_cfg.family = AF_INET;
> >  	}
>
> Is my mailer displaying this wrong, or is this hunk just intentionally
> introducing indent breakage?

You are right, it is unintentionally. I'll repost.

>
>
> --
> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>     GPG Key ID: 0E572FDD
>




--YYM4jLJxzFJ63wjS
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXzXtgAAoJEORje4g2cling6cQAJkmB2cNQegLc0hnRMMUqKjJ
1ZBBOfYe9cgl0oIRdjBA8J7js22aAjj3bo6LOTO+LlQqzqRkDvu3j/SveFlO5oM1
1TIJ8IrdMGNNTsMoo1LJg6Z2xCEacgHeCB+yi5R+44Ej8CusK110CZGHB39Fd8Rc
NceK8ivHxwIJyR0Zeixaadudo/6DH1a2cMNNsImGVc/nJUicrwn1FhHTL9oZMg+W
nXJC++QWdhmaJDe1z4ZmEyxm5S5vmJAKslMHLADj6VxcM5pXuTDpuq0If1ORoEbV
DzP6yN/MUNGB8fvjwDiSWYfSwxW++BiVAxc26qgc2qfVk+1hkQyX1DgbFR3+iLow
szRiGsbPOtRu9Pr+ro8EF/DH5IJ9lBsyF2SD8jgQ3KrpiUc9Nv7d+d0MjoCvGkv4
3v3FwJ0QxgNmpvMf1Rj/RvK7p1Eg651GP51HJtaCvc5oyMPA+CN50tgCNVuvsi3d
MUkfbb/DIEQr157Zc4XYWkvTG6csR6wEeTVqW+l3lRBzNwS0Dm6sYGbv7sF4t/UJ
8lkFEEAeWuJYpWWgyIqVbKA406pikriwEi7kOA6ByIlJuRrjntiaSJOW/v+BfQKL
7kUtHFuIfSrTLN2pl3JCJbRyEUn2yrCubmlSlb+jykxHeoGcupiRb0VdNSVpDiJE
HDlXIv2MGAKygsqePMxE
=d3+3
-----END PGP SIGNATURE-----

--YYM4jLJxzFJ63wjS--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
