Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841E5502576;
	Thu, 15 Oct 2026 10:49:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.154.123
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792061398; cv=none; b=iG5ARMGjirBu7hNX66HIJ7ZnQksy5V1YNzYbp79MWLvX8io9DBtNKmqPlSXTrHt/xvOKyDL6eUmGYCA48ATTp1uRFHuJnG8IyU++F5RU4oH9QqWFr4JovZ4y+Za39wXGR82v8gYfzyUi8nyM6z5VLiJP7EZrx5FFLNjXKnqRt8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792061398; c=relaxed/simple;
	bh=l8aVUq7TDzxK7o/5g8O49rOLFIqY4I+NPKBGy+ZUBpY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SBVxgVhzDB1uDgB8GcNEycNT80PFy7bnX3AladGw8p/vAX3Y9fv3cruKA4TLVwmdW/hLDE4hPkKUCrD/22TrBP8639pPNxJ2YMkz7PJVRX31eG9xbjr2zHlGW+f0sqsj+1omds9EJjeiRXRTV7uuAcbyrrWv3qrY4qGrBQBcvXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=qjrmJG+v; arc=none smtp.client-ip=68.232.154.123
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="qjrmJG+v"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1792061396; x=1823597396;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=l8aVUq7TDzxK7o/5g8O49rOLFIqY4I+NPKBGy+ZUBpY=;
  b=qjrmJG+vGxVjjl/sFvQvvwd4R3VmtUD5ix9DAcQHfSLpHFb93cpyZIYa
   I+M831tjhCyhtpkSKCffomGUaE1CNy2DpYfn40EEG8s60ZFaZcnjeqDRp
   YNTBMJD1VJnXQ6cKZcl7xsxmPWkoAGy3EcLFc4ymichwqsAdh6spOE7/s
   rPw6ZqouJ4/V2IwPjQUR99jgNtbKy2kmBI3eUy4DVJ8EybQ3Z4337mrZC
   HZHnm9RWozQ0/8VJhkh6N1ZbxvVfVnOb0OU65GZAZcRw6pSWp83hjqgTb
   5VMAWP1fP87G1K7cT4dCemMhosVHwXGEI6UmoK3N7fnJ0qJhgRu4vAsmp
   w==;
X-CSE-ConnectionGUID: zI5WEAn0QBGADsosev5ImQ==
X-CSE-MsgGUID: sDRlxJcOQ5ap75mFo/rnnA==
X-IronPort-AV: E=Sophos;i="6.27,159,1787036400"; 
   d="scan'208";a="64135478"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 15 Oct 2026 03:49:49 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Thu, 15 Oct 2026 03:49:39 -0700
Received: from DEN-DL-M70577.microsemi.net (10.10.85.11) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.58 via Frontend Transport; Thu, 15 Oct 2026 03:49:36 -0700
Date: Thu, 15 Oct 2026 12:49:35 +0200
From: Daniel Machon <daniel.machon@microchip.com>
To: Tariq Toukan <tariqt@nvidia.com>
CC: Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
	<davem@davemloft.net>, Eric Dumazet <edumazet@kernel.org>, Jakub Kicinski
	<kuba@kernel.org>, <netdev@vger.kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>, Carolina Jubran
	<cjubran@nvidia.com>, Gal Pressman <gal@nvidia.com>, Jiri Pirko
	<jiri@nvidia.com>, Jiri Pirko <jiri@resnulli.us>, Leon Romanovsky
	<leon@kernel.org>, open list <linux-kernel@vger.kernel.org>,
	<linux-rdma@vger.kernel.org>, Mark Bloch <mbloch@nvidia.com>, Saeed Mahameed
	<saeedm@nvidia.com>, Vadim Fedorenko <vadim.fedorenko@linux.dev>
Subject: Re: [PATCH net] net/mlx5: DPLL, fix fractional frequency offset
 scaling
Message-ID: <20261015104935.7amgxizpsao4zbsl@DEN-DL-M70577.microsemi.net>
References: <20261015074035.1092340-1-tariqt@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20261015074035.1092340-1-tariqt@nvidia.com>

> From: Carolina Jubran <cjubran@nvidia.com>
> 
> The frequency_diff is reported by firmware in parts-per-trillion, which
> is exactly what the DPLL core now expects from the ffo_get callback.
> 
> Commit bc443c253fcd ("dpll: expose fractional frequency offset in ppt")
> switched the callback contract to ppt but assumed frequency_diff was in
> ppm and scaled it by 1000000 to "convert" it. Since the value was
> already ppt, this makes both exported attributes wrong.
> 
> Report frequency_diff as is and let the core divide it down for the
> legacy ppm attribute.

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>

