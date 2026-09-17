Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49C8E4C9E1C
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 12:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789647252; cv=none; b=b2vyvXGdNkkBelbMRQ9NU3H1jeTLYswYD2NdCHelfoU2QKYYJ3r+ORl5uv1E/VLi0mcwerSSIvJpZL2F1DLJrR5VYWqHy7DwS3dDD1h9i3KSg76KgFbM+AjcHRt8GsreIHu5qqEgBobgvQdrnmgcBagdSNr7Pf9HkBxYhEfEic0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789647252; c=relaxed/simple;
	bh=D1reSLJS2+Tf96dhZGbHZHdz3L+vdTTjNxqTH+4a/DM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZNeX3mLDtivaAKnQurNsZg3h6yeXC1Poj8btyGjq4/6ufgEAatWu911gXXmi9gEAvgoSdzU8TVAgoCk8KMOMvOSVdjPhxRoLidj6Srt64D8jbHSD9bj7zJg3OZzPLpvM1ODjR2GWlGRBv/3pOY7JAnFSU3+/41BxxVsCf5xc8Tc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=czBqlzJS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="czBqlzJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 303EC1F000FF;
	Thu, 17 Sep 2026 12:13:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789647239;
	bh=D1reSLJS2+Tf96dhZGbHZHdz3L+vdTTjNxqTH+4a/DM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=czBqlzJSSRJsHFgc3jwCp9wcjWPAKDW9fI1GRhgc9445Yf2hbVg2lRkASdUxqPfXJ
	 IytSE8Fv3RGR4aae1yQT3PfccpKO70Xgymg5vsM3rzP4LYXl2D2AxzSvIebXSFaMW2
	 53id+weIFHZg52f7FWRpOu7OGPh3t7iPCbKtJ5QhPFU5wPjGO+WdqrIUeTOxY1CXZr
	 BwoOy8A3ZTe2p3Lohlbets3QfsNe2aWMgVk0tHwNo3mjoJUuIqDPptl1Ol9yNAP1mu
	 9rhQujoUILxqYsvBw6eMKFz9kulWts3kCuM4Samai31Rs0um4Iut6SZk3fK8NXeeLn
	 +rRYqp4bsxPAg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-next v4 3/5] RDMA/erdma: Support non-contiguous
 kernel CQ buffers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Cheng Xu" <chengyou@linux.alibaba.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917120459.13286-4-chengyou@linux.alibaba.com>
References: <20260917120459.13286-1-chengyou@linux.alibaba.com>
 <20260917120459.13286-4-chengyou@linux.alibaba.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 12:13:58 +0000
Message-Id: <20260917121359.303EC1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> A single coherent allocation for a kernel CQ can fail when memory is
> fragmented.
>=20
> Use page-sized coherent buffers and describe them with the existing MTT.
> Keep the userspace CQ path and doorbell allocation unchanged.
>=20
> Signed-off-by: Cheng Xu <chengyou@linux.alibaba.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917120459.1328=
6-1-chengyou@linux.alibaba.com?part=3D3

