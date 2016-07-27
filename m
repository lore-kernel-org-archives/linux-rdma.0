From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v4 2/5] IB/core, RDMA RW API: Do not exceed QP SGE send
 limit
Date: Wed, 27 Jul 2016 19:23:20 +0300
Message-ID: <20160727162319.GK4628@leon.nu>
References: <75fc8647-16a6-5a89-400f-f5f418a8d6eb@sandisk.com>
 <c71ece34-36e2-86da-5032-2fc946ff0073@sandisk.com>
 <20160727124217.GJ4628@leon.nu>
 <8604bcdc-3ab4-28df-0eff-b1c0b6865c71@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6K2R/cS9K4qvcBNq"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <8604bcdc-3ab4-28df-0eff-b1c0b6865c71-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


--6K2R/cS9K4qvcBNq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 27, 2016 at 08:24:32AM -0700, Bart Van Assche wrote:
> On 07/27/2016 05:42 AM, Leon Romanovsky wrote:
> >On Thu, Jul 21, 2016 at 01:03:30PM -0700, Bart Van Assche wrote:
> >> static inline u32 rdma_rw_fr_page_list_len(struct ib_device *dev)
> >> {
> >> 	/* arbitrary limit to avoid allocating gigantic resources */
> >>@@ -186,7 +179,8 @@ static int rdma_rw_init_map_wrs(struct rdma_rw_ctx =
*ctx, struct ib_qp *qp,
> >> 		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
> >> {
> >> 	struct ib_device *dev =3D qp->pd->device;
> >>-	u32 max_sge =3D rdma_rw_max_sge(dev, dir);
> >>+	u32 max_sge =3D dir =3D=3D DMA_TO_DEVICE ? qp->max_write_sge :
> >>+		      qp->max_read_sge;
> >
> >Bart,
> >I'm sure that I missed something.
> >
> >Can "dir" be DMA_BIDIRECTIONAL?
> >If yes, mxa_sge will be min(max_write_sge, max_read_sge).
>=20
> Hello Leon,
>=20
> The RDMA R/W API is intended for target drivers. None of the upstream tar=
get
> drivers (ib_isert, ib_srpt, nvmet) that use the RDMA R/W API support bidi
> commands today. And even if such support would be added, these target
> drivers should perform RDMA READs and WRITEs in two phases. So I do not
> expect that "dir" will ever be equal to DMA_BIDIRECTIONAL in the above co=
de.
>=20
> Bart.

Thanks Bart.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--6K2R/cS9K4qvcBNq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQIcBAEBAgAGBQJXmN/3AAoJEORje4g2clinmxIP/1Wf0spXvVA6s1N6nBHXWQbh
lEBiZobm8zx9KEdIl2X73RlSPLJnCztpwycqMNsDEUvcd7kuz5VWk9JlpwCwbUCa
BuXG+G6nl8lHg3Zb3sj2YO4TTYIynclIlNzNZuYcG0eYw+c0lmO78BJjuhpY5Ncg
Jn2XG21TylsxjHoWqGYNzRvNVoTVls/eCuxAU3XRZ30x9kAmxMIX3cmtFUl/HQC1
uVM1ZvY6itiPiaK3EcZ0GJFYIOPRhWw6xlr+rmcbjTA1Kc0+I705LCJ4dZOofqN6
wLFx+QcHuENUa5ruUvu6CcJkLziSLxvHRe5EyZqIRiGJn/zrFKVEcPsFOVfG3a4M
QWbC9kkOGVKHYLPa/Gfn4Ws8hjUXHBKV5vkiocvx64BjytxnwpBppnj0mAgy5inT
rUdks9L0YlUQtO+F47xz9aSQG2GwqhSzsbDky6/K5Tb5zbG66kq5OiESVR8aFTN9
H2XCBydlweBdpceksGB/8FJkutPmtKPOmIm+MrZq5nmSjPH2sjm2P2Y7DmlZPZ0c
OKdeITIfzvbm15O3XeDL7+zEU22+/d0BBxNzGeSqzWwWVVeLHVWyTe6VoS7XwsV9
gH+kxTGcrFFiEmsrWzM/V945Gh1LBQ4zdowMDm9XsbClRQQrv/vQLM/yzBhdRLY2
U9NIpmcLdEGAD1Lsjbrz
=7yJH
-----END PGP SIGNATURE-----

--6K2R/cS9K4qvcBNq--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
