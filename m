Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0740F366548;
	Mon, 15 Jun 2026 19:26:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781551575; cv=none; b=RdCDYjbLOjOIsZMBV03CW4hUqZGHMYXs2WQH08qCzAk2dJjYvBnQ5ClYsA9+BkXrztgj0tSBXrMUFwDFhAYOh5Voi4rCN2FLIpVNRXCoyiWyc30tspTq7+rK3frUSUvgY4EcyycEqPVbGeDLv1Vwk3zHLyxPYzh62T4oKw7rXRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781551575; c=relaxed/simple;
	bh=Kt7JepatYiaDYrc83/aTUL0FSumc4vfp3Zw2NvHMWNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ueUcIn1rjVkaOwMRbRHEmgXG560R9yiMK2wmr2UBIyMmPegqlYQv80/N0wcKCGDelccaSbFMDebi6hzDhu/LFFDt3rWJDIdYkt1KXJcE4C8a/HVh0x5YyXsWzmz66b6k5G4F7mQc8xgEHiCrKZEVv7cn/8dYazQYAGG2ZM1+ROI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=LVzDT/Ex; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="LVzDT/Ex"
Received: by linux.microsoft.com (Postfix, from userid 1204)
	id 0FE4D20B7167; Mon, 15 Jun 2026 12:25:53 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 0FE4D20B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1781551553;
	bh=UTL6An4CoAyf1IcOJ8/3F+Xidzg64tut6XSjHQdabtY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LVzDT/ExANWTEy9J0XIGztF1eoUYEUfWKvWIMxZWbMwzbj4IMIhPM9oUbDmNx8bvd
	 4pFoVA/dJGLRViK8oOvAncerx3ugF5Qtg+zsmb+7cZrZkPbGTStdhTZ/K+Dsr+/8Ql
	 WyFKTFL0N7NrftktIZZwuwpenQoUY4ayRK1+7gWI=
Date: Mon, 15 Jun 2026 12:25:53 -0700
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	leon@kernel.org, longli@microsoft.com, kotaranov@microsoft.com,
	horms@kernel.org, shradhagupta@linux.microsoft.com,
	ssengar@linux.microsoft.com, ernis@linux.microsoft.com,
	shirazsaleem@microsoft.com, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org, stephen@networkplumber.org,
	jacob.e.keller@intel.com, dipayanroy@microsoft.com,
	leitao@debian.org, kees@kernel.org, john.fastabend@gmail.com,
	hawk@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
	ast@kernel.org, sdf@fomichev.me, yury.norov@gmail.com,
	pavan.chebbi@broadcom.com
Cc: kuba@kernel.org
Subject: Re: [PATCH net-next v10 0/2] net: mana: add ethtool private flag for
 full-page RX buffers
Message-ID: <ajBRwYftEol8IE49@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260602202801.1873742-1-dipayanroy@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602202801.1873742-1-dipayanroy@linux.microsoft.com>

On Tue, Jun 02, 2026 at 01:24:37PM -0700, Dipayaan Roy wrote:
> On some ARM64 platforms with 4K PAGE_SIZE, utilizing page_pool
> fragments for allocation in the RX refill path (~2kB buffer per fragment)
> causes 15-20% throughput regression under high connection counts
> (>16 TCP streams at 180+ Gbps). Using full-page buffers on these
> platforms shows no regression and restores line-rate performance.
> 
> This behavior is observed on a single platform; other platforms
> perform better with page_pool fragments, indicating this is not a
> page_pool issue but platform-specific.
> 
> This series adds an ethtool private flag "full-page-rx" to let the
> user opt in to one RX buffer per page:
> 
>   ethtool --set-priv-flags eth0 full-page-rx on
> 
> There is no behavioral change by default. The flag can be persisted
> via udev rule for affected platforms.
> 
> This series depends on the following fixes now merged in net-next:
>   17bfe0a8c014 ("net: mana: add NULL guards in teardown path to prevent panic")
>   5b05aa36ee24 ("net: mana: skip redundant detach on already-detached port")
> 
> Changes in v10:
>   - Rebased on net-next which now includes the prerequisite fixes.
>   - Recovery logic in mana_set_priv_flags() leverages the idempotent
>     mana_detach() from the merged fixes.
> Changes in v9:
>   - Added correct tree.
> Changes in v8:
>   - Fixed queue_reset_work recovery by restoring port_is_up before
>     scheduling reset so the handler can properly re-attach.
>   - Simplified "err && schedule_port_reset" to "schedule_port_reset".
> Changes in v7:
>   - Rebased onto net-next.
>   - Retained private flag approach after David Wei's testing on
>     Grace (ARM64) confirmed that fragment mode outperforms
>     full-page mode on other platforms, validating this is a
>     single-platform workaround rather than a generic issue.
> Changes in v6:
>   - Added missed maintainers.
> Changes in v5:
>   - Split prep refactor into separate patch (patch 1/2)
> Changes in v4:
>   - Dropping the smbios string parsing and add ethtool priv flag
>     to reconfigure the queues with full page rx buffers.
> Changes in v3:
>   - changed u8* to char*
> Changes in v2:
>   - separate reading string index and the string, remove inline.
> 
> Dipayaan Roy (2):
>   net: mana: refactor mana_get_strings() and mana_get_sset_count() to
>     use switch
>   net: mana: force full-page RX buffers via ethtool private flag
> 
>  drivers/net/ethernet/microsoft/mana/mana_en.c |  22 ++-
>  .../ethernet/microsoft/mana/mana_ethtool.c    | 178 +++++++++++++++---
>  include/net/mana/mana.h                       |   8 +
>  3 files changed, 177 insertions(+), 31 deletions(-)
> 
> -- 
> 2.43.0
>

Hi Jakub,

Just a gentle ping on this series. The approach was agreed upon, and it
has picked up a few Reviewed-by tags as well.

Please let me know if you need anything else from me, or if I should
resend it to collect the tags.

Thanks,
Dipayaan Roy
 
