Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 889A129346F;
	Sun,  5 Jul 2026 17:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783272285; cv=none; b=W7spDhtKv9pPrA8GgFi0Hz1C8iKZfYFk5dhCKeBue8nHvuidkYLkWWlpv4DZpZjPt9Jc15GG/+luHieS8E4ZMfMYeRrHEnWAcyTjz+3BbNZ45uy4s9aWm2OMP49XLm5uKEqJSNW9RukEuHvtOr/L4ejXEYedg+cpERK8LU7uaPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783272285; c=relaxed/simple;
	bh=ivc2Qyu03bsUwPfyfSqWTtgsSWP9nEpWKZSwBdnTgPs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kURxGnNKhYP9A4M/8UnMY+y+vYNItEOnAqOAyg387AXEZBOTmrNxU65UUBDGt4UskZnfXCLWz8fa7m5O1w/sbjBrLVQQIXI4fGxxukPrdUmS5xU/VJloIWWCObx1t+ojkuCUX7KvzFq/PqtaMehMdaETIwnetw9jKpAO1NUXeRY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=k6EADjin; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="k6EADjin"
Received: by linux.microsoft.com (Postfix, from userid 1204)
	id 3980820B7169; Sun,  5 Jul 2026 10:17:38 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 3980820B7169
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1783271858;
	bh=3dPjdWDTR7+OAoy9Jk8DWgNI00d9M34YmpuKKbFFwwk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=k6EADjiny73p0uLx3h67fvzSPSoPHuvczsAtsve5HPQ8VQvD0vXYAr7SqI2hpe6ek
	 1y4A1QT5bYx2G1q3un0T+h6eryDlWNNF0Rk7KYqb8PFUpcTLJijrlznbPZYdQnZmtg
	 ucYKWefT4woErJlf5PLK2Je6CfmtJ/RJrFpQpOoE=
Date: Sun, 5 Jul 2026 10:17:38 -0700
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
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
Subject: Re: [PATCH net-next v11 0/2] net: mana: add ethtool private flag for
 full-page RX buffers
Message-ID: <akqRspl/M5mBvdsH@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260701141808.461554-1-dipayanroy@linux.microsoft.com>
 <akUn+nMBrjbUts2N@boxer>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <akUn+nMBrjbUts2N@boxer>

On Wed, Jul 01, 2026 at 04:45:14PM +0200, Maciej Fijalkowski wrote:
> On Wed, Jul 01, 2026 at 07:15:44AM -0700, Dipayaan Roy wrote:
> > On some ARM64 platforms with 4K PAGE_SIZE, utilizing page_pool
> > fragments for allocation in the RX refill path (~2kB buffer per fragment)
> > causes 15-20% throughput regression under high connection counts
> > (>16 TCP streams at 180+ Gbps). Using full-page buffers on these
> > platforms shows no regression and restores line-rate performance.
> > 
> > This behavior is observed on a single platform; other platforms
> > perform better with page_pool fragments, indicating this is not a
> > page_pool issue but platform-specific.
> > 
> > This series adds an ethtool private flag "full-page-rx" to let the
> > user opt in to one RX buffer per page:
> > 
> >   ethtool --set-priv-flags eth0 full-page-rx on
> > 
> > There is no behavioral change by default. The flag can be persisted
> > via udev rule for affected platforms.
> 
> Were you able to track down what is the actual bottleneck on the 'broken'
> platform? What is the performance of full-page approach on healthy
> platforms? On changelog below you mention the frag approach 'outperforms'
> the full-page one.
> 
Hi Maciej,

The HW team identified a PCIE root port stall occurring due to a PCIe
errata in a HW IP used for this platform. Using full pages increases the
time in packet refill path and indirectly helping to reduce the back pressure
in NIC pipeline caused due to the stall in root port. As per them it
will be fixed in next version of this hw which is not anytime soon.

On various other healthy platforms with 4k base page size we tested, we see
improvements using page fragments than full pages around anywhere between 5 to 15%.

Regards
Dipayaan Roy

> > 
> > This series depends on the following fixes now merged in net-next:
> >   commit 17bfe0a8c014 ("net: mana: Add NULL guards in teardown path to prevent panic on attach failure")
> >   commit 5b05aa36ee24 ("net: mana: Skip redundant detach on already-detached port")
> > 
> > Changes in v11:
> >   - Rebased on net-next
> > Changes in v10:
> >   - Rebased on net-next which now includes the prerequisite fixes.
> >   - Recovery logic in mana_set_priv_flags() leverages the idempotent
> >     mana_detach() from the merged fixes.
> > Changes in v9:
> >   - Added correct tree.
> > Changes in v8:
> >   - Fixed queue_reset_work recovery by restoring port_is_up before
> >     scheduling reset so the handler can properly re-attach.
> >   - Simplified "err && schedule_port_reset" to "schedule_port_reset".
> > Changes in v7:
> >   - Rebased onto net-next.
> >   - Retained private flag approach after David Wei's testing on
> >     Grace (ARM64) confirmed that fragment mode outperforms
> >     full-page mode on other platforms, validating this is a
> >     single-platform workaround rather than a generic issue.
> > Changes in v6:
> >   - Added missed maintainers.
> > Changes in v5:
> >   - Split prep refactor into separate patch (patch 1/2)
> > Changes in v4:
> >   - Dropping the smbios string parsing and add ethtool priv flag
> >     to reconfigure the queues with full page rx buffers.
> > Changes in v3:
> >   - changed u8* to char*
> > Changes in v2:
> >   - separate reading string index and the string, remove inline.
> > 
> > Dipayaan Roy (2):
> >   net: mana: refactor mana_get_strings() and mana_get_sset_count() to
> >     use switch
> >   net: mana: force full-page RX buffers via ethtool private flag
> > 
> >  drivers/net/ethernet/microsoft/mana/mana_en.c |  22 ++-
> >  .../ethernet/microsoft/mana/mana_ethtool.c    | 178 +++++++++++++++---
> >  include/net/mana/mana.h                       |   8 +
> >  3 files changed, 177 insertions(+), 31 deletions(-)
> > 
> > -- 
> > 2.43.0
> > 
> > 
