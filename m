Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F7F234B682
	for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 10:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.218.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785062575; cv=pass; b=S7RnB8QaVY3bdQz/uw2ZEKRAtnKl1n7AbuSnanvZnNUY2qWq9Zysols4aJPbQBoH1nFPdKbeq39QvbS6ICaT+h0E9FhC6QV+f+VyC+3Nci4bcQtnNGRnfJBvCN0FWrRz/MIP1lfqzUDcKfUDXjHOn2tn/H342qFXnhgyBIMGuks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785062575; c=relaxed/simple;
	bh=TNy/ZFMU/DBWDlPILMRAzyD/XpV7gqL+xAUqXy/PpJY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DlpWMSW4ns061prCBdJY+YBSQykVPKvRA5eqlAgsa2fJSx+W2M/mmAo0gfN7h4f0zxTY5aDpfPT/3sg6QtR0ZX6OVR9edOlaNWeAuGwo+hgqGwrs0Wzrx+3rhriB0SljaqXuxubxZOQGdL4S2e3Xo/c/w+H9sG9gTNQ7EE8769o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JwHoCQIL; arc=pass smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JwHoCQIL"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c1c52d920b8so230082866b.2
        for <linux-rdma@vger.kernel.org>; Sun, 26 Jul 2026 03:42:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785062572; cv=none;
        d=google.com; s=arc-20260327;
        b=A72cGPTWksrN/Nuy55wgy/umnf/vUqBmBfpjvErd3Avk0GmONycdORJgU6O5J6Tu8l
         DUrlW5i+8aOfEP6QPb0gydZFdB4GIxxXTgzQo03oJjdG3go/ogGCRsWOwX0CVMaKRHhJ
         avphEEcPY7rtJndITfs2sk3nmKbq6qjF0zIwrRUSeAEsCtXXxf5nU48H7O0/zWqgjJXa
         JjI+JlmYS7aYIMUoMyZjB2wJgkNLw3C4nv9jDy8K/8X1mfYpzkUqSvb+9S+ur/FyqXgr
         X9n4PHa2VILagMINmBZguoqVZYJcEuYtRK8UGWPbxoNlVsOqC5XzdbSdf9Y1ZdKD2wyu
         tFdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=mAyeHAmplyeCwCD7p5jwj4E3/5LBIuVSm3NHnEZEU5k=;
        fh=uRZUbVrdvLmvNFYlTh7enzcBGe37T37jjqJg/AEF1MU=;
        b=ewSZCGa0q3aQEyWpEhYQIWqvISn2RLtYOLO3kPXJB0PscsAZQ3W1k78q/rxHWXmCW6
         ZOWiVW9q6HLvMK5HGvLttH0aN99PoAaufrI2ki6WKaMWXqVZF9HYN94sxnSrhThrJvD0
         wJH/mgENQBBQypjDctNCJWMN+tm406w7DeQ+xhZAdEtFVwmWderkgZzBuUumu0EI8gOK
         ZEB0YMsc1O+TAPWUqbmETPyxoMIRQy7QOsjjACEt0kuyZlKQicVzMZ8MWw+7cBJtjJoJ
         FVc/i29QPqqJAMk2AipP4ASCtc/ob0kTDrM15kzXMr8LvArGJ86ouG+5xShq17REamEm
         JpTA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785062572; x=1785667372; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mAyeHAmplyeCwCD7p5jwj4E3/5LBIuVSm3NHnEZEU5k=;
        b=JwHoCQIL/MjFGe+jrZGD3KHTXYJZkO76zwhZ6cuoSFEuDT1Fr+fmc5Fr2bud7fW1i3
         FA+uAMqIZrkPL5nYvshVZi4j0J4hDfxh6ZGi5wpx1mF1vvsbkNoQN87LfQhG2GU8Lcs6
         xeJz4qKJ8N2xHatSwS/czvRsB12QA8BEJBNb9mj9Z27a9pAMzbFvLewjtMAuplnc5FhH
         +f8glEL0++Rn7VfNZ6n5fxfErDp+dNafqdYZv8kZOyRElgL5Fl/dzXJFl9XC8bdiVP4U
         VykpG+xXL+dO86hRu81Kg061Ai4SImdaNjkv3Cj/JvmnblZvgruqM9ooouIHQoXB8yrn
         caag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785062572; x=1785667372;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mAyeHAmplyeCwCD7p5jwj4E3/5LBIuVSm3NHnEZEU5k=;
        b=VWHYcY6aIxWjdiIdcPiaH+GGCXD1xbp4CP3m1TTZgC3xJH+fkEoBC7g0w2ME/D/hu8
         R9ZbvzfH83rnbqssEBwnfBifQzlkYPVyn55ZEBA/U968y2mGJF1Kobb+kXiHCy5+bUcY
         fdy4HfSuZpV7GAN56zHpTm+oXaohH6gyJ9QmEkLcsGOStST1f0cHmqjUU+4YUFGtwFvy
         OMzjdn8K0tNU82eeIDVdMaxqFxX0RCqXrvio09+Emc+foiOEh5GhAv8hnWGiOKhaqMVJ
         r+9RyJeT7KBm+mHqe6XRBaIoJsoEuPmrJV8P1PGAOwguSluNncGYL9u3vrYrLVuZOU7n
         rNrg==
X-Forwarded-Encrypted: i=1; AHgh+RppLQCjAsHVTKxjujaizijUgK32EKC9Fdi/FjU/OAeueobh5OFM5cgBSZ9v44cWU9UIuydeumk9KBMA@vger.kernel.org
X-Gm-Message-State: AOJu0YwmWnsGznb90TSxHCUlz3+OWb7TDwFO616WmCwsMdc68hpzP7xs
	ukpdp+t4ZOepy4rkxX++7lb5q1XoYZ2idT7DZCYiJ62W95+SSYtLz+wImiyE8YMcWw/xeADe1ZL
	tLF8YxVbI/qGgjWOD0GgFCHbARYfUm/0=
X-Gm-Gg: AR+sD116uxn1zpiSTHEnGftuopae8p4hsz9qhQiPGJs8bicgBvHiamTfdY0F2/IMtjV
	e++vWtpJWZGfdefKLjPpqMaVlLCV9QE42A+5x9gTE5Ro8arLNzohcUgLBJkO+EFCJbpg+ORsOHA
	u9Dy+3Ul5ndu11yqdnrapywKv9eeqnSQvRTzBwzlGJ+OO5aNn/86sUF44Ti8Kaqj2PTNYBicG2a
	aDTH8o6cOPdTf0bo3mSsKpxSXHs+qvuiXGfzskXUjuZMtfNbDQfwQArfDgj+IBYgf/s1mvSHYY3
	GMPzkTm9/IVFYPAeSG4=
X-Received: by 2002:a17:907:8e07:b0:c16:592b:ec4c with SMTP id
 a640c23a62f3a-c1f1ea07ac9mr156324466b.1.1785062571218; Sun, 26 Jul 2026
 03:42:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260725094805.916278-1-bestswngs@gmail.com> <1b99ae23-a5b0-4e3b-80b5-1538d0e0a7fe@linux.dev>
 <b70a8092-60a8-46bd-8a06-82e41f59a76b@linux.dev> <20260726082058.GE12003@unreal>
In-Reply-To: <20260726082058.GE12003@unreal>
From: Weiming Shi <bestswngs@gmail.com>
Date: Sun, 26 Jul 2026 18:42:12 +0800
X-Gm-Features: AUfX_myJVK-SnKx3vcTXq_oPRA2T5kPmNplAPf0HuyIEwKUhodo_LqOoLmj2TDw
Message-ID: <CANgPUi1fyALy7fGuqmpwZ_RCX4O19V9wdR+b20NV8QckdQrtOg@mail.gmail.com>
Subject: Re: [PATCH] RDMA/rxe: Restore HMM_PFN_WRITE check in ODP write paths
To: Leon Romanovsky <leon@kernel.org>
Cc: Zhu Yanjun <yanjun.zhu@linux.dev>, security@kernel.org, 
	Jason Gunthorpe <jgg@nvidia.com>, Zhu Yanjun <zyjzyj2000@gmail.com>, Qiang Hong <wanbafv@gmail.com>, 
	Xinyu Ma <mmmxny@gmail.com>, Shaomin Chen <eeesssooo020@gmail.com>, 
	Rui Ding <threonine42@gmail.com>, Miao Zhao <muel@nova.gal>, 
	RDMA mailing list <linux-rdma@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Leon Romanovsky <leon@kernel.org> =E4=BA=8E2026=E5=B9=B47=E6=9C=8826=E6=97=
=A5=E5=91=A8=E6=97=A5 16:21=E5=86=99=E9=81=93=EF=BC=9A
>
> On Sat, Jul 25, 2026 at 07:12:42PM -0700, Zhu Yanjun wrote:
> > While exploiting this ODP flaw in soft-RoCE for privilege escalation
> > in practice might require specific conditions, enforcing the HMM_PFN_WR=
ITE
> > check is undoubtedly the right choice to enforce strict access control
> > and eliminate the security risk.
> >
> > The special handling for pmem flush (keeping it read-only) is also a ni=
ce
> > and correct touch.
>
> Zhu, we already asked you, please reduce the amount of AI-generated
> emails.
>
> >
> > Let us wait for the feedback from Leon and Jason.
>
> There is nothing we can do here, as it is not available in Patchwork
> or lore. Please post the patch to the mailing list.
>
> Thanks
>
> >
> > Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
> >
> > Zhu Yanjun
> >
> > =E5=9C=A8 2026/7/25 17:08, Zhu Yanjun =E5=86=99=E9=81=93:
> > >
> > > =E5=9C=A8 2026/7/25 2:48, Weiming Shi =E5=86=99=E9=81=93:
> > > > Commit 0b261d7c1cd3 ("RDMA/rxe: Break endless pagefault loop for RO
> > > > pages") dropped the access permission test from rxe_check_pagefault=
()
> > > > and left only HMM_PFN_VALID. A page faulted in read-only, for examp=
le
> > > > a page-cache folio behind a PROT_READ file mapping, then satisfies =
the
> > > > check and ODP write operations (RDMA WRITE, RDMA READ response, SEN=
D
> > > > payload, atomics) modify it through kmap without ever breaking CoW.
> > > >
> > > > An unprivileged user can register an ODP MR over such a mapping and
> > > > have incoming RDMA traffic overwrite the page cache of a file it on=
ly
> > > > holds O_RDONLY, including /etc/passwd or setuid binaries. This is t=
he
> > > > same primitive class as Dirty COW and CVE-2022-2590.
> > > >
> > > > mlx5 has the missing invariant: its ODP path sets the device write =
bit
> > > > only for pfns that carry HMM_PFN_WRITE. Restore it in rxe by requir=
ing
> > > > HMM_PFN_WRITE in rxe_check_pagefault() for every operation except
> > > > RXE_PAGEFAULT_RDONLY. A write to a non-writable VMA now fails the o=
ne
> > > > fault attempt with -EPERM from hmm_vma_fault() instead of re-faulti=
ng
> > > > forever. For a writable VMA the fault breaks CoW and the write land=
s
> > > > in the private page.
> > > >
> > > > Keep pmem flushes on the read-only check. arch_wb_cache_pmem() neve=
r
> > > > modifies memory, and the FLUSH access bits do not make the umem
> > > > writable, so classifying flushes as writes would make every flush
> > > > against a flush-only MR fail.
> > > >
> > > > Fixes: 0b261d7c1cd3 ("RDMA/rxe: Break endless pagefault loop for RO
> > > > pages")
> > > > Cc: stable@vger.kernel.org
> > > > Signed-off-by: Weiming Shi <bestswngs@gmail.com>
> > > > Reported-by: Shaomin Chen <eeesssooo020@gmail.com>
> > > > Reported-by: Rui Ding <threonine42@gmail.com>
> > > > Reported-by: Miao Zhao <muel@nova.gal>
> > > > Tested-by: Qiang Hong <wanbafv@gmail.com>
> > > > Tested-by: Xinyu Ma <mmmxny@gmail.com>
> > > > ---
> > > >   drivers/infiniband/sw/rxe/rxe_odp.c | 16 +++++++++++-----
> > > >   1 file changed, 11 insertions(+), 5 deletions(-)
> > > >
> > > > diff --git a/drivers/infiniband/sw/rxe/rxe_odp.c
> > > > b/drivers/infiniband/sw/rxe/rxe_odp.c
> > > > index ff904d5e54a73..174bb2efc3c6a 100644
> > > > --- a/drivers/infiniband/sw/rxe/rxe_odp.c
> > > > +++ b/drivers/infiniband/sw/rxe/rxe_odp.c
> > > > @@ -124,19 +124,23 @@ int rxe_odp_mr_init_user(struct rxe_dev *rxe,
> > > > u64 start, u64 length,
> > > >   }
> > > >     static inline bool rxe_check_pagefault(struct ib_umem_odp
> > > > *umem_odp, u64 iova,
> > > > -                       int length)
> > > > +                       int length, bool write)
> > > >   {
> > > >       bool need_fault =3D false;
> > > > +    u64 access =3D HMM_PFN_VALID;
> > > >       u64 addr;
> > > >       int idx;
> > > >   +    if (write)
> > > > +        access |=3D HMM_PFN_WRITE;
> > > > +
> > > >       addr =3D iova & (~(BIT(umem_odp->page_shift) - 1));
> > > >         /* Skim through all pages that are to be accessed. */
> > > >       while (addr < iova + length) {
> > > >           idx =3D (addr - ib_umem_start(umem_odp)) >>
> > > > umem_odp->page_shift;
> > > >   -        if (!(umem_odp->map.pfn_list[idx] & HMM_PFN_VALID)) {
> > > > +        if ((umem_odp->map.pfn_list[idx] & access) !=3D access) {
> > > >               need_fault =3D true;
> > > >               break;
> > > >           }
> > > > @@ -159,6 +163,7 @@ static unsigned long
> > > > rxe_odp_iova_to_page_offset(struct ib_umem_odp *umem_odp, u
> > > >   static int rxe_odp_map_range_and_lock(struct rxe_mr *mr, u64 iova=
,
> > > > int length, u32 flags)
> > > >   {
> > > >       struct ib_umem_odp *umem_odp =3D to_ib_umem_odp(mr->umem);
> > > > +    bool write =3D !(flags & RXE_PAGEFAULT_RDONLY);
> > > >       bool need_fault;
> > > >       int err;
> > > >   @@ -167,7 +172,7 @@ static int rxe_odp_map_range_and_lock(struct
> > > > rxe_mr *mr, u64 iova, int length, u
> > > >         mutex_lock(&umem_odp->umem_mutex);
> > > >   -    need_fault =3D rxe_check_pagefault(umem_odp, iova, length);
> > > > +    need_fault =3D rxe_check_pagefault(umem_odp, iova, length, wri=
te);
> > > >       if (need_fault) {
> > > >           mutex_unlock(&umem_odp->umem_mutex);
> > > >   @@ -177,7 +182,7 @@ static int rxe_odp_map_range_and_lock(struct
> > > > rxe_mr *mr, u64 iova, int length, u
> > > >           if (err < 0)
> > > >               return err;
> > > >   -        need_fault =3D rxe_check_pagefault(umem_odp, iova, lengt=
h);
> > > > +        need_fault =3D rxe_check_pagefault(umem_odp, iova, length,
> > > > write);
> > > >           if (need_fault) {
> > > >               mutex_unlock(&umem_odp->umem_mutex);
> > > >               return -EFAULT;
> > > > @@ -339,8 +344,9 @@ int rxe_odp_flush_pmem_iova(struct rxe_mr *mr,
> > > > u64 iova,
> > > >       int err;
> > > >       u8 *va;
> > > >   +    /* A flush never modifies memory; read-only access suffices.=
 */
> > > >       err =3D rxe_odp_map_range_and_lock(mr, iova, length,
> > > > -                     RXE_PAGEFAULT_DEFAULT);
> > > > +                     RXE_PAGEFAULT_RDONLY);
> > > >       if (err)
> > > >           return err;
> > >
> > --
> > Best Regards,
> > Yanjun.Zhu
> >
> >

Hi Leon,

Thank you for the feedback. I will post the patch to mailing list as reques=
ted.
Regarding the reproduction details, I will omit the PoC code in the
public mailing list post for security reasons.

Best regards,
Weiming Shi
