From: Leon Romanovsky <leonro@mellanox.com>
Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
Date: Wed, 15 Feb 2017 15:47:07 +0200
Message-ID: <20170215134707.GQ6989@mtr-leonro.local>
References: <20170214185636.29250-1-bart.vanassche@sandisk.com>
 <20170214185636.29250-2-bart.vanassche@sandisk.com>
 <20170215071449.GM6989@mtr-leonro.local>
 <20170215081945.GP6989@mtr-leonro.local>
 <90797260.31671071.1487165615598.JavaMail.zimbra@redhat.com>
 <152629651.31673945.1487166218360.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="H83aLI5Lttn3Hg7B"
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <152629651.31673945.1487166218360.JavaMail.zimbra@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Max Gurtovoy <maxg@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>, Mark Bloch <markb@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>, Artemy Kovalyov <artemyko@mellanox.com>, "# 4 . 7+" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

--H83aLI5Lttn3Hg7B
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Feb 15, 2017 at 08:43:38AM -0500, Laurence Oberman wrote:
>
>
> ----- Original Message -----
> > From: "Laurence Oberman" <loberman@redhat.com>
> > To: "Leon Romanovsky" <leonro@mellanox.com>
> > Cc: "Bart Van Assche" <bart.vanassche@sandisk.com>, "Max Gurtovoy" <maxg@mellanox.com>, "Doug Ledford"
> > <dledford@redhat.com>, linux-rdma@vger.kernel.org, "Israel Rukshin" <israelr@mellanox.com>, "Mark Bloch"
> > <markb@mellanox.com>, "Yuval Shaia" <yuval.shaia@oracle.com>, "Artemy Kovalyov" <artemyko@mellanox.com>, "# 4 . 7+"
> > <stable@vger.kernel.org>
> > Sent: Wednesday, February 15, 2017 8:33:35 AM
> > Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
> >
> >
> >
> > ----- Original Message -----
> > > From: "Leon Romanovsky" <leonro@mellanox.com>
> > > To: "Bart Van Assche" <bart.vanassche@sandisk.com>, "Max Gurtovoy"
> > > <maxg@mellanox.com>
> > > Cc: "Doug Ledford" <dledford@redhat.com>, linux-rdma@vger.kernel.org,
> > > "Israel Rukshin" <israelr@mellanox.com>, "Mark
> > > Bloch" <markb@mellanox.com>, "Yuval Shaia" <yuval.shaia@oracle.com>,
> > > "Artemy Kovalyov" <artemyko@mellanox.com>, "# 4
> > > . 7+" <stable@vger.kernel.org>
> > > Sent: Wednesday, February 15, 2017 3:19:45 AM
> > > Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
> > >
> > > On Wed, Feb 15, 2017 at 09:14:49AM +0200, Leon Romanovsky wrote:
> > > > On Tue, Feb 14, 2017 at 10:56:29AM -0800, Bart Van Assche wrote:
> > > > > Tests have shown that the following error message is reported when
> > > > > using SG-GAPS registration with an mlx5 adapter:
> > > > >
> > > > > scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE
> > > > > ffff880bd4270eb0
> > > > > 00000000 00000000 00000000 00000000
> > > > > 00000000 00000000 00000000 00000000
> > > > > 00000000 00000000 00000000 00000000
> > > > > 00000000 0f007806 2500002a ad9fafd1
> > > > > scsi host1: ib_srp: reconnect succeeded
> > > > > mlx5_0:dump_cqe:262:(pid 7369): dump error cqe
> > > > > 00000000 00000000 00000000 00000000
> > > > > 00000000 00000000 00000000 00000000
> > > > > 00000000 00000000 00000000 00000000
> > > > > 00000000 0f007806 25000032 00105dd0
> > > > > scsi host1: ib_srp: failed FAST REG status memory management operation
> > > > > error (6) for CQE ffff880b92860138
> > > > >
> > > > > Hence avoid using SG-GAPS memory registrations. Additionally,
> > > > > always configure the blk_queue_virt_boundary() to avoid to trigger
> > > > > a mapping failure when using adapters that support SG-GAPS (e.g.
> > > > > mlx5).
> > > >
> > > > According to the error dump, we have an issue with max_page_list_len
> > > > supplied and/or
> > > > internal calculations from that value to the UMR byte count.
> > >
> > > Hi Bart,
> > >
> > > Do you mind to try your test on my branch rdma-next [1] with the following
> > > fixup?
> > >
> > > diff --git a/drivers/infiniband/hw/mlx5/mr.c
> > > b/drivers/infiniband/hw/mlx5/mr.c
> > > index 3c1f483d003f..3e59dce10d5e 100644
> > > --- a/drivers/infiniband/hw/mlx5/mr.c
> > > +++ b/drivers/infiniband/hw/mlx5/mr.c
> > > @@ -1045,8 +1045,9 @@ int mlx5_ib_update_xlt(struct mlx5_ib_mr *mr, u64
> > > idx,
> > > int npages,
> > >  	for (pages_mapped = 0;
> > >  	     pages_mapped < pages_to_map && !err;
> > >  	     pages_mapped += pages_iter, idx += pages_iter) {
> > > +		npages = min_t(int, pages_iter, pages_to_map - pages_mapped);
> > >  		dma_sync_single_for_cpu(ddev, dma, size, DMA_TO_DEVICE);
> > > -		npages = populate_xlt(mr, idx, pages_iter, xlt,
> > > +		npages = populate_xlt(mr, idx, npages, xlt,
> > >  				      page_shift, size, flags);
> > >
> > >  		dma_sync_single_for_device(ddev, dma, size, DMA_TO_DEVICE);
> > >
> > > [1]
> > > https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=rdma-next
> > >
> > > Thanks
> > >
> >
> > Hello Leon
> > Replied earlier but I dont know if my reply made it.
> > I will have to test this.
> >
> > is this repo
> > https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=rdma-next
> > already patched with the change you want.
> > If not can I just take the patch and apply to my earlier tree based just on
> > Linus's tree where I reverted the patch.
> >
> > Thanks
> > Laurence
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>
> I guess not, I looked at applying this patch to Linus's tree but the function
> mlx5_ib_update_xlt() is not in there yet.

This is why I asked to use my tree, there is a chance that wrong
calculation was before we introduced mlx5_ib_update_xlt() function.

>
> I will see if I can get your tree staged and test this for you.

Thanks a lot.

>
> Thanks
> Laurence
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--H83aLI5Lttn3Hg7B
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEkhr/r4Op1/04yqaB5GN7iDZyWKcFAlikW9sACgkQ5GN7iDZy
WKcufhAAlcpvv5Il8tHyvnP42jj126+pGrUYeHzwdXKOOzIjKKxB61xr/cq5shRr
FNCmj/IJAS8K40rXlhLpj2bTGUbRmcAO5uEwY81hLhHgzW8CP+I33lmUWGYtY8x+
+p4Y8LOKCJ6Hk5BBPaZPEXuvZUnEw1iUpBXBHaRnt31YucVLfl5bWyowAizwVqNd
TLnynKQN3L5RHVDQ7kZcY6zl74adnli+mikwaKbpa2+1C3ZXfxexhr7CBDcGlqWE
SKxjb/DCVPSb0YfIhzua6P9fDpuvTY0hRKtoGC7T0RFtPQEFxsSGt0NHKz0g3IFR
ucld5gyVzz6NILHNdPslFepNBuVNWDVw4yShQSsGBxKxXB6fIEI2PBVHaDfjN20P
rGmGC/WgvhuKbzLceiqwrGLMmF44OvXANVxo0HzLVxEvKQNBtauU7yVgiIEQ+A/T
CJcJbdfEBC33KQBm11OPbWuglxbNh75BP1ZjWsWSgspR2dG0EDIuIIbBFrZE9OLf
GZi9rgnAM7IX5yCiZtAt30cXGHyQa/DwyD7YYTaEeiQ4eyzzIQrHx1L8SI6TCD1n
gp/qJeLH/8nPqO/m1U4Nw60KBnQ6fjs89X0TPzIVtu6jsiQPBL4/JAA/7lcLxtQ5
OP0/axWFiUUr4mHgJbgpCMaS2Uy03ffDWYJfin2uTPltTqSdGR8=
=TEXA
-----END PGP SIGNATURE-----

--H83aLI5Lttn3Hg7B--
