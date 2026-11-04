Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793766049;
	b=I57wnKC22sJOpYxbA1oA0q9nII4/Q6tXNwtdE9OTAl4nHyxMBnnqjh3dYLBRkx0Lxep0
	 2A9GYbKkxiDuID8YZFFpw/3zFwFrUNimvPtX5a2GRDhJeQLNf9x6dMYNLUzbCppUIRzVH
	 m+wSJqkNqDB94HlwB30lVt/3oGadt+uqMKRLnQVihVt3ul2DlF3yw9seGk7IdSx7XzAvN
	 NY8ycdh2JIvtOZx96hurBU4vsjIBRJ9xlmPDxsEiQAcZxvq9JvuXhrTlWDcJhudHkkx5L
	 snmBF8m/GIuPnXr8JTziJsUW6Z+GA+Eiu/jrhmYaSeCRH+sQWUEicXE3WJs7zVg2bZw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793766049;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=F7g2BCz0r+NZ9wEGJrPIzNvHojVG3/bCfZ2RCrUh1RE=;
	b=k/5zw2t085c6+IxpU2zf6I/myq5f/n6eCkWDvsfvcFEinirlPo8fKLEhzaai33b553BJ
	 Mf7F8uEqsuLkmJ95/8sTM4OXoFxV9GmC9s8xt6+3jha/j/2YZ2jXa+z7uexUKvDB7m+EK
	 C8UUaYjYDsp/IxKHlLqH9S9MJikpi5+bPdBNPNCQ+SihTsK8EyL0ew9zjYIDKXI1Y6vku
	 JZi1xQcP3omATB/3500wAmYLKrsnqq1Uy/0Xu/0sswZZPCxo1Xv4Bqd04rDr/jm9hFwOS
	 FSkjFJUBN5GxUO5A6bFCgdAAXYS7n407MvcdglbQjiuo2WODK3vCTzh6rrv0k8XmsfA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gOaww5tY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACEAA606A31B
	for <linux-rdma@vger.kernel.org>; Wed,  4 Nov 2026 04:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gOaww5tY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6667F1F000C1;
	Wed,  4 Nov 2026 04:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793766048;
	bh=F7g2BCz0r+NZ9wEGJrPIzNvHojVG3/bCfZ2RCrUh1RE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gOaww5tYyFSR/Ci3tH/4kViuI9CBYWjro4h0Ew7Yp6nWqWbNQRBbNM+RFL/GnS6yP
	 fLDjFkzioqE0xEUCPYpCUCM5xSPPdBn7Fe4p64/vWX2LXRs7JJDtJ9lztuGgpVRFhL
	 9Vum71EDLMCPCF5kcvX5bhJHJ+nfwHj/fe6GqLb0WoNW3iwwQ+Mc5nd+yMgmoPimIJ
	 8Fgmkn2yi2RPQJOxn5i8/cUnITFRbNBw/AANOLrO/++Jboyrh42jlfKWKNXDrL2WU6
	 qotAfwqZK+HK67vMJs5FcZtLAznuEAYtC+a9W4BZ+3Sg6UhyG/PK9NkXec5zffTRv+
	 qK+AX+DCvwDOw==
Message-ID: <sashiko-outbox-196649@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v8 5/6] IB/isert: do not build a new isert_device for a
 device being removed
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yehyeong Lee" <yhlee@isslab.korea.ac.kr>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261104040318.1844865-6-yhlee@isslab.korea.ac.kr>
References: <20261104040318.1844865-1-yhlee@isslab.korea.ac.kr>
 <20261104040318.1844865-6-yhlee@isslab.korea.ac.kr>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 04:20:47 +0000
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list

> isert_device_get() looks the device up by node_guid and has no reason to
> refuse one.  A CONNECT_REQUEST arriving while isert_remove_one() runs
> therefore builds a new isert_device on an ib_device the core is about to
> free, and nothing waits for its QP, CQ or PD.  cma_process_remove() waits
> only for id destruction, and the core takes no device reference for them,
> so ib_dealloc_device() can run while they are still being released.
>=20
> node_guid is also the wrong key.  Two ib_devices can share one, and an
> isert_device holds the PD and the DMA mappings of the device it was built
> on, while isert_remove_one() looks it up by the ib_device pointer.
>=20
> Let the ib_client data say whether a device may be used, and match the
> ib_device pointer.  isert_add_one() stores a non-NULL value,
> isert_remove_one() clears it, and isert_device_get() refuses a device
> whose data is NULL.  The clear, the lookup, the reference and the removing
> [ ... ]
>=20
> Fixes: b8d26b3be8b3 ("iser-target: Add iSCSI Extensions for RDMA (iSER) t=
arget driver")
> Fixes: 63b268d232b8 ("IB/isert: Properly release resources on DEVICE_REMO=
VAL")
> Cc: stable@vger.kernel.org
> Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

Sashiko has reviewed this patch and found no issues.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261104040318.1844=
865-1-yhlee@isslab.korea.ac.kr?part=3D5

