Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B839117E469;
	Thu, 30 May 2024 11:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717070125; cv=none; b=H3utH3HjxLFAiSig9q9n9piswbyFl7DmxVJrEn6R7redP8URLwnzDUK00z3zFgx/JBCWpGlr3y/MJAFCT4DqOa4oFms8ObV85zf6Hz9UVT48Ez4zBnH+8WfLbJbyr6om0Z+OWZGPfkPvj3xiUhyN9DHrVdNtSBOqW/HXTnqZgA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717070125; c=relaxed/simple;
	bh=Opw8RaFJm5BcSRqVOUlh/M4jQ1cC47a2Jr1Nav7FFMc=;
	h=From:To:Cc:Subject:Date:Message-Id; b=RmkTc8Il+Lfoa7vaY9kA6ljvH1IE1NYMYP/iQyag4Zh/d1VTysp0bGQwHjctQyXJ3MYig7aTNn5tzJXePrnyAmpG/XPXHe2yZyuYoC6h8Cs/AnFRShMAA0CBdkCMT++sQa3MdYVJuHWvnAh8Ih8Rv/88aK/awwf+jqEHVLRQ3sA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=NKEayk30; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="NKEayk30"
Received: from linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net (linux.microsoft.com [13.77.154.182])
	by linux.microsoft.com (Postfix) with ESMTPSA id 3E70C20B915A;
	Thu, 30 May 2024 04:55:23 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3E70C20B915A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1717070123;
	bh=q9fgagC4Yf4H1eJaVbjrrK9BAWBS3+KdKEIrydPSsWI=;
	h=From:To:Cc:Subject:Date:From;
	b=NKEayk30hyrl4DIteVd0SHsA0zB1vHIAKg/buxjPWTaO8y0Z/tM7Ml+tzMn9jrUOu
	 GD/MX9l4dNHBXbuWX/xqIyoK1X8ZS8rv0g6MiJ/+I5diz6b8aRHlRyfjDKsFfI+hGx
	 1apgYiUx4A14fCEn84Y1xDlN/0Ggh9r8MYBJ9XtY=
From: Konstantin Taranov <kotaranov@linux.microsoft.com>
To: kotaranov@microsoft.com,
	sharmaajay@microsoft.com,
	longli@microsoft.com,
	jgg@ziepe.ca,
	leon@kernel.org
Cc: linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH rdma-next v2 0/2] Fill in capabilities and guid
Date: Thu, 30 May 2024 04:55:15 -0700
Message-Id: <1717070117-1234-1-git-send-email-kotaranov@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>

From: Konstantin Taranov <kotaranov@microsoft.com>

This patch series fills in GUID and device properties.
Most of these properties are required for CM.

v1->v2:
* Added a comment to the CA delay

Konstantin Taranov (2):
  RDMA/mana_ib: set node_guid
  RDMA/mana_ib: extend query device

 drivers/infiniband/hw/mana/device.c  |  2 ++
 drivers/infiniband/hw/mana/main.c    | 19 ++++++++++++++++---
 drivers/infiniband/hw/mana/mana_ib.h |  5 +++++
 3 files changed, 23 insertions(+), 3 deletions(-)

-- 
2.43.0

