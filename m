Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 28ADE3E63AD;
	Tue, 14 Apr 2026 16:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776182457; cv=none; b=lSyWhskC59Bo74JikAsG5g+PE+gcvkVEEsffBPBslQm0aQsbrile6Xz86xzQkjIRto+26z04XIkG1AJ+Ff37y6cJbyRfIMFBHO7IURFO/xSWOC5P2Z7t3iqc4z0aVE/U4IabM8zcwZcMVktpI6ham9NtyAaQGqfgSwFFpkVHfmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776182457; c=relaxed/simple;
	bh=iqcWvzGfXMfXkBPjvGQtMzc0oZwiS8MdvkTlX4lzKlg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hLzdNFett7F+u+tgfKkfuHhanljOW0QcfUdRS19jmDWQHrE6+FEiEUQs7MfhnGv8OKt3LcyFaGD1H50RsaTa5sAmG0lcpWOl6Uys1I6/qV2xgk1VFEC8/T+Da4oJr484ZV1KXQaVN+sBMJAfbwUWBhbrX9tIOEUUC/4aJTaJMyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=oab2yZPg; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="oab2yZPg"
Received: by linux.microsoft.com (Postfix, from userid 1204)
	id 09A2F20B6F01; Tue, 14 Apr 2026 09:00:56 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 09A2F20B6F01
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1776182456;
	bh=AWR6CQPjTVmxYhdo1VXWE39RpfMb8XUKUa90FYqMfu8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=oab2yZPg/3kwwxBCu4UfIDmtQpvY7FWtl7/FcQmGIPSZOLFVg2vqodagLku76f2jE
	 B/1omNyulPRBqOCwKQ4iCz/ay47736GfpJHNa8INB3S/VoJu+erocjRlI/lMFDWYlX
	 Jj35Nxbln7/5q+9Zj5N/m+vmoCu5EaTrsydliUW4=
Date: Tue, 14 Apr 2026 09:00:56 -0700
From: Dipayaan Roy <dipayanroy@linux.microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
	edumazet@google.com, pabeni@redhat.com, leon@kernel.org,
	longli@microsoft.com, kotaranov@microsoft.com, horms@kernel.org,
	shradhagupta@linux.microsoft.com, ssengar@linux.microsoft.com,
	ernis@linux.microsoft.com, shirazsaleem@microsoft.com,
	linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
	stephen@networkplumber.org, jacob.e.keller@intel.com,
	leitao@debian.org, kees@kernel.org, john.fastabend@gmail.com,
	hawk@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
	ast@kernel.org, sdf@fomichev.me, dipayanroy@microsoft.com
Subject: Re: [PATCH net-next v6 0/2] net: mana: add ethtool private flag for
 full-page RX buffers
Message-ID: <ad5kuCZz+gR1TlSh@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260407200216.272659-1-dipayanroy@linux.microsoft.com>
 <20260409183509.0b24dea6@kernel.org>
 <20260412125917.4fa8fc8d@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260412125917.4fa8fc8d@kernel.org>

On Sun, Apr 12, 2026 at 12:59:17PM -0700, Jakub Kicinski wrote:
> On Thu, 9 Apr 2026 18:35:09 -0700 Jakub Kicinski wrote:
> > On Tue,  7 Apr 2026 12:59:17 -0700 Dipayaan Roy wrote:
> > > This behavior is observed on a single platform; other platforms
> > > perform better with page_pool fragments, indicating this is not a
> > > page_pool issue but platform-specific.  
> > 
> > Well, someone has to run some experiments and confirm other ARM
> > platforms are not impacted, with data. I was hoping to do it myself
> > but doesn't look like that will happen in time for the merge window :(
> 
> Please repost with the perf analysis on other commercially available
> ARM platform. Something like:
> 
>   This is a workaround applicable to only some platforms. Modifying
>   driver X to use a similar workaround on [Ampere Max|nVidia
>   Grace|Amazon Graviton 3|..] the performance for split pages is
>   y% higher than when using single pages.
> -- 
> pw-bot: cr

Hi Jakub,

I ran the same experiment on an alternate ARM64 platform from a
different vendor, which I was able to access only recently. I still see
roughly a 5% overhead from the atomic refcount operation itself, but on
that platform there is no throughput drop when using page fragments
versus full-page mode. In both cases, the setup reaches line rate. That
suggests the atomic overhead alone does not explain the throughput loss
on the specific hardware we are discussing.

I also received an update from the hardware team. They collected PCIe
traces and observed stalls on this particular ARM64 prcossor
when running with page fragments, while those stalls are not seen in
full-page mode. The exact root cause is still under investigation, but
their current assessment is that this is likely a microarchitectural
issue in the PCIe root port. Based on that, they are asking for a
software workaround that uses full pages until the issue is fully
understood.

For that reason, I am asking whether this could be accepted as an
ethtool private flag rather than as a generic driver change,
since the problem is still specific to one CPU/platform.
Please let me know whether you think this patch with private flag
would be acceptable here.

Regards
Dipayaan Roy
