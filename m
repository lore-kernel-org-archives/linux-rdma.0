Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.153.233
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794486475;
	b=si3sGFFmXRmHwVQw+TKur8cofVXNOXHvBdM2Ry7D9RBYOpZAqAIFtn8V5BCf0JuNER3q
	 enP1ObXfOnoAF4cz4Q2bC1M0HJpejjA0qbPaKO8Plij1j4Kz7fvTiexFmI+SC6LSqleui
	 m+E/WV9Gq+65+zZ1+cjirGo9Kboh/1/iVdy+hegkSIrgxdnV80IEgKI63XGonFRSX6wjj
	 A77jXiGeF3nx8Mjc4m4txdvsrDuUXu3N7XZkqxdLOTww5A3x6eavCTGsWfCipWQXnLMmh
	 E6kEfMeNmDtbqhvZwwYPh0Q6TocNctGFS1sOvn9bGRYhrbYQuAHgo33P0g2CHFWb0Kw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794486475;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-Amp-Result:Received:Received:Received:Date:From:To:CC:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=1ZA5sC73+IlFkRAeNQ9a0k730uLXrOz2+FrELu1ZSFY=;
	b=NH11ZWUcBGZ/nzG1u9Dle+OYvGrO/4kYr6dwgYpaN3Gy+4ZhUx9EUNllitKdXv7lZxah
	 uOmmU8eDBJ/puWxKUTh+dhkwKLvohBXV9lQH/xke3NkeaSLObdlUYGn24sI9R/h+s3Fyj
	 3o7jy3UhUWIrO3c1YTN46gW7enNe8ycTcwG/dWre4KCztbjlQA6n6SoX/tkrByNNxRIqi
	 AykFYzCuvqSbQJQPhsFy2Qao3REo+ZDH8T8oeTVUhqgAAzeMPngw1oYZPgplOqFldM++I
	 Xjt0f5aI4oGciq/SZfgXjE01662ms1lCumwyqIn9yFc18SHJAlf/MjMqSM+rK65X0Tw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microchip.com;
	spf=pass smtp.mailfrom=microchip.com;
	dkim=pass header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=Kgui6sOd;
	arc=none smtp.remote-ip=68.232.153.233
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5185B606A332;
	Thu, 12 Nov 2026 12:27:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5185B606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=Kgui6sOd
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1794486482; x=1826022482;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=l3F0dgEZqqzCTcle72a7ov5JeFD0DWKUDjz+apn6hYY=;
  b=Kgui6sOdUjO6yxo2fegXimnMxpiCRlcKXU6h4nkdJm7sk+N6X+LStrRF
   cV2UOwyQSeuQY57+DHs0+GRqadakaGVVwO4nRm9gNnPibL1Kvi12+RfQb
   BH4Wubvpr9461b9YfKJUyXVhnak5P4y8zZucl/qWjTd0IW4k9XfnjOwVr
   d3AEfVzpOkgEoXiJIvCUvpAQO6GFlbGmRNKwwGiyz2POwosvp4fK6p+cS
   tIAhBMrdbqkbbLIo8vXX9RIJJ7osGwIBq0eeSvyT9gQCVJrHjpFagMQCs
   gH45rLoLEd53BZOMVfU8HoesrTiTrjMlHMxB14beb+wDaLrSXVoMIxwgB
   Q==;
X-CSE-ConnectionGUID: RVd2qb8VQ9mGyxq4pxN7VQ==
X-CSE-MsgGUID: +0FH4PJYR7KVuom5Boj3Zg==
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="77094255"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Nov 2026 05:28:01 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Thu, 12 Nov 2026 05:27:53 -0700
Received: from DEN-DL-M70577.microsemi.net (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server id
 15.1.2507.58 via Frontend Transport; Thu, 12 Nov 2026 05:27:50 -0700
Date: Thu, 12 Nov 2026 13:27:49 +0100
From: Daniel Machon <daniel.machon@microchip.com>
To: Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Gal Pressman <gal@nvidia.com>, Leon Romanovsky <leon@kernel.org>, open list
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>, Maor Dickman
	<maord@nvidia.com>, Mark Bloch <mbloch@nvidia.com>, Moshe Shemesh
	<moshe@nvidia.com>, Or Har-Toov <ohartoov@nvidia.com>, Roi Dayan
	<roid@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>, Shay Drori
	<shayd@nvidia.com>, Uri Dar <udar@nvidia.com>
Subject: Re: [PATCH net] net/mlx5: Lag, Return error when enabling MPESW
 without LAG support
Message-ID: <20261112122749.7cudepr32t4bz2le@DEN-DL-M70577.microsemi.net>
References: <20261110114350.2639891-1-tariqt@nvidia.com>
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Post: <mailto:linux-rdma@vger.kernel.org>
List-Help: <mailto:linux-rdma+help@vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-rdma+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261110114350.2639891-1-tariqt@nvidia.com>

> From: Uri Dar <udar@nvidia.com>
> 
> When firmware reports a function as not LAG capable (lag_master=0 or
> num_lag_ports < 2), mlx5_lag_add_mdev() creates no LAG object for it.
> Enabling multiport E-Switch on such a device returns 0 from
> mlx5_lag_mpesw_queue_work(), so
> "devlink dev param set ... esw_multiport value true" reports success
> although nothing was enabled, and a following "devlink dev param show"
> still reports false.
> 
> Return -EOPNOTSUPP instead. mlx5_lag_mpesw_disable() ignores the return
> value, so disabling keeps its current behavior.
> 
> Fixes: a32327a3a02c ("net/mlx5: Lag, Control MultiPort E-Switch single FDB mode")
> Signed-off-by: Uri Dar <udar@nvidia.com>
> Reviewed-by: Shay Drori <shayd@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> ---

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
