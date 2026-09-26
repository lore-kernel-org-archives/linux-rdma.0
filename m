Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F265A36495F
	for <linux-rdma@vger.kernel.org>; Sat, 26 Sep 2026 08:29:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790411345; cv=none; b=SpD6q+86RTZoq+npI+KWp8Csm3Fa6t0jJ1ZrABXZRtQXI0d4IYyXp/7T98piS444J88vkKUhA2n3T7ubNvxkfD49MLFnFVp5oUR7JeIqWItKv1a0FSyd5py50vU4dIR4zJD21C3+sQCFFClMqfUb3xuzGvstL22l3WC1sUbzCzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790411345; c=relaxed/simple;
	bh=v0/rVlc0DM/LiL3/4FelwfRm+TycJb9mpLa7lPq1ELg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UFBhEYHIMKMTY8izWI+Ro0LLDFd1MRh33QcwO7DKv+9QWKfNw5kYLE25RBLIESSlxA/fpG26RhlUSBIurYXMj1i3+YovB8hvvSFDz0qML3XazFeKihWEm3GL5rTFkj//4ym9rvOJHQyIht0NcC29OTQW8jmUZTUkbvP1ev+P0Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mTSxVKFi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mTSxVKFi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A251A1F00893;
	Sat, 26 Sep 2026 08:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790411343;
	bh=v0/rVlc0DM/LiL3/4FelwfRm+TycJb9mpLa7lPq1ELg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=mTSxVKFiFuOModMM9+CDZauNQJvxkALStVxIYs5QDKuwwOGQvpFfjYherru6it46m
	 +TxNMkTGx1mSJed8uNjowsr7R7TqXWxKQObz9odMKUbMG+Dk+eRODkWI5rcpioe3sm
	 JA3GW71NQzdeJpgGuaSe14GVwFAkYdokFy3cM+B1ukmIgPNKL28UK4nzRmbNm6zNXI
	 2+U1o+BNKh5FibVHZrF4RfwXgPcg4vojiF5jBsfLJvK4rYZBNdmX47WRLw/RR3IxB2
	 GAtgW7fGaK+a/edKPTAtdOz0850RrwV9iIzNzV7b0b8xFGubRUhzL0weiYRfsVEXDX
	 R0VADp0ycUBgg==
From: sashiko-bot@kernel.org
Subject: Re: [for-next v3 2/5] RDMA/ionic: support firmware-assigned CQ IDs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abhijit Gangurde" <abhijit.gangurde@amd.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260925082802.2675902-3-abhijit.gangurde@amd.com>
References: <20260925082802.2675902-1-abhijit.gangurde@amd.com>
 <20260925082802.2675902-3-abhijit.gangurde@amd.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 26 Sep 2026 08:29:03 +0000
Message-Id: <20260926082903.A251A1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> When the LIF advertises qid allocation for CQ, let firmware return
> the completion queue ID instead of allocating it in the driver bitmap.
>=20
> Split CQ create/destroy into distinct phases so cq_tbl is updated only
> after the ID is known and removed before the destroy admin command
> returns the ID to firmware, avoiding a race where a concurrent create
> reusing the same cqid could have its xarray entry erased by a stale
> destroy.
>=20
> Signed-off-by: Abhijit Gangurde <abhijit.gangurde@amd.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260925082802.2675=
902-1-abhijit.gangurde@amd.com?part=3D2

