Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC7A0347FFE
	for <linux-rdma@vger.kernel.org>; Tue, 22 Sep 2026 01:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790039144; cv=none; b=tD2PXr5qGbfYPVeqINf/A8AzK0Dq7KMgp8KUAfojrxXXJx3jc5Dxx29Nx61iKzi6ppBptaCsLl/G5WZgkD0u2DPC5+OkY7pNjUO4Av6WZlEE6XJSyZR//CcDfnm2Hs6ag1L8zdaoBaGOAQCJX16AjhDET45zDC6uX4U71xLW9ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790039144; c=relaxed/simple;
	bh=o6Qtx7oaXXsPQSnQO6TT8HqKUNi550blZrcS4SG2zDI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=nageHrZEZ+iWf8kJ5YcUFGmWCo60z9+Xb02a81eESgbp1b4ObYkKdlKLwVSmPErYjPCbLbsp1ksNuK8ZZxTzTFuGHCrooFUQZxgX/K83xFIW+t4epjG2Ij2IACDPGsrjxKGGzU3u9GIwZLxSuYxa6SPBziuNY4O3c7VY46EwNT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aFwfvyEr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aFwfvyEr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D8F1F000FF;
	Tue, 22 Sep 2026 01:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790039143;
	bh=o6Qtx7oaXXsPQSnQO6TT8HqKUNi550blZrcS4SG2zDI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aFwfvyErF+P/YysWavqmBo+Iy8D3936b+DkiBX01BvWIdfTENgTO7h25eTzOZfGI0
	 4kP4mwc78jhogA66UwhwgSv/HQHtByK7BErkKbli7qho/VGAqP317Oc1qajpblHNtf
	 oAOfu6CRmpUtCE/VLL3n6GiFczprPF/HveQDi2yL1FC0BVbewHcjaThYvv5wqOiXYq
	 2oOX2h4V7/rT17+cfoQ5PHSb3psCqtnT34D0Aq0Ayip+5aKY2adX+RPrqeZvtewkh0
	 CWl+vsmytcDo8dAuxcwCB9816oGG2Sw5I2gAqVJyYpUkZugdDOnA1yeuK9cWyWBeiG
	 GuDjikrqhzXtQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH for-rc v3 6/8] RDMA/bnxt_re: Serialize dcb_wq access
 against async notifier
Reply-To: sashiko-reviews@lists.linux.dev
To: "Selvin Xavier" <selvin.xavier@broadcom.com>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260922061230.7909-7-selvin.xavier@broadcom.com>
References: <20260922061230.7909-1-selvin.xavier@broadcom.com>
 <20260922061230.7909-7-selvin.xavier@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 22 Sep 2026 01:05:43 +0000
Message-Id: <20260922010543.88D8F1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> bnxt_re_async_notifier() runs in NAPI/softirq context via bnxt_en's
> RCU-protected ULP ops dispatch, never under rtnl_lock, so it isn't
> serialized against bnxt_re_uninit_dcb_wq() destroying rdev->dcb_wq.
> A concurrent notifier call can queue_work() on a workqueue that is
> being, or has just been, destroyed.
>=20
> Add a spinlock scoped to dcb_wq: the notifier takes it before
> checking dcb_wq and queuing work, and bnxt_re_uninit_dcb_wq() takes
> it to atomically clear dcb_wq before destroying it. Initialize the
> lock at rdev allocation so it is valid on every teardown path,
> including bnxt_re_dev_init()'s early failure labels.
>=20
> Fixes: 51dc5312dcd9 ("RDMA/bnxt_re: Add support to handle DCB_CONFIG_CHAN=
GE event")
> Signed-off-by: Selvin Xavier <selvin.xavier@broadcom.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260922061230.7909=
-1-selvin.xavier@broadcom.com?part=3D6

