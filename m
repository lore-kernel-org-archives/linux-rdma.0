Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 862083CC9EA;
	Thu, 30 Jul 2026 21:28:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785446885; cv=none; b=OqUtcIIXSOHwuU5t5/8M4/YSlwVnfBA9IS8L/RYrcJ/rN3bnoLV0NEFDHK/aqAeWeEva7dY9L55fGV102+rP/crTrAyG6/gqgKqVOrCB+XNQs42ueW0jlCRqp2OPSDHuCQwOufHwPjWWdVM35F41Y0D3gm4pZXJm9wSz743t4rs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785446885; c=relaxed/simple;
	bh=tw9L8ZwSB+X0PgyBrat7PqhkQ4BwWT4L8GRCPGEeGhc=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u2lh53Shzp4DdX32HuTc2JKvSRGay0+WwK4hdqxHTG7tQbkU1ZjAQkaswKR1pTvZ9+u4LSp3uPs4jBco7GeqC7nqGAV0EyY6ciFIlAhCl8uc+0CJC5r+JM3N+GMB+pd1SKeJVyrG1vbWFrmNuTuV95SKsbxoMc4MvAp+2b85i7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=a7PUJTa8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="a7PUJTa8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BBF1F000E9;
	Thu, 30 Jul 2026 21:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785446882;
	bh=K+7pOeB0yOEQdZUZidiQ4skv9ZZEXtSOHw7yB4R3KGY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=a7PUJTa8B9ykx6WtWoLWHo0FcfYDIwb1qUMLuPzK97+Ox4EoEVJQs+3lFPtJd0qFU
	 CxOEEbsSBxa+wtQOqycRQCqviSzwqrOAqUemKVd+VAHmjrqkLcaRj/f+ZtVVJeOFg8
	 cRuKHXWhFTyAz2YksHNBKz5e5cSnwVRvqjmOiNvI5tz+xFOpTb+ptNn4xl6EBgsI73
	 LoMRQq3U7owue0fKrXnQFeQv3XBJBH7YMX77japzdLm4JhWwtRpZaZX7z6Q/g8ttkN
	 w7Dej+J2jUpGdJwYQpnEJpGX9eQlCHMzIwI5nimHoCpGZlkkQ1CrDd9KqyajKpqVwW
	 AtL2EQosSFCkA==
Date: Thu, 30 Jul 2026 14:28:00 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Abhijit Gangurde <abhijit.gangurde@amd.com>
Cc: leon@kernel.org, jgg@ziepe.ca, brett.creeley@amd.com,
 andrew+netdev@lunn.ch, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, allen.hubbe@amd.com, nikhil.agarwal@amd.com,
 linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [for-next v4 0/2] Add Reorder Completion Queue (RCQ) support
Message-ID: <20260730142800.19df4e4e@kernel.org>
In-Reply-To: <31315f8d-44ad-db97-4cb3-ffae887d7bb8@amd.com>
References: <20260721121034.1616562-1-abhijit.gangurde@amd.com>
	<20260727182825.7b9bdffe@kernel.org>
	<18c6130a-c8e0-8e58-ad1c-f1578e1c5f46@amd.com>
	<20260728151058.17f8fc94@kernel.org>
	<31315f8d-44ad-db97-4cb3-ffae887d7bb8@amd.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 30 Jul 2026 14:17:32 +0530 Abhijit Gangurde wrote:
> On 7/29/26 03:40, Jakub Kicinski wrote:
> > On Tue, 28 Jul 2026 16:48:25 +0530 Abhijit Gangurde wrote:  
> >> For the earlier PHC series [1] Leon picked up both the net/ionic and
> >> RDMA changes through the rdma tree. Would you be okay with the same
> >> approach for this series or would you still prefer a shared branch with
> >> a PR?
> >>
> >> If you'd still prefer a separate PR, I can set that up.  
> > Send the PR for shared parts, please, that's the normal process.  
> 
> I have collected both series patches on below PR,

"shared parts" means patch 1, only. (Which is patch 2 in your PR for
some reason.)

But since Leon responded let's wait for the adjudication on patch 2
before respinning.
