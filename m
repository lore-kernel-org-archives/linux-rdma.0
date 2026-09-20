Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 311233D45C5;
	Sun, 20 Sep 2026 05:15:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789881327; cv=none; b=hU6ItBAASCof89J0iMDglsFcnT2n8uirHSr1haCtqZeQAVedcxcQ4G9CmVv0+TUld+gdXi/vrEq8kK5geeuGwREuei1sTSx+o5TWVk4w/R5aFNW8XlRKjleEm7UKn6wzHamAG9JVn4DRusVM3qUHngecaH1hnB7H5SrilGn1V8M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789881327; c=relaxed/simple;
	bh=MgFuSzrlymSIh1PhO4LnZLnQGj8RUxEE2AgxjBLwXuw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YOCehiAfJ3A279DVraLCLif5usGYYjEwX6SmjP1lcBi9f1DGJjCG5jrA2Zp5QM7XlBui0RjmWFJv9gnqrjrOv6dO5pGwp6OqC5I7YMzmxjviNKG7QPU+F7vqJ9Z5vUBDHm3fyvcyyrS8tc/yazh3NfahqK69i1wG0zT6yQ6+AKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=AIT1ZyBK; arc=none smtp.client-ip=192.198.163.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="AIT1ZyBK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1789881325; x=1821417325;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=MgFuSzrlymSIh1PhO4LnZLnQGj8RUxEE2AgxjBLwXuw=;
  b=AIT1ZyBK3ckJqx1ITKgMkCjwqJ08tUuznSMxfEqI/tVsjJe0jb+iRaBO
   UfIUrcpez34ro9coBMkTuj4Lx1h4xACJ9BfE0BrvbMkI0xrrLxgXflexN
   fmXLRj0LVcY7/c6BkBshAT1dtnPyJ5sqFcf6R4gpjKMsZ5avLJt+74dDG
   mc7+H9M5Q/Z3ObPFQCM7yVj8D//jSZ+jx2g4hsIC5oOwr2hCeavNBJG+r
   WEootDdY+v2whOkxyxp4oNxfoQGs1gTVrhF+RudvkaNH2bAyZhEXh1/Mg
   U6xEt6/xmQGCgcMfiEkG06Kc5Wz5yrqqUYjLltFIo2VdzdkHgPfDtsqrM
   w==;
X-CSE-ConnectionGUID: oT6udkGKTWm65zXXFfm8Gw==
X-CSE-MsgGUID: 2m53wY6DRxCS7TuicsErmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11910"; a="90406175"
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="90406175"
Received: from fmviesa009.fm.intel.com ([10.60.135.149])
  by fmvoesa108.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2026 22:14:12 -0700
X-CSE-ConnectionGUID: cJuKhlKTSKSIX2DbLE24dw==
X-CSE-MsgGUID: yWrJdF7nTImNaUyJZKHWig==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,111,1787036400"; 
   d="scan'208";a="268706652"
Received: from junjie-desk-dev.bj.intel.com ([10.238.152.71])
  by fmviesa009-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Sep 2026 22:14:09 -0700
From: Junjie Cao <junjie.cao@intel.com>
To: stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org,
	sashal@kernel.org,
	guangguan.wang@linux.alibaba.com,
	alibuda@linux.alibaba.com,
	dust.li@linux.alibaba.com,
	sidraya@linux.ibm.com,
	mjambigi@linux.ibm.com,
	tonylu@linux.alibaba.com,
	guwen@linux.alibaba.com,
	linux-rdma@vger.kernel.org,
	linux-s390@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 5.10.y 0/2] net/smc: bound v2 extension offsets and counts in CLC proposal
Date: Sun, 20 Sep 2026 13:14:01 +0800
Message-ID: <20260920051403.712116-1-junjie.cao@intel.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10.y backport of the CVE-2024-49568 fix (patch 2), requested in the
6.1.y thread:
https://lore.kernel.org/r/20260918045353.686837-1-junjie.cao@intel.com

5.10.y also lacks 9ab332deb671 (CVE-2024-47408) from the same upstream
series; 5.15.y has it since v5.15.176. It goes first: the ism_gid_cnt
limit in patch 2 bounds the gidchid[] walk only once smcd_v2_ext
itself is inside the receive buffer. The diff is the same as the
5.15.y backport a36364d8d4fab.

Patch 2 has the same diff as the 5.15.y backport posted alongside.

Each commit builds net/smc on v5.10.270, x86_64, CONFIG_SMC=m, W=1
clean. Not runtime-tested.

Guangguan Wang (2):
  net/smc: check smcd_v2_ext_offset when receiving proposal msg
  net/smc: check v2_ext_offset/eid_cnt/ism_gid_cnt when receiving
    proposal msg

 net/smc/smc_clc.c |  8 +++++++-
 net/smc/smc_clc.h | 17 +++++++++++++++--
 2 files changed, 22 insertions(+), 3 deletions(-)

-- 
2.43.0

