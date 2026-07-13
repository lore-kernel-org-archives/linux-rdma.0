Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BB33B2D18;
	Mon, 13 Jul 2026 08:36:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783931781; cv=none; b=AWhqsbuaXGjcxGfX0q83/0jcvHdEGL5ttDNPz5I7xhmVchCMIStV6O9Jy7of3XG00HED6fq7S6PcsPP25EntlDQ/d9MQ4SXfGkktVFkhjWbUad+WM5pplQNpnn9kpGMzAsu5DLqyU9kGQK+tX8uhu/tGoKHTVQ7phndXgsLshAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783931781; c=relaxed/simple;
	bh=dLfURvyONimeAjYipF2/rUflFTv+KVQKgD2DtEnkhAk=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=QItcE+I3MBdiuT7jleKuIFVF5MJtqoyOCHw/zitYPfK01sjWjrJAUJeRhpwfFRV61BibXP/BmhsIV3u5UKopbtEOvqktepdJiZs8YOgZRpQUIETfEtKEtCAp8wSsSQmzIzdKlk0JHoE3EOvya4Ps2MEdHq51BFxohhXgvaijQzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hy5rKu0Z; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hy5rKu0Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AAD81F000E9;
	Mon, 13 Jul 2026 08:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783931779;
	bh=I4buFcsf30H6aCot49azEcvMwmak6OkUu/zmiH06haQ=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=Hy5rKu0ZXt3yYonMMUesuXVQJBVxb54GSRUhmu8S+eH6bhuLRRq5Ac3NynQ/SEhbl
	 99X1SIIg1rfSLq3UFOfTQVedkCAOGp84AhgXeO9bx57vNniKXMpjHj2XBd8gagBf+f
	 HaMrasY+QktV/3FPk/m2qxKGP1SqlfQcznRz/kW+6qhTO6R4MGt0trS6IjEO9q4aNP
	 NwuXWUBqPRnLM5THCD0p2+NKcIyYzn6MTg140IAGjzCE56mp/n4xYMp0ZFoRRCSdOA
	 LLEv15y9tsVuVuZsrsgM1nPfGht/TF78qaX6PYiFvP2n4iB40C2Es/fj6KwRM0Fk9A
	 jvej8vVkg7Kkg==
From: Leon Romanovsky <leon@kernel.org>
To: yishaih@nvidia.com, jgg@ziepe.ca, linux-rdma@vger.kernel.org, 
 linux-kernel@vger.kernel.org, 
 Praveen Kumar Kannoju <praveen.kannoju@oracle.com>
Cc: manjunath.b.patil@oracle.com, anand.a.khoje@oracle.com
In-Reply-To: <20260615171759.557425-1-praveen.kannoju@oracle.com>
References: <20260615171759.557425-1-praveen.kannoju@oracle.com>
Subject: Re: [PATCH v2] IB/mlx4: delete allocated id_map_entry while
 sending REJ
Message-Id: <178393177689.1679084.4077224530208522909.b4-ty@kernel.org>
Date: Mon, 13 Jul 2026 04:36:16 -0400
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.15-dev-18f8f


On Mon, 15 Jun 2026 17:17:59 +0000, Praveen Kumar Kannoju wrote:
> The mlx4 CM paravirtualization layer rewrites a VF's local
> communication ID to a PF-visible ID when CM MADs are sent from the VF.
> For messages that start or advance a connection from the VF side, such
> as REQ, REP, MRA and SIDR_REQ, mlx4_ib_multiplex_cm_handler() allocates
> an id_map_entry when no existing mapping is found.
> 
> A REJ is different because it is a terminal response to an already known
> exchange. It should either find an existing id_map_entry, rewrite the
> local communication ID, and schedule that entry for deletion, or it
> should pass through unchanged when no mapping exists.
> 
> [...]

Applied, thanks!

[1/1] IB/mlx4: delete allocated id_map_entry while sending REJ
      https://git.kernel.org/rdma/rdma/c/9539e619660471

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>

