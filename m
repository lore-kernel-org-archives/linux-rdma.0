Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F233FF1A9;
	Thu, 30 Jul 2026 10:46:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785408401; cv=none; b=Rfl1SZ1MGOT3XYSWQW09trMOnXLm0rOjZQJR4UQlDASGV5sdLg5D8q6Izl7ZlRn0/Y1oznG9hCOJt2+nCf144/rPnvyBAK+O+x/ViDyLEnmvgI9UNCnLSGWiu9OPlH8DqE7Fa3mM1rnvpRtPVb75J+iYFCW37HS1eMtOvrpJaXU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785408401; c=relaxed/simple;
	bh=B508FBYEAm1pXZW1tJUuJaETiisvG9Lfu+PLjermyFQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DkhIbP5O5IXBur7AygCkd4ZIpbJ/sqZ1AguYsMbfGvF4PWsEUcwW7JUdUe0RSu+Nq7HEvuYCU2Ap7ljsGHyBXgEQJgEGVWGilyEp/yJXZimlvGHJ71VIGu8fVI7KRJZuetpE1BsWenfmWaUHnDOzNA0fzBaUxqFpiEx3GCLQvQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BGFdXMpG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BGFdXMpG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4E71F000E9;
	Thu, 30 Jul 2026 10:46:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785408399;
	bh=3TnqRzfQASuBVoPtniAe2TOuMwYhW0F4Q9xzQ01enAs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BGFdXMpGxxFskTjLJLqfhOCIc7dnOvjk+Fr00YVBIfZP5Mt9jQYpU71kbYmkrIIjS
	 n1z7uWsN59XV7m1g9HupRVPAkspO1ZsxwGcoWFMaKODz/VD0XviAWRsO+gXgfCKDFl
	 LQtpyiJSpOlwJyXbIh0xeVeXhPRX+pC2ukCIljHVDoWndTvZvUcxvOd/UrjOgQ6tHW
	 7oRLgeWHWQWWizw2Sr3uqMNqiDSM8Q/+0eEdxQSjgzwwuzJGqrNmpNBws2w6vwAxq0
	 JUc6yppTlj0GFkB//kBK4z/rANY0iJA+5btCBcJlRHmHLOPiyb1BQtGkAwg5zok+vv
	 x2viJHDuF+Vdw==
Date: Thu, 30 Jul 2026 13:46:34 +0300
From: Leon Romanovsky <leon@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: Abhijit Gangurde <abhijit.gangurde@amd.com>, jgg@ziepe.ca,
	brett.creeley@amd.com, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, pabeni@redhat.com, allen.hubbe@amd.com,
	nikhil.agarwal@amd.com, linux-rdma@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [for-next v4 0/2] Add Reorder Completion Queue (RCQ) support
Message-ID: <20260730104634.GP12003@unreal>
References: <20260721121034.1616562-1-abhijit.gangurde@amd.com>
 <20260727182825.7b9bdffe@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727182825.7b9bdffe@kernel.org>

On Mon, Jul 27, 2026 at 06:28:25PM -0700, Jakub Kicinski wrote:
> On Tue, 21 Jul 2026 17:40:32 +0530 Abhijit Gangurde wrote:
> > Patch 1 extends the net/ionic firmware identity structure to expose the
> > rcq_sign_bit field from the RDMA LIF identity.
> 
> Can you apply this on a linux/master tag and send a PR so that
> both networking and RDMA can pull?

I reviewed this series multiple times and still do not feel
confident enough to apply it given the feedback on v1.

For now, I am waiting for Jason to return from vacation.

Thanks

> -- 
> pw-bot: nap
