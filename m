Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01AA82772E;
	Wed,  5 Aug 2026 01:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785891725; cv=none; b=uT5nJzVwztfFPCBnv/Wt+SXM3yYqlMK1AWU/7cTtH1u0JorRG3M6TgQ/EUBpVfSxEYQ0yVnTR6O2KQP6fJqlmj1sEUQm4cV/O2BhJ201EroPxZXOnrD963GxeS0KVgWNkKpibYyxM53kmlQU65o8nkUTI3DX3Um2jZ8lMisp+Fc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785891725; c=relaxed/simple;
	bh=AEiz7xegHzp4I+synasfpOduGq+zql4/x7hJacq6VS0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UKsNqOW94JjNVNWhm2dvbaY5W09fv15xnl6G2emBy15/q0ryeTJxQMVzHblM4flafVG/74VQqd/LvM+gVP1W/WSRTiuowuw6I+/dxCbctrU/iMnLjSrZ+nnyoyhbmspx0cXZZEBdGv/AsCvDAJWqZcMZeNB1j2dqMEKeXt7o4QI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GQYocDCb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GQYocDCb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D661D1F000E9;
	Wed,  5 Aug 2026 01:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785891724;
	bh=RHMTpNQUBpyILr3uIRs6KtCpe9Z/hhEK9/1uQ+sOK7c=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=GQYocDCbcDGxLMMbkA1jqyOxTdTVV4PhmnJ/qFE8Q/F4w9v6zrGt5FoZUiOigQWmg
	 2Z9snF8g3GgS/fiWtm1gyMCODo24pdFbf3tT/t+z9lRxnaCfvDPqbtPdM0tdhHX5j/
	 gj+ztSSCs/Kp9gc+mm4B5ebFcfEfkd5vs8py4r+gTN2NXfhuoWsfiNfymnPM5OAik3
	 dgSckNTyPreo1d65EEueKrPyM8unNeTP88BJIW1usF7MFTprSDjVxdDCquIiU7Ykmr
	 0ZGoS4p7fxIDnfuxwxYH655o+1QF5NMLITmKYFS+ZIqbRhVZNNGrWuNhX5APhsB5lN
	 5eFAV4eprcAQg==
Date: Tue, 4 Aug 2026 18:02:03 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, jhubbard@nvidia.com, leon@kernel.org
Subject: Re: [PATCH net v4 0/4] net/rds: Bug fix ports
Message-ID: <20260804180203.3413c381@kernel.org>
In-Reply-To: <20260730041629.3512480-1-achender@kernel.org>
References: <20260730041629.3512480-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Jul 2026 21:16:25 -0700 Allison Henderson wrote:
> This is a small set of net/rds bug fixes and ports from uek to upstream
> rds.  I've been working on extending the rds selftest case, but need to
> stabilize a few more bugs and the first few fall into net with Fixes
> tags. I decided to leverage fable for this set and I thought the ports we
> clean and well explained.
> 
> This series fixes a sleeping-in-softirq bug in the RDS message free
> path, a use-after-free of the RDS socket through long-lived MR
> references, a message leak in the rds_send_xmit() drop path, and - new
> in v4 - a pinned-page leak in the IB transport's MR teardown.
> 
> The first three patches are ports of fixes carried in the Oracle UEK
> kernel, reworked where the UEK approach no longer applies upstream.

I don't have much confidence in my ability to review this,
so let's queue this for -next. Hope that's okay with you.
