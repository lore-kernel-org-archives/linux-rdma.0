Received: from aer-iport-8.cisco.com (aer-iport-8.cisco.com [173.38.203.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76873AA4F6;
	Fri, 21 Aug 2026 21:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.38.203.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787348329; cv=none; b=K6KloNoiLhqtPfy2pKa4Vw4yhwQBo0TX/xKMzhhMCu99YlhSYhogSvbUQMzuKPkVoKOypsYtlzvwZ+Bz2pf4FZSJw5gCz2tLj7eAFXAvf2ZIZYHeaIcHWbscV9NFzfncGMeCSZ62RjC2jT3EVQPtL8SitfDbeS39pJgxl3xXKC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787348329; c=relaxed/simple;
	bh=Gc/7lBy3gbT7mQGnUkK/8rD2GP7clWUe59xDWl8TZvw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tVKfr9URCqErmdxEBdnL5ZzYPH96kGOgw98Al9ni+dm8WFeJQlgaJvCuBIpWi3t6+X/44hNHS8QHx4hWC0KmvQhxIt722NSRw20E1cgTG27SCp77FOijPE9G1aXUuNrkrjd0xnQOB3o+XfbOZ0u2/PPGWrDDDFi51bc8qyT/JAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=kqtsx3Ez; arc=none smtp.client-ip=173.38.203.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="kqtsx3Ez"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=1113; q=dns/txt;
  s=iport01; t=1787348327; x=1788557927;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=SXWUYgWL4b+Bz3+W8zIynJxlan1c5WkPCLgXTDERme0=;
  b=kqtsx3Ezla5B0/LJmJSAGS3Je+DTWz5Uj32glcoT+lwmMu5F9QyNwAdZ
   muRyPqVfTcpkenQaYjo9G7lxzo6xLoOQmRqFZH9Yymgt9y4zo/glpHe84
   8IdYRJ+8t08IER6o+pPpZBC1r7YZd5wWupiO8Lh9/6PA3MwGpDkMiQZbA
   k3zh1cffOLH0oUQKYgLyASnoF872u4WQAe5BZcY5LR3vcr7kpDrPnSsFr
   Rd4hbTXZ9vbWkN5MFjG0NzFjT5BlfIea3jSZyzk3RA6Wrrp3vmJx2mkQ9
   20JE6iLFhty15SLBab1+Zf5SNt8N67jnTeFsMek6/y8BilYcb9Wp6aIqS
   Q==;
X-CSE-ConnectionGUID: 165d0COrSfayiv4oN5CASw==
X-CSE-MsgGUID: /om3+WFNSpumQ0CO/Qsz9A==
X-IPAS-Result: =?us-ascii?q?A0BkAwCGw4hq/9RK/pBaglmDS15DSQSUJYIhkiuLcxSBa?=
 =?us-ascii?q?g8BAQEPRA0EAQGFBQKNbAImNAkOAQIEAwIDAQEBAQEBAQEBAQELAQEFAQEBA?=
 =?us-ascii?q?gEHBYEOE4ZPDYZbAgEDMgFGEFFWGYMCAYJ0AxHBRYIsgQHeR4FsBhWBOI1hd?=
 =?us-ascii?q?oR8JxuBSUSECAdvhCpmhXgEgxwSk1dIgR4DWSwBVRMNCgsHBYFmAzUSKhUyP?=
 =?us-ascii?q?DIdgSM+F4ENGwYFgR2BKIQQIxk2eoEJXoErKWABEheBCYIHAoJaggUCAUlDD?=
 =?us-ascii?q?gdIIgsYDUgRLDcUGQQ+bgeOXh+CGDWBDgoigUNQAZZ6sCOEKIwilVMBM5dfk?=
 =?us-ascii?q?w2ZCI4KmzmBaDyBWTMaCBsVgyMSQBkPlzbHCEU0AToBAQcCBw4DC4FokX4BA?=
 =?us-ascii?q?Q?=
IronPort-Data: A9a23:wT7+P6DgGLLL5RVW/xnjw5YqxClBgxIJ4kV8jS/XYbTApDsl1zJUn
 zcfWG7QPP7fZzb0KIh/YIrj9B4EvMTUxtdmOVdlrnsFo1CmBibm6XV1Cm+qYkt+++WaFBoPA
 /02M4eGdIZvCCeA+n9BC5C5xVFkz6aEW7HgP+DNPyF1VGdMRTwo4f5Zs7ZRbrVA357jXmthh
 fuo+5eBYA//gmYtWo4pw/vrRC1H7ayaVAww5jTSVdgT1HfCmn8cCo4oJK3ZBxPQXolOE+emc
 P3Ixbe/83mx109F5gSNy+uTnuUiG9Y+DCDW4pZkc/HKbitq+kTe5p0G2M80Mi+7vdkmc+dZk
 72hvbToIesg0zaldO41C3G0GAkmVUFKFSOuzXWX6aSuI0P6n3TEmqszABkdGpcj9O9mAH8S8
 tpFAxk2cUXW7w626OrTpuhEj8k5ac2uN4QFtzQ5lHfSDO0tRtbIRKCiCd1whWtswJoTQbCBO
 4xDMGAHgBfoO3WjPn8VFJU6mOq0rnL+aDZf7lmSoMLb5kCOk1UsjOGzbLI5fPTNQsAO3Xm2g
 Fne4mHAWjo9c+WE22uspyfEaujn2HmTtJgpPLGx6PNvqFGa2GEWDBoYSR29rOXRolWyVfpRL
 EkV8Sojs+43+SSDTN79WVu2qWWYtxQRXdZ4HOgz6QXLwa3Riy6UCnUBRyxMdPQps8g5QTFs3
 ViM9/vlDDpuvbm9SHWS+76OpzSify4YMQcqbDQYZQgI+d/upMc0lB2nZtZqD62djdDvHzz0h
 TeQo0AWhKgZhOYI2r+98FSBhCijzrDASAIv6xqUWG+54g5nTIq4YYru4lizxfpcJZqESlSIl
 H4amsSf5aYFCpTlvCiAR+MXG5mv+feJMTSaillqd7Ek/TCq8H6Le55R7DB3YkxuN64sYjbkb
 UPWkQVP5ZNSNT2haqofS564EcUz0YDmC9XpV/mSZd1LCrBpfQWK+iBGf0Oc32nx1kMrlMkXM
 4+VWdijAGxcCql9yjeyAeAH3tcDwiE42HOWRp3hyRmj+aSRaWTTSrofNlaKKOcj48uspATT7
 sYaLcePwj1BX+DkJCra64geKRYNN3dTLZb7t8BaaMadLQd8XmIsEfncxfUmYYMNokhOvu7F5
 DS5H0Rf0le63CSBIgSRYXclY7TqNXpikU8G0eUXFQ7A8xAejUyHtc/zq7NfkWEbydFe
IronPort-HdrOrdr: A9a23:KFXrpK8fA3hHLipmZOtuk+D4I+orL9Y04lQ7vn2ZhyY4TiX+rb
 HLoB1173HJYVoqMk3I3OrwW5VoIkmskKKdg7NxAV7KZmCP01dAbrsSj7cKqAeOJ8SRzINgPN
 9bE5RWOZnXEUVwi9r87U2TFtYtx8TCzYWT7N2uqEuEiWpRGthdB8ATMHf8LnFL
X-Talos-CUID: 9a23:8abEt2z7Q51H4VrCUpfZBgVNRJ0pKlb61kzeKl65FzpubuC+YGSPrfY=
X-Talos-MUID: 9a23:VV4+zwbY3Qcan+BT8Djp33JdGuFT+7mrMRgmttI/oNvVHHkl
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,235,1779148800"; 
   d="scan'208";a="57154164"
Received: from aer-l-core-11.cisco.com ([144.254.74.212])
  by aer-iport-8.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 21 Aug 2026 21:37:33 +0000
Received: from localhost (unknown [10.189.108.235])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aer-l-core-11.cisco.com (Postfix) with ESMTPS id 17E93180001C5;
	Fri, 21 Aug 2026 21:37:33 +0000 (GMT)
From: Jerome Tollet <jtollet@cisco.com>
To: netdev@vger.kernel.org
Cc: saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	leonro@nvidia.com,
	dtatulea@nvidia.com,
	daniel@iogearbox.net,
	andrew+netdev@lunn.ch,
	davem@davemloft.net,
	edumazet@google.com,
	kuba@kernel.org,
	pabeni@redhat.com,
	ast@kernel.org,
	hawk@kernel.org,
	john.fastabend@gmail.com,
	sdf@fomichev.me,
	linux-rdma@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	bpf@vger.kernel.org
Subject: [PATCH net v3 0/2] net/mlx5e: Prevent stale XSK buffer release on refill retries
Date: Fri, 21 Aug 2026 23:37:30 +0200
Message-ID: <cover.1787347981.git.jtollet@cisco.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820151558.11015-1-jtollet@cisco.com>
References: <20260820151558.11015-1-jtollet@cisco.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.189.108.235];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.189.108.235, [10.189.108.235]
X-Outbound-Node: aer-l-core-11.cisco.com

Prevent duplicate XSK buffer release when a deferred RX refill fails and
the same WQE is retried.

Patch 1 fixes legacy cyclic RQ. It is unchanged from v2 and retains
Dragos' Reviewed-by tag.

Patch 2 fixes the analogous striding-RQ MPWQE path pointed out by the
Sashiko automated review. Targeted fault injection forced three
consecutive allocation failures for one MPWQE. Stock freed the same 16
XSK buffer pointers three times; the fix freed each pointer only once,
made subsequent releases no-ops, and preserved the successful
allocation path's bitmap reset.

Changes in v3:
- Turn the submission into a two-patch series.
- Add the striding-RQ MPWQE fix and its dedicated Fixes tag.
- Rebase onto net/main at 4e15e89faac9.

v2: https://lore.kernel.org/netdev/20260820151558.11015-1-jtollet@cisco.com/

Jerome Tollet (2):
  net/mlx5e: Prevent stale XSK buffer release on refill retry
  net/mlx5e: Prevent stale XSK buffer release on MPWQE refill retry

 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

-- 
2.55.0
