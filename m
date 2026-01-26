Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3B91283FC5;
	Mon, 26 Jan 2026 20:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769460650; cv=none; b=FSTnL0p0IqU4WZ1VD7ciolA1SJh7xgjWQawKMbFxy14euw2PHbbPK59aN66/eEyqBqowMwdrB52cZm9uTrC6oRh5jK2T8GPpHMupV7EzU0Fj1dYe+FoVqVrRdTHIwGpUSOs0ksIUX5WRj3lRC2x4c93MSWvQuRVlSv138/5G5lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769460650; c=relaxed/simple;
	bh=yndic95Dd8m5l7C1UqbBVJQY3dB2qyl3JPw2oSTE5TQ=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=Y7vgKw8a2nXORWlUEQDEWA+lELdWwbe5Hh3DccTgzfnu6+nQH6o0Mwk3YymL135lgN4EmRXsm+ScdrDKote5KhnlvEgPZGw91sycHLM/7D4Fqtzr2EQLINc3lIiByNgUf0yYO1CsioJAOJo9PCP3dH4IeBxJdVlieJrvRkBxq10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=Gnbh9Loe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="Gnbh9Loe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC155C116C6;
	Mon, 26 Jan 2026 20:50:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1769460649;
	bh=yndic95Dd8m5l7C1UqbBVJQY3dB2qyl3JPw2oSTE5TQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Gnbh9LoeYg4uZkvQPBCJHv7TazOmO+eqozhbasI0b8pDuDPJ/LE4GearjPOnG04NB
	 /t1tDK4uOP4xN4ZsPWegJH7KYRjDifFFGDt4laaZ+PpC0Uf05a9w2tV709Z6OH1Ogt
	 GvJ4OwYOaLmX6a2pJF4xDjbXynMUAml/PDzkSr5U=
Date: Mon, 26 Jan 2026 12:50:48 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Alice Ryhl <aliceryhl@google.com>, Boris Brezillon
 <boris.brezillon@collabora.com>, Christian =?ISO-8859-1?Q?K=F6nig?=
 <christian.koenig@amd.com>, Felix Kuehling <felix.kuehling@amd.com>, Leon
 Romanovsky <leon@kernel.org>, Steven Price <steven.price@arm.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>,
 linux-kernel@vger.kernel.org, amd-gfx@lists.freedesktop.org,
 dri-devel@lists.freedesktop.org, linux-rdma@vger.kernel.org,
 netdev@vger.kernel.org
Subject: Re: [PATCH v2 7/7] netclassid: use thread_group_leader(p) in
 update_classid_task()
Message-Id: <20260126125048.323a281527fb2554c96f40bf@linux-foundation.org>
In-Reply-To: <aXY_4NSP094-Cf-2@redhat.com>
References: <aXY_h8i78n6yD9JY@redhat.com>
	<aXY_4NSP094-Cf-2@redhat.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 25 Jan 2026 17:08:00 +0100 Oleg Nesterov <oleg@redhat.com> wrote:

> Cleanup and preparation to simplify the next changes.
> 

"next changes".  This is the final patch?

> --- a/net/core/netclassid_cgroup.c
> +++ b/net/core/netclassid_cgroup.c
> @@ -93,7 +93,7 @@ static void update_classid_task(struct task_struct *p, u32 classid)
>  	/* Only update the leader task, when many threads in this task,
>  	 * so it can avoid the useless traversal.
>  	 */
> -	if (p != p->group_leader)
> +	if (!thread_group_leader(p))
>  		return;
>  
>  	do {
> -- 
> 2.52.0
