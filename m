Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DE0B63B9;
	Wed,  3 Jun 2026 00:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780446970; cv=none; b=QmInrZsPpOBz3h/c31pgGMzo6AT0M/2aPpf46rTLZyFXirdUjj5x3YBA/PsZft4CIv/EfQmHSKGmiaZdvqllhwu/nz96vAxivgObIr+vqd16aLpfLoIK6iyB5wbwDwn0PSiZt4Cudhnj6uwtd6Ic61di9SIrFWI6zlMoPLt7BBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780446970; c=relaxed/simple;
	bh=MfxSBQ7FpIjW+XoZea7Me1fc7/DqySN+aGsMB3ADWC8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mEIB1+q+vXSrhtjBqdm4Yz3wuAZXZ+WkwezbogIftX1c5wPq8qUG3Iow4Kg71nNLKjjNPBqKDXXrBRXZ0PisSF2a3OXB8RpXA/4lNjCGUoLXEguzLO4TLLTkAMB+BAQ+eZcKdIoMzS40jJ3GxObr9ji3LcpjAut2QTa9iOyIqAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YUxovYYO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YUxovYYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB251F00893;
	Wed,  3 Jun 2026 00:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780446969;
	bh=SLkU7PYVCeZihT1F/frvulQEOLYYzwLpY2joSuqmbFQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=YUxovYYOwqxK0M4zHnFPEa9l8r/VBix5KW/qBoZf6rQ40rTolEqQ8kaREyEn7XHRw
	 p9woDWqoGo9XSfI0CZnHi4V4BiDxpE/+ie4HYZgIAnAomT3ClJZWQOetqz5cA519XA
	 X0URwv2DmsU0NrFPl3Pvsf+wHhIgP4fqi0ArSKNBr85e7p0TnQ7yVNXVKA5Odomlye
	 CtVXGlrnUcrxB/5OH1TzPlqtCs8r9zcMkjoYZgm5b2vAN+ZoIPVaxhg/SBNETSv4Hj
	 /yVn6t75XWU3gjfzxCkKOcwuM2VoRVRTY0p8hVyuJ2ch9na8/kT+dvburrFs80M1O1
	 xxZ7+s4JAXzWg==
Date: Tue, 2 Jun 2026 17:36:07 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Long Li <longli@microsoft.com>
Cc: Konstantin Taranov <kotaranov@microsoft.com>, "David S . Miller"
 <davem@davemloft.net>, Paolo Abeni <pabeni@redhat.com>, Eric Dumazet
 <edumazet@google.com>, Andrew Lunn <andrew+netdev@lunn.ch>, Jason Gunthorpe
 <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, Haiyang Zhang
 <haiyangz@microsoft.com>, KY Srinivasan <kys@microsoft.com>, Wei Liu
 <wei.liu@kernel.org>, Dexuan Cui <DECUI@microsoft.com>,
 "shradhagupta@linux.microsoft.com" <shradhagupta@linux.microsoft.com>,
 Simon Horman <horms@kernel.org>, "netdev@vger.kernel.org"
 <netdev@vger.kernel.org>, "linux-rdma@vger.kernel.org"
 <linux-rdma@vger.kernel.org>, "linux-hyperv@vger.kernel.org"
 <linux-hyperv@vger.kernel.org>, "linux-kernel@vger.kernel.org"
 <linux-kernel@vger.kernel.org>
Subject: Re: [EXTERNAL] Re: [PATCH net-next v11 0/6] net: mana: Per-vPort EQ
 and MSI-X management
Message-ID: <20260602173607.34063034@kernel.org>
In-Reply-To: <SA1PR21MB6683230E973519C12E2AB797CE122@SA1PR21MB6683.namprd21.prod.outlook.com>
References: <20260523020258.1107742-1-longli@microsoft.com>
	<20260527192735.34a794cf@kernel.org>
	<SA1PR21MB6683A7B2415BEAF17BD0EB4ECE092@SA1PR21MB6683.namprd21.prod.outlook.com>
	<SA1PR21MB6683230E973519C12E2AB797CE122@SA1PR21MB6683.namprd21.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 2 Jun 2026 22:48:05 +0000 Long Li wrote:
> Changes in patch 6 from v2 to v11:
> 
>  - Error handling updated from NULL/-ENOMEM to IS_ERR()/PTR_ERR() for mana_gd_get_gic() return values
>  - Added mdev->eqs[i]->eq.irq = gic->irq to populate the irq field on all RDMA EQs for consistency with the Ethernet path
>  - Introduced a separate msi variable instead of modifying spec.eq.msix_index directly
>  - Commit message updated
> 
> The gdma.h changes are identical to v2.

Hm, yes, Leon seems to be AFK since May 19th.
Please repost with his tag included, the list of changes you provided
does seem immaterial. I don't want to merge v11 as is, there's a good
chance people marked this thread as ignored by now.
