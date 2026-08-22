Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2152FC8EB;
	Sat, 22 Aug 2026 00:03:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787357030; cv=none; b=O0P/LOJfMUoOCD2lmIobgREDjLdmqe84EtGmTq63wihCZ+aKfn9Q78eIOcWz0jcXL0VWr4vt+Oz2IA8fQThPcghokOz21rtv7WONvPIxl0twMq9y8dkohPmWGDixqNRvwLUz/2J2yGeHddU8/bRG2FxX8JSfYfxyzyDJ+v7W938=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787357030; c=relaxed/simple;
	bh=NqoHc45I7VXGON+fDtU9Hag2iX7RjPG6uEFny+9vx4s=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y5i4aJst7Bcrax67DC6mFS3LwP9MlyL6m1k43jrKLHxWSLg0d/RcKoAbKZQgeUYrZvNVhmSQOvE/p/h7XGxaD45ANfLMiVl3Fd6kgYLsp/5Utqoj9V89DpsXvUdLHRBH1mJsekn0IHHMyhGu53mCCM/l9cBX5WYPfmHESrA/jcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MXJqTa5Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MXJqTa5Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EF771F000E9;
	Sat, 22 Aug 2026 00:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787357028;
	bh=un4boMs1vDHu0wMf34UCmT71RQC3T3xUNRxC7MFg3BI=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=MXJqTa5Qb47WTnnPLzvt5kXZeOpMB2zeX/3buzzwCfEyjYgWJPiPEUhj3KRB8+VT4
	 qTjZ49HqQHG9tbIjYdEHj7eI8TGD31nV5w79Y2GDUdj7o5D6fx9SvWKR2jhfLpIjmO
	 n8ejezEguSDVRhJ4+uvLnZNFhwJKULQKGeIDZDYNEhhPU7rgA83C7ZOCJob5aTHpGL
	 1IGtIYis210PCPYNVK/tFZ97sMbjNSd8XWTN/X61vlpAql4riLTSXLNbQYPk1ItHAC
	 BwouWHCPHrhymvJfRrsDjYFgBje2LQi3y0NDnqSykxUeJMrU1szP4cnLqFs8M1ksqG
	 NqdKKo73NH9XA==
Date: Fri, 21 Aug 2026 17:03:47 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, jhubbard@nvidia.com,
 woni9911@gmail.com, michal.kubiak@intel.com, leon@kernel.org
Subject: Re: [PATCH net-next v2 0/5] net/rds: own the fastpath locks across
 connection teardown
Message-ID: <20260821170347.77cfaadd@kernel.org>
In-Reply-To: <c3c9a3f2683a37474256b9f879f9ee896d62704c.camel@kernel.org>
References: <20260816001510.73645-1-achender@kernel.org>
	<20260820133832.5384be37@kernel.org>
	<c3c9a3f2683a37474256b9f879f9ee896d62704c.camel@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 20 Aug 2026 22:07:26 -0700 Allison Henderson wrote:
> The other commentary nits from the review do have merit though. If you
> like, I can send a v3 with those corrected, but I think the code itself
> is ok. The patch 1 comment about cong.c is a pre-existing issue similar
> to the lost-wakeup issue that patch 1 fixes. So I can send a follow-up
> converting those waitqueue_active() calls to wq_has_sleeper().
> 
> I hope that helps? Thank you for being accommodating with the branch
> targeting.

Thanks, yes! IIUC you don't mind sending a v3 so let's go with that
option.
