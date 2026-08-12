Received: from pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com [34.218.115.239])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF2A399CF5
	for <linux-rdma@vger.kernel.org>; Wed, 12 Aug 2026 06:59:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=34.218.115.239
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786517943; cv=none; b=MU0kN6D+ipJEsZPh88+CRNRunPfrHh/TMp/vXq/knQwYY/LSErtEN9MSOzbdsfbLGxvf4XYknFR+tR8HfOGLpAtESZfMWpVgWXcSJ3gzlGsHvcqzNb5oTpmqDZ04aqs+SyHe5SLF06uKIKDw2AE++bGTnYc6xs2d/dPcMWisy8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786517943; c=relaxed/simple;
	bh=LkGb/u9KdHAhdu8DfQXbOn0mVfnZMNp/2S93hGbUWIc=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uDDg1aVP/xKC0EaN0cdxAT3d9V4K0Ruo5ueufbmyIKCTeprVtUWRLzkOR28++PK0rhXgtplojGzjJG+wV3h+GdLwHzryb937WcI4r/9WgWGcLhYOD/t3vH4j+dnim+wMktha/gF/7W5lQ7L/V9qg5n/mza4TFlqH3zZlwmX50Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com; spf=pass smtp.mailfrom=amazon.com; dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b=XDlB/rA8; arc=none smtp.client-ip=34.218.115.239
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=amazon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=amazon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=amazon.com header.i=@amazon.com header.b="XDlB/rA8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1786517942; x=1818053942;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MCHifZLeJpGL35kGIljuRYmQxSf+mu4jXfFN/YnDiSQ=;
  b=XDlB/rA8XaSe82mQ0M0Q9mEkqz8iMA0WGVUxfpI9gaMQ0dwrK0PZ3eSm
   tynD2ms0+oiIV1bBjwTNbAlDjFksxhtYRm4CuVPlY5Z0JQl9PELapeKEg
   sqKQtUt/jCHeMvxyNMnWuJETlWTge+ux1PjYmAIrriqaQWMSMiZY9UxmW
   Yft20iG2NtiOqa2o4Mb2KRp4FUk/seN7sCH9CLJKDpyfeMIwMo2HaZhT0
   D8+ifgqTCCGXn4MQ0KumYbENn2EFlrxnJzNanjjKIkD7ZKJDC27mkkfuL
   IXX7ITu1BAqu2tuCx9lGmqOtV+us+0b6I8z6oBlflUVm4eaFIJ79JKszF
   Q==;
X-CSE-ConnectionGUID: 9dcjIvthSdm+eRLva2P7Ug==
X-CSE-MsgGUID: vye+asb/SW6g8IfqZspf2w==
X-IronPort-AV: E=Sophos;i="6.25,218,1779148800"; 
   d="scan'208";a="25552863"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-013.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Aug 2026 06:59:00 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:9921]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.35.90:2525] with esmtp (Farcaster)
 id 82dcc8d3-a539-432b-b880-e0d790cd7572; Wed, 12 Aug 2026 06:59:00 +0000 (UTC)
X-Farcaster-Flow-ID: 82dcc8d3-a539-432b-b880-e0d790cd7572
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Wed, 12 Aug 2026 06:58:59 +0000
Received: from dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com
 (10.253.69.224) by EX19D001UWA001.ant.amazon.com (10.13.138.214) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45; Wed, 12 Aug 2026
 06:58:58 +0000
Date: Wed, 12 Aug 2026 06:58:45 +0000
From: Yonatan Nachum <ynachum@amazon.com>
To: Jason Gunthorpe <jgg@nvidia.com>
CC: <leon@kernel.org>, <linux-rdma@vger.kernel.org>, <mrgolin@amazon.com>,
	<sleybo@amazon.com>, <matua@amazon.com>, <gal.pressman@linux.dev>
Subject: Re: [PATCH for-next v2 0/3] RDMA/efa: Add support for 128B admin v2
 SQ entry
Message-ID: <20260812065845.GA22503@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
References: <20260731075007.3878376-1-ynachum@amazon.com>
 <20260809192237.GA15936@dev-dsk-ynachum-1b-aa121316.eu-west-1.amazon.com>
 <20260811193938.GA661193@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
In-Reply-To: <20260811193938.GA661193@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ClientProxiedBy: EX19D041UWB003.ant.amazon.com (10.13.139.176) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)

On Tue, Aug 11, 2026 at 04:39:38PM -0300, Jason Gunthorpe wrote:
> On Sun, Aug 09, 2026 at 07:22:37PM +0000, Yonatan Nachum wrote:
> > 
> > Hi, kind reminder for this series.
> > I reviewed the Sashiko comments and they aren't correct.
> 
> They look correct to me, the stack buffers should be u64 arrays for
> the alignment reason it gave.
> 
>     common_v2 = (struct efa_admin_aq_common_desc_v2 *)aq_entry;
>     common = &common_v2->common;
>     common->command_id = cmd_id;
>          ^^^^^^^^^^^^^^^^^^^
> Stores u16 to an u8 aligned memory area.
> 
> You should also fix the race it pointed it.
>

Hi,
I will upload v3 with the alignment change and for the existing race
Sashiko found I will create a new for-rc patch.

Thanks.
