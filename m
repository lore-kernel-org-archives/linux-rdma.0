From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
Date: Wed, 15 Feb 2017 09:53:56 -0500 (EST)
Message-ID: <242820990.31706010.1487170436012.JavaMail.zimbra@redhat.com>
References: <20170214185636.29250-1-bart.vanassche@sandisk.com> <20170214185636.29250-2-bart.vanassche@sandisk.com> <20170215071449.GM6989@mtr-leonro.local> <20170215081945.GP6989@mtr-leonro.local> <90797260.31671071.1487165615598.JavaMail.zimbra@redhat.com> <152629651.31673945.1487166218360.JavaMail.zimbra@redhat.com> <20170215134707.GQ6989@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170215134707.GQ6989@mtr-leonro.local>
Sender: stable-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Max Gurtovoy <maxg@mellanox.com>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, Israel Rukshin <israelr@mellanox.com>, Mark Bloch <markb@mellanox.com>, Yuval Shaia <yuval.shaia@oracle.com>, Artemy Kovalyov <artemyko@mellanox.com>, "# 4 . 7+" <stable@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org



----- Original Message -----
> From: "Leon Romanovsky" <leonro@mellanox.com>
> To: "Laurence Oberman" <loberman@redhat.com>
> Cc: "Bart Van Assche" <bart.vanassche@sandisk.com>, "Max Gurtovoy" <maxg@mellanox.com>, "Doug Ledford"
> <dledford@redhat.com>, linux-rdma@vger.kernel.org, "Israel Rukshin" <israelr@mellanox.com>, "Mark Bloch"
> <markb@mellanox.com>, "Yuval Shaia" <yuval.shaia@oracle.com>, "Artemy Kovalyov" <artemyko@mellanox.com>, "# 4 . 7+"
> <stable@vger.kernel.org>
> Sent: Wednesday, February 15, 2017 8:47:07 AM
> Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
> 
> On Wed, Feb 15, 2017 at 08:43:38AM -0500, Laurence Oberman wrote:
> >
> >
> > ----- Original Message -----
> > > From: "Laurence Oberman" <loberman@redhat.com>
> > > To: "Leon Romanovsky" <leonro@mellanox.com>
> > > Cc: "Bart Van Assche" <bart.vanassche@sandisk.com>, "Max Gurtovoy"
> > > <maxg@mellanox.com>, "Doug Ledford"
> > > <dledford@redhat.com>, linux-rdma@vger.kernel.org, "Israel Rukshin"
> > > <israelr@mellanox.com>, "Mark Bloch"
> > > <markb@mellanox.com>, "Yuval Shaia" <yuval.shaia@oracle.com>, "Artemy
> > > Kovalyov" <artemyko@mellanox.com>, "# 4 . 7+"
> > > <stable@vger.kernel.org>
> > > Sent: Wednesday, February 15, 2017 8:33:35 AM
> > > Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
> > >
> > >
> > >
> > > ----- Original Message -----
> > > > From: "Leon Romanovsky" <leonro@mellanox.com>
> > > > To: "Bart Van Assche" <bart.vanassche@sandisk.com>, "Max Gurtovoy"
> > > > <maxg@mellanox.com>
> > > > Cc: "Doug Ledford" <dledford@redhat.com>, linux-rdma@vger.kernel.org,
> > > > "Israel Rukshin" <israelr@mellanox.com>, "Mark
> > > > Bloch" <markb@mellanox.com>, "Yuval Shaia" <yuval.shaia@oracle.com>,
> > > > "Artemy Kovalyov" <artemyko@mellanox.com>, "# 4
> > > > . 7+" <stable@vger.kernel.org>
> > > > Sent: Wednesday, February 15, 2017 3:19:45 AM
> > > > Subject: Re: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
> > > >
> > > > On Wed, Feb 15, 2017 at 09:14:49AM +0200, Leon Romanovsky wrote:
> > > > > On Tue, Feb 14, 2017 at 10:56:29AM -0800, Bart Van Assche wrote:
> > > > > > Tests have shown that the following error message is reported when
> > > > > > using SG-GAPS registration with an mlx5 adapter:
> > > > > >
> > > > > > scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE
> > > > > > ffff880bd4270eb0
> > > > > > 00000000 00000000 00000000 00000000
> > > > > > 00000000 00000000 00000000 00000000
> > > > > > 00000000 00000000 00000000 00000000
> > > > > > 00000000 0f007806 2500002a ad9fafd1
> > > > > > scsi host1: ib_srp: reconnect succeeded
> > > > > > mlx5_0:dump_cqe:262:(pid 7369): dump error cqe
> > > > > > 00000000 00000000 00000000 00000000
> > > > > > 00000000 00000000 00000000 00000000
> > > > > > 00000000 00000000 00000000 00000000
> > > > > > 00000000 0f007806 25000032 00105dd0
> > > > > > scsi host1: ib_srp: failed FAST REG status memory management
> > > > > > operation
> > > > > > error (6) for CQE ffff880b92860138
> > > > > >
> > > > > > Hence avoid using SG-GAPS memory registrations. Additionally,
> > > > > > always configure the blk_queue_virt_boundary() to avoid to trigger
> > > > > > a mapping failure when using adapters that support SG-GAPS (e.g.
> > > > > > mlx5).
> > > > >
> > > > > According to the error dump, we have an issue with max_page_list_len
> > > > > supplied and/or
> > > > > internal calculations from that value to the UMR byte count.
> > > >
> > > > Hi Bart,
> > > >
> > > > Do you mind to try your test on my branch rdma-next [1] with the
> > > > following
> > > > fixup?
> > > >
> > > > diff --git a/drivers/infiniband/hw/mlx5/mr.c
> > > > b/drivers/infiniband/hw/mlx5/mr.c
> > > > index 3c1f483d003f..3e59dce10d5e 100644
> > > > --- a/drivers/infiniband/hw/mlx5/mr.c
> > > > +++ b/drivers/infiniband/hw/mlx5/mr.c
> > > > @@ -1045,8 +1045,9 @@ int mlx5_ib_update_xlt(struct mlx5_ib_mr *mr, u64
> > > > idx,
> > > > int npages,
> > > >  	for (pages_mapped = 0;
> > > >  	     pages_mapped < pages_to_map && !err;
> > > >  	     pages_mapped += pages_iter, idx += pages_iter) {
> > > > +		npages = min_t(int, pages_iter, pages_to_map - pages_mapped);
> > > >  		dma_sync_single_for_cpu(ddev, dma, size, DMA_TO_DEVICE);
> > > > -		npages = populate_xlt(mr, idx, pages_iter, xlt,
> > > > +		npages = populate_xlt(mr, idx, npages, xlt,
> > > >  				      page_shift, size, flags);
> > > >
> > > >  		dma_sync_single_for_device(ddev, dma, size, DMA_TO_DEVICE);
> > > >
> > > > [1]
> > > > https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=rdma-next
> > > >
> > > > Thanks
> > > >
> > >
> > > Hello Leon
> > > Replied earlier but I dont know if my reply made it.
> > > I will have to test this.
> > >
> > > is this repo
> > > https://git.kernel.org/cgit/linux/kernel/git/leon/linux-rdma.git/log/?h=rdma-next
> > > already patched with the change you want.
> > > If not can I just take the patch and apply to my earlier tree based just
> > > on
> > > Linus's tree where I reverted the patch.
> > >
> > > Thanks
> > > Laurence
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > >
> >
> > I guess not, I looked at applying this patch to Linus's tree but the
> > function
> > mlx5_ib_update_xlt() is not in there yet.
> 
> This is why I asked to use my tree, there is a chance that wrong
> calculation was before we introduced mlx5_ib_update_xlt() function.
> 
> >
> > I will see if I can get your tree staged and test this for you.
> 
> Thanks a lot.
> 
> >
> > Thanks
> > Laurence
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hello Leon
I pulled your tree, ran git checkout rdma-next
I applied the patch manually, built the kernel and started the tests.

Pretty soon I ran into

ibclient login: [  132.640142] mlx5_1:dump_cqe:262:(pid 11417): dump error cqe
[  132.640185] scsi host2: ib_srp: failed RECV status WR flushed (5) for CQE ffff880bd86a97b0
[  132.718106] 00000000 00000000 00000000 00000000
[  132.743616] 00000000 00000000 00000000 00000000
[  132.767790] 00000000 00000000 00000000 00000000
[  132.793626] 00000000 0f007806 2500002a 8ad015d1
[  136.181512] systemd-readahead[701]: open(/var/tmp/dracut.ZR8CYG/initramfs/usr/bin/loginctl) failed: Too many levels of symbolic links
[  136.250779] systemd-readahead[701]: open(/var/tmp/dracut.ZR8CYG/initramfs/usr/lib/systemd/system/dracut-emergency.service) failed: Too many levels of symbolic links
[  147.791028] scsi host2: ib_srp: reconnect succeeded
[  147.827012] scsi host2: ib_srp: failed RECV status WR flushed (5) for CQE ffff880bf5e71330
[  162.908764] scsi host2: ib_srp: reconnect succeeded
[  162.944244] scsi host2: ib_srp: failed RECV status WR flushed (5) for CQE ffff880bf5e71330
[  166.409523] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f23ec570
[  177.292496] scsi host2: ib_srp: reconnect succeeded
[  177.334396] mlx5_1:dump_cqe:262:(pid 0): dump error cqe
[  177.363793] 00000000 00000000 00000000 00000000
[  177.388434] 00000000 00000000 00000000 00000000
[  177.413918] 00000000 00000000 00000000 00000000
[  177.438911] 00000000 0f007806 25000042 00102dd0
[  177.465048] scsi host2: ib_srp: failed FAST REG status memory management operation error (6) for CQE ffff880bd7c90138
[  181.386124] scsi host1: ib_srp: reconnect succeeded
[  181.422892] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f23ec5b0
[  192.827678] fast_io_fail_tmo expired for SRP port-2:1 / host2.
[  193.230036] scsi host2: ib_srp: reconnect succeeded
[  193.329290] mlx5_1:dump_cqe:262:(pid 0): dump error cqe
[  193.356245] 00000000 00000000 00000000 00000000
[  193.379488] 00000000 00000000 00000000 00000000
[  193.404853] 00000000 00000000 00000000 00000000
[  193.429633] 00000000 0f007806 2500004a 006c46d0
[  193.455183] scsi host2: ib_srp: failed FAST REG status memory management operation error (6) for CQE ffff880bd7c906f8
[  196.178111] scsi host1: ib_srp: reconnect succeeded
[  196.215197] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f23ec5b0
[  208.277396] scsi host2: ib_srp: reconnect succeeded
[  208.318454] mlx5_1:dump_cqe:262:(pid 0): dump error cqe
[  208.349012] 00000000 00000000 00000000 00000000
[  208.374873] 00000000 00000000 00000000 00000000
[  208.401070] 00000000 00000000 00000000 00000000
[  208.426873] 00000000 0f007806 25000052 00103dd0
[  208.452788] scsi host2: ib_srp: failed FAST REG status memory management operation error (6) for CQE ffff880bd7c90138
[  211.066945] scsi host1: ib_srp: reconnect succeeded
[  211.101645] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f23ec5b0
[  223.296126] scsi host2: ib_srp: reconnect succeeded
[  223.396340] mlx5_1:dump_cqe:262:(pid 0): dump error cqe
[  223.423310] 00000000 00000000 00000000 00000000
[  223.448590] 00000000 00000000 00000000 00000000
[  223.473520] 00000000 00000000 00000000 00000000
[  223.499008] 00000000 0f007806 2500005a 006c56d0
[  223.524787] scsi host2: ib_srp: failed FAST REG status memory management operation error (6) for CQE ffff880bd7c906f8
[  225.463312] scsi host1: ib_srp: reconnect succeeded
[  225.499915] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f23ec5b0
[  238.912126] fast_io_fail_tmo expired for SRP port-2:1 / host2.
[  239.254388] scsi host2: ib_srp: reconnect succeeded
[  239.291843] scsi host2: ib_srp: failed RECV status WR flushed (5) for CQE ffff880bf5e712f0
[  240.619914] scsi host1: ib_srp: reconnect succeeded
[  240.654445] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f23ec5b0
[  254.620679] scsi host2: ib_srp: reconnect succeeded
[  254.658021] scsi host2: ib_srp: failed RECV status WR flushed (5) for CQE ffff880bf5e712f0
[  255.798616] scsi host1: ib_srp: reconnect succeeded
[  255.832897] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f23ec5b0
[  269.228783] scsi host2: ib_srp: reconnect succeeded
[  269.272055] mlx5_1:dump_cqe:262:(pid 0): dump error cqe
[  269.300655] 00000000 00000000 00000000 00000000
[  269.325885] 00000000 00000000 00000000 00000000
[  269.350457] 00000000 00000000 00000000 00000000
[  269.375757] 00000000 0f007806 25000072 005847d0
[  269.402013] scsi host2: ib_srp: failed FAST REG status memory management operation error (6) for CQE ffff880bd7c905b8
[  269.856464] scsi host1: ib_srp: reconnect succeeded
[  269.893203] scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff8817f23ec5b0

Thanks
Laurence
