Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793227152;
	b=AJUH3WFKmMpHRwyguBq9STSQp15mT3P3Nqe6o+V4SSfTYTi+DO4mtjBWdHtycAb+SwyS
	 zX3LEw/vsuV69fzzu9428+vLy3CXTkb/7rrLh2MiX/901H3U+DznA8oDBFACmmaJQ80Nm
	 3WmSxiNgd8h3yB4ArxwhBuUP1JE6Ar6DKUIBv/QB7QCOUrDy2f4niEXj4GjTr1dz+Ner6
	 x5U+AXRkszEs3LNwW1hi98bwlGG5lnnwnZC5sx36ddkmVHiARc/Gm0wM8tvlqEh3xOxYq
	 ZdwkobDn7lHRFBjGioUWfnOFrLRam1UjM5FazlOIcEoVbH6gonIaadceabIa6k9kGtQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793227152;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 In-Reply-To:References:MIME-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=sptKTufmKvL8HpZwPKOH1Q+7N6rHyLXbpotzs9340aU=;
	b=s502433pDZp1YxcAI+oo0DZVEHWNAQ6HC4vGAgXCSt91DDvxBaJADrwcMwZbCqUklav+
	 oVxvaCmOAVwPSOyzhWUNxIXqy4wPLx92a+kvX6ga+Rji/hLiRKcrCBcdsiOXzOuPVV01D
	 y8QYqFXjUABadqOBVxFqjiAyBukEznT0zPBhXgqYqqFdVYHsyR+uPSlXuJPv0X1IcMVhZ
	 SMrU9MF5MZB6xG7HwKEQmt/1P8extD7P8zpd70iOLX3zKw9xAM/ctgvK0ZEaJH6eSbYhW
	 Hul5k/QuRwkRE6VAEmVdHI/T8ccPTNe2JZsHPNzXfJlHjYIGmyl4iM7UnynxbWNCBwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g8Ie2HLZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9509606A31A;
	Wed, 28 Oct 2026 22:39:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=g8Ie2HLZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 349B11F01825;
	Wed, 28 Oct 2026 22:39:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793227151;
	bh=sptKTufmKvL8HpZwPKOH1Q+7N6rHyLXbpotzs9340aU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=g8Ie2HLZNHyiGj1lLMH2CKScbvl8vNv0wkF0tmWo/NnRkkBc4AkiK08mYkFe9cpiT
	 JceGWn2X4v8/ZvkIyUMzYNQkGKO9+cKjLd4f4wWCzAVeF0S6pHLu+87mr/sp+N6vZm
	 LgwKeNV3lOvuQUgwsiOoceA6YTMxftv2BrGACGznS0NDRykCjqaIbyOcxIQp1vDlau
	 x1A1W0YpO9CaXu92mhyPW7w6kYCW030O+BXI1r2gLtg7yss3PLhieVdDlAagiMo5n8
	 oC5eT05w6r0G2fL30ddYe2w3n2v5fJQUuQW2bWe5N/doZWt2I1QXyjKQcj5HNhcyE/
	 LXPuVPpNrRG5g==
Date: Wed, 28 Oct 2026 15:39:10 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Allison Henderson <achender@kernel.org>, Joel Granados
 <joel.granados@kernel.org>, pabeni@redhat.com, edumazet@google.com,
 horms@kernel.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: Re: [PATCH 0/5] net/rds: move sysctl-only code under CONFIG_SYSCTL
Message-ID: <20261028153910.6308cd06@kernel.org>
In-Reply-To: <atzRTslzb6CAKPKX@redhat.com>
References: <atzRTslzb6CAKPKX@redhat.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 24 Oct 2026 17:39:58 +0200 Oleg Nesterov wrote:
>  net/rds/ib.h        |   1 -
>  net/rds/ib_sysctl.c |  33 +++++---
>  net/rds/rds.h       |   5 --
>  net/rds/sysctl.c    |  26 ++++--
>  net/rds/tcp.c       | 230 ++++++++++++++++++++++++++++------------------------
>  net/rds/tcp.h       |   2 +

This presumably is net-next material?
Please wait until the merge window is over, rebase on net-next/main and
repost
-- 
pw-bot: defer
