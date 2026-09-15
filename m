Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49BFA41F379
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 03:37:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789443459; cv=none; b=rdxQxMdounUi64M9+wK/qmB1AA1KRjMnXvwUq5hn0TpmywBZ/QKxr8SFUPA5Qwhi9SJ/Mc7qFTcNYbs64386kwKofZwuEPm7dwKbMsU/id/XlBXkRRzsdONLUz0qFtS6M6qBut+Qt4WrnpFscSeS1lr4S4KPQzUbfCmbBSN3KIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789443459; c=relaxed/simple;
	bh=pCOPaD4oTTKQcZ/bVLtYlvmcti5/MHBr9fLVTyI6xq0=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=fPSb3HdHI5SiTUY2mXCsW0/CYRSEnEOG2Hg8PnRSZaOB1YCIi0qAy1VQ7+i0qwD88Ea5vtuO0yL4SdSWTQ39tadUWQF/4rpVi3Xr0JpKUbJw1hUrIFpJHHtgQ1ixc4xOX9ZBSEe+CD3LKDOWg1mBZAEtLDLrQPFmx0DELg2A5qw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T3KoZq3W; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T3KoZq3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7E221F00893;
	Tue, 15 Sep 2026 03:37:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789443456;
	bh=LjFX9e/3Zas3VlhxEvyocbIWblblyHiQbjjsz4xlmE8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=T3KoZq3WXSen21b9gnTmqMdlclXoV0n0Dl2FIAfdjxwwudW6SNnphmgo8fNQpWhnQ
	 iLuT2B9YcvCRpFpzZgMgYQPR0+ewhUW0iYHyl+xPjfuO9OSO2i9nY+cL5b+BIbOOSj
	 NiiRUAqo5yEcnerM9pJFVXQje7L8P9rleoed7wt1ymxCxXSG1bpbUu5qmesHP/6zqU
	 hAhvD+4TFtIQTl1y38aTBS5kP5s5bCwbKVEysg3Q1yOevVAjnHSoY2qEZAA8rGF3Iv
	 TTHT6rzsi/0uGxwiTZHUpIj5A8pvK+UI7ubLS0cv2nqmDlBUNnV3rN9Wy7XbDCsmYF
	 XBMRNmZCtzZLg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 06/13] net/rds: wait for connections to be
 freed on transport unload
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260914033719.138057-7-achender@kernel.org>
References: <20260914033719.138057-1-achender@kernel.org>
 <20260914033719.138057-7-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 03:37:36 +0000
Message-Id: <20260915033736.A7E221F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> From: Sharath Srinivasan <sharath.srinivasan@oracle.com>
>=20
> Since connection free became asynchronous, rds_conn_destroy() only
> quiesces the connection; the actual free - including the transport's
> conn_free, which lives in the transport module - runs when the last
> reference is dropped.  The transports' exit paths destroy all of
> their connections and then proceed to unload, so a free that is still
> pending (a racing lookup-style holder, or simply the destroyer's own
> put not yet run when destroy was invoked from another context earlier)
> would execute transport module code after that module's text is gone.
>=20
> Count each transport's live connections in t_conn_count (incremented
> when a connection is published in __rds_conn_create(), decremented as
> the last step of rds_conn_destroy_fini()) and make the transport exit
> paths - rds_ib_exit(), rds_tcp_exit() and rds_loop_exit() - wait for
> [ ... ]
>  place of UEK's wait_event_timeout() + WARN_ON(), plus the resweep for
>  IB's asynchronous device detach; also cover rds_loop_exit(); rewrite
>  commit message]
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914033719.1380=
57-1-achender@kernel.org?part=3D6

