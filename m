Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64623783C4;
	Sat, 10 Oct 2026 16:29:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791649743; cv=none; b=ZZIWfkCvN5fVTfJNPXDoYqtQzwjWRBPRkNRShQsxe10IIULcpxItbO4EZ0h/ol8wWWMqE4fnXAl9IW7QHvOTpL8HCNcfEiWeBpwZD9ILk5c0w4Ag37GQ6PONviMkGR+fya8zJp6bRKzRR6WnkqwJK326CCQpLXT+ZQ9U7web7Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791649743; c=relaxed/simple;
	bh=upnNnvvd65lyRz//cR6oXD5ptZrwqd3R+JgdBPLEgAw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RTDHYzox8Dmszwq2rTM2G/OXGvXg8fwszgPbkV5TQ+crzu8AU99FnNy6V4WiJGkgmHepKWLB8RUiLfyz3HLEvMvVF7isOMwGwvhE1cm47AEyLxUvx7684mbTgDfwobbNdi7ANHUqmMaVlryDQD/RuCg/v1baAVUcYmp66xrtvC8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=G6sph4zz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="G6sph4zz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC3C1F000FF;
	Sat, 10 Oct 2026 16:28:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791649742;
	bh=i2wb2UWPupDZ/mUYyrqhwi0WMeSN3U+R59Znavn3hWo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=G6sph4zzh6BClUIKGDOPlKmH8/DK71ojEwWPNML39pPH+1VTRJXAQQrXCRXvWJG4L
	 89+BXnsUgEV3yWXUGm+UyUSm59/S20D+PiAZDXNV3iu6ZzyDodDrH7lcr6TeBWeAUD
	 f82ZSZO+7cFYz/xaLLfdmf8uZNN/YqLBqjiWeRlVsO0xZchftuzJLwr/S0j89wxibR
	 wrDx87HaxlQoN3hmkFDyE7QoO3Tsv1AKwE1Jx/y2nPjQdsiOcnkHWCkU7KyBdS2Bc/
	 49DsXZ3h6c9qza0tXfb2pgicW4r1FBmuRDtEBsiaHpObgwWpYtUpVXhyp3psuTcgyP
	 BlC5vqOmtIQiQ==
Date: Sat, 10 Oct 2026 17:28:55 +0100
From: Simon Horman <horms@kernel.org>
To: Wei Hu <weh@linux.microsoft.com>
Cc: longli@kernel.org, kotaranov@microsoft.com, kuba@kernel.org,
	davem@davemloft.net, pabeni@redhat.com, edumazet@google.com,
	andrew+netdev@lunn.ch, jgg@ziepe.ca, leon@kernel.org,
	haiyangz@microsoft.com, wei.liu@kernel.org, decui@microsoft.com,
	shradhagupta@linux.microsoft.com, ernis@linux.microsoft.com,
	stephen@networkplumber.org, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, linux-hyperv@vger.kernel.org,
	linux-kernel@vger.kernel.org, dipayanroy@linux.microsoft.com,
	bpf@vger.kernel.org, sdf@fomichev.me, daniel@iogearbox.net,
	hawk@kernel.org, ast@kernel.org, john.fastabend@gmail.com,
	weh@microsoft.com
Subject: Re: [PATCH net-next v6 00/13] net: mana: reconfigure by replacing
 the queue set
Message-ID: <20261010162855.GU83879@horms.kernel.org>
References: <cover.1790795005.git.weh@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1790795005.git.weh@linux.microsoft.com>

On Fri, Oct 09, 2026 at 02:41:11PM +0000, Wei Hu wrote:
> I am carrying Long Li's queue-set reconfiguration series forward for this
> revision. Long remains the author of twelve patches, and Dipayaan Roy
> remains the author of the detach change. Their authorship and signoffs
> are retained; I have added my signoff for this revision.
> 
> Replace detach/attach reconfiguration with pre-allocation and queue-set
> replacement. Allocation failure leaves the running configuration intact.
> Publication failure attempts rollback; a failed rollback closes the port
> and holds carrier down until a successful reopen.
> 
> EQs and statistics belong to the port. Valid user-configured RSS tables
> survive queue rebuilds. Channel-count changes reuse surviving queues:
> reductions retire the tail and increases allocate only the added queues.
> Ring, MTU, private-flag and XDP layout changes still perform full rebuilds.
> 
> This series does not depend on the pending HWC concurrency/dynamic-depth
> v6 series linked below. Their CQ-publication changes overlap in
> gdma_main.c and hw_channel.c; whichever series lands second will need a
> rebase preserving both table-publication and per-CQ lifetime guarantees.
> Related HWC series:
> https://lore.kernel.org/all/cover.1790665894.git.weh@linux.microsoft.com/

Hi Wei,

Unfortunately this patch-set did not apply cleanly to net-next,
and thus our CI did not run.

Please rebase and repost.

...

--
pw-bot: changes-requested
