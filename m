From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH] RDMA/bnxt_re: report vlan_id and sl in qp1 recv
 completion
Date: Wed, 8 Nov 2017 09:49:44 +0200
Message-ID: <20171108074944.GQ18825@mtr-leonro.local>
References: <1510119893-24676-1-git-send-email-devesh.sharma@broadcom.com>
 <VI1PR0502MB3008145309EC3989B23415CED1560@VI1PR0502MB3008.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="Wfe1KbQWcwuymTys"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <VI1PR0502MB3008145309EC3989B23415CED1560-o1MPJYiShExKsLr+rGaxW8DSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Devesh Sharma <devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--Wfe1KbQWcwuymTys
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Nov 08, 2017 at 06:27:26AM +0000, Parav Pandit wrote:
>
>
> > +static bool bnxt_re_is_vlan_pkt(struct bnxt_qplib_cqe *orig_cqe,
> > +				u16 *vid, u8 *sl)
> > +{
> > +	u32 metadata;
> > +	u16 tpid;
> > +	bool ret = false;
> > +
> Large number of places reverse Christmas tree reverse order is not followed, but let's try to follow for newly added code  like below.
> 	bool ret = false;
> 	u32 metadata;
> 	u16 tpid;

Reversed Christmas tree is a netdev requirement and not other subsystems,
so it a little bit too much to request from the people to do it without
actual updating CodingStyle guide.

I personally require it in our internal reviews to ensure that every
patch can go through netdev if needed (for example shared code) and not
because I like it.

Thanks

--Wfe1KbQWcwuymTys
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAloCtxgACgkQ5GN7iDZy
WKesshAAjYeMEZuMnzK0qHMZSA8/4c5QPbh/pYXpbo0Um3koUoEE16bsWUOZosTf
GyIMQl9Ry0+QgFSkBGqVVvRfU+AaosrkScXScKer21KWFo+Lsf1Xq1PvyMIjph8k
XSe2zPZ8MthH5XMcNHXtozIV3aDOWgbzCdqEPoMkM1p1G+wGGByAUIgJz6Xv5qof
KsQgDwnd5CZXc1znhkGWOgjk7z/vwjcnFMdDDZSqZlxTuJQFcPrsLXYiR6zX/2wC
9uxdyMVodftEst6oZ/o+aU/Bhx6w7/GFh6VUprLDtoTlD60xSeEw5s4IWxHUfngA
uvwZlykwQgOGcoJb/7trXMbkic01kHc5qNggLtB8IG7APYCUfaKW+SvSuoSjYEjM
ITIZFoRp3P7Tou6EfKpBq7qHStQtv2xIGzCKvuIkqrcN/81FD7HAOIzoe0ysJLWn
0d2yloqfLhus9g/pQ9+faPIAQxwg1ZuWa9gSV1tggmMBJUQsiHFL4bcjp9pEa4hY
MCywgffLfsd1PwG4/k5oLVWwiBMz6YhhG04QfCOe2mMHmnSa/jevEYBlNszK2lMF
MAAHHrUjzVkun6AZNfMTehyQRKQWd/pRmFPqiXtvWhz0yg1Iyg2HCaxjEiI+h6i8
pAwia3dQBN2c4W4OE/zmNjDWpTGM3WkLf1lHvXi565Mase0r5eo=
=UeHm
-----END PGP SIGNATURE-----

--Wfe1KbQWcwuymTys--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
