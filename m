Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F19F22BE03C;
	Fri,  7 Aug 2026 13:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786110725; cv=none; b=LOQL2LCcJbuofMBCMs+RVAjuqmTisKVKXAqjOZfuvqrFUS9TEPraM9gXs4XskvSu4/FeGineoJ54PpxSE/XhWgrkM0cDxWi/Y7HmVqvvYVLCIgwuXMaMdeP2RexVK6x+zZZCCrxy8kBp9uM8mqLUkZ95wZAFlh+sFo+IG/gS3BE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786110725; c=relaxed/simple;
	bh=OwGyqadSmMaTDofY1u6qcolJZJFg+whpL+G3/QTADZM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=GxazjPQm/MaP/bkBBUIaES6EJzNwwVizC5zVte4WYLv7gqmuJsiX6hMONRhdUJVAiIwU1dYM4/kAZMrn/umXwlUoKO9sEEx4yDO0pKdoKg6R+Aq1EmY/kHd7v5rviZ5T+vinF01xN5npaz7oW4I1mV1NkwSQFT3MvbNPsg7NGVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=P/yPDon6; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="P/yPDon6"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 5B88A20B710C; Fri,  7 Aug 2026 06:51:32 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5B88A20B710C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1786110692;
	bh=n7UO/3qV3+mu+texSTUFZQVE2N/xPwF6nm+Q0bqciqQ=;
	h=From:To:Cc:Subject:Date:From;
	b=P/yPDon6AFNzDnmedzWCBOJxazsqn3lEXDyawdvT6No5In1uKfheyHCxtc3sDdXtO
	 9y7KtziEy7KnxXSwlhhGIUoJSkZixfT7YVmMjDcuaXZ+vTEWyqeJwHGzqOj/AzLnrI
	 DjTekPvN5bWC8+8mORZuPnvHJpfM5G6zNzrCIG3w=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next 0/3] RDMA/mana_ib: Extend MANA RC QP support for UAPI
Date: Fri,  7 Aug 2026 06:51:29 -0700
Message-ID: <20260807135132.1618382-1-kotaranov@linux.microsoft.com>
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

