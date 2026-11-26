Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795685609;
	b=iuuis7GcXVdZmFILCHHUAlq3U3U2+3ubmDnFvkdEHU+RN8h4XrQd/LdVsoxpi020aZzZ
	 WJELcFj8dVi9QszpThTYjAtB9EQ0aJuM3zQlHF+nomCTVwtZwL4SNQUPQXhpEUQFJb0Hj
	 WZfATrtP0hAzRe8D6ST+/8R6tcbA9UBcj7FfuYsjdPr6dywTN8tG3hzMBFIiyvkQ6LXJ5
	 iIg6foiIuZcZER/LYPpwZJk+50ZUs8Q8c8vngeODcFe2CjGAeDR4NekmTePCz2wUgt12X
	 GBKwG7t2vPS5sXxYrK1/6QzhT3ka4+lAkMDwe0kSA1yeb3f+xzfrvytC2/wJK48H/Vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795685609;
	h=Received:DKIM-Signature:From:To:Cc:In-Reply-To:References:Subject:
	 Message-Id:Date:MIME-Version:Content-Type:Content-Transfer-Encoding:
	 X-Mailer;
	bh=UeyiBsBF9ExM6QVMAaUyWl4t4XrQT+ob5B5M3XSZJow=;
	b=cophBgcUPx2XczQY/0MAFOSk+Zbnnnz/wcHtwsw76dyM03ieyDN4PSI7S1zWAReFSHfh
	 OTu2qsr/vTe/mAwUzSL2kKi1T2c2Diil/ADPohws7o79wAXNNdCuB9OqJrg4Vp9QTmxrx
	 HQCjGybh+Ohr0uUOQzuKzlkQPEuaDdcddcnnl1mYKiM9F2msigOImNIXHe2+6+PIVmgKt
	 fdepWb/7FWIBUmLrEmFCAcn9oDgQVtll6MCW/sjs8Z5WgcngIRCPaB+zSwIIKCjwc5wq5
	 P2L2r48FQCQkekJY5BppI7EJatNNCBPu3ZrBnMP2OmI67XIwJo9qnuGjlDAWFf7Amuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SRJSkxkS;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B484606A31E
	for <linux-rdma@vger.kernel.org>; Thu, 26 Nov 2026 09:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SRJSkxkS
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF091F000C6;
	Thu, 26 Nov 2026 09:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795685608;
	bh=UeyiBsBF9ExM6QVMAaUyWl4t4XrQT+ob5B5M3XSZJow=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=SRJSkxkS5diBKf+fuUieIWOCWfxps4Rhs/Llq3A3KF2rooUgTy+95PWN1j+2tteOF
	 hcu9uAFfyvbSOZbSNC/sc+lFovtjPeBsmZlBtO80F4hEy0Du+lemJEy4vfaVItB9Hs
	 0ZxPOene+pxI17M8h0k4xpEMMUzxEXMSYTtrGn4SLds8cyX2KPQm3YSko5NV2YMQD6
	 EbrVOW6DaXvwr/uS16yhD2/PppU3EMCxy6UJ96FSUDudQkCetekFRE8FQXHIB9B9vB
	 C/zuj8LDlMjDuKAo9ohVciGzj2VAd6MnvmCR5P3Rz/SmTHspKYm9RP48JEikdupABW
	 SPgeHDNr84xZw==
From: Leon Romanovsky <leon@kernel.org>
To: Selvin Xavier <selvin.xavier@broadcom.com>, 
 Kalesh AP <kalesh-anakkur.purayil@broadcom.com>, 
 Yuho Choi <oss.patchbox@gmail.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>, linux-rdma@vger.kernel.org
In-Reply-To: <20261124015141.294866-2-oss.patchbox@gmail.com>
References: <20261124015141.294866-2-oss.patchbox@gmail.com>
Subject: Re: [PATCH rdma-next] RDMA/bnxt_re: Don't republish a QP whose
 destroy failed
Message-Id: <179568560548.1256166.4123564942925125447.b4-ty@kernel.org>
Date: Thu, 26 Nov 2026 04:33:25 -0500
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Tue, 24 Nov 2026 01:51:36 +0000, Yuho Choi wrote:
> bnxt_qplib_destroy_qp() removes the QP from rcfw->qp_tbl before sending
> DESTROY_QP and re-inserts it if bnxt_qplib_rcfw_send_message() fails.
> 
> No caller uses the QP after a failure, though:
> - bnxt_re_destroy_qp() logs the error and returns 0 since
>   commit d507d29bfde3 ("RDMA/bnxt_re: Don't fail destroy QP and cleanup
>   debugfs earlier"), so the IB core frees the QP.
> - bnxt_re_destroy_gsi_sqp() logs the error and frees gsi_sqp.
> - bnxt_re_create_qp() frees the QP resources and returns the error so the
>   IB core frees the QP.
> - bnxt_re_create_shadow_gsi() abandons the shadow QP on failure.
> 
> [...]

Applied, thanks!

[1/1] RDMA/bnxt_re: Don't republish a QP whose destroy failed
      https://git.kernel.org/rdma/rdma/c/a95c6b735017c6

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

