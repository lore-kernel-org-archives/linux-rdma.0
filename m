Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030CA1E9919
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 12:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789646698; cv=none; b=cwW9wSgeM87bnc0itUoRREN2kQz3A3+Lvo7PpBpB/sxaiIkYcA9jmCqEF+eph7kfUhljAxQG/ShxWmDdhYQc7gYeA5Dmfvv+AyJXr/uf3QflTYIk7zq/gXKAyS3G0h0HUujB/80jUFhHbnw25Y13cWlbX6FZ0adCpp9gFAWoCVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789646698; c=relaxed/simple;
	bh=5jGmJEd1pLTsogJYmMsvKgjMZocwK7nzZrc6HtdXwVI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=h3LgAVK47Angir/7QwWaWOBL3rzV8W+EMeVEO7w4avOHSYCV5eIu7pb4tJPep1yxu2Jiyd/AAyHqHRlkPVf5/6qY8UStsLjNuuLFIhsMQ0NwQpn5AnHoiPV4uwgQplIeYFpH8HEq7PYGJ6gIhV1DAWEls4Nd7tGSyUoJPcv3u+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L3LAYfsA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L3LAYfsA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251571F000FF;
	Thu, 17 Sep 2026 12:04:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789646678;
	bh=5jGmJEd1pLTsogJYmMsvKgjMZocwK7nzZrc6HtdXwVI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L3LAYfsADDJu2j04OAlAMywCZ8Xj9uH2rHYGg8fCgsuAj1t4JtRfu089uukeVShua
	 3PEm5VLz4lF/kBNzA5Dnd3lh057qOkO8IYkyqJLo8Q/CNL6TccBGRopNxd8BC78XMT
	 Qy5RYynTlDZDWlnkwBLHk02AEAmUk+Y6HiaTDiRCelRkC9J7iiBERFnV00xyIvs64e
	 epzlzWT0jzqRfEbiKcl0yxyNSp/8z9YvzREkcinsGKu5gFJaQ4HwtGB0VUh56VkaME
	 HqJEq3kMuZehhjbHAz6XlbSsLuVOv6igAnf7LBLHymLcP+989nKeVQavNv0aeAddQM
	 o+XVdQEDNGUGQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/mlx5e: fix swapped IPv6 IPsec policy masks
Reply-To: sashiko-reviews@lists.linux.dev
To: "Andrea Parri" <parri.andrea@gmail.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917115542.177675-1-parri.andrea@gmail.com>
References: <20260917115542.177675-1-parri.andrea@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 12:04:37 +0000
Message-Id: <20260917120438.251571F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> IPv6 XFRM policies may use different source and destination prefix
> lengths. mlx5e_ipsec_policy_mask() builds the corresponding masks
> independently, but setup_fte_addr6() installs each mask in the opposite
> address field.
>=20
> When the prefix lengths differ, this makes the source match use the
> destination prefix and the destination match use the source prefix. The
> resulting hardware rule can both miss traffic covered by the policy and
> match traffic outside it.
>=20
> Install each mask in its corresponding match field.
>=20
> Fixes: ca7992f52c2c ("net/mlx5e: Properly match IPsec subnet addresses")
> Cc: stable@vger.kernel.org
> Assisted-by: LLM
> Signed-off-by: Andrea Parri <parri.andrea@gmail.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917115542.1776=
75-1-parri.andrea@gmail.com?part=3D1

