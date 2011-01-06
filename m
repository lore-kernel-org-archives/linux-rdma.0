From: Vivien Bernet-Rollande <vbr-GKN1HSsW2S7R7s880joybQ@public.gmane.org>
Subject: Re: [PATCH] infiniband/mthca : Fix userland mapping of mthca
 infiniband cards in Xen dom0
Date: Thu, 6 Jan 2011 12:08:11 +0100
Message-ID: <AANLkTi=zMiVJfTRDeYvbxT46b0iASKG9jPgXqG81bqAK@mail.gmail.com>
References: <1293034260.30522.426.camel@trax>
	<adamxnfdty8.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adamxnfdty8.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, rdreir-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, xen-devel-GuqFBffKawuULHF6PoxzQEEOCMrvLtNR@public.gmane.org, Jeremy Fitzhardinge <jeremy-TSDbQ3PG+2Y@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Thanks  for your reply.

> This is kind of unappealing -- is there no way to make
> io_remap_pfn_range do the right thing under Xen? =A0It seems unfortun=
ate
> to make drivers both set VM_IO and call io_remap_pfn_range. =A0Or may=
be we
> should get rid of io_remap_pfn_range() and just have drivers set VM_I=
O
> and call remap_pfn_range() all the time?

Aside from IB drivers, the devices that need userland mapping are
mainly graphic cards. There has been quite a few issues with that and
the topic is discussed here :
http://wiki.xensource.com/xenwiki/XenPVOPSDRM

AFAIK, on x86 io_remap_pfn_range() is just #defined as
remap_pfn_range(). remap_pfn_range() sets the VM_IO flag, but does not
refresh the vm_page_prot field (mm/memory.c:1875). I think it could
make sense to patch remap_pfn_range(), but I'm afraid it might break a
lot of other drivers.

 > +    vma->vm_flags |=3D VM_IO;
 > +    vma->vm_page_prot =3D vm_get_page_prot(vma->vm_flags);
 >      vma->vm_page_prot =3D pgprot_noncached(vma->vm_page_prot);

Under Xen, when the VM_IO flag is set, the vm_get_page_prot() macro
will set the _PAGE_IOMAP bit on the the vm_page_prot.
Xen needs that bit to be set in order to understand that we actually
want the real memory space to be mapped. The use of this macro was
pointed out to me by the Xen team (see last post on
http://xen.1045712.n5.nabble.com/Kernel-Oops-when-reading-kernel-page-t=
ables-debugfs-file-td3279750.html
), and, I assume, is the proper way of handling things.

To sum up :
 - Xen needs the _PAGE_IOMAP flag set on the vm_page_prot for the
device to work.
 - I understand the proper way to do this is to set the VM_IO flag,
and then call vm_get_page_prot()

> There are quite a few drivers under drivers/infiniband/hw that call
> io_remap_pfn_range() -- presumably they all need the analogous fix?

I only have access to Mellanox Infinihost HBAs for testing, but once
we figure out how we want this fixed, I can take a look at the other
drivers.

> Finally as a stylistic thing I would probably prefer to see the
> vm_page_prot manipulation written as
>
> =A0 =A0 =A0 =A0vma->vm_page_prot =3D pgprot_noncached(vm_get_page_pro=
t(vma->vm_flags));
>

Makes sense.
While digging, I've also seen things like :

vma->vm_page_prot =3D pgprot_noncached(vm_get_page_prot(vma->vm_flags |=
 VM_IO));

But it seems a bit dense.

> and if this fix is really the right thing to do, this should probably=
 be
> wrapped up in a helper function; presumably every instance of
>
> =A0 =A0 =A0 =A0vma->vm_page_prot =3D pgprot_FOO(vma->vm_page_prot)
>
> under drivers/ would need the same fix for Xen.

The issue is actually only related to mappings of bus memory to
userland. In kernel space, ioremap() is generaly used, which I
understand sets the _PAGE_IOMAP flag.

--=20
Vivien Bernet-Rollande
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
