Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1522D57F73D;
	Thu, 15 Oct 2026 19:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792092998; cv=none; b=FIz5dGab3cNlHEppnetBxqNdQ4qApvPmJEM/VpWafhl0SwvNK1ZZHztL70ps7QtdSVkRdQ5nLirYnIkjFrvbYyMoCXGrXz/OqzZC1gWaiVnpskcxKqKVBNAl/73G6TmijK8Yve7CW1hyzk+z0HKMdTBFYiYEBnptBUdJ8wtoMYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792092998; c=relaxed/simple;
	bh=8YZbO+kM9CMWBS8o16UL9kxUAjmhZDYKeJXg+3KAWbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RO+Qm7s6QeppHpa85HgmbxY6YNZc84DpOTZv1OAzqWQNZSVypooMTcfIxIBTaceA9TvKXThPtvPBgn7lRp79ACIiXkqi3MHpvhmSInPVd728PcksUyo2HTNi362xLTJF361fzD0qs8h3KXVVuKAkyJkXnTB0i3aeliOtYjW4zMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AznvU9q/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AznvU9q/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DFAC1F000C8;
	Thu, 15 Oct 2026 19:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792092997;
	bh=nmO4C8aXMj86Qf2BoiIdp0//VUkwCz9hLZJJ+u8wyW8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AznvU9q/bmt1tpZUEYUOzyr2eESoopDvF3LBfBGmKHxVS97sDETZEmk4a3x0br2O+
	 Y1cWU5pnNZSwsHTYCsNJJ1ezcqMHWb12EeNWclkD2chnwItSMph446XAMHFEM3LAcU
	 k4QNPJY5VpSsbpq1wQQeYdHn7m+8EH7lZqUdiwTqjGvIHEBHdvfAKko8el/JUYjqqx
	 9mbrHXljNNSEgODTQL54LILHPT86crAIX1GKDkwm2xwpX8w3EkIBZSzCPGcdqflbo9
	 c3q+GoFSpF8TU1iph+F9UCQmQX7YtamLPc4ueyMlxESkcIQIKvQOdu2je366qIT3pX
	 b/r0KU6SFBUMQ==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@kernel.org,
	kuba@kernel.org,
	leon@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	mbloch@nvidia.com,
	netdev@vger.kernel.org,
	pabeni@redhat.com,
	saeedm@nvidia.com,
	shayd@nvidia.com,
	tariqt@nvidia.com,
	Artem Dinaburg <artem@trailofbits.com>
Subject: Re: [PATCH 6.6.y 0/2] CVE-2026-22996, CVE-2026-23035: backport fix series
Date: Thu, 15 Oct 2026 15:35:56 -0400
Message-ID: <2026-10-15-1-daily-reply-0013-cve-2026-22996-mlx5e-6-6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261014191738.24034-1-artem@trailofbits.com>
References: <20261014191738.24034-1-artem@trailofbits.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> Please consider this backport series for CVE-2026-22996, CVE-2026-23035 to
> 6.6.y.

Queued the series for 6.6, thanks.

-- 
Thanks,
Sasha
