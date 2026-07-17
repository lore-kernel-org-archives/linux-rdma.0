Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5C9033F394;
	Fri, 17 Jul 2026 19:17:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784315836; cv=none; b=SRjR2j7JnwOU+4BsMxPZLV192r5ryOnXW2tFYl1kD50vtLKxNu7869C7QwEPqPEpzIhacPTZluFczU6N+gvBnNCae8ORwhkAnHwq/9DuRN49uqS75rO16+1rHVhEncGJVdqn+huZMBAS0FmjHHLiDJ7+fKm2uXLpodyZBgfkz5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784315836; c=relaxed/simple;
	bh=bn1Kno6BkvOksLaRfMpUCI/1hnM+P4CBZmGNz0DBMmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZNTgGmDAzSipbCVe61+ACZ9ufryomPif/5ovh8nfsnIz4I/cDASzjyKHxgiBrdnl9tPiYbKEOKM5TkejRNT5cDqfKLU14KKin/mvwpiyWX5XHSujaMgk8IF3Z0uf2VYpuLEAre0mdqEhFqRGi2mr/pa9FpFG79R5T9nLJ7VN48o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=MtaqVU1S; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="MtaqVU1S"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 3C5AC20B7169; Fri, 17 Jul 2026 12:16:59 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3C5AC20B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1784315819;
	bh=8noSor8ENbecM5MBVrPc29AbSBhLcjSBzcq0dl0sadI=;
	h=From:To:Cc:Subject:Date:From;
	b=MtaqVU1SLyXOipgEkrHQLqKd1PDM0wKtfBQBBnauUe9VB6qHkQbU3snIXAvHgA8Ol
	 Rx6B3GGmFbVll2E0hGT8qWt1voJHEmcg6XIYX5/5AngjAho1qlS+3ryKmI2XjR8x2c
	 Lqe4njxBVh3Wcagwf+5hi7mlM9k/A9W/F6Noylok=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v4 0/2] RDMA/mana_ib: UC QP support
Date: Fri, 17 Jul 2026 12:16:57 -0700
Message-ID: <20260717191659.486802-1-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 2.43.7
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Konstantin Taranov <kotaranov@microsoft.com>

Implement UC QP creation in the RNIC HW for user API.

v4: renamed rc_qp destrot helper to rnic_qp. Use the latest robust udata API.
Unified QP lookup table to simplify code for inserting UC QPs.
That is why the changes were split into 2 patches. The first patch is about
the changes related to qp lookup/store.
v3: use new udata helpers
v2: removed udata check and removed enum from mana-abi.h

Signed-off-by: Konstantin Taranov <kotaranov@microsoft.com>

Konstantin Taranov (2):
  RDMA/mana_ib: unify QP lookup table
  RDMA/mana_ib: UC QP support for UAPI

 drivers/infiniband/hw/mana/main.c    |  49 ++++++++-
 drivers/infiniband/hw/mana/mana_ib.h |  83 +++++++++++++--
 drivers/infiniband/hw/mana/qp.c      | 154 +++++++++++++++++++--------
 include/uapi/rdma/mana-abi.h         |  11 ++
 4 files changed, 243 insertions(+), 54 deletions(-)

-- 
2.43.0

