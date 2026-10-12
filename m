Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35AB5381E94;
	Mon, 12 Oct 2026 13:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791811486; cv=none; b=akSe7GV08bmj41PCnKQTKPA9twLu2DLU2gDsvWocoeprEdKP5Rcgkis5g1AIaLcktX+V73BZicVa2yuhbIOX/HRTq18p5NjMQjznwm7+Mw7bLZyAXrCKMpHNDH5eDRk4cDIdXNi3EraTFm4iD5LxA5+pCFgrT8kG2reuw7hubBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791811486; c=relaxed/simple;
	bh=S6GVK+HU2NoNyKOx+MCGE7l9jYGw+aRnSZybNDWo9fg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=e+hqs1zc21e+AWAJxoVTb1DP4Yt3aIj0R3EeideyT0pXGa1UtAtsG+C+6nAZ4fUKBs+AchwcEfih0hj06sYPrlOKVu4UROA2bryTW1vn9AoObuxsR9X0MZmtamFJ/f2Ne2n3BVlfKfBxBVMd4vkoepaq/5F2sfYZbLDq9xBdvBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nHMrSitm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nHMrSitm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 945D21F0089B;
	Mon, 12 Oct 2026 13:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791811484;
	bh=S6GVK+HU2NoNyKOx+MCGE7l9jYGw+aRnSZybNDWo9fg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=nHMrSitmCywvonGomal9ma3CQlBLfruezBunDR7fuSVFaXEpB97CT5vKCFv+mMQQ4
	 AGAPV2vsOs4V4pcwf84zk/aapWHwBSBG5/GPEYr4YPU5zcs1lLjI33iLbt2V7L7oaz
	 jrwI0kBwKjo5YU+qWgcftkbD1Lm148PHKvMCUfm+qhLNo9js2I5qDmpZdsCxkr4pXQ
	 AlzyEodfbaSd0O8Jdcp/xCJ7NYigW5ISBuCgdMsLWE7B9/6GaVdMsAw1cFr77/JU3P
	 UMztcAPguWptvoF2PHxays2JGNvB9W9/GWrSyijWznyPJkzPQNK3GWdJdX76I+itXc
	 u2xw6xLmTS2Nw==
Message-ID: <sashiko-outbox-168174@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v10 18/18] PCI/P2PDMA: Test the routing of clients with
 ATS enabled
Reply-To: sashiko-reviews@lists.linux.dev
To: "Leon Romanovsky" <leon@kernel.org>
Cc: linux-rdma@vger.kernel.org, media-ci@linuxtv.org, linux-pci@vger.kernel.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org
In-Reply-To: <20261012-fix-p2p-acs-v4-0-v10-18-6ffe7b7a4517@nvidia.com>
References: <20261012-fix-p2p-acs-v4-0-v10-0-6ffe7b7a4517@nvidia.com>
 <20261012-fix-p2p-acs-v4-0-v10-18-6ffe7b7a4517@nvidia.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 12 Oct 2026 13:24:44 +0000
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Leon Romanovsky <leonro@nvidia.com>
>=20
> A client that enables ATS for the whole device must never be handed a
> bus address, and Translation Blocking must reject its peer-to-peer
> traffic even when the caller asks for the default class. That has to
> hold for answers taken from the cache as well.
>=20
> Cover those on the fabricated fabric, together with a client that
> declared per-mapping ATS keeping the per-class answers and a client
> without ATS answering for the Untranslated Requests it will issue.
>=20
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261012-fix-p2p-ac=
s-v4-0-v10-0-6ffe7b7a4517@nvidia.com?part=3D18

