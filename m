Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF94641D131;
	Thu, 23 Jul 2026 12:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784808011; cv=none; b=s2TBOikzy6qAPxnRj3th7XveF9TqXf2Xc2XFi6w1UDUXAUWJQ+5ZG955cv6Y0GspyA/UV2E+gzNqYSz10gKhKthVFHuGnDzXXETyFSHUYyjVZc00KxIunaaBtJLvOnym+fVxuvphlgiaW21szAr9VlOH3mtuCR8fZVXZFcmmSfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784808011; c=relaxed/simple;
	bh=7EeDOvJAByeL2vw+smA5VikLw3E+ej/k41tqDREyFx0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r4OOa3hP83011/PtLCJikB/HJHWNgRN9ER6rfVe3J0S2AHzM07rcLNihwc2xphJVvOPaGcEV8PZHw/hi7NaUPUHdLPNKlh2DwAYDmkH1A3IkxbmDTvJX6hMTUJeUyGRpMeLdrORdUu1k85xY3UUFswcgplMTw+Vn6bNb5CxsRiw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=VtiIZ5Ea; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="VtiIZ5Ea"
Received: by linux.microsoft.com (Postfix, from userid 1186)
	id 58A5920B7167; Thu, 23 Jul 2026 04:59:55 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 58A5920B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1784807995;
	bh=/OHvD5UjbMXmv64Wadqf++kWS2uPCLz9JmgnjzU2mjg=;
	h=From:To:Cc:Subject:Date:From;
	b=VtiIZ5EapA/MSnpFxgPQFD00XAp93yUyqjIxezsdsSRyvuYUHVxKNW/PUtDCOoThp
	 KhEvNopbbF+FnEhclvUSl/QPiPvgAZXfeOPxHdY0FNLZV0DSqAlI+DtvanX4MX3G4a
	 uy/Yi9xQfhdgCVTM9+mA9yPC8D/FEC+bKrAF4nV4=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v5 0/2] RDMA/mana_ib: UC QP support
Date: Thu, 23 Jul 2026 04:59:53 -0700
Message-ID: <20260723115955.1859519-1-kotaranov@linux.microsoft.com>
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

v5: revised 1/2 to incorporate the drain fix from Leon
v4: renamed rc_qp destroy helper to rnic_qp. Use the latest robust udata API.
Unified QP lookup table to simplify code for inserting UC QPs.
That is why the changes were split into 2 patches. The first patch is about
the changes related to qp lookup/store.
v3: use new udata helpers
v2: removed udata check and removed enum from mana-abi.h

Konstantin Taranov (2):
  RDMA/mana_ib: unify QP lookup table
  RDMA/mana_ib: UC QP support for UAPI

 drivers/infiniband/hw/mana/main.c    |  49 +++++++-
 drivers/infiniband/hw/mana/mana_ib.h |  83 +++++++++++-
 drivers/infiniband/hw/mana/qp.c      | 181 ++++++++++++++++++---------
 include/uapi/rdma/mana-abi.h         |  11 ++
 4 files changed, 255 insertions(+), 69 deletions(-)

-- 
2.43.0

