From: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: kernel BUG at drivers/iommu/intel-iommu.c:1767 on F16 3.1.1-2.fc16.x86_64
Date: Thu, 8 Dec 2011 19:56:37 +0200
Message-ID: <CALfB72BUDiZOZY8f4wvYej5Ozur2FZN3h3FNgc78Ur=tUsSCmA@mail.gmail.com>
References: <CALfB72BHLmN_vkpz9j7mi4yQWaYfJOojqopJ6d4911vuf3WRAA@mail.gmail.com>
 <CAL1RGDVh7gNTrteiEaGg=4fxW=p3ydZPVf4d1hgtwNT9xUdOMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVh7gNTrteiEaGg=4fxW=p3ydZPVf4d1hgtwNT9xUdOMw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Woodhouse <dwmw2-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello

On Thu, Dec 8, 2011 at 7:47 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> =
wrote:
> =A0> [ =A0597.412843] kernel BUG at drivers/iommu/intel-iommu.c:1767!
> So this is
> =A0 =A0 =A0 =A0BUG_ON(addr_width < BITS_PER_LONG && (iov_pfn + nr_pag=
es - 1)
>>> addr_width);
>
> in __domain_mapping() I believe. =A0And we have:
> =A0 =A0 =A0 =A0int addr_width =3D agaw_to_width(domain->agaw) - VTD_P=
AGE_SHIFT;
> How much RAM does you system have?

192 GB.

A few gigabyte is reserved for 2 MB huge pages, if that matters.

> I don't know too much about the low-level VT-d details, but is it
> possible the setup code
> is choosing a too small "guest address width" to cover all your memor=
y?
>
> drivers/net/ethernet/mellanox/mlx4/main.c has
>
> =A0 =A0 =A0 =A0err =3D pci_set_dma_mask(pdev, DMA_BIT_MASK(64));
> =A0 =A0 =A0 =A0if (err) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_warn(&pdev->dev, "Warning: couldn'=
t set 64-bit PCI
> DMA mask.\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D pci_set_dma_mask(pdev, DMA_BIT=
_MASK(32));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_err(&pdev->dev, "C=
an't set PCI DMA mask,
> aborting.\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err_release_regio=
ns;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0err =3D pci_set_consistent_dma_mask(pdev, DMA_BIT_MASK=
(64));
> =A0 =A0 =A0 =A0if (err) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_warn(&pdev->dev, "Warning: couldn'=
t set 64-bit "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "consistent PCI DMA m=
ask.\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0err =3D pci_set_consistent_dma_mask(pd=
ev, DMA_BIT_MASK(32));
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (err) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0dev_err(&pdev->dev, "C=
an't set consistent PCI
> DMA mask, "
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0"abort=
ing.\n");
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0goto err_release_regio=
ns;
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0}
> =A0 =A0 =A0 =A0}
>
> do you see any warnings in your kernel log about setting the PCI DMA =
mask?
> (in any case that should only affect bus addresses, not "guest addres=
ses")

I don't see anything like what you mentioned here.

=46rom the SAS controller:

mpt2sas0: 64 BIT PCI BUS DMA ADDRESSING SUPPORTED, total mem (198141716=
 kB)

Not seeing anything about PCI DMA errors.

I think the BIOS has VT-d enabled. dmesg says:

PCI-DMA: Intel(R) Virtualization Technology for Directed I/O

I can send you a full dmesg if that would help.

Regards

Albert
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
