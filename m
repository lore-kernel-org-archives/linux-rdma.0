Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC1E4418FF;
	Fri,  5 Jun 2026 19:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780688277; cv=none; b=XWqOpiOWuMbiKnPwvldPco5PVMm7KSkZEGbtvGNnJ8Qz/YJ+8dIlBzpbAVBv8UZ2+IZK6EhHot6oElrVo46JZLuYG/7uQXO7ra2eLCHVVC0o4waG2xaqpjL4oX+kuu1vczGf/3OBheyRSV8saUrSGdjQ7xyHRTih5reBx/QspII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780688277; c=relaxed/simple;
	bh=eBW079d2xQiXO+JShVeZcVB0hgdx4zjyQSCR20yGVoQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gRWGzppxj/pohzi0gf+A6ZImkHc83EjdPrMUgrak9QQ7q2T6xLFcPvIXB81GZK7LgRlmlCTa1ECI8jzowcsEpT3fWeGpOmD/zXA5lZwxCm3dNXtWj1QC8UX+UR9vHmRqX21w26eUQa8Jxoesn4Bozt0QHnQ7HauHX2pIU+kpMcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ctaS8MkM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ctaS8MkM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CAD1F00893;
	Fri,  5 Jun 2026 19:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780688276;
	bh=/a7G7f25H4cU1CNJKSOc5D3i5C8CEpdGKn/zi7RTUoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ctaS8MkMgpfBt0k5G6nPd/VnKQB7A3lEId/1+XWMoV0i7qFcBNRIoSNroKdKKteTp
	 g5bl0Bs5Zilk5Dce7yiYDKLyObqW4C7KbMZsJuKF/V+z7BExoUiIHil/9pH6o3oZEO
	 TIbR8e96yyI7QYDs0gA5a3Hx/WdbJqoCtMALJKDaO4Deoz4/kR+19Im+yBKF0QwgCc
	 BLbuGNwkzm/YbtK9ONk6SOF/0Q7j1ONdWTcyLA/dVP7ktSumwPdQzAwWThthA1ZjqG
	 QnbODrqiW0sLHiC+yS82/PbAcMDcVjktt+nwSWpHqcMmUGDlSlB+/IpVx73woHtirj
	 6MA41hakqiBdg==
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
	syzbot+cfcc1a3c85be15a40cba@syzkaller.appspotmail.com,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 5.10/5.15] RDMA/rxe: Fix the error "trying to register non-static key in rxe_cleanup_task"
Date: Fri,  5 Jun 2026 15:37:28 -0400
Message-ID: <20260605-stable-reply-0021@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260603121902.274-1-vlad102nikolaev@gmail.com>
References: <20260603121902.274-1-vlad102nikolaev@gmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> [PATCH v2 5.10/5.15] RDMA/rxe: Fix the error "trying to register non-static key in rxe_cleanup_task"

I'm dropping this for now; it isn't right for either branch as submitted:

 - 5.15.y: the bug doesn't exist there -- the task locks are already
   spin_lock_init()'d on the QP-create error path.
 - 5.10.y: mis-targeted -- it patches rxe_qp_do_cleanup(), but the 5.10
   error-unwind path doesn't call rxe_cleanup_task() there.

-- 
Thanks,
Sasha
