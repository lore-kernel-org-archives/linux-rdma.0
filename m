Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E0FB4B8262;
	Thu, 17 Sep 2026 09:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789637969; cv=none; b=UOQs0atsMW24vFXpa2uDhxfJVeBmvjSUK4DuA0BuHCf4Z2wpc7O6AtfhYKN59lW2sOiGlEV0D5PAz/1U8eEwyENhgWXOKraSm35V1RVb0kfWLFD2FjnBiv5f8Fy2H+v9vaCpLU3f4528u9fgeGtf8UCdGmhHb9ivunCiAnJYtVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789637969; c=relaxed/simple;
	bh=CnA+q2pW/I5UJHdg/0qRe0yTT3PYjygwp0lxuHvQYwY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=pWfhrUNc9XQKmPrFhPkt7hr9qgo6ilIjeCHH+RuEM0lF40lVaHWYjJGPCgtq2HcnngMWvQaUIotowBne2FDL+upOPzQf3RQPf/sSK9/lX/66dZd3erBJ3eo+BJCWS4aLuB+GA2STS45vAr52K/jtwZsZKehQW95MGWK1deCjf/Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=b0DHBeqJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="b0DHBeqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FA291F008A1;
	Thu, 17 Sep 2026 09:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789637930;
	bh=T6H67Wz/I1+qs3in6zACYkpg/6JYBEniav5/Da5UtZk=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=b0DHBeqJzPQ6MlXTpQbRL1t05YZXaqOHSV2H6O6pB2ZSb4ovOr2EJoEl8lkGki3cG
	 ucoo6EVljfTJn37AAx3VQZb+gtkvv7VXK90o+tO2oIj5hzoqkDWTSzUKxZGWr0cF29
	 k74RgfBeN/egAIk2xmwvQmoCU/RK4NeayEfKOByKto2/lSYXOu2nIhIn3QfJbjOl3c
	 7RKbTacZlyuTgoxhMLDkBAkVutnp+2rzgmnx4VFRLmvvfdIxFwfTXVay2PyBLT6ygL
	 6ixDe1An6OYj1/ueo40rx+pWJLB6iK1LmoLGeu3+rHZuh2Ol+RgOr1zucBEjbLyStL
	 LX/p60i/CFzdA==
Subject: Re: [PATCH net-next v3 12/13] net/rds: drop rds_conn_count in favor
 of t_conn_count
From: netdev-bot+sashiko@kernel.org
To: achender@kernel.org
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, kuba@kernel.org, horms@kernel.org, nicoyip.dev@gmail.com
Date: Thu, 17 Sep 2026 09:38:49 +0000
Message-ID: <178963792920.22033.642153234422430542@kernel.org>
In-Reply-To: <20260914033719.138057-13-achender@kernel.org>
References: <20260914033719.138057-13-achender@kernel.org>
X-sashiko-severity: Low
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 0 · Medium: 0 · Low: 1

- [Low] The commit message of "net/rds: drop rds_conn_count in favor of
  t_conn_count" opens with "The previous patch gave each transport its…

--

net/rds: drop rds_conn_count in favor of t_conn_count

This patch seeds the per-path workqueue names in __rds_conn_create() from
trans->t_conn_count instead of the global rds_conn_count, and removes
rds_conn_count along with the rds_conn_lock round-trip that
rds_conn_destroy_fini() took solely to decrement it.

No Link: tags are present in the commit header.

> net/rds: drop rds_conn_count in favor of t_conn_count
>
>     The previous patch gave each transport its own connection count in
>     t_conn_count, incremented and decremented at exactly the points where
>     the global rds_conn_count is.

[Severity: Low]
Is "the previous patch" the right reference here?

The immediate parent of this commit is 3e53d58bba13 ("net/rds: pin the
connection across RDMA-CM event handling"), which touches net/rds/ib_cm.c,
net/rds/rdma_transport.c and net/rds/rds.h (adding
rds_conn_get_unless_zero()) and does not mention t_conn_count.

t_conn_count and its comment in struct rds_transport were added six patches
earlier, by 45c2c8294f3d ("net/rds: wait for connections to be freed on
transport unload"):

    Count each transport's live connections in t_conn_count (incremented
    when a connection is published in __rds_conn_create(), decremented as
    the last step of rds_conn_destroy_fini()) [...]

whose porting note also says "t_conn_count did not exist upstream and is
introduced here".

The rest of the sentence, that the increments and decrements sit exactly
where rds_conn_count's did, matches the code.  Would it be clearer to name
45c2c8294f3d ("net/rds: wait for connections to be freed on transport
unload") explicitly, or to say "an earlier patch in this series"?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260914033719.138057-1-achender%40kernel.org
