Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAF437A844
	for <linux-rdma@vger.kernel.org>; Thu,  8 Oct 2026 03:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791430340; cv=none; b=SCBhW8ajWtv/W+YlD01fFFiLlSLAfQCaZRiRcf7MIloAZ6eJqXaAXC73kC9fewWKk9O1+MZ+sA2K9PlCCxJvoimjto/3E5OYM18A1lduYs1pQYO0sc1AeAkEXaV0BDXGM9Xv/9479XguZDJqYaOmo7SDN8dogJU0MgCBTRVb8wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791430340; c=relaxed/simple;
	bh=uodeD8CmxWgMd7Myfg4S4tHW/HFBQo4AKuVTyHFiXrg=;
	h=Message-ID:From:Subject:To:Cc:In-Reply-To:References:Content-Type:
	 Date; b=ALFZEDhPiUXU4b3Vtux03vrxplp+GQQts35x0KhC/sNN7QG8UkCEJu9m02kyIKX4W1DyE8pfhVFFFZzQRwzfe9bPHiaHMLEU08kmeUNs8S1N6qlKEXvST07zNgsBLUViVleI3MvMEJLkrwEORGBQHvq8NIp89Qdry3ndaqy44Fg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DXYzPsVG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DXYzPsVG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1DF11F00893;
	Thu,  8 Oct 2026 03:32:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791430338;
	bh=KFR3ebyMRLc1SiPrcrQKmI2/dUjnG5Wp/ZbEtuiV1Dw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DXYzPsVGg9We702L9SK38hf4alciFtVY9waGlLPPtTDy5nhfpBFPqUA+cdtRqdRFB
	 eJfJp0aO/Wk1HdIrN5N/s/ZeZ9nxUUzykARz8xBl7CRwepTQ5LJm0OBfKk6VrrVNRi
	 +TMIm/7TYggOeAfFK+EQ8WJGNSghfB5nxRc+F7tUotNWL7AxvN9EhD/prngl5NsMQe
	 rN070EYUheCq/dKODXo70kJfxt00bkTSVORfFtJJttjic4DLVKBFGFYse+Ne2wle1E
	 WjVWb/wQpQJAWJ1Th1DAjm1T+q/LM03zvjRu3EyD1CTZwzq1oPK9/Ah8PI4VwUhG0P
	 GU2ti/+t8I8GQ==
Message-ID: <sashiko-outbox-163549@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH net-next v9 05/13] net/rds: make rds_destroy_pending()
 report a connection's own destroy
Reply-To: sashiko-reviews@lists.linux.dev
To: "Allison Henderson" <achender@kernel.org>
Cc: linux-rdma@vger.kernel.org
In-Reply-To: <20261008031333.1142174-6-achender@kernel.org>
References: <20261008031333.1142174-1-achender@kernel.org>
 <20261008031333.1142174-6-achender@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 08 Oct 2026 03:32:18 +0000
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
> sites - apart from the workers' own self-requeues, which the sync
> cancel in the destroy path already rejects, and the destroy =3D=3D true
> rds_conn_path_drop(), which the destroy itself issues and flushes and
> IB device removal issues ahead of the module exit that destroys the
> connection - guard the queueing with
> rds_destroy_pending() under rcu_read_lock() (the last stragglers were
> converted by the previous patch), and rds_conn_destroy() already issues a
> synchronize_rcu() after unhashing the connection.  But the predicate
> only tests for the two global teardown cases (netns destruction via
> check_net(), module unload via ->t_unloading).  Because the conn
> [ ... ]
> missing pieces of the requeue guard, which stand on their own.
>=20
> Suggested-by: Sharath Srinivasan <sharath.srinivasan@oracle.com>
> Assisted-by: Claude-Code:claude-fable-5
> Signed-off-by: Allison Henderson <achender@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261008031333.1142=
174-1-achender@kernel.org?part=3D5

