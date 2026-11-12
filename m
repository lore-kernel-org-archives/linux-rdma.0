Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.154.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490870;
	b=yPDjwPhv4RlrECPBXhF9ZbX5WJ3R59wZhfvp6Y7FfjzNUaupBE9//cKpdl/XzV26ArjS
	 q+FxC/CHEZ8wRIqq3Ynectu4L5INUDcjmD0JScoe+xjum7n9ttlNCLte+beFPX5Da1ybU
	 eqbGG99llRH/zWP1BXE/JVhoKkUIBiQgolfGFwZa6VEAR6ly9kEtqWuMsgf4nYnfDK7Ci
	 JC5eZIioWUIWu9d3Q7RaISDON5VjqaVYIQOu8Y8jROKv7REGe8Zx11s4jUnXRxWvn1eRN
	 wtTBjUwvOMYI+jBk+Q6EhTIDAyuOCHEXQqlIhnQXhxU48GcLKd7UC/CTcc+nVIUM+vg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490870;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-Amp-Result:Received:Received:Received:Date:From:To:CC:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=QmzaHZwcWIgD/I7vZeFAkMM5l5LwjkXmq59q1IdwVGA=;
	b=jo+mtErfHy9vnvGPzTM5WCj9ZpCMePf21ZB/AHNfdFpaivnHAPm5BxyppntmcqfLYwg0
	 4aQEqfyxWNAMk/7Nnvm2tpeUidbLT3SpCb2PA4PXSn/0zQqwfHLCZjk8tMUCZ927xfxMo
	 bV3ZbYJCv+yHkdHAqGWATdh7wmPxF2D6Zd/8Jb04QZLIuokYidqZJ6uNDCFlJ4Rrv66HB
	 7kb7/r0G60uCs8F1RdxtbNW+iAH/9vxe76W+YDRaPV7sAsdii6KFXNQLvcohBeiD8mKPk
	 4kjzPqOU6ErOT6i+xLW9PAEPkFEd+k8Ay4xqeC0j5ObG9CpBzrmifGSHzXNNqEw0VIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microchip.com;
	spf=pass smtp.mailfrom=microchip.com;
	dkim=pass header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=drAQ5NnV;
	arc=none smtp.remote-ip=68.232.154.123
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2DD3606A32E;
	Thu, 12 Nov 2026 13:41:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A2DD3606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=drAQ5NnV
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1794490869; x=1826026869;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Nkrvva85zQVvthz3uFSom9vyQ8CsiUmBBuEgpZi9NAc=;
  b=drAQ5NnVm1smRWDwDe13xEvRR9nXqVAHnPifVCUzEUI+oV5RfCj7cH6g
   Od1LG+Giyf3D3TqgVSYvdhEh5rjWlFkwP6aInYLPMhZqrUSndsJBTRgrJ
   vBIDanlyq+ltlydXmJ0ck5VATNndUo5qjIuVP/POl7f0SNgFtd+hoReCK
   luQpfP/3Go9yS8o1WzxETGl/QU3ioSV+e0IUQMsG5hc+4uhDLecdHpDhe
   iQsSSp0GakxZPPas+ktuj5KfxynubTaC+owptbj0hOOAwJuux9JFqmbei
   4ypjOD+aapLOCz+ccCqlvkAUP3DyerbbNeTzWh8FkCv2mppFpB4q5RFci
   Q==;
X-CSE-ConnectionGUID: dSC/5sMIQbabWb7eKbagMw==
X-CSE-MsgGUID: E1ZVT+JrS6m4SNXJ2/dBBw==
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="66654975"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa2.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Nov 2026 06:41:09 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Thu, 12 Nov 2026 06:41:08 -0700
Received: from DEN-DL-M70577 (10.10.85.11) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Thu, 12 Nov 2026 06:41:06 -0700
Date: Thu, 12 Nov 2026 14:41:05 +0100
From: Daniel Machon <daniel.machon@microchip.com>
To: Joe Damato <joe@dama.to>
CC: <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <edumazet@google.com>, <horms@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next 2/5] net/mlx4: factor csum flags into
 mlx4_en_csum_flags()
Message-ID: <20261112134105.xq2x7vpkxadltqkw@DEN-DL-M70577>
References: <20261110231304.1859217-1-joe@dama.to>
 <20261110231304.1859217-3-joe@dama.to>
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
In-Reply-To: <20261110231304.1859217-3-joe@dama.to>

> Extract the code which converts skb csum fields to WQE fields into a
> helper. This helper will be used by a follow-up series implementing
> software USO, to reduce code duplication.
> 
> Signed-off-by: Joe Damato <joe@dama.to>

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
