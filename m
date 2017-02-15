From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
Date: Wed, 15 Feb 2017 18:30:32 +0200
Message-ID: <20170215163031.GT6989@mtr-leonro.local>
References: <20170214185636.29250-1-bart.vanassche@sandisk.com>
 <20170214185636.29250-2-bart.vanassche@sandisk.com>
 <cebcaeae-94a6-de82-cfc8-ce055b273836@grimberg.me>
 <0514bb01-95cf-c10a-b883-494f149845f3@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="ffBYM5qgR8HH9Mta"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <0514bb01-95cf-c10a-b883-494f149845f3-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "# 4 . 7+" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--ffBYM5qgR8HH9Mta
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 15, 2017 at 06:18:02PM +0200, Max Gurtovoy wrote:
>
>
> On 2/15/2017 5:38 PM, Sagi Grimberg wrote:
> >
> > > Tests have shown that the following error message is reported when
> > > using SG-GAPS registration with an mlx5 adapter:
> > >
> > > scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE
> > > ffff880bd4270eb0
> > > 00000000 00000000 00000000 00000000
> > > 00000000 00000000 00000000 00000000
> > > 00000000 00000000 00000000 00000000
> > > 00000000 0f007806 2500002a ad9fafd1
> > > scsi host1: ib_srp: reconnect succeeded
> > > mlx5_0:dump_cqe:262:(pid 7369): dump error cqe
> > > 00000000 00000000 00000000 00000000
> > > 00000000 00000000 00000000 00000000
> > > 00000000 00000000 00000000 00000000
> > > 00000000 0f007806 25000032 00105dd0
> > > scsi host1: ib_srp: failed FAST REG status memory management operation
> > > error (6) for CQE ffff880b92860138
> > >
> > > Hence avoid using SG-GAPS memory registrations. Additionally,
> > > always configure the blk_queue_virt_boundary() to avoid to trigger
> > > a mapping failure when using adapters that support SG-GAPS (e.g.
> > > mlx5).
> >
> > Hi Guys,
> >
> > Sorry for addressing this late, but has this failure been investigated?
> >
> > Max, Israel, what does this error syndrome map to?
>
> Sagi,
> this syndrome says that number of klms to write is bigger than number of
> mtts.
>
> Artemy started investigating it and proposed solution that were tested by
> Laurence.
> Let's see if your fix will help.

No, Artemy's change doesn't fix it.

>
> >
> > Looking at mlx5_ib_sg_to_klms, I think the mr->length is incorrectly
> > incremented. Does the following change fix the problem?
> > --
> > diff --git a/drivers/infiniband/hw/mlx5/mr.c
> > b/drivers/infiniband/hw/mlx5/mr.c
> > index 8f608debe141..c21c9eee37f6 100644
> > --- a/drivers/infiniband/hw/mlx5/mr.c
> > +++ b/drivers/infiniband/hw/mlx5/mr.c
> > @@ -1832,7 +1832,7 @@ mlx5_ib_sg_to_klms(struct mlx5_ib_mr *mr,
> >                 klms[i].va = cpu_to_be64(sg_dma_address(sg) + sg_offset);
> >                 klms[i].bcount = cpu_to_be32(sg_dma_len(sg) - sg_offset);
> >                 klms[i].key = cpu_to_be32(lkey);
> > -               mr->ibmr.length += sg_dma_len(sg);
> > +               mr->ibmr.length += sg_dma_len(sg) - sg_offset;
> >
> >                 sg_offset = 0;
> >         }
> > --
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--ffBYM5qgR8HH9Mta
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlikgicACgkQ5GN7iDZy
WKfWWQ//YtDe1oWgxTsipdEvP3NEsPg0vL7u/zS//KivraZ8UHzItwxDwp0crVFC
xd92ttdL2N242EWGJ8Oc/nF1KxJZ4/yv/ZadXJb+ZYignev4UeCOmGQL8UWbRd2l
uE/Vx+Osp+xqg7DihLRGN+4RKvyVX7Yq984+X3dQFbO5b1nAdEaaFMpSqDq6wj90
NPRR4lbrBaVc/Qqey5OB1fmqs0FP3sPwdK1uUB86wKRGXqoKv4A64kDBiAakZXiv
7H7tFTYnOeto5hXEwAxjf9zYxinBaGq0t2xygLTpaW74a8hAD5Ngd8yb073WEpZl
lM6ji7xL/YtVrMTYOpFO0CReq/hMkqyLuIp+18ojX8XVLCGpmRQss8E8jdOlIAuY
7sV0zmFJzN4VpkZlYZuCTatLdJsFR/1zbc7DwQ9BVKbb/IbuN0wO/aX5gQRfbC4E
AcfQTDeiTKHhdJyWDJQCjL72X2QoihsVmRYunsc46AOpJ+W5HEtE1SKFCNd1RncS
L1onTjBf6uKhjJ47+7lrpJn2yPYjhwJpeRip+CxJySPcZiNy43Mk6TyuXGx0or8U
xMvj2EkEkoXlEzy5RxEMYvUvzP02nIQBzYTL2+z+Ibj3Loxk6tR802zPJ17Hmo9/
ZPVLyocROnvQVELQGF1vVFbo8HZLOGUWTzMYZcP7cKUXM3PsKK4=
=BWYs
-----END PGP SIGNATURE-----

--ffBYM5qgR8HH9Mta--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
