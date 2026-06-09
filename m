Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7407B2C029D;
	Tue,  9 Jun 2026 00:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780966336; cv=none; b=nnHNQKqVEUWhAtc3bbzlZrWLhijBbYMkFLwvvk9Lx3sKsKWG9G4mbxtBQurUAGm2fLUvv+AqlNi13UbBf9NYFlkEFNosr9FmQGQWBjMjPXzW4lcrsUUOJac/xxCdQOpNtQwfJywESPRZVf331cy4fM8cAaCkhkVbx2jtQTXq384=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780966336; c=relaxed/simple;
	bh=4WKU2kJr3dKEig3fEKW5UMXeLYSp2Fllc+AbXu/YyuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VufyMNVyo8r+5JnQM7uAOvOubCb2sGBeSiCEkRla1l7c1x8PoCYR0nDyfCNW+rSZGv3sON07Pakg9ZUfPGlHdyfXzqHTkR/Dsjih5kB6biX7Tw5Q1/ReSdBhP5uGlWRkdGOSOuUZZzyYRNXxS8iHVRDn5J4NRq8hx4rSMLoL5O0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EqWrEYH0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EqWrEYH0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 204A71F00893;
	Tue,  9 Jun 2026 00:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780966335;
	bh=4WKU2kJr3dKEig3fEKW5UMXeLYSp2Fllc+AbXu/YyuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EqWrEYH026U56ztci5jrwt7H3ZZbclYQl4AGHt35lX4dN2CWe8zvYwWDjswHgzOcf
	 6smm1m4EcunbPpcKKFCW9VryIQrhkyZ1DFMx9+MRe7EUeii8ANofNJ+2AIT2tTFaXn
	 zMX+1a/6WoCtQAy4baq3lcARxecvepSZ4HHo1Dko9hDfvN06L825GIHIKj/fKWw6JF
	 VDnawubDKN6B9129p5ngtAiAWM9dST+7xMCCdnPJdqAOdiy6A4rtdpgVq7zFExTbtc
	 UMy0UtstTQgQiyHkylVkUILdiPgk7Uxy0dGMRi5jIy7idkU3cEySjbOrwO43M8p6wO
	 bdaxNIXF+Si3A==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Sasha Levin <sashal@kernel.org>,
	Vladislav Nikolaev <vlad102nikolaev@gmail.com>,
	Zhu Yanjun <zyjzyj2000@gmail.com>,
	Doug Ledford <dledford@redhat.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Haggai Eran <haggaie@mellanox.com>,
	Kamal Heib <kamalh@mellanox.com>,
	Amir Vadai <amirv@mellanox.com>,
	Moni Shoua <monis@mellanox.com>,
	Yonatan Cohen <yonatanc@mellanox.com>,
	Leon Romanovsky <leon@kernel.org>,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Zhu Yanjun <yanjunz@nvidia.com>,
	lvc-project@linuxtesting.org,
	syzbot+4edb496c3cad6e953a31@syzkaller.appspotmail.com,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH 6.6] RDMA/rxe: Fix "trying to register non-static key in rxe_qp_do_cleanup" bug
Date: Mon,  8 Jun 2026 20:51:53 -0400
Message-ID: <20260608-stable-reply-0007@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260605165556.1082-1-vlad102nikolaev@gmail.com>
References: <20260605165556.1082-1-vlad102nikolaev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [PATCH 6.6] RDMA/rxe: Fix "trying to register non-static key in
> rxe_qp_do_cleanup" bug

Queued for 6.6, thanks.

--
Thanks,
Sasha
