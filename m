Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95347353A7B
	for <linux-rdma@vger.kernel.org>; Wed,  7 Oct 2026 15:47:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791388071; cv=none; b=qiieEA7UaeE3/Z+bepaBl1f+pWyM3BnN3Vfh++xV1k86i30Zv5VB1HJNdT6pTaudu0OAONgveK0wfxuKWfjYoBAcCas8w6WfEAjN+SXpljnHlfdE2vA5QSQzLDo3Jxn0DYXCxELw5Vfa587F5FSR9wY5iBSDZGa2sMgZfzqRBYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791388071; c=relaxed/simple;
	bh=oX5wn+ZnEKKm+zzueyJOq7hmCU7W3L24ih8kfA8kYsI=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=jNFZwJDfQIBHmiIs4JUwA6NBz/PVZ14Lnijfu6T9xR9AMnjQvT2Ya94Vg1dhzdsgFdU49fbmabclOhpSpJPF79io+sGe1K6RrjTQUnZDoNnVxY5k4ffVKdzIeNm9NP73KzJLvCuWSELLqau0wU5quHjSCC4q/Gh3yaTPaoBvsls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n/sNVB/o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n/sNVB/o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAE451F00898;
	Wed,  7 Oct 2026 15:47:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791388068;
	bh=oX5wn+ZnEKKm+zzueyJOq7hmCU7W3L24ih8kfA8kYsI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=n/sNVB/oqGMmGBwGGKYUUQhB9uHxitzk/nSvDtB/KxPfDlOm8INuAiQpsHYnknyqv
	 zFFqHDjc/EiERP4vpblpQaYjmAKTH/UOOyHBIZOT0iWG0rOALk1WGn0U6O1+967ijt
	 W+8tGg2bzveB5Z3bLYOBuNkngchI4ZI1BTS2sVHUTNgrCIxmgnZsdjHv6Qe8nFUdJ4
	 NNcKU8VTVF34YoEYhjxNoQjadsotlxu2qdh1uiCIOyFFO/LMQANK59lWLsh+vxmiK1
	 oNfxhmgUKYO0/V/LL/fxcmNoFjKfhRropqTmqBGVIBJk56ZJqmqKvQt4AYV9Tzjs8G
	 1WS9wNRfrpybg==
Message-ID: <sashiko-outbox-163161@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH rdma-next v3 03/10] net/mana: Extend GDMA encoding for
 new RDMA WQEs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Konstantin Taranov" <kotaranov@linux.microsoft.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261007153330.2979799-4-kotaranov@linux.microsoft.com>
References: <20261007153330.2979799-1-kotaranov@linux.microsoft.com>
 <20261007153330.2979799-4-kotaranov@linux.microsoft.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 07 Oct 2026 15:47:47 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Konstantin Taranov <kotaranov@microsoft.com>
>=20
> Extend mana_gd_post_work_request() to support extra-large OOB data and
> fixed-size WQEs. These formats are supported only for power-of-two WQE
> sizes.
>=20
> For fixed-size WQEs, use num_pad_sge to specify the padding size. Encode
> the WQE header fields required by RC QPs based on the WR flags.
>=20
> Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261007153330.2979=
799-1-kotaranov@linux.microsoft.com?part=3D3

