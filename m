Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=68.232.154.123
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795088935;
	b=sg+nQhXPMOUZsX7DjxVckDadHDn99TPInjr3J7187dqGnVKkvhZhOgeonYi5ByZvA2W3
	 VKHpKss3NrsCmviLQ2/EM81X+uW949aYqeBBmeoNk0XW4FoDBkVp8XbywGZi5ltc9y/QN
	 vSAfgqlB7Ft48fSYu2ijPmxZrFJwF51iWWZDfqczGdm7N0K5Nx1XEYywet+2rqwRWYoLo
	 oYzhUHUQYwM91llC02uR0KIaFP5jHIAy6aSe1EtsndE6w0zCAF77YbTW2UfPj3Fa/G/LN
	 Karb0bB9g+gvvaqLfhXQ9ccz5v9Gi7OaaI7L0Y/ry7YKHlyFnQPpCUMuzVEc7AjqRjg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795088935;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-Amp-Result:Received:Received:Received:Date:From:To:CC:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=ZTyzomv6gn4DyTlHNqpwldZlcCE7/LWTrt4ijf0rUEA=;
	b=iEHlFRgTNw5BtmPVrhUB+9RkQfLNwwgUY6mlrPmLNE2EQG1mXD88b4DNE7gfJ7hDfbiC
	 cmC7CeMhP1Mme8wVzNeTfWPPMYHwRP9tM9AFO3+33ejwAqNwHWD2puY7Dv36ED9bXdZRG
	 knbjN37xoLALbYsgBmZnZxnD704SIPVCCXHH9ivhMHk+AhbiLt9X+PRMDiSrGjaf02D71
	 raFN7wYObzJdTu02GzyqY2evb25LvxOboUaC9vBCQuByxdhstj8d7gPGRPBbMUz/fjPiZ
	 RMfxY/GndAPDYfkKsfRf/cKUSGXHdHNC7D6IadTpPxVfydZXrmjD5VcJLOAYcQB3W3Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=microchip.com;
	spf=pass smtp.mailfrom=microchip.com;
	dkim=pass header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=lqvcIgdq;
	arc=none smtp.remote-ip=68.232.154.123
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 481CD606A325;
	Thu, 19 Nov 2026 11:48:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 481CD606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.a=rsa-sha256 header.s=mchp header.b=lqvcIgdq
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1795088935; x=1826624935;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=0mqY9DMxcso3ErCUbL4FV1Cp5DxTulfgJVGr5xRjnrI=;
  b=lqvcIgdqkV+rzjpiAP4UyavxMJ4HIDuFqeHeIJ/ClMUF2OqDx8r8KQuz
   tK8yfyRyiCoxc5hnBQsmDa2pyBHhkKxGRcxvDI0r3BMKjI86syaYJWwV0
   m9lEWPyZbd/v8l+R2ahXG/d7Z9WNQ6J2a4c/eiRpQZnLhiSjosTsEz4P9
   aQB5gfTmyo3sqv1RAQj+ajqVqpX8Pckn2QVsrmAkALUeMA1/J+4nokMY9
   /EXtrZa/p0oLxIkDuuL50w9yhMkoMojozu3jXof9ZGC6NGSwyqF/ZuCax
   EahhZ7JXdvJzl2mthA+hms8KJbU+Bl84GbkIrV0ZFmiXeyepE3Wg+77vm
   w==;
X-CSE-ConnectionGUID: wZg5LJbGSf2b1tDTuC+ooQ==
X-CSE-MsgGUID: 1B8FZc4cReyx+FbOP2LYcQ==
X-IronPort-AV: E=Sophos;i="6.27,220,1787036400"; 
   d="scan'208";a="65785161"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa4.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Nov 2026 04:48:54 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.87.152) by
 chn-vm-ex3.mchp-main.com (10.10.87.32) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.2.2562.56; Thu, 19 Nov 2026 04:48:53 -0700
Received: from DEN-DL-M70577.microsemi.net (10.10.85.11) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server id
 15.1.2507.58 via Frontend Transport; Thu, 19 Nov 2026 04:48:51 -0700
Date: Thu, 19 Nov 2026 12:48:50 +0100
From: Daniel Machon <daniel.machon@microchip.com>
To: Jinvas <jinvas@126.com>
CC: <saeedm@nvidia.com>, <tariqt@nvidia.com>, <mbloch@nvidia.com>,
	<leonro@nvidia.com>, <andrew+netdev@lunn.ch>, <davem@davemloft.net>,
	<edumazet@kernel.org>, <kuba@kernel.org>, <pabeni@redhat.com>,
	<netdev@vger.kernel.org>, <linux-rdma@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <horms@kernel.org>, <alexious@zju.edu.cn>
Subject: Re: [PATCH net v3 1/1] net/mlx5e: fix NULL pointer dereference in
 arfs_create_groups()
Message-ID: <20261119114850.d3a24mau3t6j6yqt@DEN-DL-M70577.microsemi.net>
References: <20261118134514.1765-1-jinvas@126.com>
 <20261118134514.1765-2-jinvas@126.com>
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
In-Reply-To: <20261118134514.1765-2-jinvas@126.com>

> arfs_create_groups() creates up to two flow groups in ft->g[], and
> increments ft->num_groups for each group that was created successfully.
> If creating the second group fails, the error path frees ft->g and sets
> it to NULL, but leaves ft->num_groups at 1.
> 
> The only caller, arfs_create_table(), calls mlx5e_destroy_flow_table() on
> the error path, which calls mlx5e_destroy_groups(). The latter walks
> ft->g[] from ft->num_groups - 1 down to 0 and dereferences ft->g[0].
> Since ft->g was freed and set to NULL, this is a NULL pointer
> dereference, and the kernel oopses.
> 
> The same error path also leaks the flow group that was created
> successfully before the failure, since ft->g is freed without the group
> being destroyed.
> 
> Freeing ft->g here was added by commit 3c6d5189246f ("net/mlx5e: fix a
> double-free in arfs_create_groups"). Before that commit, the group
> failure path did not touch ft->g at all, so the caller destroyed the
> flow groups that had been created and then freed the array. That
> commit fixed a double free in the allocation failure path by freeing
> ft->g here as well, and in doing so changed the group failure path
> too.
> 
> Rather than also resetting ft->num_groups, leave the free of ft->g to
> the caller: mlx5e_destroy_flow_table() frees ft->g exactly once, and
> also destroys the flow groups that were created. This fixes the NULL
> pointer dereference and the leak, while keeping the double free fixed.
> 
> The bug was hit on a virtual mlx5 device whose firmware answers host
> mailbox commands. The device took longer than the firmware's own
> timeout to answer one CREATE_FLOW_GROUP command, so the firmware
> reported the command as failed even though the device had completed it.
> The host then took the error path and oopsed:
> 
>   Oops [#1]
>   epc : mlx5e_destroy_groups+0x38/0x6c
>    ra : mlx5e_destroy_flow_table+0x10/0x30
>   status: 0000000200000120 badaddr: 0000000000000000 cause: 000000000000000d
> 
> Note that the host oopses on any error returned by CREATE_FLOW_GROUP,
> no matter where the error comes from, so the trigger is not specific to
> that firmware.
> 
> The fix has not been tested: the patched kernel was not booted, only the
> original crash was reproduced.
> 
> Fixes: 3c6d5189246f ("net/mlx5e: fix a double-free in arfs_create_groups")
> Signed-off-by: Jinvas <jinvas@126.com>

Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
