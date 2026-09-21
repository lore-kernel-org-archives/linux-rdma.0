Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FB5517BCE
	for <linux-rdma@vger.kernel.org>; Mon, 21 Sep 2026 21:59:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790027967; cv=none; b=gUw67S9QvswT50ghyNg6eln4nxJQVlRdwE0cYszfC45oF0kriaMdhpZogYazEsfru6I7vecSfmLfRAc5n+xYtfIqjByCoYtuYweDPH8nhv+BQ+wfTnOxWNCFrdlkewd+ieee59tZ/u3/6TJO/6e5F4T+0awqtO2IcWBkEXR5sAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790027967; c=relaxed/simple;
	bh=hd/KXhRnhIHnxy9hKuYgaespr6J7F4ZIvvHrqBLKVFI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=thFkrJuStjInan72DzuuJyt2/XmFBzGGY5NQ5x0yOy05Ee4VXu7/JkOAkSeh8ITFn0oxPlO7uRfrkyKxJ3JhT7a53+ILvFL27VFfGqE2qeRVXdT0c5dehZZrWhOuSO9kMBcAaLU7sp+G72+lbTQp2m1NKyIR+UK5+e8cHcPRhGI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BNBzZjOn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BNBzZjOn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC6DB1F000FF;
	Mon, 21 Sep 2026 21:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790027966;
	bh=7ZMEUI3ENrGFYk4Oi8CUNnG4pOscBTFw8G+sNsdesq0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=BNBzZjOnBt0+bs5eCXvGoEuvjl92H4yQSz/3lf04XrzI3d25ijnjHmVIbsAJxfwMP
	 IIO/vo2fJ0MxZg/WijQ0LTomtaVFpBaUPsgBvT7c8UCBukeaUX5m3CNX/rj8yeBhzS
	 G5qlsBA4FI4tsYUYtaNsnxDqtSIAmQK6kczj11ksGhfqc6dxUCXJpiJrzjXDM625M0
	 Q4YFdN/YWpJ+t7rrV2ExLR1nA2j5I3s2s6keeGzHFxsdt1VdtfIgAJrYnlz584y1eD
	 o/w2OJXS4ukVPHV0yY9L1PTqD4l+f+13iCKHxlnyk9rHSjE6exj+k8SEvkj/wxqbtA
	 CXHc0WW5J0etw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net] net/rds: size a connection's path set by the
 transport it ends up with
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260921215027.174657-1-achender@kernel.org>
References: <20260921215027.174657-1-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 21 Sep 2026 21:59:25 +0000
Message-Id: <20260921215925.DC6DB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> __rds_conn_create() computes npaths from the caller's transport before
> it decides whether a connection to one of the host's own addresses is
> to be handled by the loopback transport instead.  That substitution is
> what an RDS/TCP socket sending to a local address gets, and after it
> the path init loop still runs for the TCP transport's RDS_MPATH_WORKERS
> paths and allocates an ordered workqueue for each, while
> rds_loop_conn_alloc() only ever provides transport data for path 0.
>=20
> rds_conn_destroy() sizes its teardown from c_trans, by then the
> loopback transport, so it visits path 0 only - and
> rds_conn_path_destroy() would skip the other paths anyway, since it
> returns before destroy_workqueue() for a path without transport data.
> kfree(c_path) then drops the last pointers to seven workqueues.  That
> repeats for every such connection, on every netns teardown or module
> unload, and every distinct local destination address is a separate
> connection.
>=20
> Recompute npaths once the transport is final, so that creation and
> destruction agree on the set of paths.  The c_path array stays sized
> for the caller's transport; the unused entries are freed with it.
>=20
> Fixes: 4716af3897e9 ("net/rds: Give each connection path its own workqueu=
e")
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260921215027.1746=
57-1-achender@kernel.org?part=3D1

