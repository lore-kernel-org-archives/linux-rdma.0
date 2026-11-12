Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.153.233
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490892;
	b=4rNkKRK1PlbfCY7bIMCd3kjN0pr/zB4Zr2f1nvTJUraaipuOWHvoaVjPhB9L4EvnaX8b
	 GwvMLyQdexY+KlJ8nRzIQftP2hksumNSSz3Py/uZBv5AkVUgoab9nXQ0bHWhKFMn2VfTg
	 nWuEu78WYfXnTL1z/JasOSNlfuhUJk306FjnUCsy8b6lH2fSt02bbgybtST6WWHWevA+y
	 Q077vdRfKNcBvEGFAcCw6Q9RIWihcdXiwwXh4aPLrkIZeKa6BD9WtOgqPTYiFOqr83ZzY
	 RfNOg9pFhalA7F0PvlkmSff0YBC7ESipHeAEXPNPNkyeg4EIR3gFv/y4fyP0YUdnQuw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490892;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-Amp-Result:Received:Received:Received:Date:From:To:CC:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=vwAW0uFdo7/BOz21AYXGAReKmASIq+BVKX+OrTkm94g=;
	b=MaUz4nu75ySkPBj0HG8WYMn+4qMOH4bs5/iiKvWkQOcbtBtfpanZbNhrwB7i+L4z4yn7
	 Em633qQ2u8XbAr6iwuK7DTe8t6uvK+SeMxpr1gNf+CTWZqReUDjcBIbS5C8mxzu6egB15
	 lgxiNS+Eab0y/bt55sWoUxQ6Rjb4CIycADGZTl7MRnC62X5K4VNDbaKiC1fOmEuElzFhq
	 2vDqXdnaRB9E5K5Kw/jM/kVzNDyQWWEM8XATNKN7ZIKaYZ5nwtkPa99qrjlb0mAmax+g+
	 9A3xrFxmksj8gZDOpL6Y+7RguyxGN9K4nP3yonq28pA5C0n1+UGDBd1Hr53egIh49Fw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microchip.com;
	spf=pass smtp.mailfrom=microchip.com;
	dkim=pass header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=TMTZqY0Q;
	arc=none smtp.remote-ip=68.232.153.233
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8568606A335;
	Thu, 12 Nov 2026 13:41:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E8568606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=TMTZqY0Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1794490899; x=1826026899;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zPsKqtkUwktR8nrGH/gE8FHHhCvfpf3sLqDMbExCNcc=;
  b=TMTZqY0Q9a5GYoKNiK3hyFxBP9n5B7iCPeq/E2UPhbFBYChtj0Mg+LPW
   JcjHdX25H/wFZZARFJXVWBlIef8CekrMGFsy7lWb5XfQuejU1iIBDXd2f
   8Z7LUrOssOhUBrUNEzYZb1F7CsqENxOcLDYqgJtSvkcB8uima4AuiYeE7
   HhjeN5VP62dJW6ZBUb49Vh4M8ftk+RngVGNa2VxARqish6/AAcSj6Reyt
   h7utG4Tj3BvdcpF3c84IcmTtSfqWYNr/hcW+9BvDF7su3v664UosUxkMZ
   PUZ04Hh+bFEMjxzyJ9KWcq6Vva0dRl+sleN9wFirX/oiKIe2C3x48K7eZ
   g==;
X-CSE-ConnectionGUID: fXvZKbdtT8ucMxCWKA1ySg==
X-CSE-MsgGUID: QsvRYYWuQB+LU7/brlO+eQ==
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="297833422"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa5.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Nov 2026 06:41:38 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Thu, 12 Nov 2026 06:41:30 -0700
Received: from DEN-DL-M70577 (10.10.85.11) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Thu, 12 Nov 2026 06:41:28 -0700
Date: Thu, 12 Nov 2026 14:41:27 +0100
From: Daniel Machon <daniel.machon@microchip.com>
To: Joe Damato <joe@dama.to>
CC: <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <edumazet@google.com>, <horms@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next 3/5] net/mlx4: factor HW loopback DMAC into
 mlx4_en_set_loopback_dmac()
Message-ID: <20261112134127.ltcw2kjochwp3dj3@DEN-DL-M70577>
References: <20261110231304.1859217-1-joe@dama.to>
 <20261110231304.1859217-4-joe@dama.to>
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
In-Reply-To: <20261110231304.1859217-4-joe@dama.to>

> Extract the code which copies the destination MAC into the WQE for
> eSwitch loopback into a helper. This helper will be used by a follow-up
> series implementing software USO, so USO packets between functions on
> the same port are looped back too.
> 
> Signed-off-by: Joe Damato <joe@dama.to>

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
