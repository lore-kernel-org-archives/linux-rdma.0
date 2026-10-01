Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6C3E4848A5;
	Thu,  1 Oct 2026 06:16:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790835386; cv=none; b=kDkm6c2rXsxejWTZtxLHudfN6adsZY2mXoGmMsuJ+HDhkgueS5NVOWQEa8pStg72QB2VCdo4OuRTkWHp+4VDpPikSNBFCnLNdLEAB9++670wUMnN3ztey97OzmAauRAB2glqAAW4BlatzWrFOhE1Rb5MXojLy3uaNuXegIrCehE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790835386; c=relaxed/simple;
	bh=ub+XohoGRrnhjgEhzhTKKaN/IzeHDuIP8KE9OG2GtuA=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=Jofg7QAbO6A8dpp/ROIlHSWAjqF3b0l2ziSlNXuImYj14aXDLp/NVn2GkEGz9I6HCK5WlpXB6jEPFvCxAJL+hsXHFKLqQOykN57Y9AdLewChsF3niuphl7GiDmHK3stDKgE/hfdrs8thjT6nxZq4EIYFsqGRiQk694k6LjoYjpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Be1Nawtn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Be1Nawtn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551441F0089B;
	Thu,  1 Oct 2026 06:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790835376;
	bh=pmi2oGX9kXow8mtfl0pejmWifOBIvlnRTEtBigWs9R8=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=Be1NawtnitbIAwt/uIW4fXy899Z4Gqqt3xPgUzQo6Xn37F6mHObqCyTmXRxlEH/fi
	 3ataoWsOe0To/ZzxJ8SHlhvlNLng+/ZmMNKOUEoiJKgh963POZoErAggH/3aRgcilb
	 +aXwHi5YiAyTwdBgIOdIETDvU90siLmD9K107IgW/HuTEJXEg63K2tL/jOzFtHwCEG
	 CEwOi5QSw6erGrKpejNAMT42JaFuqGNvYP684fIi3b30FMTrL6bNFXRJw8UpddyRYJ
	 5nqVv0H6LsO6fj3TAzseelZ0d+rOBcY64fdnuuXeFMt3hGpFuI9pfjKC1IweAkmq/G
	 DvoezeEyXo4iA==
Subject: Re: [PATCH net-next v7 12/12] net/rds: drop rds_conn_count in favor
 of t_conn_count
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org
Date: Thu, 01 Oct 2026 06:16:15 +0000
Message-ID: <179083537588.434549.13021010950771764616@kernel.org>
In-Reply-To: <20260927061448.167862-13-achender@kernel.org>
References: <20260927061448.167862-13-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found more severe
issue(s) in other patches of this series. This mail is only an FYI, in case
you want to address the nit picks below when you respin.

Low priority / nit picks for your consideration:

- [Low] The commit message says the wrong patch introduced t_conn_count.

--

net/rds: drop rds_conn_count in favor of t_conn_count

This commit removes the global rds_conn_count. The per-path workqueue
names in __rds_conn_create() now use the per-transport t_conn_count as
their seed. It also drops the rds_conn_lock round-trip that
rds_conn_destroy_fini() took only to decrement the old counter.

> The previous patch gave each transport its own connection count in
> t_conn_count, incremented and decremented at exactly the points where
> the global rds_conn_count is.

[Severity: Low]
Is "the previous patch" the right reference here?

The patch right before this one is "net/rds: pin the connection across
RDMA-CM event handling". It does not touch net/rds/connection.c or
net/rds/rds.h, and it has nothing to do with t_conn_count.

t_conn_count was added earlier in the series by "net/rds: wait for
connections to be freed on transport unload". That commit's notes say
"t_conn_count did not exist upstream and is introduced here". It also
cites the same UEK commit, "net/rds: Each RDS transport should keep its
own connection count".

Could this sentence name that commit by its subject instead? For
example:

  Commit "net/rds: wait for connections to be freed on transport
  unload" gave each transport its own connection count in
  t_conn_count, ...

That way the reference still holds if the series is reordered or
split when it is applied.

The rest of the message matches the code. In the parent tree,
rds_conn_count's only reader is the alloc_ordered_workqueue() name seed
in __rds_conn_create(). Its increments and decrement sit right next to
the t_conn_count ones.

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260927061448.167862-1-achender%40kernel.org
