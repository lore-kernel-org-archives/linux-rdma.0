Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296F925A642
	for <linux-rdma@vger.kernel.org>; Wed, 29 Apr 2026 15:08:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777475319; cv=none; b=ZxCLQA7DhWeK5Y8/iQK6dNFuv47ATiSb0t+UiJpg5AcQY7h33pGOrPRa7mpPfCWNuZReQVq9zMXzrVnbqNas5mw09qT3GwXqObSgS9AKzwv+9G16bRu1CsHEnk1k74S4JYbfFt0Ye9aqV+I6qmd8Z8yqReKC9wtiILiE7WT4zRc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777475319; c=relaxed/simple;
	bh=kQGgil5UtMbQLmT0vDByEJyWHWYRQNQUc/bdOI23AVc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pE13MDsDxm8OnHR2wXNn5Lr9MfgyQJIGqfTtfUUMMRvkhLLc530+7soPUgBUFDR3sM30XcWqV6kEk/GOUyRd5zKTubeyNa6olZ+in8jIxF2iXHqUVpjPB80vRISZ6kGYjBYpbGW9pD7T0gtX03JpimNIITip/eeo7DuJpJSkCek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SQzotiOF; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SQzotiOF"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1777475317;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=jmgVAR52adSNZivpuFC5mZuvwbrYOguZpZ/j6Z7n8jU=;
	b=SQzotiOFbyoR96F6hBUXyE7bF773TKia5N53iY8EH6JyOCWg9HTgk7KERCbLuW/dmVRJda
	OSUAr/4YzJhPocxeLAyD17+0QV0bzfW4uwx3FQxXiU5+N+XtJNHNDl2fsnLTLULMJBqHG6
	gojMgLjcEfThGP6q6abQ+cX+5B4CarU=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-302-6tO-l2hcN0OUXDVHlhOFqQ-1; Wed,
 29 Apr 2026 11:08:32 -0400
X-MC-Unique: 6tO-l2hcN0OUXDVHlhOFqQ-1
X-Mimecast-MFC-AGG-ID: 6tO-l2hcN0OUXDVHlhOFqQ_1777475307
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 047E71955F0B;
	Wed, 29 Apr 2026 15:08:26 +0000 (UTC)
Received: from p16v.redhat.com (unknown [10.44.49.234])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 01D8319560B6;
	Wed, 29 Apr 2026 15:08:18 +0000 (UTC)
From: Ivan Vecera <ivecera@redhat.com>
To: netdev@vger.kernel.org
Cc: Andrew Lunn <andrew+netdev@lunn.ch>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
	"David S. Miller" <davem@davemloft.net>,
	Donald Hunter <donald.hunter@gmail.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jiri Pirko <jiri@resnulli.us>,
	Jonathan Corbet <corbet@lwn.net>,
	Leon Romanovsky <leon@kernel.org>,
	Mark Bloch <mbloch@nvidia.com>,
	Michal Schmidt <mschmidt@redhat.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Pasi Vaananen <pvaanane@redhat.com>,
	Petr Oros <poros@redhat.com>,
	Prathosh Satish <Prathosh.Satish@microchip.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Simon Horman <horms@kernel.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: [PATCH net-next 0/2] dpll: rework fractional frequency offset reporting
Date: Wed, 29 Apr 2026 17:08:15 +0200
Message-ID: <20260429150817.3059763-1-ivecera@redhat.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

Rework how the fractional frequency offset (FFO) is reported in
the DPLL subsystem.

The fractional-frequency-offset-ppt attribute is moved from the
top-level pin attributes into the pin-parent-device nested attribute
set. This makes it consistent with phase-offset (which is already
per-parent) and clarifies that FFO PPT represents the frequency
difference between a pin and its parent DPLL device.

The two FFO contexts are distinguished in the ffo_get callback:
dpll=NULL for the top-level RX vs TX symbol rate offset and a valid
dpll pointer for the nested pin vs DPLL offset.

Patch 1 restructures the DPLL subsystem netlink handling, updates
the YAML spec and driver-api documentation, and adds NULL guards
to mlx5 and zl3073x drivers.

Patch 2 implements the nested FFO for zl3073x using the
dpll_df_offset_x register with ref_ofst=1, providing 2^-48
resolution. The old per-reference frequency measurement is removed
as it was redundant with measured-frequency.

Ivan Vecera (2):
  dpll: move fractional-frequency-offset-ppt under pin-parent-device
  dpll: zl3073x: report FFO as DPLL vs input reference offset

 Documentation/driver-api/dpll.rst             | 16 +++++++
 Documentation/netlink/specs/dpll.yaml         | 11 +++--
 drivers/dpll/dpll_netlink.c                   | 34 ++++++++++----
 drivers/dpll/dpll_nl.c                        |  1 +
 drivers/dpll/zl3073x/chan.c                   | 31 ++++++++++++-
 drivers/dpll/zl3073x/chan.h                   | 14 ++++++
 drivers/dpll/zl3073x/core.c                   | 45 -------------------
 drivers/dpll/zl3073x/dpll.c                   | 34 +++++++-------
 drivers/dpll/zl3073x/ref.h                    | 14 ------
 drivers/dpll/zl3073x/regs.h                   | 15 +++++++
 .../net/ethernet/mellanox/mlx5/core/dpll.c    |  4 ++
 11 files changed, 126 insertions(+), 93 deletions(-)


-- 
2.53.0

