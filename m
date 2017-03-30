From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: Extend LID space in InfiniBand beyond 48k? Is this really
 possible?
Date: Thu, 30 Mar 2017 07:04:09 +0300
Message-ID: <20170330040409.GL20443@mtr-leonro.local>
References: <b9531f99-c350-3985-edae-296b1bc97509@simula.no>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="n83H03bbH672hrlY"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b9531f99-c350-3985-edae-296b1bc97509-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vangelis Tasoulas <vangelis-S8y2klWGCOFhl2p70BpVqQ@public.gmane.org>
Cc: Linux RDMA Mailing List <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--n83H03bbH672hrlY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 29, 2017 at 06:07:47PM +0200, Vangelis Tasoulas wrote:
> Hello,
>
> I was reading a year+ old article where Steve Scott (CRAY CTO) was
> interviewed here:
> https://www.nextplatform.com/2016/01/08/cray-cto-connects-the-dots-on-future-interconnects/
>
> At a certain point Steve mentions (or at least that's what the article
> claims):
>
> /InfiniBand has another limit in terms of the number of logical IDs, or
> LIDs, it can support, which is around 48,000 end points, and for the
> most point, people have stayed within that limit. There is an extended
> version that has some higher packet overhead that can go to higher
> scalability./
>
> Is this true? Is there any reference that one can point me to for the
> part of the "extended version that has some higher packet overhead that
> can go to higher scalability"?
>
> To the best of my knowledge, there is no extended version defined in the
> InfiniBand specification. What is mentioned is that /The unicast LID
> range is a flat identifier space defined as 0x0001 to 0xBFFF./

Right, there is no any extended version of that spec.
As far as I know, Intel's OmniPath technology is marketed as new and
extended version of Infiniband [1], so it is probably that he referenced to it.

[1] http://www.intel.com/content/www/us/en/high-performance-computing-fabrics/omni-path-architecture-fabric-overview.html

>
> Vangelis
>




--n83H03bbH672hrlY
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAljcg7kACgkQ5GN7iDZy
WKd4BhAAh2fzRhAOJIbz5sHslXj2zYMe8HWdZT1hV4XqHJ48rIdvL9JB1i+ICjX9
fc1guOkttsUDz0tUgSC/fdCVxj6xW4I4pWMUndy0khRCKGzvcDBWvCc5wl7IIB95
ntZmum16HWgiPZ/Q75d8ifqkAwkeI535IHKlCs/Mb1pGl1T4QNWtyuIYmB7A4Fda
Bb4BiwzYyKHTQa24TxYt6fAcSqu5/J+4OsoDVlZ+cVJ+UAQBw+2t9FUZZD0csbuf
vQBk+afw1t1o3vyPvDYk+idBskmCLwSmxN+Hv+uvMB7quCCG59YSMS/YPG3PGL6l
NexW/JpTy19tWwjE0mhssekzaJwjFQrTmmaHr5E4+3ovg9rYKuNVY1yLgF25aaWn
9HzQ4nVwdQTJMVtKj1YrFi9f4LiAqbj1DzPTisXeCCRYqiPb+qUYq6n080hYR9j4
4OpHgKl6MFCK8xolK5RlALI8qz6DCaAIwnK8gr66bbIUx1PsDsYtIE5rzyGwNY9Q
74OtE0wypa4jHrYpkX7TDJSKGW8sndHYPmc1n3VMJgS5LUlBOkm5e6i2z4QIuHzf
os7rvoZ1K24fE1tUzyKZ+GGTOTadKHQq3R6jB2bsEsi+GHgJP/kRqsflRgV2RqFx
ARMwoeEFcUE8fZ0faRNwc9Upj1FCSAn3BUy5v463yW6l4bPzVSc=
=7tPK
-----END PGP SIGNATURE-----

--n83H03bbH672hrlY--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
