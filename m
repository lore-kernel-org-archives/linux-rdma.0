Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794920723;
	b=tAXS/oK6Oupo4ayFQUWasjn4yTuQ703Pjyb+eG+hGRCe/fibndwv5QOBvPacwAAvQhNN
	 m27T9ojnIYqh8Vd3fcbqqLrfy00pclM043K5TJBQE9T4bjsuPQ+Cb2sh39hGQEqyKW3Hb
	 TxoDJOFBuzF1FGLNRMHLIhBdASJH3FgyseQNwyRQlTSgLId7T3a4DRAgRKNSd1OUFDGUH
	 /cjxsg6SyBYrT8uKQgOMPSidtRmMLIj5tV96Px1pcTmQaqYZOzow19lRGRlgQLeq7Lgv1
	 3vKEUVi+i0ptApz9t1grdVrVXoIip1wEpDM6CmZpeVBV2KN0ilhm+kKt2zp4bML1eUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794920723;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=QmU2Y+I0FcGeR8HtQ9+tl4S8TIq+jpg7ELjdyedN1D8=;
	b=M6EPokGgg3k/4IT8MvFythfx4FGsGUB7RI+5TsKCnZ3XFL29pqmiW45Mtilau+AkNTfS
	 H5RaVV0FvtbW43dUMMsqkdWS10I7lsyI+noRjVJK2O87xyeK62AGwIuRrSYE+vZtEGzhW
	 uz0amVODhhTOIgvbq0jfTZktiNI7yd3F4FnXt//qJDNqTNzrU37EAbQCtSkROzIeNxlpY
	 RM168kNXENd9J4IdBbcqhz9g7OvoXFXxbdxXocm6k+g94Tcqm5KLvuj2sZ1ticV4pHM3A
	 HRQARzusL0bWNQghUQR5m1OthQ0YKu69plt63fdOwCXmGzLayFzd9xRsasHOvZQhbig==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HxDbKCBC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3F1606A32C
	for <linux-rdma@vger.kernel.org>; Tue, 17 Nov 2026 13:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HxDbKCBC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC3D31F000C4;
	Tue, 17 Nov 2026 13:05:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794920722;
	bh=QmU2Y+I0FcGeR8HtQ9+tl4S8TIq+jpg7ELjdyedN1D8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=HxDbKCBCTdjBI3ps4dzyh09edaxomUwfpNyjPXpIdmg5O++BcUDLrcY3Mr6FTHVpW
	 RitCVHfzrwMFiXHmNWDxRPjOOD58ctx9ltcqtRILBX9IZcTdExwFE5d05OrJb0vq7u
	 yqUXoIFCSDhkZDuJOv/j2i3LhoGqyNVX6h5dpAFcdZSIEZnN7guVsfEAqb2TgXAjoQ
	 txsxKCvqjEHAlYBXZfJ3WuKMGAFMV+C7EJ5wAdIxr5W5cAuJf9fF7Gso2zG6exdCm5
	 xTrRk/RaQc3YUoyKCeRNNUYZOeOPq8bte220XYAtMv3VtcH+P1/Q48jzFe85d0dGyQ
	 X3O0IBmXZDHhA==
Message-ID: <sashiko-outbox-218835@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net v2 1/1] net/mlx5e: fix NULL pointer dereference in
 arfs_create_groups()
Reply-To: sashiko-reviews@lists.linux.dev
To: Jinvas <jinvas@126.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261116130406.1171-2-jinvas@126.com>
References: <20261116130406.1171-1-jinvas@126.com>
 <20261116130406.1171-2-jinvas@126.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 13:05:22 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] net/mlx5e: single-word handle used in Signed-off-by trailer
--

commit 4b74aff981e93bc5945b2c05fbb873b1deefaa0c
Author: Jinvas <jinvas@126.com>

> net/mlx5e: fix NULL pointer dereference in arfs_create_groups()
>
> arfs_create_groups() creates up to two flow groups in ft->g[], and
> increments ft->num_groups for each group that was created successfully.
> If creating the second group fails, the error path frees ft->g and sets
> it to NULL, but leaves ft->num_groups at 1.
>
> The only caller, arfs_create_table(), calls mlx5e_destroy_flow_table() on
> the error path, which calls mlx5e_destroy_groups(). The latter walks
> ft->g[] from ft->num_groups - 1 down to 0 and dereferences ft->g[0].
> Since ft->g was freed and set to NULL, this is a NULL pointer
> dereference, and the kernel oopses.
>
> The same error path also leaks the flow group that was created
> successfully before the failure, since ft->g is freed without the group
> being destroyed.
>
> Freeing ft->g here was added by commit 3c6d5189246f ("net/mlx5e: fix a
> double-free in arfs_create_groups"). Before that commit, the group
> failure path did not touch ft->g at all, so the caller destroyed the
> flow groups that had been created and then freed the array. That
> commit fixed a double free in the allocation failure path by freeing
> ft->g here as well, and in doing so changed the group failure path
> too.
>
> Rather than also resetting ft->num_groups, leave the free of ft->g to
> the caller: mlx5e_destroy_flow_table() frees ft->g exactly once, and
> also destroys the flow groups that were created. This fixes the NULL
> pointer dereference and the leak, while keeping the double free fixed.
>
> This also makes the error handling of this function consistent with the
> rest of the driver, e.g. mlx5e_create_l2_table().
>
> Fixes: 3c6d5189246f ("net/mlx5e: fix a double-free in arfs_create_groups")
> Signed-off-by: Jinvas <jinvas@126.com>

[Severity: High]
The Author header and Signed-off-by trailer use a single-word handle
("Jinvas") instead of a full real name, which does not meet the Developer's
Certificate of Origin requirements in
Documentation/process/submitting-patches.rst.  Could this be updated to use
a full real name?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116130406.1171=
-1-jinvas@126.com?part=3D1
