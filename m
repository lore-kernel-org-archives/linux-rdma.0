From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: [PATCH v2 01/24] mlx4-ib: Use coherent memory for priv pages
Date: Sun, 19 Jun 2016 10:05:23 +0300
Message-ID: <57664433.8060206@grimberg.me>
References: <20160615030626.14794.43805.stgit@manet.1015granger.net>
 <20160615031525.14794.69066.stgit@manet.1015granger.net>
 <20160615042849.GR5408@leon.nu>
 <68F7CD80-0092-4B55-9FAD-4C54D284BCA3@oracle.com>
 <20160616143518.GX5408@leon.nu> <576315C9.30002@gmail.com>
 <20160617090541.GY5408@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160617090541.GY5408-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> First of all, IIRC the patch author was Christoph wasn't he.
>
> Do you think that author's name can provide different results in
> verification/bug reproduction? We didn't send this patch officially
> yet and all relevant authors will be acknowledged and honored when th=
e
> official (second round of IB fixes) will come.

Not sure what you mean here. what different results?

>> Plus, you do realize that this patch makes the pages allocation
>> in granularity of pages. In systems with a large page size this
>> is completely redundant, it might even be harmful as the storage
>> ULPs need lots of MRs.
>
> I see proper execution of the driver as an important goal which goes
> before various micro optimizations, which will come after.

I still don't understand how this fixes the original bug report from
Chuck. I sent a patch to make the pages allocation dma coherent
which fixes the issue. Yishai is the driver maintainer, he should
decide how this issue should be addressed.

In any event, if we end-up aligning to page size I would expect to
see a FIXME comment saying we can do better...

> id you ask yourself, why are not so many users use that ARCH_KMALLOC_=
MINALIGN?
>
> =E2=9E=9C  linux-rdma git:(master) grep -rI ARCH_KMALLOC_MINALIGN dri=
vers/*
> drivers/infiniband/hw/mlx4/mr.c:        add_size =3D max_t(int, MLX4_=
MR_PAGES_ALIGN - ARCH_KMALLOC_MINALIGN, 0);
> drivers/infiniband/hw/mlx5/mr.c:        add_size =3D max_t(int, MLX5_=
UMR_ALIGN - ARCH_KMALLOC_MINALIGN, 0);
> drivers/md/dm-crypt.c:                ARCH_KMALLOC_MINALIGN);
> drivers/usb/core/buffer.c:       * ARCH_KMALLOC_MINALIGN.
> drivers/usb/core/buffer.c:      if (ARCH_KMALLOC_MINALIGN <=3D 32)
> drivers/usb/core/buffer.c:      else if (ARCH_KMALLOC_MINALIGN <=3D 6=
4)
> drivers/usb/core/buffer.c:      else if (ARCH_KMALLOC_MINALIGN <=3D 1=
28)
> drivers/usb/misc/usbtest.c:     return (unsigned long)buf & (ARCH_KMA=
LLOC_MINALIGN - 1);
>

Not sure how to answer that, the use of it comes to make the allocation
padding just as much as we need it to be in order to align the pointer.

>>
>> Also, I don't see how that solves the issue, I'm not sure I even
>> understand the issue. Do you? Were you able to reproduce it?
>
> Yes, the issue is that address supplied to dma_map_single wasn't alig=
ned
> to DMA cacheline size.

Thats not true Leon, the address is always aligned to
MLX4_MR_PAGES_ALIGN which is 64B.

>
> And as the one, who wrote this code for mlx5, it will be great if you
> can give me a pointer. Why did you chose to use MLX5_UMR_ALIGN in tha=
t
> function? This will add 2048 bytes instead of 64 for mlx4.

The PRM states that the data descriptors array (MTT/KLM) pointer
must be aligned to 2K. I wish it didn't but it does. You can see in the
code that each registration that goes via UMR does the exact same thing=
=2E

>> IFF the pages buffer end not being aligned to a cacheline is problem=
atic
>> then why not extent it to end in a cacheline? Why in the next full p=
age?
>
> It will fit in one page.

Yea, but that single page can be 64K for a 128 pointers array...
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
