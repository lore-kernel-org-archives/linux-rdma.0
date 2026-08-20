Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B99B644064C;
	Thu, 20 Aug 2026 20:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787258314; cv=none; b=jhx0eZbzHho0Y1OTNMhzGWXth+Mrs7gmOIrMxxFrMPB74oegLCaHMkcoPlFvRaQ6iUA3UHU2UTLYgyyFhI2LG4Gyjmv9S2qIS7fLSoQpjBYYb59XQ/0KjDLkwTSsSjA0vSdFYSdpf4Z26Jm/FLJt8JQyz/wgi6U5/kMr9URdfyI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787258314; c=relaxed/simple;
	bh=RrPriegdCkzmXYs8bcP+skDHY2Jjfrtiq8o1DAF0cgE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BwmMAHtLYEYaxItP8rNYMdSZPKBc8a6gdFe9KFs1eHUzx9om6JVXwgHkGEQrLHOsTCTaOL264THp1gr5fjjNnvJgsfntvedXnsNWWlsWQMJ9Dy6CYsqRYpbZ5soFc/eFmEKo1RhY/+xdi5ic2iKHXKV+zUaDjSuxLsKbDNf3Tss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F1qYz7Ja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F1qYz7Ja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1718B1F000E9;
	Thu, 20 Aug 2026 20:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787258313;
	bh=4M4qz3dT+yaSJnEXa5rDQUZYCv5z2DrqUY/KZqpbKuk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=F1qYz7Ja8JbJz+B7apHVDk1vMTg8Qs+f93cnCb9n20pK3kKngx0IPCfHS7fkF3h2l
	 1LWwFZznWgUHriHFg+pmRkwTqEMkMFKMZPQQ2uZb6L+A6bNUGkDl7bSUQAJs5s+IeG
	 FXSj/Gq93T5T+t0RukN3jExGoVoKtL0HoyEhkyM494vUxQGg3so2v5EnNCVEiTp9wZ
	 Xd1WT8aIBpJQSGecvp1yRWjBuYhcBZd+In818OszwCq/xXIxBMnOr5ENjcRCxzsE54
	 7F8Ar2HcgYnkhl1+gyLGpfIKPXy1mdfaFg3xlRnAd1K6I14siQYVLwpByKsPAv0F9J
	 VJaOYUibiCvgg==
Date: Thu, 20 Aug 2026 13:38:32 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Allison Henderson <achender@kernel.org>
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, pabeni@redhat.com,
 edumazet@google.com, horms@kernel.org, jhubbard@nvidia.com,
 woni9911@gmail.com, michal.kubiak@intel.com, leon@kernel.org
Subject: Re: [PATCH net-next v2 0/5] net/rds: own the fastpath locks across
 connection teardown
Message-ID: <20260820133832.5384be37@kernel.org>
In-Reply-To: <20260816001510.73645-1-achender@kernel.org>
References: <20260816001510.73645-1-achender@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 15 Aug 2026 17:15:05 -0700 Allison Henderson wrote:
> This is v2 of the follow-up set to "net/rds: Bug fix ports, part 2"
> [1] (v1 of this set is at [2]).  During review of part 2, the later
> half of that series needed more work than a respin, so it was split
> off into this set together with the companion fixes identified along
> the way.

Any thoughts on the AI review?
https://netdev-ai.bots.linux.dev/sashiko/#/patchset/20260816001510.73645-3-achender@kernel.org
IDK enough about RDS to judge the severity of the last one.

BTW we will take these via net now that the 7.2 final was tagged.
Don't worry about net-next being closed.
