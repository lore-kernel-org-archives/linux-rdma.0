Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C226E32ABCA;
	Mon, 12 Oct 2026 13:20:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811220; cv=none; b=FEi1ZsGPAOK0n+Jm6YcY+81R1RdA4FKbR60l2BSR8IioM3HF6ls6WlA5cQAzjH1q8j1kzq2nH7+D76b0VwltnZThIwC9bFMIxSYH7jTc4SZTY8pXm/zdsp7DgJjvLIxabjHoBi9Ltj9A5i7jpSex9xZhIp0EA++7R27xHKqzBCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811220; c=relaxed/simple;
	bh=jis67edseTgaYxGPkQgotJRGpKv36kj5tWrkBdnm6HM=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=VdGos6WPxXsjvcYytNhJOIKzkQk5NwDGYAU7bAAvNhXk/ojdXopZTtrXQlatXu1/tl8IecagJ6Fn1lT4vMwusBXRX8noPhjX05Ak5RTwLZjO7l/z3knvfUyhF0Q3mEs+sfEqvSghkdO63tbUXv9HrS7helTRyWI2UxzJqFf1xhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NKFEJkBh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NKFEJkBh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B01B1F0089E;
	Mon, 12 Oct 2026 13:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811219;
	bh=jis67edseTgaYxGPkQgotJRGpKv36kj5tWrkBdnm6HM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NKFEJkBh554OcFhDG7aC+WpEk3QFBE6RWEOd8PodcN1eiMYpWrbtiIdI0416nGlEY
	 0VlS1cXTXdlxwr69YvSVtKOSdVOPBl3YPm6vovH+hGUxm4x9417mXlI5Tl8xW8HZbg
	 CjyUh75dSSFnnGRg+q4oak08mux/OOU+XMuL0zNUTmM0SHO7o3zZE4FkM7MMzcf7fs
	 GNgOjuGbnJO/lqEYb6hrHNWmTAi79BuiuwtGSgQjJ77MRKCfJorarcktyOcNrJQE0D
	 vI4S53WnIfkdmglLz7QI/lkYQyVbKuSlNsE9P4QR09+j5HWZF79i+/jgN+/IQcNzcs
	 IOTXK515xwS7A==
Message-ID: <sashiko-outbox-168166@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 09/18] PCI/P2PDMA: Reject Translated Requests
 blocked by Translation Blocking
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: dri-devel@lists.freedesktop.org, media-ci@linuxtv.org, linux-pci@vger.kernel.org, kvm@vger.kernel.org, linux-rdma@vger.kernel.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-9-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-9-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:20:18 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> A Downstream Port with ACS Translation Blocking enabled treats every
> Upstream Memory Request whose Address Type is not Untranslated as an ACS
> Violation, ahead of "any applicable ACS P2P control mechanisms" per PCIe
> r7.0 sec 6.12.1.1. P2PDMA never looks at that bit, so it reports a
> bus-addressable path where the Requester's Translated Requests would be
> rejected.
>=20
> Add PCI_ACS_P2PDMA_BLOCKED, and because blocking is not a routing control,
> scan the path for it rather than the divergence port alone. A blocked
> Request has no host bridge fallback, since the Address Type is rejected
> wherever the Request is addressed.
>=20
> The two routes do not pass the same ports, so scan them separately. A
> direct route turns around at the divergence and only passes the ports
> below it, while the host bridge route keeps climbing and passes that port
> and everything above it as well.
>=20
> Reviewed-by: Logan Gunthorpe <logang@deltatee.com>
> Tested-by: Tushar Dave <tdave@nvidia.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D9

