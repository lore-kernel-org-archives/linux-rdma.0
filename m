From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH rdma-next v3-v5] Add OPA extended LID support
Date: Sat, 12 Aug 2017 09:29:41 +0300
Message-ID: <20170812062941.GL24282@mtr-leonro.local>
References: <1502476546-9367-1-git-send-email-don.hiatt@intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="RwGu8mu1E+uYXPWP"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1502476546-9367-1-git-send-email-don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--RwGu8mu1E+uYXPWP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Aug 11, 2017 at 02:35:46PM -0400, Don Hiatt wrote:
> This patch series primarily increases sizes of variables that hold
> lid values from 16 to 32 bits. Additionally, it adds a check in
> the IB mad stack to verify a properly formatted MAD when OPA
> extended LIDs are used.
>
> Signed-off-by: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>
>

<...>

>
> -/* Return slid in 16bit CPU encoding */
> -static inline u16 ib_slid_cpu16(u32 slid)
> +/**
> + * ib_lid_cpu16 - Return lid in 16bit CPU encoding.
> + *     In the current implementation the only way to get
> + *     get the 32bit lid is from other sources for OPA.
> + *     For IB, lids will always be 16bits so cast the
> + *     value accordingly.
> + *
> + * @lid: A 32bit LID
> + */
> +static inline u16 ib_lid_cpu16(u32 lid)
>  {
> -	return (u16)slid;
> +	WARN_ON_ONCE(lid && 0xFFFF0000);

It will print warning for first lid > 0
The proper lines should be "lid & 0xFFFF0000" (one ampersand).

> +	return (u16)lid;
>  }
>
> -/* Return slid in 16bit BE encoding */
> -static inline u16 ib_slid_be16(u32 slid)
> +/**
> + * ib_lid_be16 - Return lid in 16bit BE encoding.
> + *
> + * @lid: A 32bit LID
> + */
> +static inline u16 ib_lid_be16(u32 lid)

This function returns be16 and not u16.

>  {
> -	return cpu_to_be16((u16)slid);
> +	WARN_ON_ONCE(lid && 0xFFFF0000);

The same as above.

> +	return cpu_to_be16((u16)lid);
>  }
>  #endif /* IB_VERBS_H */
> --
> 1.8.3.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--RwGu8mu1E+uYXPWP
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlmOoFUACgkQ5GN7iDZy
WKdegRAAsJ0b2R8acZr/Aaq60DKj9sRedPnqVo+341b1jXLzM9g8TOGhEvokSQfE
lmnQnPk0ckZK1lBByiFqbm2jAxiseCLaUmBSQMnPtyhtsm8znLOSeTBpDyFXYiv3
Kdpnr4awqDGHSky9Nf7X91Y7i7xirwXIsH3jLk8NnKUx8uTHbgjoRmn3O/BFZWgW
NWzadOo3ZxnDgoK5kwwvQIUUqmVLZAcQOFkVcX+BlEqWo1U5FZM+bXiWpCOsgb0y
zVfKjraYYEMTSXCSoQl65LTAWLdk7TXckDHu+nXji9IojMJ/jKrwJpUok/wqAC5m
g2F4OImLn/gs741hI48E0lRsKS6aXUVSxO07p9Hi4n2uogAm5HN8rx4LSmo/wEYC
rnmNYPmc0sUB3RgBs2EbavVDihIQVpgx/TTIiUxe7XeE0YdG3uoOvIgxU/M41ms3
H+hW1SyjhKMla/diwUSr6E5Utnt1OzuASN6mvkN5HrJEqsPh91P6VMACzOfRdn/u
2bNHPVmJ9xtonZtC0AGuhBp/qFb5mSroBTYFm2PUzOYeAOs6AUsqU3Nc20ATuXPf
dIQKqMOIu3xmhJyx+eM0odFwWzKkojIqVeiRjce2W+f2319Kl+sPclEeXg1ztUVT
LxCHZXWWTD9PzpUpFNwZxWG1heZxK/V4D6ng4Rf94StjeRKODaQ=
=OGzC
-----END PGP SIGNATURE-----

--RwGu8mu1E+uYXPWP--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
