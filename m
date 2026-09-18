Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC311522699;
	Fri, 18 Sep 2026 19:45:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789760752; cv=none; b=Y125aNHgUixOU/yu3TvzXfKen9j9TPiOZdCHJfssk2afrz1OFCUq8aDniKWlBxfcVxpL9YQGZtpj6LyDTkXbrrO3xBYYqUQUAdxbpZODIHafSjNjEqi67ZF1RL0ONmyqFyKaZ/CG3BQgMMLfYdtjz+FXqh7oePl7DhbP4Kqsz5w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789760752; c=relaxed/simple;
	bh=Buk2H4UGWd1HKKhaku9nG/8YiPC1RZu+XniqN9Z4+V0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gpF1yc1OjioHZkVEd2NT8brgECaiJK4aKCMwEpDsKHxjt+paT2etm9ByI/OSSgXH2LOUGonmKprmkurJl+BbjLWG1mhGxZGcsiA8TwAXwLz08eJzQGeGJNN1w2UvestyBfGBCk3moFautV+neXCPjR7MJRJ0/npRWLiLXeVA4rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UO3MeYxT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UO3MeYxT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099B71F00898;
	Fri, 18 Sep 2026 19:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789760748;
	bh=vYQ6BtbbVgXXP8MV1veSsvM8EhJvgEGrwFCTi1zmUXo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UO3MeYxTHGJ5KmoTPW4UdkTh2wsEnScnQv/m8Ws7iFif5wgHpEHMrpd8ku1ZSOFMJ
	 Oyk8sZAM73SDN7Dm9RieRI4gyMHxw69FUUzVs0JEKgtZwkcEsyb45K1CRE7JiiF/Re
	 n5d1L34EjQE7Scr1iejMlUKilm5SqlO6pCkuRcZFuYaItlteZrbm0dZUDUSOXRfeNA
	 D/BMWkLL56M24STXKAH5gxEC+D6HlH5YlxrC3bSnjPwWgD5sMYy2++idnDAXo9/K1m
	 v0eW2pNpb8lxgQiGjbO5dXVB4uRD38UKmauxSFSolFnUid7dR48L5kLCOjVhtwmwgU
	 Qsaa/3B5oLYTg==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	gregkh@linuxfoundation.org,
	guangguan.wang@linux.alibaba.com,
	alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	mjambigi@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	"David S . Miller" <davem@davemloft.net>,
	Junjie Cao <junjie.cao@intel.com>
Subject: Re: [PATCH 6.1.y] net/smc: check v2_ext_offset/eid_cnt/ism_gid_cnt when receiving proposal msg
Date: Fri, 18 Sep 2026 15:45:29 -0400
Message-ID: <2026-09-18-daily-reply-0002-re-net-smc-proposal-msg@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260918045353.686837-1-junjie.cao@intel.com>
References: <20260918045353.686837-1-junjie.cao@intel.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Backport of the CVE-2024-49568 fix to 6.1.y. The CNA record lists
> 6.6.68, 6.12.7 and 6.13 as fixed and nothing for 6.1; the affected
> code (v2 CLC proposal parsing) dates from 5.10. The other five fixes
> from the same series are in 6.1.y since v6.1.122; this is the only
> one missing.

Queued for 6.1, thanks.

> 5.15.y and 5.10.y are in the affected range as well; the commit
> conflicts in af_smc.c there and needs a separate backport.

Send those along when you have them and I will queue them too.

-- 
Thanks,
Sasha
