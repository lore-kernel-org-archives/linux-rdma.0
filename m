Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317464F7CA5
	for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 16:09:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791907749; cv=pass; b=fK58I8vs2u0PhnZXOf+6ARlMSaxVLapp10rvQWEoQT4qThXdKo1Gqyqzjgy9W7a/FqhenNagJ8S7z43bgEfUo8Hc8zI3Cs/HlWYbwajZDkNO0wje1+DV0lUU/Y0QRZq773dM9knjdE+55Fw7VOoTUdFR4bS1wnmaZgrc20pxG5c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791907749; c=relaxed/simple;
	bh=2r+YVrhD+Alf7yOe1p5lxvQWqkFYfmsY/Re/oFjW1QU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hrkdgq7kL9sKHB3CZpKnLm7/1l8ROzXNAH7nrRa/O0fhwVl6ZeE7Chjhjhbiqy6Hk7iDAM5GZJ7CsqVivlDwnQCHSeok45A3xwHBUdL06v8B4lR0RBcLYdwJC9CNCJ4MsKgjxw/BkVsAtNP4h+IwYEW0Cl7nKn5OS7ajHIqycrg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SZ3fKW5L; arc=pass smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SZ3fKW5L"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-88b8f0a1bcdso2477661b3a.3
        for <linux-rdma@vger.kernel.org>; Tue, 13 Oct 2026 09:09:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791907747; cv=none;
        d=google.com; s=arc-20260327;
        b=hXimT9mYfN/f+gAEDtGJl4Hqg2Q8gXfXmFQQk/1WFrxe/8fAgbMNuZ9ph3zH7y5YDG
         11Zdv5yj6bxv+s+dB6lQ5Z8wZ7LvQdkDk/LS2c0uvjYKWhNMAvgK3oroq4QTWVG1HeW1
         wg22FkqjZPWsk/KhfCf2wnmxwpfgLxRZ3kRiMi6FDTXTWqUUOY24Yh0oIvYlqWG09TbS
         G98pmD7i/ZIsR0eYCG2dStzujZROdGkk0tGlxLElEGW6GSAWwpdkPVgm7pr+gheKOYmJ
         jskXGzs9Kte4STTlvnhI81Bb/ENKuE6PI3hZLH9fU1tkKxYzRGj/piVNuItkc50GUTFD
         6IXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6CJVOEvoZNPuIDQB/spJlOL01ZnqVBd3gPYqDN4AvaA=;
        fh=VqyeqAI1uZWN9Sljjv2P8+fOO2/WerGAGAWYW4fJuio=;
        b=gqSu7zdBAVWhVbER1F2h7eELvjuUl9GpHO1E0W0cnet1TNgzfL84NUFaTY3wKtWpEa
         TYI7jj1tUprlAEMul7SQQT3YM6rIj8SP6krIZZVJRqJL2FiVqwRqUJKgrHaN/y6mlRNH
         w3q3abvbKYvEszJyHNK880TNGSV6alVTdbCVg8rat1zM8RiTJYq9Ixlk2CSEuNX1Sc1C
         HEffoth5xGKKjLzm5Tw0Mj8dw/zESQBqZsIYIdhbnwOKazsJGSgw2/EnbNQgjOz7P3b8
         KHgUjOrwHVZmyMomSGDpuRs5JuCJj6VXuzk0ZXekyCJsiQj3ZZEkS9+FuvYZht+MEtaq
         bwWA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791907747; x=1792512547; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6CJVOEvoZNPuIDQB/spJlOL01ZnqVBd3gPYqDN4AvaA=;
        b=SZ3fKW5L/6iploOWc7prDs/lw5PbPzSpbalJaAjxBYr0wcMOIbqIl/215lh4fjfs42
         g/dj+zJliAaIOw1kbZNPkGoLFAUXJsRAB7Gf4CACOwSyyo1ML64LeR0sdz2PuU+3DsGY
         yEVqHY6Aypk4hKzZkk8Z7aKmDuYN6qKe9V2LAJ3OBsFs6WEKCqviHHRPBcA1e9cSzW6l
         vX/Y138Bo2FMxQWccE0cUdGo6ASbbTpNHjkDwJpmFKdsS9j5anrRP4/sLkbX4hZaIwiO
         4JYofxrUB9xnNfXWy2E6gbXl+HQhh2Rx4t+q3FAe7raS+XsNqr1e4fsAkVlvXC/wlMLx
         BPmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791907747; x=1792512547;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6CJVOEvoZNPuIDQB/spJlOL01ZnqVBd3gPYqDN4AvaA=;
        b=bGgVBjaB9Tan/ALBFEm820AElXfU8UzOr2JVvcKkbf/wAF+74N81uS2Aiafz1Yeoco
         KfIVRMtK/9JmvwrB+f2Tth0joM7bhSvok9TIiB1W3zawRT74wCJf85kE6sVYflaqKJI2
         moK5Bh48cuVa78SRIMYcthSxaxwabCsoSnqSzjKB/iKmdhid11vsxJDt5qxPUwKh3VPI
         MdWesHQ0iokly4YkN94fg4xGmS7b3hh/6h04/HH70jbykYsUm1KplD6riIERsP4v+QUy
         sYkpcUxxJDt3BTuduZ0jFGTxg4hr2EAUxP48OUBb1B5ml5H7wg2lrlrIlko5wocNJEcO
         x1AQ==
X-Forwarded-Encrypted: i=1; AKwUvBxExo5kPiN7e2l1k1gLOCjkrbCSlrtT1K4zU89rUwvAd5QTpZT0RvFX/0zBIllfBT9OGHi76FSeD6L+@vger.kernel.org
X-Gm-Message-State: AFq9FYJH95LoN3SNL2KJ49gDZpgpltT3DLUe9zYZYfU4PmeZYoe7zac1
	MYzEEvvmK5pLeQs8ONdLQLs0BWMnz3W+WSPg63LJfn3cWW8L3/PwHp25xqm1JPFVudaLRdzF5AP
	QNT1hlg2vNHxB+p2WwzvgLK1OYxZuMBmn5dzxd0OW
X-Gm-Gg: AYBFou3aoxqG3nh0CeUxqpZPH5mV2Xtupuy2CMYPC/q2/DghYR4496V7jmNbLA9Y1s3
	3SnRxEDj8pbQkW6OEyno+xURg6X4PCDo2bwdjKHUiopvlhTDR7ywFlrm+mFtIZGjdjVVtGiSXyD
	Ze7UUP5p2E01UqRZs8OWglByIkA00DXwWlYUn4haOn5kKRggg7bf4Qbh0B+FCnRQaU8U5qN0Voz
	uQIgKu9WsDlKgnqgm2AD69ZpZ8/WC6QLgchJRl+zPmCpzugYcrEcF0qXKKIeaZiJhKXJf91QGcN
	b2PudngF0KHmq6SUt8Pq2P3fKowIZHseOF6zrRW6/YdwX7Gl82cO0KOzpvs7HMLLWyAMCrxvfSZ
	YZW8jE1CekPGnrYptv2yaWMQyitrmWvoZqpnZi6PgVD3WaQfax9n2
X-Received: by 2002:a05:6a00:17a9:b0:893:1336:481d with SMTP id
 d2e1a72fcca58-897c76e3c04mr11560506b3a.24.1791907746863; Tue, 13 Oct 2026
 09:09:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20261010194832.2415477-1-jmoroni@google.com> <20261012185010.GH14213@ziepe.ca>
 <20261013112211.GM219304@unreal>
In-Reply-To: <20261013112211.GM219304@unreal>
From: Jacob Moroni <jmoroni@google.com>
Date: Tue, 13 Oct 2026 12:08:54 -0400
X-Gm-Features: AclHuK8yuo5UoykXoD7qTnf6W6a1emTWZe5VLGqv0N63zMmpWtvl9fq_yTwez-8
Message-ID: <CAHYDg1ReKsz_RNB_k3nc+qDu2vjGz+OQfNQhthNzW7TvGMLc6Q@mail.gmail.com>
Subject: Re: [PATCH rdma-next] RDMA/irdma: Check MR contiguity before PBLE alloc
To: Leon Romanovsky <leon@kernel.org>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, tatyana.e.nikolova@intel.com, linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Okay, I will respin to skip the best_pgsz call. I should have it out soon.

Just to run this by you: The HW still requires a page size in contiguous mo=
de
and expects the DMA address to be aligned to that size. So, I'll use SZ_4K =
which
should be safe in all cases and then ALIGN_DOWN the value of
ib_umem_start_dma_addr().

Thanks,
Jake




On Tue, Oct 13, 2026 at 7:22=E2=80=AFAM Leon Romanovsky <leon@kernel.org> w=
rote:
>
> On Mon, Oct 12, 2026 at 03:50:10PM -0300, Jason Gunthorpe wrote:
> > On Sat, Oct 10, 2026 at 07:48:32PM +0000, Jacob Moroni wrote:
> > > @@ -3487,6 +3442,8 @@ static struct irdma_mr *irdma_alloc_iwmr(struct=
 ib_umem *region,
> > >     pgsz_bitmap =3D (reg_type =3D=3D IRDMA_MEMREG_TYPE_MEM) ?
> > >             iwdev->rf->sc_dev.hw_attrs.page_size_cap : SZ_4K;
> > >
> > > +   iwmr->is_contig =3D ib_umem_is_contiguous(region);
> > > +   /* Call best_pgsz after is_contiguous to restore correct umem->io=
va. */
> > >     iwmr->page_size =3D ib_umem_find_best_pgsz(region, pgsz_bitmap, v=
irt);
> > >     if (unlikely(!iwmr->page_size)) {
> > >             kfree(iwmr);
> > > @@ -3846,6 +3803,7 @@ static int irdma_rereg_mr_trans(struct irdma_mr=
 *iwmr, u64 start, u64 len,
> > >     iwmr->region =3D region;
> > >     iwmr->ibmr.iova =3D virt;
> > >     iwmr->ibmr.pd =3D pd;
> > > +   iwmr->is_contig =3D ib_umem_is_contiguous(region);
> > >     iwmr->page_size =3D ib_umem_find_best_pgsz(region,
> > >                             iwdev->rf->sc_dev.hw_attrs.page_size_cap,
> > >                             virt);
> >
> > You should not call ib_umem_find_best_pgsz() after
> > ib_umem_is_contiguous(), it is nonsense to compute a page_size once
> > the contiguous optimization is being used.
>
> ok, I dropped the patch from mu wip/leon-for-next branch for now.
>
> Thanks
>
> >
> > Once you decide to use contiguous the start dma address should go
> > straight into the MR structure and just avoid all the pbl stuff.
> >
> > Jason
