Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE4021339A4;
	Fri, 23 Jan 2026 08:23:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769156639; cv=none; b=r2Zqq4ouoeduUB5kV1bvwBGntdPJ3AfUU+vwPtN225X4PEsbj5bLqFM+L+g26w0PQ0WsrX6KI+nz27QhifsVlpUw09WTZOAjMJ9rgHxNzkdo6LBvVb5Vrqm9LhnA2eNsHqTS3WAEdQLc/y18tGTlGnjbeYX4F3BDT2qyXLG1RpE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769156639; c=relaxed/simple;
	bh=DQcH0PY7/R5XnOeYcpOzF2IC3lFMXoE8qT45X2llzOk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=qDgD3o3rBCeaJ//PgEc77TTlDO6ImxT0T4atOP8sCyKQ5lRqPglj9ygN3qTbOQDkp8D085DvY50OoD4kN0/mZplw7yRLUHC5nQEhjidxRi0/8sdyLnYK0zRl7N/hfnjrnY5eDxME9Ul+XygofFcMPiyCxV+DLuq1BvWm0x1noPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=dfqcbpFR; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="dfqcbpFR"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1769156634; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=+ToaMMw996GZ44VRILSBmrGyDdta+DK0o/5glqE5fFI=;
	b=dfqcbpFRmTGUsmBbhURHsT/QeIBx9digLSUzZHXsQoj84cyPb+iCd+hrOjfojlSWmJPH6Y205f96ZLCjjslS2spBlTRLzQpqn336AEGPxR8LttsYpS2yrtSA4jRlw3ZrM+xp4fALuqMDGOLJ5KBEhRbC1RnrkTuZMHRrfNQK6B4=
Received: from j66a10360.sqa.eu95.tbsite.net(mailfrom:alibuda@linux.alibaba.com fp:SMTPD_---0Wxf8oqi_1769156629 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 23 Jan 2026 16:23:53 +0800
From: "D. Wythe" <alibuda@linux.alibaba.com>
To: "David S. Miller" <davem@davemloft.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dust Li <dust.li@linux.alibaba.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Sidraya Jayagond <sidraya@linux.ibm.com>,
	Uladzislau Rezki <urezki@gmail.com>,
	Wenjia Zhang <wenjia@linux.ibm.com>
Cc: Mahanta Jambigi <mjambigi@linux.ibm.com>,
	Simon Horman <horms@kernel.org>,
	Tony Lu <tonylu@linux.alibaba.com>,
	Wen Gu <guwen@linux.alibaba.com>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org,
	oliver.yang@linux.alibaba.com
Subject: [PATCH net-next 0/3] net/smc: buffer allocation and registration improvements
Date: Fri, 23 Jan 2026 16:23:46 +0800
Message-ID: <20260123082349.42663-1-alibuda@linux.alibaba.com>
X-Mailer: git-send-email 2.45.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This series improves SMC-R buffer management by refining the allocation
logic and reducing hardware resource overhead during registration. 

The primary improvement is the significant reduction in MTTE consumption.
By aligning IB registration with the actual physical block sizes, we can
reduce the entry count from one per 4KB page to just one per contiguous
block. This is especially beneficial for large buffers, preventing
hardware resource exhaustion on RDMA NICs.

D. Wythe (3):
  net/smc: cap allocation order for SMC-R physically contiguous buffers
  mm: vmalloc: export find_vm_area()
  net/smc: optimize MTTE consumption for SMC-R buffers

 mm/vmalloc.c       |  1 +
 net/smc/smc_core.c | 31 ++++++++++++++++++-------------
 net/smc/smc_ib.c   | 23 ++++++++++++++++++++---
 3 files changed, 39 insertions(+), 16 deletions(-)

-- 
2.45.0

