Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2963BED38
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 14:36:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789482968; cv=none; b=e4j6QSZNQbyAhvquQb00rLbf1dfZnfgfi+SFHnIw4fEwVo7GngjP4aZ2ddoDph1d6wG8xJ3AH5Gvqhagv/syWB/AuCcg/RncVyYJOM/40+MNGdhm2FUXhs0FIdEGMTQ0K5ONFXFA14Fffo/C62Hc+5izPnhed8DAFmKyWRY3bqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789482968; c=relaxed/simple;
	bh=YA91ehoLcwsQ0fbFtkMhAW0NCWfDgusviGIUmJRxV8A=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=u5FBsQ1lHTxbIoFba/bNPPS/m2qkwFZ8XNlhqMfKLAA4eouZEtMckTRp+cS9j0fYVIGwkBSKoa0yja3498cgrD2BJMIDvu4Sjtg6zNDHGbW+i7VT++LQW/SP/d46e2AlID7aK2Dr6Qq63uAC/FwMBoxfyJiSRg19Shf13xboVgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gkNSkOEm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gkNSkOEm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2872C1F000FF;
	Tue, 15 Sep 2026 14:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789482967;
	bh=YA91ehoLcwsQ0fbFtkMhAW0NCWfDgusviGIUmJRxV8A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gkNSkOEmzXRKHaP/ckS/Cll0OOuOPLzR8bu91i9IKeFubf1z/YOgyGsFmKx9hehuE
	 BAC3Ir1K2ihOgVqBnaVlevIy2GPe5iUYLThALng4avE0P4/XMc0mGV4o/locMY4AMP
	 3iaEdt2exViBZUJh4Ec2Cm9DaSsp3BKSnHmyQelLYw9Cf7c9zF0bO1x9HAdOgcB6VD
	 TGK+kAmFY4N0q7uFxfwqHu+yHUT5g4gIgnLkMW5xXkjBj2ptEEHEVX/CVmwWW+qSIu
	 01uET49uIY9ecOTpg/818ZcUDF4pIe+snfVBuKPmYU4UX6jnK8M/IJXObGqdtZOsuk
	 cUnwio2lai4uA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH V1 rdma-next 11/15] RDMA/mlx5: Set SRQ event handler
 before xarray insertion
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yishai Hadas" <yishaih@nvidia.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260915140933.40580-12-yishaih@nvidia.com>
References: <20260915140933.40580-1-yishaih@nvidia.com>
 <20260915140933.40580-12-yishaih@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 14:36:06 +0000
Message-Id: <20260915143607.2872C1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> mlx5_cmd_create_srq() stores the SRQ into the xarray before
> srq->msrq.event was assigned. A firmware SRQ event arriving in that
> window calls through a NULL pointer.
>=20
> Move the assignment before mlx5_cmd_create_srq().
>=20
> Fixes: e126ba97dba9 ("mlx5: Add driver for Mellanox Connect-IB adapters")
> Signed-off-by: Yishai Hadas <yishaih@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260915140933.4058=
0-1-yishaih@nvidia.com?part=3D11

