Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E29CB360EF0;
	Wed, 22 Jul 2026 00:53:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784681594; cv=none; b=ms4quKy7n8RoO5AyvoqXC4LW/OcBodCZCazLsD0p68xsfFMZRgWWLDYwV5zfO9G0zaDzLivV8thow0PXPiOE17OHWF6YqWnNqOHCUB52q5SEBoyvzLgjNt+c4O8sTJdfwbjEnEeT5/TdCQEwR/K0cQzKzpSk++CCoPJSzZP2q8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784681594; c=relaxed/simple;
	bh=ndtmzNgwDqxeUw2zsH85hlvrvEgwOpqX67axg7QVw2w=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MHux/Tg0QC2bDsqhAhudsPkDew8LLD4/Zmfp1Zcf1jPQJzwHz/Bg8ObM0qY4cB4vKpNGj2iePcBe3m4bByJpWW2gv412z5rE8ZYeNOZXPlm+jRs8LLxKpRtfLS8LqW7lt4QTav99S6QaKpVCjFawzi0z4s3jo4j+1TKYT+jaiiE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KBuejSey; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KBuejSey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6FB71F000E9;
	Wed, 22 Jul 2026 00:53:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784681590;
	bh=ndtmzNgwDqxeUw2zsH85hlvrvEgwOpqX67axg7QVw2w=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=KBuejSeytj5zhAuuCfIp+wsjVVI2Wz3AnrPInWOHJgTUWCkMMW0jcjFrQJ/hZTXwz
	 QtuwDiUntBst7pH/olvFvJk3inTect7e9WmVa5hvleZGuq9m4+2jNYzGsx2NiXYV/7
	 xAOOCb8WNNdbZ7f1FNMvd+s5tTGEeBbK/JrGC6xxIJ84bBRQBICN6D6LNAh4+u3ffm
	 +G/c+4aml/LLsNNBHMVar55B5bVGVLdyz+h9bYv2MVff5US0kZMBeO8kfNOzDto2a9
	 Hymrh6An92UUxOlphiomaKlc0oUV5L3IXstLu9yq82vc+npBG1MQXbunp1VaqXjv2h
	 mrNly93quM20w==
Date: Tue, 21 Jul 2026 17:53:09 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: "D. Wythe" <alibuda@linux.alibaba.com>
Cc: mjambigi@linux.ibm.com, wenjia@linux.ibm.com, wintera@linux.ibm.com,
 dust.li@linux.alibaba.com, tonylu@linux.alibaba.com,
 guwen@linux.alibaba.com, davem@davemloft.net, netdev@vger.kernel.org,
 linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org, leonro@nvidia.com,
 pabeni@redhat.com, edumazet@google.com, sidraya@linux.ibm.com,
 jaka@linux.ibm.com, oliver.yang@linux.alibaba.com
Subject: Re: [PATCH net-next v4 0/3] net/smc: transition to RDMA core CQ
 pooling
Message-ID: <20260721175309.321b6503@kernel.org>
In-Reply-To: <20260716113745.65234-1-alibuda@linux.alibaba.com>
References: <20260716113745.65234-1-alibuda@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 16 Jul 2026 19:37:42 +0800 D. Wythe wrote:
> This series transitions SMC-R completion handling to RDMA core CQ pooling
> via the ib_cqe API. The new completion model improves scalability by
> allowing per-link completion processing across multiple cores and enables
> DIM-based interrupt moderation.

There are 2 fixes for SMC on the list waiting for review.
It'd also be great to get someone to review this series, preferably
from IBM. There are 7 reviewers/maintainers for this code.
Pinging y'all is getting really tedious.
