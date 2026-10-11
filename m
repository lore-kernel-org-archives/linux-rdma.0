Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECD871B87C9
	for <linux-rdma@vger.kernel.org>; Sun, 11 Oct 2026 01:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791682056; cv=none; b=W4sePzHhKfBRrLIPK2kvXxMlyqpbGlC2f38mT0WUEC9CXpDr1neQ1qXZRmqrxbf9KkApvUUZIfCVDrLfq2mMp9SopR9eZPaSrRJyWGXMo7k1+DursPhXZhnfNs9mv4UjJYuL3AHr9ZFEFraR14GknknndR6455+oQ+KrCrYoyTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791682056; c=relaxed/simple;
	bh=LMacocohg+/SsWUuiFeDX8YvCg3s6745Kzk3WI/x+9w=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=US3qJER2YvPp/NeZ+l4J1xvkKXZhO/y+F/3jMV+9mmxUonZqK956m0cTMwvwraWS+Cq0UB1hxhs7yHEkm4sclST6Pjc+1Td7cWO2Tja9CDkc1Tw3UXbI73J5+n6rTHDKPqQRfc+SOOCoEjOIFmCL9WDAi8T06M0H74Koo5OXB9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lFgheHl1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lFgheHl1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F661F000FF;
	Sun, 11 Oct 2026 01:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791682055;
	bh=vSsrT+9ucUE69JQqZe+ShpCj37i7h1jdDb7R58nCbAU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lFgheHl1FG5fCO81w9Y5RduFuRz7wZTUPNKg6KwSfh0Bt2FIuE9/jmVelNGmtWH4Z
	 GLKCN8dTlCb9+IabYScSSNSNqlHpsrZnnB7c/7ohyyNEaySF/9UmuQ+dryEIPMCYML
	 KBkjcFa3ic8pjiT9wx9zATJLjisxyJ8WW9p4YnxGsFz3745XTt0FWpT2NfUDO/7APe
	 4URrvxRnqoUQJj9NN8EQncPF2om2Kzsjutlf3RbpXx2HNGrftOo65f+vrdb9myna4Y
	 4A2XIjtZc9Tra4+nqeCGM0IEQPNcW+D3c/hLK8a2BXrW+kojP3dHbAzsAWzy4LZV7W
	 UhWPsA//olhbg==
Message-ID: <sashiko-outbox-166959@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 4/5] RDMA/irdma: Support UMEM attribute for CQ
 creation
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Hu" <dhu@x6u.co>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261011011022.1445352-5-dhu@x6u.co>
References: <20261011011022.1445352-1-dhu@x6u.co>
 <20261011011022.1445352-5-dhu@x6u.co>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 11 Oct 2026 01:27:35 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] rdma/irdma: Memory and resource leak in irdma_resize_cq for 1-step=
 CQs
--

commit fbc0fbebd82d8c5ffc02a6bcacb939600a040cd7
Author: David Hu <xuehaohu@google.com>

RDMA/irdma: Support UMEM attribute for CQ creation

This patch supports the standard 1-step queue buffer creation model for CQs
using UMEM attributes. It sets up hardware PBLs directly from the pinned CQ
and shadow umems, and adds proper cleanup in irdma_cq_free_rsrc() upon CQ
destruction. Legacy 2-step registration is maintained for backward
compatibility.

> diff --git a/drivers/infiniband/hw/irdma/verbs.c b/drivers/infiniband/hw/=
irdma/verbs.c
> index ab25445f38282..e4a02a6b2a113 100644
> --- a/drivers/infiniband/hw/irdma/verbs.c
> +++ b/drivers/infiniband/hw/irdma/verbs.c
> @@ -2028,13 +2028,24 @@ static void irdma_cq_free_rsrc(struct irdma_pci_f=
 *rf, struct irdma_cq *iwcq)
>  		if (iwcq->iwpbl) {
>  			iwmr =3D iwcq->iwpbl->iwmr;
> =20
> -			refcount_dec(&iwmr->user_ring_refs);
> +			if (iwmr && refcount_dec_and_test(&iwmr->user_ring_refs)) {
> +				ib_umem_release(iwmr->region);
> +				if (iwcq->iwpbl->pbl_allocated)
> +					irdma_free_pble(rf->pble_rsrc, &iwcq->iwpbl->pble_alloc);
> +				kfree(iwmr);
> +			}
>  		}

[Severity: High]
Does the introduction of 1-step CQs create a resource leak in=20
irdma_resize_cq()?

When userspace resizes the CQ via ib_uverbs_resize_cq(), the kernel invokes=
=20
irdma_resize_cq(). This function successfully swaps in the new PBL and drop=
s=20
the reference to the old MR:

drivers/infiniband/hw/irdma/verbs.c:irdma_resize_cq() {
...
	spin_lock_irqsave(&iwcq->lock, flags);
	if (udata) {
		struct irdma_pbl *old_iwpbl =3D iwcq->iwpbl;
		...
		iwcq->iwpbl =3D iwpbl_buf;
		if (old_iwpbl) {
			struct irdma_mr *old_iwmr =3D old_iwpbl->iwmr;

			refcount_dec(&old_iwmr->user_ring_refs);
		}
	}
...
}

For 1-step MRs, the refcount drops from 1 to 0 here. However, since=20
irdma_resize_cq() doesn't use refcount_dec_and_test() with the explicit=20
cleanup logic added to irdma_cq_free_rsrc(), it appears the MR struct, UMEM=
=20
region, and PBLE resources will be permanently leaked.

If the cleanup logic is added to irdma_resize_cq(), it looks like it would=
=20
cause a sleeping in atomic context bug if placed inside the spin_lock_irqsa=
ve=20
region, since irdma_free_pble() acquires pble_mutex_lock. The cleanup would=
=20
need to be deferred until after spin_unlock_irqrestore().

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261011011022.1445=
352-1-dhu@x6u.co?part=3D4
