Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2681933F8B7
	for <linux-rdma@vger.kernel.org>; Tue, 15 Sep 2026 03:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789443456; cv=none; b=jlvKd5+pagRN384H7wJrICLdrVs0Y0dy9bneGVjJnc9qJxcZ7U/tqAOiLPcEqX5BToU/5cWC4yOiR6coZOqgzu3QcsFT1hNAbln1wcWQKG6tILPQjwkACjQjgsSSG9rK6qyaP9x0M7Hd26lXzGvsZUuypFyslsksb4s/YWiZ9j8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789443456; c=relaxed/simple;
	bh=Bitah6aDvjy9EpJ4UnaHW5/C5zcTXUhyS0qBJ1sh4AA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=QU+8GIxKnPZUt+Mj8G1xezQv+9XwdqDZzdgSPyu4e4VoJ74zzh4/rlBwtXR1RQPDyFPpeoiimoMeNXuQxKHqQgcpsDDVCeCzTf3h3L+tRIMwXn82efwHV5nksNNUBU1TEvpNZpVw6gF1h4/zjyx8T9fKw2G88EuKUvsn6lh0xEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DqGiASv/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DqGiASv/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 903A31F00893;
	Tue, 15 Sep 2026 03:37:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789443454;
	bh=gaMbiLw3cL9sgNYhO7GlP3uLP9P1yE7z2VLcjnmEvqc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DqGiASv/O3rhsfHhaAKaNlE6Ivuskba6s/Coxb/5xGThIoiMZX4eVtFYYeAKNaAxe
	 6uzbZI3xhypoTTob7COA6pCEwVk+4q6lP5q00JYnJArnVakwAgwZOg9g7alke9IqLL
	 7+lpYajN67ydLcuWciR22cja+tetdFSKHB6OiIhoKPxxub/2w2/HMmKK4f9Ppip3Bs
	 Vo8LpLH4G4WbI1OSE6jAuRP7NYHYfnkeGKOU2flVGWvdCWk57HjQ/Ak8Oi1ZcqKw14
	 BdwkEDs4XrXDZF1glwo5Zp1csWWyYybPfIGeQnSfb7rd4SlrqiIwrePYjjcXDediyg
	 WZo6UcgsgX4OQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v3 04/13] net/rds: make rds_destroy_pending()
 cover single-connection destroy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20260914033719.138057-5-achender@kernel.org>
References: <20260914033719.138057-1-achender@kernel.org>
 <20260914033719.138057-5-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 15 Sep 2026 03:37:34 +0000
Message-Id: <20260915033734.903A31F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

> rds_conn_destroy() cancels the path works and then destroys the
> per-path workqueue.  However, nothing currently stops the
> work-requeueing sites from queueing new work on the connection while
> that happens.  The existing code would suggest that this protection
> is supposed to come from rds_destroy_pending(), since all of those
> sites guard the queueing with rds_destroy_pending() under
> rcu_read_lock() (the last stragglers were converted by the previous
> patch), and rds_conn_destroy() already issues a
> synchronize_rcu() after unhashing the connection.  But the predicate
> only tests for the two global teardown cases (netns destruction via
> check_net(), module unload via ->t_unloading).  Because the conn
> itself lacks any indication that a destroy is in progress, the
> predicate does not cover the destruction of a single connection
> outside these two cases.
>=20
> [ ... ]
>=20
> Fixes: cdc306a5c9cd3 ("rds: make v3.1 as compat version")
> Suggested-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914033719.1380=
57-1-achender@kernel.org?part=3D4

