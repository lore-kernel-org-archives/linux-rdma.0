From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Tue, 15 Nov 2011 10:38:01 -0800
Message-ID: <CAL1RGDXnzQTQuMica3ZsRYbGNhT7GcySQvcAnJ+-5E2P0xw4Ag@mail.gmail.com>
References: <1321110951.99968.YahooMailNeo@web24712.mail.ird.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1321110951.99968.YahooMailNeo-06aSuiz6pSvyX4RqAA4FmIglqE1Y4D90QQ4Iyu8u01E@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sparclinux-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Nov 12, 2011 at 7:15 AM, Lukas Razik <linux-GLgANOly0l1BDLzU/O5InQ@public.gmane.org> wrote:
> But I also get this BUG message from the kernel:
> ---
> [ 9305.698663] swap_free: Bad swap file entry 100005e000061800
> [ 9305.698791] BUG: Bad page map in process ibv_devinfo=A0 pte:bc0000=
c300104848 pmd:00f38054
> [ 9305.698908] addr:fffff80100114000 vm_flags:000844fa anon_vma:=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 (null) mapping:fffff807f313a410 index:6180082
> [ 9305.699087] vma->vm_file->f_op->mmap: ib_uverbs_mmap+0x8/0x38 [ib_=
uverbs]
> [ 9305.699135] Call Trace:
> [ 9305.699174]=A0 [00000000004cd558] unmap_vmas+0x514/0x7f4
> [ 9305.699302]=A0 [00000000004d1274] unmap_region+0xb4/0x164
> [ 9305.699383]=A0 [00000000004d22c0] do_munmap+0x2a8/0x31c
> [ 9305.699467]=A0 [000000000042d350] SyS_64_munmap+0x88/0xa8
> [ 9305.699550]=A0 [0000000000406154] linux_sparc_syscall+0x34/0x44

Hi Sparc Linux hackers!

This message is coming from someone using a ConnectX (mlx4) adapter on
a Sun T5120 (SPARC64).

I'm wondering if the bug is in the mlx4 code or in the sparc
io_remap_pfn_range()
code.  From the "Bad page map" pte value, if I understand sparc mm corr=
ectly,
the PTE is seen as not present.

The mapping is coming from the code in drivers/infiniband/hw/mlx4/main.=
c:

static int mlx4_ib_mmap(struct ib_ucontext *context, struct vm_area_str=
uct *vma)
{
	struct mlx4_ib_dev *dev =3D to_mdev(context->device);

	if (vma->vm_end - vma->vm_start !=3D PAGE_SIZE)
		return -EINVAL;

	if (vma->vm_pgoff =3D=3D 0) {
		vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);

		if (io_remap_pfn_range(vma, vma->vm_start,
				       to_mucontext(context)->uar.pfn,
				       PAGE_SIZE, vma->vm_page_prot))
			return -EAGAIN;
	} else if (vma->vm_pgoff =3D=3D 1 && dev->dev->caps.bf_reg_size !=3D 0=
) {
		vma->vm_page_prot =3D pgprot_writecombine(vma->vm_page_prot);

		if (io_remap_pfn_range(vma, vma->vm_start,
				       to_mucontext(context)->uar.pfn +
				       dev->dev->caps.num_uars,
				       PAGE_SIZE, vma->vm_page_prot))
			return -EAGAIN;
	} else
		return -EINVAL;

	return 0;
}

which is just taking one page -- the pfn comes from the PCI BAR
resource value in

int mlx4_uar_alloc(struct mlx4_dev *dev, struct mlx4_uar *uar)
{
	uar->index =3D mlx4_bitmap_alloc(&mlx4_priv(dev)->uar_table.bitmap);
	if (uar->index =3D=3D -1)
		return -ENOMEM;

	uar->pfn =3D (pci_resource_start(dev->pdev, 2) >> PAGE_SHIFT) + uar->i=
ndex;
	uar->map =3D NULL;

	return 0;
}

and calling io_remap_pfn_range on it.

Is there some VMA flag we're forgetting to set that only affects sparc?
Or could this possible be a bug in the sparc handling of PFN maps?

Thanks!
  Roland
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
