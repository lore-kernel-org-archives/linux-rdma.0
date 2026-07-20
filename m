Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA623D8115
	for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 09:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784541509; cv=pass; b=iihKy046r9G3GMUpDKIZxi1kvCXac15MqH9djDxwtZAKh6ZN/sCNu5qI3OWJakLh+Iw0ulVCGQ1K0FKjFDangi0r6bf7CmMU79qympQG7FcdxvKvoptKpiDB49JTM/u7HSeTBQeFoqOzXTiXAhzAXPh1xyNSraaS5JjAIgHWbAw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784541509; c=relaxed/simple;
	bh=kEFjACGfN5Mv6vqShSwIb0iC96xq8g68uewoYj2b2I4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S8ZrhepDmw52e1OcJ8axZnu3onxiGn+G5yMDEAR7+mBVyzsMxVNYaV7I67k27btN93i77TIZqfT6/tXnSrWAwkGuUh0hOiYFhDGk4/3HKrq6101Lu4yM8PSxSOonWmUu/x3I5EclEdW3E6xS36qjAX1phYBYrBVVXRSvyP+GpBI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KgyKPN6P; arc=pass smtp.client-ip=209.85.160.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KgyKPN6P"
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-51c01c79467so662081cf.0
        for <linux-rdma@vger.kernel.org>; Mon, 20 Jul 2026 02:58:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784541501; cv=none;
        d=google.com; s=arc-20260327;
        b=lsMdtrJV6zGFcwQhZ/DRC1SO54bxhbum0+uO43vSqkzvc7yz7BCOHNCXvL0ywHlUxh
         mqW/XsNNx4OiV/wQnHBzAeZTFhq5LowK5ZInwTisuSrZE5gGDZLBGtuSXcV4eGAl1JQ/
         GkGrTfox1rYYEAVPtHI4PdC9G+kTqKz/98k5lEZtp5qPdpfU8uEHmtOjsF+T+hr9COYh
         c0yL4dUBeoLk5RhN3iw2zbF7ie/swwi9mPE5diJwI0zBw8skxE9bxl0fWlLCfpcaBM22
         XF5BtUPwdEj8mZYmV/5OeG7CF6qQxpt+iNVr0Xy6b3lqc4qVYP/kaFE5o9+m1xiITmW9
         0nLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hvDfTHrwZHejRymuJb/B06PTdjYcc+YhxsDIaGscHQE=;
        fh=zR1fRGgxoUuuGuy9KYa8jHASOjzPzIHtofnOY+PlpdQ=;
        b=WfJnThptpSuY/ZxWlzuKoCb0jtwS3KeMbs9zdndQnQ9Y+veWYHhd/cXhfGtXiAcvTx
         GrUVFsjlX1kQlHwqoZXUMZIUNcpl3SlswMHd9Y7rcVGArs3uGbyM9zKKs6q6EcW0L6wL
         2dAIndg306VJ+NOmhesBdyD44kzPDOT5rbEwYQK916THbkHoxfsgNwpGN0zHIjQDG2oW
         4qO5lvBKu1ceIT52JgtGxR0OwcIbVcgP5PtbDV+XiEF4mXlW0WK6pzjRyxsdcX+Fdq1X
         jPs6569xojaLInyLxOeCg3PJ31L/jAChrT1jglzBKkpOAlATqhlbnvxAfJGAGS7hCObh
         SLGg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784541501; x=1785146301; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hvDfTHrwZHejRymuJb/B06PTdjYcc+YhxsDIaGscHQE=;
        b=KgyKPN6PASoxJ6z5T2Z+JKoaeOicbbZo0SlIfBmqIGW33d91hWYr0idTJM9kz4LX7t
         fMqmSok1OejhauUfU3iK9NgpPE1vwW2hmBeeFdMhngicYRHohzNHX3IHvycWvm9pXK36
         Iy6V+c3P8BkgLKpkT1vSnhDjTGeHWuK8s+jYMH4qTyyxPZjSOdUJ7cotYvScMQeG92b7
         pXe6plz1NXNgXXouDzL8uHklomjq/kpfWF+AjAOIhn53RrHNTjol8LNI80+qkAJJdYMB
         idAF2b70X4HVyLNdmZBZprdLnv78qeu8g3Ip9OFqhX6A4F0thl05OtuioILyBsz1yeIv
         IMfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784541501; x=1785146301;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hvDfTHrwZHejRymuJb/B06PTdjYcc+YhxsDIaGscHQE=;
        b=kgG6yO3rj8FGzL0nOGdzOc/qy8fYR9AN1vB4iHyUEjfRE6rOK0joq2GM6EWiUJBfH8
         Vqyd8379IBbpullY33SXDf+HlSDbHlKpMBFmKWc+RTw65pic18ECdpqVy62Te/fOrczn
         sMwrHdUDkxZinPbBnRiv3s27wgOPBF5mum8y3vP8YPlk1S8sFmfIptFu4S9862zaOzmr
         /HnqcD9MM+jmGJYfSkv3JzBRMxAriMJ5nck4phJcqgGUbqgJ1Fx6tvQJeAAOCqZgtAxU
         zedwyOfHj8dotzPdh2yhw4KAbgoXKzdw4lwHkVgnRCEtZkMzxnUgv7l5ffJaNwSdTgS5
         sV7g==
X-Forwarded-Encrypted: i=1; AHgh+Rr+OnFy9bw5019Ka7ENf+/WpFeXyflUnvdYdCMwKj5hPNK6L7kYvt7eLBloP/C2ayIERIPKWhOtP8Ia@vger.kernel.org
X-Gm-Message-State: AOJu0YzAKRHJrtfwwHhBruEu8z/TQ43nj1UxPj+gbfyKbRem+u8etn6p
	+z5P6Y1RxsQomCXoYEaxWNbnhxEer1I0rhrAGMGloJ9qQnwYoWeYbE9N9zLupFqaj05mF6aemmb
	GcTes5CxDDTFihO43RPXUYWufu5r12tWQ/Gmgc2Qr
X-Gm-Gg: AfdE7cliYDjutH1LZhoSQSxbZ192N2LKxfh5dy2toYkQT1Jq02vJ/QygRJVWjyb/Az7
	EwL1s14xxpg26dFG0JcVBlFDf6s2j3k+KuCxLRYhaUiUJLIYPrhj2OuuSsRYwzlm6mpeB8Rg078
	JwCwdzlkkztx3joEqVIZ4DmHcZcmFxv6POs/lORmMGS1GEcZ0hUzBd98d4c4TdNENfKwaJG/ez+
	hCm3FzqYwneAqoK1SIaP42G7Qgb0OE4R2AF/ybBZYeqcnu/NYIeZYWuv6ssKeDD6AT4QgEmRLv7
	Vg0S0euPeR6hX+fSkcNFi8ukFFuUhLlNM19huVxOOsXHTBKluiUi
X-Received: by 2002:a05:622a:48:b0:50d:edb1:6bd1 with SMTP id
 d75a77b69052e-522620dd7c2mr14223141cf.13.1784541500062; Mon, 20 Jul 2026
 02:58:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260715143540.3597616-1-praan@google.com> <20260715143540.3597616-4-praan@google.com>
 <20260720091505.GC24298@lst.de>
In-Reply-To: <20260720091505.GC24298@lst.de>
From: Shivaji Kant <shivajikant@google.com>
Date: Mon, 20 Jul 2026 15:28:09 +0530
X-Gm-Features: AUfX_mzZMPcyHs4G_t5jKfKYQ71kCdRTHOUOtRtezglHlIfk1lucEret0Y4gcKo
Message-ID: <CAMEhMp=eHz105-t+pDLbX+6uWOPAGHWfkjd4PqTdeXmXf0tPGw@mail.gmail.com>
Subject: Re: [PATCH v3 3/5] nfs: Introduce nfs_release_request_list helper
To: Christoph Hellwig <hch@lst.de>
Cc: Pranjal Shrivastava <praan@google.com>, Trond Myklebust <trondmy@kernel.org>, 
	Anna Schumaker <anna@kernel.org>, linux-nfs@vger.kernel.org, Chuck Lever <cel@kernel.org>, 
	Jeff Layton <jlayton@kernel.org>, linux-kernel@vger.kernel.org, 
	Logan Gunthorpe <logang@deltatee.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-pci@vger.kernel.org, 
	linux-rdma@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 20, 2026 at 2:45=E2=80=AFPM Christoph Hellwig <hch@lst.de> wrot=
e:
>
> On Wed, Jul 15, 2026 at 02:35:38PM +0000, Pranjal Shrivastava wrote:
> > Introduce a centralized helper, nfs_release_request_list, to handle
> > the bulk release of nfs_page requests from a list.
> >
> > This serves as a preparatory step for two upcoming improvements:
> >
> >    1. Pin-Aware Cleanup: As we migrate to iov_iter_extract_* API,
> >       requests will hold pins (GUP) instead of standard references. The
> >       helper ensures that the correct unpinning logic gets applied
> >       consistently across all requests in a list.
> >
> >    2. Folio Support: In subsequent patches where nfs_page structures
> >       will cover multi-page folios, this helper provides a clean
> >       infrastructure to unlock these larger units of I/O in bulk during
> >       completion, similat to the pattern in bio_release_pages.

nit: similar -> similar


> >
> > Additionally, refactor nfs_read_sync_pgio_error() to utilize this new
> > helper.
> >
> > Signed-off-by: Pranjal Shrivastava <praan@google.com>
> > ---
> >  fs/nfs/direct.c          |  8 +-------
> >  fs/nfs/pagelist.c        | 18 ++++++++++++++++++
> >  include/linux/nfs_page.h |  4 ++--
> >  3 files changed, 21 insertions(+), 9 deletions(-)
> >
> > diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
> > index 19792a38c924..96995736fac2 100644
> > --- a/fs/nfs/direct.c
> > +++ b/fs/nfs/direct.c
> > @@ -314,13 +314,7 @@ static void nfs_direct_read_completion(struct nfs_=
pgio_header *hdr)
> >
> >  static void nfs_read_sync_pgio_error(struct list_head *head, int error=
)
> >  {
> > -     struct nfs_page *req;
> > -
> > -     while (!list_empty(head)) {
> > -             req =3D nfs_list_entry(head->next);
> > -             nfs_list_remove_request(req);
> > -             nfs_release_request(req);
> > -     }
> > +     nfs_release_request_list(head);
> >  }
> >
> >  static void nfs_direct_pgio_init(struct nfs_pgio_header *hdr)
> > diff --git a/fs/nfs/pagelist.c b/fs/nfs/pagelist.c
> > index 7d51e10fe97a..569bac4faff7 100644
> > --- a/fs/nfs/pagelist.c
> > +++ b/fs/nfs/pagelist.c
> > @@ -622,6 +622,24 @@ void nfs_release_request(struct nfs_page *req)
> >  }
> >  EXPORT_SYMBOL_GPL(nfs_release_request);
> >
> > +/*
> > + * nfs_release_request_list - Release a list of NFS read/write request=
s
> > + * @head: list of requests to release
> > + *
> > + * Removes each request from the list and drops it's refcount.
> > + */
> > +void nfs_release_request_list(struct list_head *head)
> > +{
> > +     struct nfs_page *req;
> > +
> > +     while (!list_empty(head)) {
> > +             req =3D nfs_list_entry(head->next);
>
> req could/should be local here.  Or you switch to list_first_or_null,
> which some folks prefer.
>
> > +extern void nfs_release_request(struct nfs_page *req);
> > +extern void nfs_release_request_list(struct list_head *head);
>
> Please drop the superflous externs for new code.
>

Small nit + fix christoph's comment,
else looks ok

Reviewed-by: Shivaji Kant <shivajikant@google.com>
