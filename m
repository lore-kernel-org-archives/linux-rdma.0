Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C05F438494;
	Thu, 27 Aug 2026 14:38:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787841500; cv=none; b=uREhPTpRkfsR9lAuSKjHfGQ9ntLBisa6yyDx0WMn7WOSHmfnYcQNRQobNxIAStbgDLGPZ2s5CJZmIVkFx5OHZoRDFMS0pGw2D14909h9JdHRDUdBSkUfKMpszhyV+7uxsrljbb68PWwakuL7LC67hp63UTYqAQbx/mtU8UdJiws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787841500; c=relaxed/simple;
	bh=67JM7CSmfp8pCNgVOKCOSwmMZ+5FHRn+Iwc+gfzW/qE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=D0b2j4sB7ZSrwDlgYPg3lz27rDm2nbBNZSMZo5VdbvmUpPuZkN1XxB9il/xymAuLRNTiQGucNF/4qa2Pf6uriasBHcU9HmYu0IY0o1s8Np/UrhSiIHpzbkT0g8IDJy64k59j6Upo1Us0Y9ZdFftuWrTWS+M0uqRXkqR9UirpgVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=gF0PHFVt; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="gF0PHFVt"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 9450020B7167; Thu, 27 Aug 2026 07:37:36 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9450020B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1787841456;
	bh=84GJovZsbPEJDLR9c578M0gGOROYQJ11UOGr2S44k20=;
	h=From:To:Cc:Subject:Date:From;
	b=gF0PHFVtLuyxUUuPAK82/JTjN5p0Xg1UCenySF01nMCLfyqEFO8MgSoryTdsDArdS
	 nck2/dJGtDfmeiXb/CTexdQdzDT+YRGo2s05lRJTs19Q3Dp40oaxAaL40IdXZ3OzCr
	 p0T4lwJBT4JfN3ep6ZJdXNkBvYb/M1cfTy+D9NII=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	snsanghvi@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v2 0/3] RDMA/mana_ib: Extend MANA RC QP support for UAPI
Date: Thu, 27 Aug 2026 07:37:33 -0700
Message-ID: <20260827143736.2013093-1-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Extend MANA RC QP support with an updated userspace ABI and optional MMQ
and fixed-size send WQE features.

The series first extends the RC QP creation request and response while
preserving compatibility with existing userspace. It then allows
userspace to create an MMQ and receive its queue ID. Finally, it adds
fixed-size send WQE support, including MSN-in-WQE when supported by the
adapter.

Existing applications continue to use RC QPs without these optional
features.

v1->v2: use << instead of BIT() in the mana-abi.h

Konstantin Taranov (3):
  RDMA/mana_ib: Extend RC QP udata request and response
  RDMA/mana_ib: MMQ creation for RC QPs
  RDMA/mana_ib: fixed send wqe size support for RC QPs

 drivers/infiniband/hw/mana/main.c    |  4 +++
 drivers/infiniband/hw/mana/mana_ib.h | 11 ++++++--
 drivers/infiniband/hw/mana/qp.c      | 42 +++++++++++++++++++++-------
 include/net/mana/gdma.h              |  1 +
 include/uapi/rdma/mana-abi.h         | 11 ++++++++
 5 files changed, 56 insertions(+), 13 deletions(-)

-- 
2.43.0

