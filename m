Received: from aer-iport-7.cisco.com (aer-iport-7.cisco.com [173.38.203.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9C60382388;
	Mon, 24 Aug 2026 19:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=173.38.203.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787599228; cv=none; b=VZCKraWDZT5BNl7eU1SIDSDM+d2B5eYUuBilKR3rthCUy+mL+rssNujIRFMcyZzMPoG2suxTjfdNXE49jgnJxxvhcTkunAj9E6ANgd9YghZ0dMibJ6ZBZom+4MitIMqEALYSMHbUhKpvamsl9jO9XaDN+weepnKJbFtWrRTEdYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787599228; c=relaxed/simple;
	bh=ddIZjjhFHL2Gwf8ToRYLMwIPyRz+Y7EsI1A9KAVtV20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tFRnc4vsqCE3xxWuReRh8VO+Q+yFg7/4sAw+PmQg7eITZtc1MKKEfIoi3cNqKjXPEyL9DLSEntfrznEhSwNmfxtQlV3J5JRWgsfzLZ/wofOqg1xnZQfmdHKUWge+NWEjt/rPHCtrB80AZADlzJ+3B1dkKrpi37ug+/sLFs8bWxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com; spf=pass smtp.mailfrom=cisco.com; dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b=Rj2GVR4S; arc=none smtp.client-ip=173.38.203.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=cisco.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cisco.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cisco.com header.i=@cisco.com header.b="Rj2GVR4S"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=cisco.com; i=@cisco.com; l=101; q=dns/txt;
  s=iport01; t=1787599226; x=1788808826;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ddIZjjhFHL2Gwf8ToRYLMwIPyRz+Y7EsI1A9KAVtV20=;
  b=Rj2GVR4S33zSeGVTHsfVuCwE6Tdt1SleCGq6ZRGgmAgZgpuJZ8skvoKi
   uSplpzN7VrLRlEP7TmvtOQrNvwbWoT7OiOep/8KjDkhvImMzQ5v3HELvh
   b7HqgclgbBZFMABtqgRCoMJUIFHX/eZMqsze7lNA4dN1OGJ/ViVb0yoj3
   xIM3PtOjYscAjlC7t1AvRbesgYm0V+B0LwadNN/dLVW+qB8r6iyn84qgF
   cyFj066SqKMHphGwNuwzTjygmcmEvCvWzuyHOQUOIp3OcO5ITe16SKJb0
   GsxJmXVjqwb1qQlgz9KhlSFtPx9eNvmr+51+SLU5/evgtyJa660LEKj3c
   A==;
X-CSE-ConnectionGUID: lFJ5jWrzSGiJtG9kOKDp6A==
X-CSE-MsgGUID: qRNzCayMTw+PH41TWYnedQ==
X-IPAS-Result: =?us-ascii?q?A0BhAwCkmIxq/9BK/pBaglmEKUOFII9SoD+Bfg8BAQEPU?=
 =?us-ascii?q?QQBAYFRAYMpAQkCjWwCJjQJDgECBAMCAwEBAQEBAQEBAQEBCwEBBQEBAQIBB?=
 =?us-ascii?q?wWBDhOGXIZbAgEDIw8BRhALDgwCJgICVgaDFYJ1A75heoEygQHeR4FyFYEKL?=
 =?us-ascii?q?oheAYUCdoR8JxuBSUSEDzE+iB6CagSCIoEMk1VICngcA1ksAVUTDQoLBwWBI?=
 =?us-ascii?q?0MDNRIqFSMPPAUtHYEjIR0XFx5YGwYFEiAqQUQVDgM+gRlBAoF1PyMZNnyBC?=
 =?us-ascii?q?V6BKylgAQIQF0YuFYIHAoJagSdeAgFJQw4HRyILGA1IESw3FBkEPQFuB5JDg?=
 =?us-ascii?q?gJQlnuwI4QooVwaM4NxAZNtkw2ZCKlDgWg8gVkzGggbFYMjUhkPjl/PX0VvA?=
 =?us-ascii?q?QEHAgcOAwuBaJF+AQE?=
IronPort-Data: A9a23:J35rGq93mDPtsxOyxz2ZDrUDSH6TJUtcMsCJ2f8bNWPcYEJGY0x3x
 mpKCGGEM/beajegc99wPo/loU5UsZ6Bn4RgHQdvrSlEQiMRo6IpJzg2wmQcns+2BpeeJK6yx
 5xGMrEsFOhtEDmE4EzrauS9xZVF/fngbqLmD+LZMTxGSwZhSSMw4TpugOdRbrRA2bBVOCvT/
 4mvyyHjEAX9gWAsYjhIs/jrRC5H5ZwehhtJ5jTSWtgT1LPuvyF9JI4SI6i3M0z5TuF8dsamR
 /zOxa2O5WjQ+REgELuNyt4XpWVTH9Y+lSDX4pZnc/DKbipq/0Te4Y5nXBYoUnq7vh3S9zxHJ
 HqhgrTrIeshFvWkdO3wyHC0GQkmVUFN0OevzXRSLaV/wmWeG0YAzcmCA2kyE69F+NltE1ph9
 N4EB2EOSTOvn7yflefTpulE3qzPLeHiMZlavjRryivUSK55B5vCWK7No9Rf2V/chOgXQaqYP
 ZdFL2UzKk6YM3WjOX9PYH46tOW0gX37fiFwo1OOrq1x6G/WpOB0+Oa1bISPIoHXLSlTtl+ig
 HDt9nXcPg5ZDPzDkAa6w3ShitaayEsXX6pXTtVU7MVCjFSNy2k7BBQIWF6/pvelzEizR7p3M
 EAa0iQpqKk59EG1CNzwNzW6p36C+BAVQMZZGeA85CmCz6PV50CSAW1sZjNNddkvpsIqbTMt0
 VCNkpXiAjkHmLGcT3OQ8p+Vqjy/MDIfKn9EYyIYJSMM+MXLo4wpiB/LCNF5H8adjtTqGhnzz
 iqMoSx4gK8c5eYIyq+y1VPKmTShot7OVAFdzgzRUnio8UB/aZKpapKA7UXd67BLLO6xQkWIo
 GUAlsG26v4PAZCE0ieKRY0lGLyu4eyCGDvCgFJuFt8q8DHF03upeYdb4Bl4OkZlM89CcjjsC
 GfIsA5c6Jp7OmWrYa5+JYm2DqwC0aH6FM35fvbKb9ZPa956cwrv1Dlnb0OW3kj3nUQsmL15M
 pCeGe6mFXgyF6tq1ny1Sv0b3LttwToxrUvXRJbm31Gk3KCYaXq9V7gIKh2NY/o/4afCpx/am
 /5bNs2X21BFXOj3SjfY/JRVLl0QK3U/Q5fspKR/cOOfLgd4MH8uBuWXwr47fYFh2aNPmY/g5
 W20UEtV4ETwiGeBKgiQbH1nLrT1Uv5CQWkTNCE2eFLt0H85bMP3s+EUdoA8ev8s8+kLIeNIc
 sTpsv6oWpxnIgkrMRxEBXUhhOSOrCiWuD8=
IronPort-HdrOrdr: A9a23:lP6cyqALdPhTalvlHemK55DYdb4zR+YMi2TDGXocdfUzSL3+qy
 nOpoV+6faaslgssR0b8+xofZPwIk80lqQFhLX5X43CYOCOggLBR72Kr7GSoQEIcBeQygcy78
 pdmtBFaOHYPBxdkdvw5hW+HpILxdmK973tuMLlpk0dKz2Dr8pbnn9E4sHxKDwOeDV7
X-Talos-CUID: 9a23:vohuFW8h2TNarzD0wneVv0o6OJ0nTWfP91jRAVOXWGVOa5GNF3bFrQ==
X-Talos-MUID: 9a23:vUh8igmh6JxPgOgmSnxldnp7DuF6yK2/LXwS0q0m55C4Ch12Njuk2WE=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="6.25,241,1779148800"; 
   d="scan'208";a="60462055"
Received: from aer-l-core-07.cisco.com ([144.254.74.208])
  by aer-iport-7.cisco.com with ESMTP/TLS/TLS_AES_256_GCM_SHA384; 24 Aug 2026 19:19:12 +0000
Received: from localhost (unknown [10.189.102.136])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by aer-l-core-07.cisco.com (Postfix) with ESMTPS id 7BC731800022C;
	Mon, 24 Aug 2026 19:19:11 +0000 (GMT)
From: Jerome Tollet <jtollet@cisco.com>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: netdev@vger.kernel.org,
	saeedm@nvidia.com,
	tariqt@nvidia.com,
	mbloch@nvidia.com,
	leonro@nvidia.com,
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
	bpf@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH net v4 2/2] net/mlx5e: Prevent stale XSK buffer release on MPWQE refill retry
Date: Mon, 24 Aug 2026 21:19:10 +0200
Message-ID: <20260824191910.64016-1-jtollet@cisco.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260824141645.23700-3-jtollet@cisco.com>
References: <cover.1787347981.git.jtollet@cisco.com> <20260824141645.23700-1-jtollet@cisco.com> <20260824141645.23700-3-jtollet@cisco.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Outbound-Client-TLS: ANONYMOUS;unknown [10.189.102.136];TLSv1.3;TLS_AES_256_GCM_SHA384;256
X-Outbound-SMTP-Client: 10.189.102.136, [10.189.102.136]
X-Outbound-Node: aer-l-core-07.cisco.com

Hi Dragos,

Thanks for the review and for suggesting the error-path approach.

Regards,
Jerome
