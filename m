Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F2039D3D0
	for <linux-rdma@vger.kernel.org>; Fri,  5 Jun 2026 22:39:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780699165; cv=pass; b=fbl8v1LYSDD7hcx3fsRC+CP7iaU6CVM2Q4df34RoVrzB8CEt7oevQMtRTxD3L35iM5f8guDqPSSKLrz1ixgXh03WO4vOYxZw4ypdd6KhLyrGz42oyGNzMw+CqgE6wtASZ/sWimcjmAmuLXoCvVq7IILMXROa71WZ8J3Q8ZQ9pBY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780699165; c=relaxed/simple;
	bh=FnXrjnkNI33tVdfHYkYQx3ixiIoGOgfo4flzDs56Vb4=;
	h=From:References:In-Reply-To:MIME-Version:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SoVg4QRaE3/utuQPjAwHqBUAnFaeQ+nqM+v4nnutWTyM3Y6kj0cenePyUMiQX+oxsij88WjaH6Gkh6E9tllh8ZmmxXhYXvJBGIjLxvpLfG/85MW8+nGf4vxRkqXDi4O3TqP2Jm+eeWsPUY1xEdkEv7md8dP1edmqXCjNb/MoGW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hammerspace.com; spf=fail smtp.mailfrom=hammerspace.com; dkim=pass (2048-bit key) header.d=hammerspace.com header.i=@hammerspace.com header.b=FpRyl6hB; arc=pass smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=hammerspace.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=hammerspace.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hammerspace.com header.i=@hammerspace.com header.b="FpRyl6hB"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490a765d410so25216475e9.1
        for <linux-rdma@vger.kernel.org>; Fri, 05 Jun 2026 15:39:22 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780699161; cv=none;
        d=google.com; s=arc-20240605;
        b=RpquaJ/3KCqKOAcgxclG74ya0mPiDeXb9TB6FIfEt0V6tcqbECZLMYgNmefFlLVx1I
         Kf3DQvGsYQVNDA2AGrEWtre1AFa2i3aKXtC4kUePhUJcvEaukTMSAPPCTguVvxQiK8y1
         2TYB3LwGJivdCBvHerTevae6QQpax0xubP/Z4/5SbAd+lnlGAY+qiarejFlc1VzuNJ+u
         YP7RI1pvZwb2I00Az/gYZ+PMqMabFvdTQ1CARD15YXI14mVF12BeCEZiETyqEXslSMBl
         Ce/tq2NmpPNhmEgMP4P6QZ/lWcJ/ZWG+eRB1cEcAXywKS51inIzszG8+9yQ8oPQoX36v
         4J8w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:dkim-signature;
        bh=Fc6W6oIkjMbqytM9E/cvVD3Cas3uXp/UlRnjJ0px6I0=;
        fh=105b4i1cBBe/Q5ysiQ1NbhVCx8/+su9scbMs6h0o+pk=;
        b=a7k15JReBKr0Go8LylngIYq/E3FZzD5pE/jUz/Lzz5ci+oVWwScH3Mcn2dlOngfCZ1
         /UrYq36/Ie1ZVcbOqcQjln1gUzT65RFr3QYEwdmMTzn9kC9KrPoLyn4ab8+7re/OT17U
         dQYFzKyuGRolQJ7PceCyab8cJb6jGKMiehtzL7PYQqt+IEo/gHVrsBMQqZXR6W++JEiM
         ZeTW0U/2SFjrGpxebjAQ7tckFm9OkJ6oc0q6W1SF7TVfSDdhwFoV1244YjjtO1pP7k60
         7zcgkGjOZUNMhUwWkIj/NGIzL/96+xjcTqau7KRizUkhgZrEUCRiNR5K4m8Dzxsx2Xn5
         z2Lw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=hammerspace.com; s=google; t=1780699161; x=1781303961; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Fc6W6oIkjMbqytM9E/cvVD3Cas3uXp/UlRnjJ0px6I0=;
        b=FpRyl6hBOA1tRKzb1NYQRH0n5h6zJWNP7+Vv/Jv6xlzl1q5POyjrRAKg75ilawF8dz
         YZf/6fIl1gg2pxLmwnBTzoONP8G+Q23F6GFFah6w7jPrNhz3J8wKTN662LnutQJ0HwZo
         AeR6I8ldnH8XmocD7OeiGdDpjrMAQd4AYc7Pfxvvns9ShM6H5YQk+Ymaybv+3wFkNYNz
         4HRIQc8svHQusKq/c+zTw8DNwHt6aqIktSNVS+Wju7VVbEg4qUr8dMAFSJMO4ybKA8Di
         X+EDBghkYvXAE8lUjoI+U7QOOSbSxWSUTG+XIh3m4W5AofZJDaa99EkfXXwOGfyM44J7
         tXRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780699161; x=1781303961;
        h=cc:to:subject:message-id:date:thread-index:mime-version:in-reply-to
         :references:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Fc6W6oIkjMbqytM9E/cvVD3Cas3uXp/UlRnjJ0px6I0=;
        b=VfGAN81ccoudvhMnyfTJaqc8uEfFcdo4nHmCh4qh/rhK0AJIWk319+ZZdZIcwOGGgv
         Mj23chUhyRpQ5KjAnhfXLO2x656uZ5tWdUWAZ7aSLLDxJGE1LrmjrgFPTlQ7YLtyP+5n
         OlT+K22BtotfYw4pMYu1zaAu3H912tAOgRIH37GX3p1qfY51QiMuOWlrF20SYAMQ4ueY
         xvGgITlTTV9L1DqEbwfCG7b7UgMM0yIdqv8YfsEVsQC/2WVpyuCdi2iI6U2pwL7k9ZAN
         bnpl5pKKqbpr31xK6cEN7MlDhStdUgbXICrd9GdUHbbqEpzo0wQTUKaFkuA+UpJ9oi/p
         jFKw==
X-Forwarded-Encrypted: i=1; AFNElJ/xvoMEPugS6M+3WWkM3nB3O2a5fhmjrkMfCSD3I7SmWcTzXUwXkoDZ6rlTUUojnaEKEeSE+Dk+JYqv@vger.kernel.org
X-Gm-Message-State: AOJu0YzRcHs4o4i/lSdMaFGgP9bRMGIjB1Nx5L+eG4shYagwvIOkX2PN
	GsvAYEIQkm/Z3gpwA28ObqBb+KMNBk6T4w0HX0i1DoaR8h5zs2bEbY6ceg0yJ6LdvJczrmk36Uz
	EDaFBZD2k2hagF0vBgXyMcRJPudYrRtx0/cfMietuRw==
X-Gm-Gg: Acq92OGrKYDi6fxvMCVY8EXcRE9rIhy6XyhjUotJG38PkfRhOo/NAsnmH8VizrwObhj
	G1iiQN5yyCWzyXy66O8QQjmlss5nU5OvMeEXF+hpxcsioUGaolPdoUpI+WA46MukT/wiFTgK+F1
	jyXMOdj8k432mj2IcR11OP0dokV/AuXAeB8ZQXAuEcuGR6/cyH0TrfUZIGDkr1aEvM7bDo7lVUP
	0f8XpZrXgtJ/xcdxN1K5FBEIm+gTPhrmYu9dI9X9BTx/pEVSMvE2HmevUIyKWlg7jdXwTyFwmVt
	+7hPFQHWUZ+64WouZUqlZY0wD/Q=
X-Received: by 2002:a05:600c:8215:b0:490:a1be:6b01 with SMTP id
 5b1f17b1804b1-490c2560493mr100406745e9.4.1780699161033; Fri, 05 Jun 2026
 15:39:21 -0700 (PDT)
From: Jonathan Flynn <jonathan.flynn@hammerspace.com>
References: <20260605223118.75092-1-cel@kernel.org>
In-Reply-To: <20260605223118.75092-1-cel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIiV4E/dqzlDyccSLfgm6X2NNlNbLWlyTfw
Date: Fri, 5 Jun 2026 16:39:20 -0600
X-Gm-Features: AVVi8CdXBg5Y8jbUNOnF8jvT6U-MYB1M6GFzsUq2DqSnz6vAYtQ5xwc8jaW0bKE
Message-ID: <32141f1303369612966329d18bc37c0d@mail.gmail.com>
Subject: RE: [PATCH] svcrdma: Avoid direct reclaim when allocating Read sink buffers
To: Chuck Lever <cel@kernel.org>, Mike Snitzer <snitzer@kernel.org>
Cc: linux-nfs@vger.kernel.org, linux-rdma@vger.kernel.org, 
	Chuck Lever <chuck.lever@oracle.com>
Content-Type: text/plain; charset="UTF-8"

Thanks Chuck, give me a few to test it out!

> -----Original Message-----
> From: Chuck Lever <cel@kernel.org>
> Sent: Friday, June 5, 2026 4:31 PM
> To: Mike Snitzer <snitzer@kernel.org>
> Cc: linux-nfs@vger.kernel.org; linux-rdma@vger.kernel.org; Chuck Lever
> <chuck.lever@oracle.com>; Jonathan Flynn
> <jonathan.flynn@hammerspace.com>
> Subject: [PATCH] svcrdma: Avoid direct reclaim when allocating Read sink
> buffers
>
> From: Chuck Lever <chuck.lever@oracle.com>
>
> svc_rdma_alloc_read_pages() passes __GFP_NORETRY, which limits the
> allocator to a single round of direct reclaim and asynchronous
compaction per
> attempt. Under memory pressure or fragmentation that round can take a
long
> time, and the fallback loop repeats it at each order, multiplying the
stall while
> the RPC waits for its Read sink buffer.
>
> The contiguous allocation is opportunistic: when it fails, Read sink
buffers
> come from the pages already in rq_pages[]. Direct reclaim effort buys
little
> here. Allocate with GFP_NOWAIT instead, which omits
> __GFP_DIRECT_RECLAIM so the allocator takes pages only from the free
lists
> and returns NULL immediately when none are available. GFP_NOWAIT retains
> __GFP_KSWAPD_RECLAIM, so a failed attempt still wakes kswapd to
replenish
> higher-order pages in the background, and it already includes
> __GFP_NOWARN. __GFP_NORETRY has no effect once direct reclaim is off.
> skb_page_frag_refill() takes the same approach for its opportunistic
high-
> order allocation.
>
> Reported-by: Jonathan Flynn <jonathan.flynn@hammerspace.com>
> Fixes: 18755b8c2f24 ("svcrdma: Use contiguous pages for RDMA Read sink
> buffers")
> Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
> ---
>  net/sunrpc/xprtrdma/svc_rdma_rw.c | 18 +++++++++---------
>  1 file changed, 9 insertions(+), 9 deletions(-)
>
>
> Given the perf symbol resolution inaccuracies I can't swear this will
fix the
> issue, but here's a stab at it.
>
>
> diff --git a/net/sunrpc/xprtrdma/svc_rdma_rw.c
> b/net/sunrpc/xprtrdma/svc_rdma_rw.c
> index 587e4cd29303..efde26cac961 100644
> --- a/net/sunrpc/xprtrdma/svc_rdma_rw.c
> +++ b/net/sunrpc/xprtrdma/svc_rdma_rw.c
> @@ -746,10 +746,9 @@ int svc_rdma_prepare_reply_chunk(struct
> svcxprt_rdma *rdma,  }
>
>  /*
> - * Cap contiguous RDMA Read sink allocations at order-4.
> - * Higher orders risk allocation failure under
> - * __GFP_NORETRY, which would negate the benefit of the
> - * contiguous fast path.
> + * Cap contiguous RDMA Read sink allocations at order-4. Higher orders
> + risk
> + * allocation failure under GFP_NOWAIT, which would negate the benefit
> + of
> + * the contiguous fast path.
>   */
>  #define SVC_RDMA_CONTIG_MAX_ORDER	4
>
> @@ -758,9 +757,11 @@ int svc_rdma_prepare_reply_chunk(struct
> svcxprt_rdma *rdma,
>   * @nr_pages: number of pages needed
>   * @order: on success, set to the allocation order
>   *
> - * Attempts a higher-order allocation, falling back to smaller orders.
> - * The returned pages are split immediately so each sub-page has its
> - * own refcount and can be freed independently.
> + * Attempts a higher-order allocation, falling back to smaller orders.
> + The
> + * allocation is opportunistic: it takes pages only from the free
> + lists,
> + * without direct reclaim, so it fails fast under memory pressure. The
> + * returned pages are split immediately so each sub-page has its own
> + * refcount and can be freed independently.
>   *
>   * Returns a pointer to the first page on success, or NULL if even
>   * order-1 allocation fails.
> @@ -775,8 +776,7 @@ svc_rdma_alloc_read_pages(unsigned int nr_pages,
> unsigned int *order)
>  		SVC_RDMA_CONTIG_MAX_ORDER);
>
>  	while (o >= 1) {
> -		page = alloc_pages(GFP_KERNEL | __GFP_NORETRY |
> __GFP_NOWARN,
> -				   o);
> +		page = alloc_pages(GFP_NOWAIT, o);
>  		if (page) {
>  			split_page(page, o);
>  			*order = o;
> --
> 2.54.0
