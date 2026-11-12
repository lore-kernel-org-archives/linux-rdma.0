Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.154.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794490851;
	b=31eR97fF12e1sx0VNq57Lxn7ek4WW3NLB+bq7O8QrRD9qrFWp6+1BRBLHXXEzr6Crdhx
	 X1K+PoBjdr7zG3xHQSX975OjcjTc+mSCc34EhdfPftXGftVNmQ/vbryxJHP+nMY8dPPMb
	 DJwv5SlkaMig2sFy8vHvGTDTYvD2cJRUgHxc2XBAgMyes36k865qKOAqi3VVJD8liiLrs
	 9G6JYlntT/3LBptfRqrJoZMn9IwC5IzSovlkbyTnVwsRK7WLGetOumfzyYFfRyq61TI+J
	 WHcYduWvS5kht0FCBrUX+5biiU39zSJS+ZDT85WNZqsDYdBwc+R79qLHOF9IXcOfalQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794490851;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-Amp-Result:Received:Received:Received:Date:From:To:CC:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=DfrilG09OuyxTH5qMaImAYWIUsCGZ3zn5Mg/WIjTOtY=;
	b=zrxFykG6KwTETZteBoA4Ay1Yd7cmzAv9ebTbsND99Raum9h0OPVnrwG4pRC46i1X+6eV
	 8ucMkscn664IO2oL1269deBuiXK0sdzXRWqChcZjfI+SbLXAi7cVQO6/6wIcZojg13ON5
	 PvKQ0h/0vDDOLPNAHorZ1nJJQM9DDW+G8EJd0t1n/jAC5Y//20vObqIe/ASK3aIyBMe6C
	 8P9fKs08S/VekiaheSRMwSm+OpbfSDDLIEmnOuT/Q1L4j/HEeDmXtBH9kyQWBPANAW8cr
	 nmDaRCjzVum/uVWnLpvq5H72Sll+g2lNVY+3V42DW52BU0OzOj8YOKoH60U0Rf4IhaQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microchip.com;
	spf=pass smtp.mailfrom=microchip.com;
	dkim=pass header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=v8gOuI28;
	arc=none smtp.remote-ip=68.232.154.123
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D281B606A335;
	Thu, 12 Nov 2026 13:40:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D281B606A335
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=v8gOuI28
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1794490850; x=1826026850;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=DfrilG09OuyxTH5qMaImAYWIUsCGZ3zn5Mg/WIjTOtY=;
  b=v8gOuI28HovNFvkkw3pBobJSs8ppZjJEF/yYu225Na+vVF7fiTMFmX+/
   hHQgparr2uTz8sPi3yiSsizYPpnigLNr9oFXNXBssBN04zNXzIVgvF/Ks
   bTv7Ia4uIxRL78qTp6ytlElT5Llw4CbDNx9Z4bvFIPdB7hqAB+DYjeskS
   eGH5GeaB72XU0zBGFFkan6fP66vz4YBCdUGFUZeyIMWdJPxrYK2p1gFse
   4dFSFt09bNlDhAekKtDbWMpnbnIGsd3EKJIKTzE7Z9e7rWZq8NAWtSTst
   tnw9uVs0rHggBplFUKe9sG2GSdmzW294Dz2CeU2u0oqVpJ1ea0oMEh0ZK
   w==;
X-CSE-ConnectionGUID: SDvyZbn6QDGT5JU82SqcEw==
X-CSE-MsgGUID: YIop3FYCS5KKTvmwO/UCJg==
X-IronPort-AV: E=Sophos;i="6.27,209,1787036400"; 
   d="scan'208";a="65446573"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Nov 2026 06:40:49 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.87.71) by
 chn-vm-ex2.mchp-main.com (10.10.87.31) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.56; Thu, 12 Nov 2026 06:40:49 -0700
Received: from DEN-DL-M70577 (10.10.85.11) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.58 via Frontend
 Transport; Thu, 12 Nov 2026 06:40:47 -0700
Date: Thu, 12 Nov 2026 14:40:46 +0100
From: Daniel Machon <daniel.machon@microchip.com>
To: Joe Damato <joe@dama.to>
CC: <netdev@vger.kernel.org>, Tariq Toukan <tariqt@nvidia.com>, Andrew Lunn
	<andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@kernel.org>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, <edumazet@google.com>, <horms@kernel.org>,
	<linux-kernel@vger.kernel.org>, <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH net-next 1/5] net/mlx4: factor VLAN parsing into
 mlx4_en_prep_vlan()
Message-ID: <20261112134046.xab7dntf7or3dsgw@DEN-DL-M70577>
References: <20261110231304.1859217-1-joe@dama.to>
 <20261110231304.1859217-2-joe@dama.to>
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
In-Reply-To: <20261110231304.1859217-2-joe@dama.to>

> Extract the code which converts an skb VLAN tag into WQE fields into a
> small helper. This helper will be used by a follow-up series implementing
> software USO, to avoid code duplication.

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
