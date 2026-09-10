Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95BF73B8BA4;
	Thu, 10 Sep 2026 23:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789084709; cv=none; b=TT/nRdwmPcxu3kOmvHf/MDNDL5rwOHgndEobh5GNjaj5Hff9Qoz+jSn3ACAJBWXdFMtvfVcUpJhaIpU3r3hTmPqXgUKslrJJmfOF+yX0K6rP15yU7xImbd4OlW/xvCuLEImLiK0zdlTprjXLJQbkwsRrUbPZF6quMNMJtch+Gj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789084709; c=relaxed/simple;
	bh=ylaZIgsNVye7bkoFAuAtybYsj+UHEg9ST6gmVn0yGtM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=np9/ExAt9FcukfsL6+GMAdaYvhqWYtn794NYer0VzhgbHAIzQboafz5rcrRvMrLvUq6kAF7O9sLnU23NanKpOCTuj70aFi+OVY9vgRP8TgWPsQfqV5DQsKVCXqHwATaxUOVXxmBeqAduUFBUI6waqZZOndwQz13vnyNdXn+CmHY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nii2dGwI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nii2dGwI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22F6B1F000FF;
	Thu, 10 Sep 2026 23:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789084708;
	bh=r1GB+TQ8qLpUcpQEDQzNVPr5C4h7RRGgHCF574IpnCg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Nii2dGwIvsbpXOjRBxXQT9yU+Cd1NF2kz2bWUphO7hEqTX94xw4bCerYOz05KxJdz
	 UolLyOgD4qwuzPbbqu/bxEVTHCTIN+heLzOJVQqt35x01owqcWAnyqEw+u8NhCZV4q
	 oKfGVmchI61vJuCJW5RnhdMlCMaecUKyPr43hvLK9yydU/DIdgpMylzHYETnX+qCT2
	 8lYCtGs7K6jOuLqfBcLKYkKQ5t2nqxoDGhztnpbK2B6ZHG72j0ErArUL+HT9cpb9dQ
	 d6vYqS5AapHAkJHALrANzwDMfVSgWXw5BZHwTdG4z/I4OvEavaZFDmqz/ZIF8QZLo2
	 ESnaFEbe9i57Q==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 01/10] net/mlx5: Add IFC structures for CQE and WQE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jason Gunthorpe" <jgg@nvidia.com>
Cc: linux-rdma@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <1-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
References: <1-v5-4cacb99249f6+1b4-mlx5st_jgg@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 10 Sep 2026 23:58:27 +0000
Message-Id: <20260910235828.22F6B1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> Building the WQE and CQE using the IFC system is easier than with a
> C layout struct. Add definitions for their layout. Structs for:
>=20
>   - wqe_ctrl_seg_bits (16B): WQE control segment
>   - wqe_raddr_seg_bits (16B): RDMA remote address segment
>   - wqe_data_seg_bits (16B): data segment
>   - cqe64_bits (64B): 64-byte CQE with error syndrome union
>=20
> The VFIO mlx5 selftest will use these.
>=20
> Assisted-by: Claude:claude-opus-4.6
> Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/0-v5-4cacb99249f6+1=
b4-mlx5st_jgg@nvidia.com?part=3D1

