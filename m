Received: from pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com [44.246.77.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE171F8755
	for <linux-rdma@vger.kernel.org>; Sun,  9 Aug 2026 19:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=44.246.77.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786303380; cv=none; b=rE51uxLiW8VTskwbwcAUadFP8YeHyca20EixhhsIDlUGoOPB3nX1OIsuvueE87bo+cTJq+BS309L+gklqsM6vIkqUrjMEL44qKPnoIPSg3UAenKM01UzGSekgqI0o2+GO3EfFQnJxIfrkV0veEgjeURHGqpHvtFMJzTJawI12R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786303380; c=relaxed/simple;
	bh=61ObG326Sm4eCgkmrwhiUTVTV6GSSH12JNtEJdFlwwI=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SO3T3fa73QyjRLyqwCmZOvH2+cFXeeap1JvIUFZUCMGhDQb50aU2dsiyyneNMXGzBcOJMkVYqVeU4Do5RxAQLOZB4/Ysd9Dy541fdYVl1BMk7lO/NJjNqG8FRGwUcJU4FwoMBKnKF5g5B4Z1ScA2vwzeSpFu2rkKU1YNOhSX6gY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=kRnhVW6s; arc=none smtp.client-ip=44.246.77.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="kRnhVW6s"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1786303379; x=1817839379;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=jseoQHRxgWk7irZVIVkdLTAhyLJQ0jZEm0FYl0xOaI8=;
  b=kRnhVW6s5ciTmXMKbD9xMhTq9RDWbJKpkLPNNGH9stnBGSIBetMGbA69
   +JYRrrLXuhWs4HYudnKCu4xgH+HCCxvx0XyEL14zzcMxotWbvvHM5cI5g
   dgKaPtVKsLOMiGugzOhmIAO9yyciIA4scjMC3LExGCye5Eaqaw3FEXiRi
   plJMImpcOmZ33aWu8aJlW0VDKiK6ccLUFfOKJX/tN/Da+7/6somHYUQpF
   caskMxL+UfVmnuOVT6nlGcd2CPMHjQi/c05akNjM/QMgHt5KG9GDWh3hD
   b2V2q2yk4izaitXxpUOGcjpnEI82+mo7mmm4WUfwxlbZx9AUnjSC6wr+C
   Q==;
X-CSE-ConnectionGUID: V+4sOvCTTh2S3P0mS3rr5g==
X-CSE-MsgGUID: daylcx1BSCifa4mlzRoJBg==
X-IronPort-AV: E=Sophos;i="6.25,214,1779148800"; 
   d="scan'208";a="25520732"
Received: from ip-10-5-9-48.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.9.48])
  by internal-pdx-out-004.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Aug 2026 19:22:56 +0000
Received: from EX19MTAUWB001.ant.amazon.com [205.251.233.51:9903]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.44.25:2525] with esmtp (Farcaster)
 id 92203b36-824d-4b5f-b895-74f629edd78a; Sun, 9 Aug 2026 19:22:56 +0000 (UTC)
X-Farcaster-Flow-ID: 92203b36-824d-4b5f-b895-74f629edd78a
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWB001.ant.amazon.com (10.250.64.248) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Sun, 9 Aug 2026 19:22:56 +0000
Received: from dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com
 (10.253.69.224) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45; Sun, 9 Aug 2026
 19:22:54 +0000
Date: Sun, 9 Aug 2026 19:22:37 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: <jgg@nvidia.com>, <leon@kernel.org>, <linux-rdma@vger.kernel.org>
CC: <mrgolin@amazon.com>, <sleybo@amazon.com>, <matua@amazon.com>,
	<gal.pressman@linux.dev>
Subject: Re: [PATCH for-next v2 0/3] RDMA/efa: Add support for 128B admin v2
 SQ entry
Message-ID: <20260809192237.GA15936@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
References: <20260731075007.3878376-1-ynachum@amazon.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260731075007.3878376-1-ynachum@amazon.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D040UWB001.ant.amazon.com (10.13.138.82) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Fri, Jul 31, 2026 at 07:50:04AM +0000, Yonatan Nachum wrote:
> Changelog:
> v2:
>  * Rebase on for-next branch instead of wip/leon-for-next.
> v1: https://lore.kernel.org/all/20260726123854.638687-1-ynachum@amazon.com/
> 
> -------------------------------------------------------------------------
> Add support for the new 128-byte admin v2 SQ entry format. The v2 entry
> extends the v1 header with checksum and payload version fields, and
> carries a larger inline payload.
> 
> The series first decouples admin command payloads from admin headers,
> then generalizes the SQ ring to use a configurable entry size, and
> finally adds the v2 entry format selection based on device API version.
> 
> Yonatan Nachum (3):
>   RDMA/efa: Decouple admin command payload from admin header
>   RDMA/efa: Generalize the admin SQ
>   RDMA/efa: Add support for 128B admin v2 SQ entry
> 
>  .../infiniband/hw/efa/efa_admin_cmds_defs.h   | 116 +++--------
>  drivers/infiniband/hw/efa/efa_admin_defs.h    |  33 ++-
>  drivers/infiniband/hw/efa/efa_com.c           | 194 +++++++++++-------
>  drivers/infiniband/hw/efa/efa_com.h           |  16 +-
>  drivers/infiniband/hw/efa/efa_com_cmd.c       | 170 +++++----------
>  5 files changed, 240 insertions(+), 289 deletions(-)
> 
> -- 
> 2.50.1
> 

Hi, kind reminder for this series.
I reviewed the Sashiko comments and they aren't correct.

Thanks.
