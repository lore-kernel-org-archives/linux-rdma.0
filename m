Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F7A9363C67;
	Mon,  9 Mar 2026 11:49:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773056951; cv=none; b=KSKUd6WrrVgCQRQi3wUX1tHRtHloh2RzV3O1tiBIQd185AyCWlh8KsT7sCOl0w05ljRyb8/AhhCD+tcjsOpqd7r5A86SrlQpsPzfhrScAprdH5sNMAjBfpIu+0brBLZX62qPk+03/iZGdOXbMLs3B1wVdfR6tupEeQ93saaCyyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773056951; c=relaxed/simple;
	bh=obQesHjTuGhDPBJexa2y8wWPRcB8s0PhWfaj0ISSGlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=EalmE+jbmSWFIfBKB7c2VpA2I59uA7oQZLLNQDGqNCVM4qyxvfE5byNmLecN3PSSy+WMK9qEhgui3ArgrfRsJ2Ki50kYGzF4xv/PAmd2sX4kxdERaWdGy066nY5KVoON6MkBMoCEl8JUjHY77vJgANjpGtqo5Kp4tqKXg+Wmyso=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=CC/c5xLJ; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="CC/c5xLJ"
Received: by linux.microsoft.com (Postfix, from userid 1173)
	id C970120B6F00; Mon,  9 Mar 2026 04:49:04 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C970120B6F00
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1773056944;
	bh=cxVRrtJ71QEmYzTtxLKbAa1noqi4UA66TYgCcNfu/wA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CC/c5xLJ6lvrk8s1aRfhuZpo+kr1NGLmtQscc+e1g+CR+63OhbqJDJurfTSVAUTdL
	 bhHh4taR1Y5p4mDeAe/hpqzUtQoRiThE1CF4X2oXYb2QxJWQLvTQXlXw0aJpZc3SA6
	 trDyaKoyYUup559O/FS1lyT/sivsxNIyo5nJQnbo=
Date: Mon, 9 Mar 2026 04:49:04 -0700
From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: pabeni@redhat.com, linux-kernel@vger.kernel.org, yury.norov@gmail.com,
	kys@microsoft.com, decui@microsoft.com, kees@kernel.org,
	longli@microsoft.com, dipayanroy@linux.microsoft.com,
	davem@davemloft.net, netdev@vger.kernel.org,
	linux-rdma@vger.kernel.org, kotaranov@microsoft.com,
	andrew+netdev@lunn.ch, linux-hyperv@vger.kernel.org,
	edumazet@google.com, haiyangz@microsoft.com,
	ssengar@linux.microsoft.com, shradhagupta@linux.microsoft.com,
	horms@kernel.org, shirazsaleem@microsoft.com, wei.liu@kernel.org
Subject: Re: [net-next] net: mana: Expose hardware diagnostic info via debugfs
Message-ID: <aa6zsEiJahwMKjKt@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260305205252.470089-1-ernis@linux.microsoft.com>
 <20260307032228.1379456-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260307032228.1379456-1-kuba@kernel.org>

On Fri, Mar 06, 2026 at 07:22:28PM -0800, Jakub Kicinski wrote:
> This is an AI-generated review of your patch. The human sending this
> email has considered the AI review valid, or at least plausible.
> 
> For local reproduction steps see https://netdev-ai.bots.linux.dev/ai-local.html
> ---
> net: mana: Expose hardware diagnostic info via debugfs
> 
> This commit adds debugfs entries to expose hardware configuration and
> diagnostic information for the MANA driver. It creates device-level and
> port-level debugfs entries to aid in debugging initialization and runtime
> operations.
 
> Do these debugfs entries get recreated on every suspend/resume cycle?
No. Thankyou for pointing out Jakub.
I'll  make this change in next version.
> 
> Both mana_gd_query_max_resources() and mana_gd_verify_vf_version() are
> called from mana_gd_setup() during device initialization. On suspend,
> mana_gd_suspend() calls mana_gd_cleanup() which doesn't remove these
> debugfs entries. When mana_gd_resume() calls mana_gd_setup() again, it
> attempts to create the same debugfs entries a second time.
> 
> This means debugfs_start_creating() in fs/debugfs/inode.c will print an
> error for each duplicate file:
> 
>     "'num_msix_usable' already exists in 'mana/<slot>/'"
>     "'max_num_queues' already exists in 'mana/<slot>/'"
>     "'gdma_protocol_ver' already exists in 'mana/<slot>/'"
>     "'pf_cap_flags1' already exists in 'mana/<slot>/'"
> 
> This produces 4 error messages in dmesg on every suspend/resume cycle,
> contradicting the commit message's goal of operating "without adding
> noise to dmesg."
> 
> Should these device-level entries be removed during suspend (in
> mana_gd_cleanup or mana_gd_suspend), or should their creation be moved
> to mana_gd_probe where they're only created once?
Right. I will remove the entries during suspend and re-create them in
resume. 
> 
> [ ... ]
> -- 
> pw-bot: cr
