Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793068436;
	b=SutMwBFoV2rNDNv/OnYcgPAn2antZlcngrLT37bfcVYBJn3Nvo80IhfNdJi88S8S44c/
	 KliwytwaGcuOEiCYA6R/lWiGlzSEipQ5x4QajvsWw3w59DETeVsLxoF8A/DQRjKzQGkpa
	 SxsIze4rzoKlKQHuod5FSZ5AH4nlXv6Td+uuk1W2FK0M+wd4hH9h6R+GZ97IDEJdzKF1B
	 hxFcVoKU/VEV8gE3GsKKlj5LArdPrIWqY+qTfB/ArYv90XtP0bWxqr1JO97QTwm38BDml
	 KI+3rQgIYYJ4dkevvLjhMKLaa9H+qiaDX9V8TLSH7UkiVIp4y6NOyv2wdar8ngijvog==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793068436;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=4b+t6BUzPROpnYm4LeCyGHbBXsxEE5A6v3JAThHh5PA=;
	b=Z7SCFQqHTS+W7QoJgjEZXGGV7IsjrgZTITXvuK767Lpco6+7g4K6WKUXGBk6aENCPWUi
	 47LiaQ3C8PQvkIivYT4YzAGSUUW5UaJP8SKmtFuXF7P0fxdcc10iPkzNyFdOR/dooUjsb
	 XEhQvH41+IKvYU9h8WYSpx56JlU7e6aFc1eNIaGzREzGQSaUTz42AeBmdJ2yQK9PwnDcC
	 NINt0Ge9OuyFTrRPi6XAwjCVlnvJLk809bIESwBBOMXuF/5XGTXLOX2md9g94QA1Z6KXu
	 ZjxGcI914yVe+SDBGREPatrM7zB7BQqKKQZoOaxEegL88Q6sJQJwlBe21lbwrOvBWdA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iva0p9wp;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED77C606A31A
	for <linux-rdma@vger.kernel.org>; Tue, 27 Oct 2026 02:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iva0p9wp
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54DCE1F01825;
	Tue, 27 Oct 2026 02:33:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793068435;
	bh=4b+t6BUzPROpnYm4LeCyGHbBXsxEE5A6v3JAThHh5PA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iva0p9wp/5KRzEiej99ra0RnZLGPDfdP38DJ+MrEqAXdaxfbK2WM7xMQ4g9legVU8
	 b8UNoSV9DdZxe+Koe+fqkJ07uYB2Gl3ubYd3M8i9lL58gz2IMTtFPO+h7wG7nRs56/
	 jrqTZX50SPut2vS6Er5FFbE1fSFY6324edYsHOeWcLGUYAW73jKAsnX25jRPA1TxmN
	 cjBmthavXuGIdnDQpv43NS8w72Qja2tcOBZOBnX7LuRjgF8jzzAUb47KhcqJIw3sTz
	 GQlgo0pLeQupIDkd6rFJZV+sWhPCWwGse0LxbRGLxAu5XsmIGZf2YZ5EmEXRHiXUrf
	 CuwFNY9mzC4Hg==
Message-ID: <sashiko-outbox-186024@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma v7 4/7] RDMA/zrdma: Add hardware resource
 initialization and verbs skeleton
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yanze Zhang" <zhang.yanze@zte.com.cn>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261027021119.2325798-5-zhang.yanze@zte.com.cn>
References: <20261027021119.2325798-1-zhang.yanze@zte.com.cn>
 <20261027021119.2325798-5-zhang.yanze@zte.com.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 27 Oct 2026 02:33:54 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] RDMA/zrdma: double free of rf->qp_cnt_8k_idxs in zxdh_initialize_h=
w_rsrc()
--

commit 3b69f0f7bdc773fc9fcdb598091be138d4e8e28a
Author: Yanze Zhang <zhang.yanze@zte.com.cn>

RDMA/zrdma: Add hardware resource initialization and verbs skeleton

This patch adds hardware resource initialization logic and a minimal verbs
layer skeleton, including device registration and initial ib_device_ops.

> diff --git a/drivers/infiniband/hw/zrdma/zrdma_hw.c b/drivers/infiniband/=
hw/zrdma/zrdma_hw.c
> new file mode 100644
> index 0000000000000..068d9aea7c711
> --- /dev/null
> +++ b/drivers/infiniband/hw/zrdma/zrdma_hw.c

[ ... ]

> +static int zxdh_initialize_hw_rsrc(struct zxdh_pci_f *rf)
> +{
> +	u32 rsrc_size;
> +	int ret;
> +
> +	rf->max_cqe =3D ZXDH_MAX_CQE;
> +	rf->max_qp =3D ZXDH_MAX_QP;
> +	rf->max_mr =3D ZXDH_MAX_MR;
> +	rf->max_cq =3D ZXDH_MAX_CQ;
> +	rf->max_srq =3D ZXDH_MAX_SRQ;
> +	rf->max_pd =3D ZXDH_MAX_PD;
> +	rf->max_ah =3D ZXDH_MAX_AH;
> +	rf->max_mcg =3D ZXDH_MAX_MCG;
> +	rf->max_pri =3D ZXDH_MAX_USER_PRIORITY;
> +	rf->max_8k_idx =3D ZXDH_MAX_8K_IDX;
> +
> +	rf->qp_cnt_8k_idxs =3D vzalloc(rf->max_8k_idx * sizeof(u32));
> +	if (!rf->qp_cnt_8k_idxs) {
> +		ret =3D -ENOMEM;
> +		goto mem_8k_qp_cnt_vmalloc_fail;
> +	}
> +
> +	rsrc_size =3D zxdh_calc_mem_rsrc_size(rf);
> +	rf->mem_rsrc =3D vzalloc(rsrc_size);
> +	if (!rf->mem_rsrc) {
> +		ret =3D -ENOMEM;
> +		goto mem_rsrc_vmalloc_fail;
> +	}
> +
> +	zxdh_set_hw_rsrc(rf);
> +
> +	set_bit(0, rf->allocated_mrs);
> +	set_bit(1, rf->allocated_mrs);
> +	set_bit(0, rf->allocated_pds);
> +	set_bit(0, rf->allocated_qps);
> +	set_bit(0, rf->allocated_ahs);
> +	set_bit(0, rf->allocated_mcgs);
> +
> +	return 0;
> +
> +mem_rsrc_vmalloc_fail:
> +	vfree(rf->qp_cnt_8k_idxs);
> +mem_8k_qp_cnt_vmalloc_fail:
> +	return ret;
> +}

[Severity: High]
Can this cause a double free of rf->qp_cnt_8k_idxs if allocating
rf->mem_rsrc fails?

In zxdh_initialize_hw_rsrc(), if vzalloc() succeeds for rf->qp_cnt_8k_idxs
but fails for rf->mem_rsrc, the mem_rsrc_vmalloc_fail error path calls
vfree(rf->qp_cnt_8k_idxs) without clearing rf->qp_cnt_8k_idxs to NULL.

In the follow-up commit ("RDMA/zrdma: Add device probe and remove logic"),
zxdh_probe() calls zxdh_ctrl_init_hw() -> zxdh_initialize_hw_rsrc(). On
failure, zxdh_probe() jumps to err_dealloc and calls
ib_dealloc_device(&zdev->ibdev), which invokes the .dealloc_driver callback
zxdh_ib_dealloc_device(). Because rf->qp_cnt_8k_idxs is still non-NULL,
zxdh_ib_dealloc_device() calls kvfree(zdev->rf->qp_cnt_8k_idxs) on the
dangling pointer and frees it a second time.

Should rf->qp_cnt_8k_idxs be set to NULL after vfree(), or should freeing it
be left solely to zxdh_ib_dealloc_device()?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261027021119.2325=
798-1-zhang.yanze@zte.com.cn?part=3D4
