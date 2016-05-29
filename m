From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: RDMA Read: Local protection error
Date: Sun, 29 May 2016 11:56:21 +0300
Message-ID: <20160529085621.GB25500@leon.nu>
References: <57277B63.8030506@sandisk.com>
 <6BBFD126-877C-4638-BB91-ABF715E29326@oracle.com>
 <1AFD636B-09FC-4736-B1C5-D1D9FA0B97B0@oracle.com>
 <8a3276bf-f716-3dca-9d54-369fc3bdcc39@dev.mellanox.co.il>
 <aaa67d51-663a-0aba-fc54-a5ab5d947a55@sandisk.com>
 <C0AE237D-5E5A-4F94-B717-F3A3B4B4D4A8@oracle.com>
 <574728EC.9040802@grimberg.me>
 <57473025.5020801@grimberg.me>
 <20160526192351.GV25500@leon.nu>
 <20160529071040.GA24347@infradead.org>
Reply-To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ATYltwmfWCpDp8Ax"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160529071040.GA24347-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Joonsoo Kim <iamjoonsoo.kim-Hm3cg6mZ9cc@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--ATYltwmfWCpDp8Ax
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 29, 2016 at 12:10:40AM -0700, Christoph Hellwig wrote:
> On Thu, May 26, 2016 at 10:23:51PM +0300, Leon Romanovsky wrote:
> > > +       mr->pages =3D dma_alloc_coherent(device->dma_device, size,
> > > +                               &mr->page_map, GFP_KERNEL);
> >=20
> > Sagi,
> > I'm wondering if allocation from ZONE_DMA is the right way to
> > replace ZONE_NORMAL allocations.
>=20
> Where do you see a ZONE_DMA allocation?

Thanks for pointing that out, it caused me to reread code again more
carefully and it looks like I mistakenly added GFP_DMA flag to the
proposed code which is definitely not the case.

Sorry for the noise.

--ATYltwmfWCpDp8Ax
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXSq61AAoJEORje4g2clinmR0P/2yHJzjQRLdw4GG0mZp7HGv6
TncimK6NPgBdBQFayUlmPKOkxAt1JT7h2r8DDbjSWbhXZNL47nwXz6UNUEKI4HHC
jf2dWiJ4X2Vh05j3GtUllyhv8tFABr0D5wUObqHzlZNbwxY8iS8zBXbKvKaVyMe4
feFsjoF8q25ttpSUpZA4tmxjMU4qK6cIwgLUnvrfxpaW0Sx6lJkSvJ8kj9l8LnoO
Ckgi72+pXVmHlssCL8+Tis+GtvBqEwyawZd4NoR9Q/lAShf3rbIpeUkqFYjwXdjE
bcK5AJoEeCtoikqMvLFhaaPwbapol2Y0H21iK/xQM9EG9MH+KyJuQnZlmlJgLoyb
U78GggypxagEPxK3vbsYEfMqJ85+jVHaA8pS/bsG/OQxAJBKRVWsH5THQ+V8KQig
oXktmFNCNZAJTfHyp1fyPO0wkctxLeB2HGDu9AhpuK2itGLYv9aR5EC+eseTKkmk
qMyiqRaj6bYT9S5fPGhTXyas4ZE79vmD332LWwS74nYy9PoqDNrAMf7L/+xDoxt1
iDAr8koT1DRGsKDSWQT1z5T3E6vf5uJUWfTtwsjNvCRUGUgeZbJqjPIHszHHKyTK
g9YYUfovJLdGDsv4mczT5bxqSLAIMJCzPvm2i4mP4i0Rgd2ruvMK7bbc/yRZtfHJ
KQrslZ4h3C0njBrYjcS3
=mhVl
-----END PGP SIGNATURE-----

--ATYltwmfWCpDp8Ax--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
