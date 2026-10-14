Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0566A496D34
	for <linux-rdma@vger.kernel.org>; Wed, 14 Oct 2026 22:29:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792016993; cv=none; b=c+St4yeJlSc3BC23HOmeKdd+OxPNP1y3/lP6UYOGU5HLwgQZlqm3+DHMi9Dj5mT1nAZOB2WVTC+7/UyPdw2MNm06voA2DtUu9RP5sTS/qX5Q9qZCzmJw33BdGZKqf9I+HJzgafQ8jRu/jWUT5AM63ANUW1YeKN6QxwOi8FaMNqY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792016993; c=relaxed/simple;
	bh=ZB/p/fN+WB/MNdVpcIyO8ASgLiSiCjmw4XxtSuq/Cuo=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=lWipXye67NqguuH5HSFby8Zq+MGN2IrqwIR2gykigWtnEiM83HqLmzbEJ2HQSfcb2cwlmjC+2Hq0XcJfLnYfMvYmdOYdqYBB8N5CYy5/YqWyNtyVbRoe0TGo42YTs+0VfXOEQxSJRmHE7MJCKLiZOXjm22vdlXSM/yIdOFur6IU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kKVEishH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kKVEishH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 555C91F000C4;
	Wed, 14 Oct 2026 22:29:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792016991;
	bh=ZB/p/fN+WB/MNdVpcIyO8ASgLiSiCjmw4XxtSuq/Cuo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kKVEishHZQatuv8JQhIbHzwgp/CuOuXkFKHeQAFJi897+sj0/2fzQetk5FPMRmDhF
	 TE8856CQAc1V7h5dSYMj+NftHhZRHnsDqkvMV4/JPphylAoKuZMth8KU4JAkAze22P
	 B/5rBT+qXNseIFeuUtx4460qgJdnadZ64efJa+mKm3y9oN+bCGBemrrj+yEJMI7c9g
	 U+Cr9uWhjYU/blbpohEHBuD9IszaGTBrpeD1fVGHcJlYZeM+ZWFm7Je/MXnt9cQsqt
	 8RJclnWztntDG1fhaTL4SPkXWxjtsxhQHj06R2FsP51LyMctsmh47mtN7TDeKftrGO
	 s0BhnppBv5vmA==
Message-ID: <sashiko-outbox-171971@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next 01/13] RDMA/core: widen the uverbs object key
Reply-To: sashiko-reviews@lists.linux.dev
To: "Eric Davis" <eric.davis@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261014-uet-ib-core-v1-1-a0e626117113@broadcom.com>
References: <20261014-uet-ib-core-v1-0-a0e626117113@broadcom.com>
 <20261014-uet-ib-core-v1-1-a0e626117113@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 14 Oct 2026 22:29:50 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Eric Davis <eric.davis@broadcom.com>
>=20
> Two more core objects would leave drivers no free object keys. mlx5
> alone uses all ten that remain. Add a bit to the object key.
>=20
> Signed-off-by: Eric Davis <eric.davis@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261014-uet-ib-cor=
e-v1-0-a0e626117113@broadcom.com?part=3D1

