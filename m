From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [RFC 5/5] verbs: Tag matching receive interface
Date: Tue, 13 Jun 2017 09:34:22 +0300
Message-ID: <20170613063422.GI2576@mtr-leonro.local>
References: <1497249767-15353-1-git-send-email-artemyko@mellanox.com>
 <1497249767-15353-6-git-send-email-artemyko@mellanox.com>
 <20170612164206.GC12282@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="v2/QI0iRXglpx0hK"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170612164206.GC12282-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, anag-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--v2/QI0iRXglpx0hK
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 12, 2017 at 10:42:06AM -0600, Jason Gunthorpe wrote:
> On Mon, Jun 12, 2017 at 09:42:47AM +0300, Artemy Kovalyov wrote:
> > Extending poll_cq with tag matching support.
>
> > +static inline void ibv_wc_read_tm_info(struct ibv_cq_ex *cq,
> > +				       struct ibv_wc_tm_info *tm_info)
> > +{
> > +	cq->read_tm_info(cq, tm_info);
> > +}
>
> This series has no man pages.
>
> Every single new public API needs corresponding man page updates.

It will.

Thanks

>
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--v2/QI0iRXglpx0hK
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlk/h24ACgkQ5GN7iDZy
WKfoBg//dGQbU0y1Ut1E0arJv1UunmHfBjabx+BjjV8GDA8v2vpiE+qkewz5yYFc
N0xZvtsfvZ0YLawJPRkwL+NRBjRMKFu2IZp4ugeR5SbTnixGz/7XaZAIkCmFycB+
TiYlnZR57QM6EM5zIs3Mj/upkqWJhpKhFRcKYB2rA7rKVLnRztGD7B6vUO/dwzA1
sHcNwByjfuHCJzgwQ3FlymHB5p6rpPmfp8Q26V+qHYIUj//WW0XZgIsDqu9/MFBO
cqKzo1dG16F4g+o71vd2kaZDI0kCFKmnEls1/r2p4SiHmMwV9FfEtdUz0r3m5JT5
cTsEK71OhyGx3argzaF9H6rnDjTAYa4t31bKbQwI2e7ZHbLDRlrpQPbv2XKB6ve0
FoIoQdkFxeS4voKjLjF1ptwlhXuP4/+Ljjww9n0wEunrn8Vif7aDCm3g+xD4EsL+
PtgxZqVu9gRkMD0bfNFHSzXXg+BUviPyRxAgl3BmbkUNYD57JmZ27oCH5AZ/Lb2X
V1X5oPRCUx3nnca7L/eDLQHAjuvsg2WRK/dYxNxp7OCNp7kYGm79QfCBAxM3v3cg
UerRVWCCeTF6V5EZJRveNECYqnZytPXFWQgt7EzKyuyaPtX6VzTbB1K9GZYzjgLA
j4cQ46aenDhwy6LTWA/RlSjVKOBHxsejsviiZ7bG8im3mUJB3+E=
=OgnT
-----END PGP SIGNATURE-----

--v2/QI0iRXglpx0hK--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
