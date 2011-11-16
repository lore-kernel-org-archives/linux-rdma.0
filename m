From: Lukas Razik <linux@razik.name>
Subject: Re: [BUG] Bad page map in process ibv_devinfo
Date: Wed, 16 Nov 2011 19:22:34 +0000 (GMT)
Message-ID: <1321471354.5493.YahooMailNeo@web24714.mail.ird.yahoo.com>
References: <1321110951.99968.YahooMailNeo@web24712.mail.ird.yahoo.com> <CAL1RGDXnzQTQuMica3ZsRYbGNhT7GcySQvcAnJ+-5E2P0xw4Ag@mail.gmail.com>
Reply-To: Lukas Razik <linux@razik.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <sparclinux-owner@vger.kernel.org>
In-Reply-To: <CAL1RGDXnzQTQuMica3ZsRYbGNhT7GcySQvcAnJ+-5E2P0xw4Ag@mail.gmail.com>
Sender: sparclinux-owner@vger.kernel.org
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "sparclinux@vger.kernel.org" <sparclinux@vger.kernel.org>, Roland Dreier <roland@purestorage.com>
List-Id: linux-rdma@vger.kernel.org

That's a forwarding of Roland's email he sent yesterday to you (the spa=
rclinux list) because you haven't received it.
I thank you for any help!


That's his original email:
Roland Dreier <roland@purestorage.com> wrote:

On Sat, Nov 12, 2011 at 7:15 AM, Lukas Razik <linux@...> wrote:
> But I also get this BUG message from the kernel:
> ---
> [ 9305.698663] swap_free: Bad swap file entry 100005e000061800
> [ 9305.698791] BUG: Bad page map in process ibv_devinfo=A0 pte:bc0000=
c300104848 pmd:00f38054
> [ 9305.698908] addr:fffff80100114000 vm_flags:000844fa anon_vma:=A0=A0=
=A0=A0=A0=A0=A0=A0=A0 (null)
mapping:fffff807f313a410 index:6180082
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
code.=A0 From the "Bad page map" pte value, if I understand sparc mm co=
rrectly,
the PTE is seen as not present.

The mapping is coming from the code in drivers/infiniband/hw/mlx4/main.=
c:

static int mlx4_ib_mmap(struct ib_ucontext *context, struct vm_area_str=
uct *vma)
{
=A0 struct mlx4_ib_dev *dev =3D to_mdev(context->device);

=A0 if (vma->vm_end - vma->vm_start !=3D PAGE_SIZE)
=A0=A0=A0 return -EINVAL;

=A0 if (vma->vm_pgoff =3D=3D 0) {
=A0=A0=A0 vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);

=A0=A0=A0 if (io_remap_pfn_range(vma, vma->vm_start,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 to_mucontext(context)->uar.p=
fn,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PAGE_SIZE, vma->vm_page_prot=
))
=A0=A0=A0=A0=A0 return -EAGAIN;
=A0 } else if (vma->vm_pgoff =3D=3D 1 && dev->dev->caps.bf_reg_size !=3D=
 0) {
=A0=A0=A0 vma->vm_page_prot =3D pgprot_writecombine(vma->vm_page_prot);

=A0=A0=A0 if (io_remap_pfn_range(vma, vma->vm_start,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 to_mucontext(context)->uar.p=
fn +
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 dev->dev->caps.num_uars,
=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0=A0 PAGE_SIZE, vma->vm_page_prot=
))
=A0=A0=A0=A0=A0 return -EAGAIN;
=A0 } else
=A0=A0=A0 return -EINVAL;

=A0 return 0;
}

which is just taking one page -- the pfn comes from the PCI BAR
resource value in

int mlx4_uar_alloc(struct mlx4_dev *dev, struct mlx4_uar *uar)
{
=A0 uar->index =3D mlx4_bitmap_alloc(&mlx4_priv(dev)->uar_table.bitmap)=
;
=A0 if (uar->index =3D=3D -1)
=A0=A0=A0 return -ENOMEM;

=A0 uar->pfn =3D (pci_resource_start(dev->pdev, 2) >> PAGE_SHIFT) + uar=
->index;
=A0 uar->map =3D NULL;

=A0 return 0;
}

and calling io_remap_pfn_range on it.

Is there some VMA flag we're forgetting to set that only affects sparc?
Or could this possible be a bug in the sparc handling of PFN maps?

Thanks!
=A0 Roland
--
To unsubscribe from this list: send the line "unsubscribe sparclinux" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
