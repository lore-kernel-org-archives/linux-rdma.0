From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
Date: Wed, 15 Feb 2017 10:19:45 +0200
Message-ID: <20170215081945.GP6989@mtr-leonro.local>
References: <20170214185636.29250-1-bart.vanassche@sandisk.com>
 <20170214185636.29250-2-bart.vanassche@sandisk.com>
 <20170215071449.GM6989@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="/JIF1IJL1ITjxcV4"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170215071449.GM6989@mtr-leonro.local>
Sender: stable-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Max Gurtovoy <maxg@mellanox.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>, Mark Bloch <markb@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>, Artemy Kovalyov <artemyko@mellanox.com>, "# 4 . 7+" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--/JIF1IJL1ITjxcV4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 15, 2017 at 09:14:49AM +0200, Leon Romanovsky wrote:
> On Tue, Feb 14, 2017 at 10:56:29AM -0800, Bart Van Assche wrote:
> > Tests have shown that the following error message is reported when
> > using SG-GAPS registration with an mlx5 adapter:
> >
> > scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff880bd4270eb0
> > 00000000 00000000 00000000 00000000
> > 00000000 00000000 00000000 00000000
> > 00000000 00000000 00000000 00000000
> > 00000000 0f007806 2500002a ad9fafd1
> > scsi host1: ib_srp: reconnect succeeded
> > mlx5_0:dump_cqe:262:(pid 7369): dump error cqe
> > 00000000 00000000 00000000 00000000
> > 00000000 00000000 00000000 00000000
> > 00000000 00000000 00000000 00000000
> > 00000000 0f007806 25000032 00105dd0
> > scsi host1: ib_srp: failed FAST REG status memory management operation error (6) for CQE ffff880b92860138
> >
> > Hence avoid using SG-GAPS memory registrations. Additionally,
> > always configure the blk_queue_virt_boundary() to avoid to trigger
> > a mapping failure when using adapters that support SG-GAPS (e.g.
> > mlx5).
>
> According to the error dump, we have an issue with max_page_list_len supplied and/or
> internal calculations from that value to the UMR byte count.

Hi Bart,

Do you mind to try your test on my branch rdma-next [1] with the following
fixup?

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 3c1f483d003f..3e59dce10d5e 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -1045,8 +1045,9 @@ int mlx5_ib_update_xlt(struct mlx5_ib_mr *mr, u64 idx, int npages,
 	for (pages_mapped = 0;
 	     pages_mapped < pages_to_map && !err;
 	     pages_mapped += pages_iter, idx += pages_iter) {
+		npages = min_t(int, pages_iter, pages_to_map - pages_mapped);
 		dma_sync_single_for_cpu(ddev, dma, size, DMA_TO_DEVICE);
-		npages = populate_xlt(mr, idx, pages_iter, xlt,
+		npages = populate_xlt(mr, idx, npages, xlt,
 				      page_shift, size, flags);

 		dma_sync_single_for_device(ddev, dma, size, DMA_TO_DEVICE);

[1] https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=rdma-next

Thanks

--/JIF1IJL1ITjxcV4
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlikDyEACgkQ5GN7iDZy
WKcjHw/+P7TypZKF8/Qqay6/VxiuLc2ws4L94XxfcaCGQQ1XgZlCcAjCnkCZ10Td
60TFVbrfSRax9pbI9Lc4UA1fnqnnCLdHZ86tpJen0ZXEgYWlN+vH90w68MILqnwS
EnRhieUuhC/lJ4CS/kEsipsryLD+1DEeKJGplYBK/SZ5YrYKPyDJzu2si2aHuPVj
FkANMx1RXfm3Oc3g1BQ8QPEoAxyi73I26EgvWzFDUExWz0BQweZLzBJnTQ3roKkg
SqYmNFNkd2qfCeYbKFk+gx9nFjp3Wyb4lezyeAe0+bEbeD3HG4hgulh9IUj/1acE
VaNG49tL73ktOyo22YT/GfumZB63DOuIeDbYnwm5XQn9RhOfkBKXUVGnWuPH4gPG
zsmlnCp5FMuyOhzEIiPJiGZSBplIsu8UXk6yRK+L63mKBB8vyLtXhxYZOrITXlEy
HV0HMQaMYg8mudX6XmVkp2bbudzbmTptLBb+QGIDN4EZozCx/PYKbiBjnO+sdG0d
OgVs3o1r+KcS4dvMb+5Pe9wx0eWYzsv9P+ILdEF2Vz0DWzJKGD6H0pu2OFe7eyvx
my+tmRVAkKZnTeLYKJoU6g6ZRGKlAqHDlHALoK2tfkHJvhQ+5C+TvUxzlKYSlRn6
EY+MNP+dZ9ld0uSJksTd5ZYK4EsstMipzFU/sXb2c1UW72xH+Cs=
=ArrG
-----END PGP SIGNATURE-----

--/JIF1IJL1ITjxcV4--
