Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E07517BAC
	for <linux-rdma@vger.kernel.org>; Thu, 17 Sep 2026 13:46:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789652783; cv=none; b=W0rT93cxByhmVSG7brtqd6jXVorMygtZQpiwshOU0n0mUAVKcr09ZqsEihdmpoISnbSwhvzpcFpDNpIzd4UxtF51ym2rzgJ/iWc2AvbFDh/X6FSviZQVluU8Qe467VXsdvBYFcQOJ20sq84RBrf0vt89nrlSVE/HAOQ+zDjhw08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789652783; c=relaxed/simple;
	bh=rdiMxySp505FnISgbjTBm6KIGSihMUNpmnZ6mdcHssU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=FiSo1LqxvRfaV4E67Yx9GsiQMkfcK1qfCGFHdcUWUzXXCijGhKT5NK9johlEqgaMvSTUvGvkC3wWENvy2irSD+ts3fNQUrxIz/ZFgyZifo29hiVwGtqObW9/Szsna0j9AjFIwSYel+Kl8C/anbrsknDqsJuvM7GNBVngkcm7o8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BMac/G5q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BMac/G5q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE5FF1F000FF;
	Thu, 17 Sep 2026 13:46:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789652770;
	bh=rdiMxySp505FnISgbjTBm6KIGSihMUNpmnZ6mdcHssU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BMac/G5q4HD6AOIMAEgsS8D2JHxYZR2QYcMZtt9syu7aMr9UygVhOpHt0FNOo6swv
	 kFzv6uEs03WU0rM4dXNn5PGaFAP4Wh1fLFXT/7Ygtp+pK+AszN/OWvUrVd5bXYSz1D
	 rXePl7FEDJR7ZspvTmJWnn86tyfwTEsaqL/488S4irUI7aOGB+E9LeW0eS0rnZ1YJi
	 x4QWPERBOGcFj4zlR9aHqkM8KBqYAA8y6a/TI8915TSAmaqKff7XoIhiqJ+lBE8WFh
	 dlXOV4O9y0iJ0+omCWW6FvKbHlmPN77TZRMjHk4Ruy3RuWqOJvDOVhgFBwfr6hEXpf
	 SGW/hOvaInZtA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2] RDMA/nldev: Fix NULL deref in dumps of objects
 abandoned by DRIVER_FAILURE
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yili Zhang" <zhangyili01@baidu.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260917133340.42002-1-zhangyili01@baidu.com>
References: <20260917133340.42002-1-zhangyili01@baidu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 13:46:09 +0000
Message-Id: <20260917134609.DE5FF1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> fill_res_cq_entry() dereferences
> cq->uobject->uevent.uobject.context->res.id unconditionally for user
> resources.
>=20
> This is normally safe by ordering: destroy_hw() removes the resource
> from the restrack before uverbs_destroy_uobject() clears ->context,
> and the XA_ZERO_ENTRY marker set by rdma_restrack_begin_del() hides
> the entry from concurrent netlink dumps.
>=20
> The ordering breaks when a driver keeps failing to destroy an object
> during ucontext teardown. uverbs_destroy_ufile_hw() then falls back
> to __uverbs_cleanup_ufile(RDMA_REMOVE_DRIVER_FAILURE), which
> abandons the object in place: the HW object and its restrack entry
> are intentionally leaked, while the uobject bookkeeping is torn down
> and ->context is explicitly set to NULL by uverbs_destroy_uobject().
> [ ... ]
> while another object that failed to destroy still holds the PD usecnt.
>=20
> Fixes: c3d02788b45a ("RDMA/nldev: Provide parent IDs for PD, MR and QP ob=
jects")
> Link: https://lore.kernel.org/all/20260813000442.GI662699@ziepe.ca/
> Signed-off-by: Yili Zhang <zhangyili01@baidu.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917133340.4200=
2-1-zhangyili01@baidu.com?part=3D1

