From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] infiniband/mthca : Fix userland mapping of mthca infiniband cards in Xen dom0
Date: Thu, 06 Jan 2011 11:15:34 -0800
Message-ID: <adad3o9desp.fsf@cisco.com>
References: <1293034260.30522.426.camel@trax> <adamxnfdty8.fsf@cisco.com>
	<AANLkTi=zMiVJfTRDeYvbxT46b0iASKG9jPgXqG81bqAK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AANLkTi=zMiVJfTRDeYvbxT46b0iASKG9jPgXqG81bqAK-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Vivien Bernet-Rollande's message of "Thu, 6 Jan 2011 12:08:11 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vivien Bernet-Rollande <vbr-GKN1HSsW2S7R7s880joybQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, rdreir-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, xen-devel-GuqFBffKawuULHF6PoxzQEEOCMrvLtNR@public.gmane.org, Jeremy Fitzhardinge <jeremy-TSDbQ3PG+2Y@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

 > > Finally as a stylistic thing I would probably prefer to see the
 > > vm_page_prot manipulation written as
 > >
 > > =C2=A0 =C2=A0 =C2=A0 =C2=A0vma->vm_page_prot =3D pgprot_noncached(=
vm_get_page_prot(vma->vm_flags));
 > >
 >=20
 > Makes sense.
 > While digging, I've also seen things like :
 >=20
 > vma->vm_page_prot =3D pgprot_noncached(vm_get_page_prot(vma->vm_flag=
s | VM_IO));

This isn't the same, since it doesn't set VM_IO in vm_flags.

 > > wrapped up in a helper function; presumably every instance of
 > >
 > > =C2=A0 =C2=A0 =C2=A0 =C2=A0vma->vm_page_prot =3D pgprot_FOO(vma->v=
m_page_prot)
 > >
 > > under drivers/ would need the same fix for Xen.
 >=20
 > The issue is actually only related to mappings of bus memory to
 > userland. In kernel space, ioremap() is generaly used, which I
 > understand sets the _PAGE_IOMAP flag.

Right, but setting vm_page_prot means a driver is doing userspace
mapping of something, and if it's setting pgprot, that would generally
mean it's not mapping RAM.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
