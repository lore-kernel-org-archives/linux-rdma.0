From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: RDMA Read: Local protection error
Date: Thu, 26 May 2016 22:23:51 +0300
Message-ID: <20160526192351.GV25500@leon.nu>
References: <57238F8C.70505@sandisk.com>
 <B72A389F-FFF1-498C-A946-8AA72B7769F8@oracle.com>
 <57277B63.8030506@sandisk.com>
 <6BBFD126-877C-4638-BB91-ABF715E29326@oracle.com>
 <1AFD636B-09FC-4736-B1C5-D1D9FA0B97B0@oracle.com>
 <8a3276bf-f716-3dca-9d54-369fc3bdcc39@dev.mellanox.co.il>
 <aaa67d51-663a-0aba-fc54-a5ab5d947a55@sandisk.com>
 <C0AE237D-5E5A-4F94-B717-F3A3B4B4D4A8@oracle.com>
 <574728EC.9040802@grimberg.me>
 <57473025.5020801@grimberg.me>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CSNFvL6ilyiKL/Hs"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <57473025.5020801-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--CSNFvL6ilyiKL/Hs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 26, 2016 at 08:19:33PM +0300, Sagi Grimberg wrote:
>=20
> >>>>>When debugging is disabled, kzalloc returns page-aligned
> >>>>>addresses:
> >>>>
> >>>>Is it defined some where that regular kzalloc/kmalloc guaranties to
> >>>>return a page-aligned address as you see in your testing ? if so the
> >>>>debug mode should behave the same. Otherwise we can consider using any
> >>>>flag allocation that can force that if such exists.
> >>>>Let's get other people's input here.
> >>>
> >>>My understanding is that the fact that k[mz]alloc() returns a
> >>>page-aligned buffer if the allocation size is > PAGE_SIZE / 2 is a
> >>>side effect of the implementation and not something callers of that
> >>>function should rely on. I think the only assumption k[mz]alloc()
> >>>callers should rely on is that the allocated memory respects
> >>>ARCH_KMALLOC_MINALIGN.
> >>
> >>I agree. mlx4_alloc_priv_pages() is carefully designed to
> >>correct the alignment of the buffer, so it already assumes
> >>that it is not getting a page-aligned buffer.
> >>
> >>The alignment isn't the problem here, though. It's that
> >>the buffer contains a page-boundary. That is guaranteed
> >>to be the case for HCAs that support more than 512
> >>sges, so that will have to be addressed (at least in
> >>mlx5).
> >
> >rrr...
> >
> >I think we should make the pages allocations dma coherent
> >in order to fix that...
> >
> >Nice catch Chunk.
>=20
> Does this untested patch help (if so, mlx5 will need an identical patch)?
>=20
> --
> diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h
> b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> index ba328177eae9..78e9b3addfea 100644
> --- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
> +++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
> @@ -139,7 +139,6 @@ struct mlx4_ib_mr {
>         u32                     max_pages;
>         struct mlx4_mr          mmr;
>         struct ib_umem         *umem;
> -       void                    *pages_alloc;
>  };
>=20
>  struct mlx4_ib_mw {
> diff --git a/drivers/infiniband/hw/mlx4/mr.c
> b/drivers/infiniband/hw/mlx4/mr.c
> index b04f6238e7e2..becb4a65c755 100644
> --- a/drivers/infiniband/hw/mlx4/mr.c
> +++ b/drivers/infiniband/hw/mlx4/mr.c
> @@ -278,30 +278,13 @@ mlx4_alloc_priv_pages(struct ib_device *device,
>                       int max_pages)
>  {
>         int size =3D max_pages * sizeof(u64);
> -       int add_size;
> -       int ret;
> -
> -       add_size =3D max_t(int, MLX4_MR_PAGES_ALIGN - ARCH_KMALLOC_MINALI=
GN,
> 0);
>=20
> -       mr->pages_alloc =3D kzalloc(size + add_size, GFP_KERNEL);
> -       if (!mr->pages_alloc)
> +       mr->pages =3D dma_alloc_coherent(device->dma_device, size,
> +                               &mr->page_map, GFP_KERNEL);

Sagi,
I'm wondering if allocation from ZONE_DMA is the right way to
replace ZONE_NORMAL allocations.

I don't remember if memory compaction works on ZONE_DMA and it makes
me nervous to think about long and multiple alloc/dealloc MR scenario.


--CSNFvL6ilyiKL/Hs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXR01GAAoJEORje4g2clin1OgQAJ3O3KyJLlHrk18Ga7/zuYbv
Pegyo3VGN/vgqsLYEo6Vb+Mcdi1BVMolxmpCkLeg1AUTteRpQLvZhe49nmi6WKVb
fcrN3yhQFYTUcCNWJreiGnwHQNjwfKq4Wr1VvJOQ4XCqxsB+XvFiP0rO5jApDQ3U
y1+Taq44Ub1RCz+LM+MF7S3mJQXlSqKcH0/Aze5u+Jous9yr7GCkkUNI5EbzvPTr
nYWezB4kU9tOX3rzpnj0dXw1XcJvx99HyO2fZR3Y85916BV469Gejzq4GIIVhISy
HF2qze7CXON11IyFaok3L9LuhR6iQ0unbQjGlVzNnVnsZAOLAio04Mq/KgVf2Fqq
OzEdtHHF9XrO9IlvgSQahc0V7Oq6agTF5QmWFbYgIVdttrlMoBIHfke/zYIae5Ir
gilBgF9fv2bNZ1O1aC/2WC36X14mkLnPGjSaUttflMvaXcMDURSLBds51HRc140c
h7MMvNX3EoIRTh3OrdyFvc//1+qU0gFLm1l+GD2+jr2ark69woixhD5nJxmLnsk4
uBQcBp6/XdmFQaIpK1/lelsR8i80Gqw0v2EVE8F0qB0isvgzqmrnYNafj7JOrN3R
1ikICkrg0JDJjafVk0mSwJoU9u58O34NlGjKz1N9ASKz73l4c5w49/TCAgQMfH8H
cRqA5PrYJ2eWYoew4VkQ
=R8kl
-----END PGP SIGNATURE-----

--CSNFvL6ilyiKL/Hs--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
