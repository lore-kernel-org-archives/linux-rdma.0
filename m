Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C305D1EB5C2;
	Tue, 16 Jun 2026 00:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781569336; cv=none; b=k3gux171PXrNITMHytemOE6qBbPLhw+E21tjtTWhzOkwKVxrbogFKWIHjyoXbDhoJAY8xU1PKY23y5AF/blVqVaePlerAjJvEAHzJYP41ICU7iA9fwv+wZR50OCbvWxEvO9/s/DTiDB66Xb/hhiKh/hj72CN5G719g4gUlPHfB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781569336; c=relaxed/simple;
	bh=UMcVPpruDDkYQYnWRy0Hxa/BKJj2ykG2jrj8uEEVaRA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=C2XdSmTmLi8sHlEq/tstr/TnqO+9pENjoZ8vRSNwEwFlFpDrLPuGpUvpPNVLIKvyIIEJ9rRuVLOKxzORzZE/SG25T5O/ERWQYbNY+L2WgHAhhuCp9yuMxOQ3Km1HRmHnhwsm+6Z2E04QqsjGUfAHjtXrWovk2RqfMUKDEnhURJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=nl2SDowu; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="nl2SDowu"
Received: by linux.microsoft.com (Postfix, from userid 1204)
	id 8BF0F20B7167; Mon, 15 Jun 2026 17:21:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 8BF0F20B7167
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1781569314;
	bh=gi6PoLatD2+bj6j6Y7WdAhMKb6zW6vjj4LAwGsYYOGk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nl2SDowuRY36jNIJ4nTCbCHKG8Ftfi3ovSRYVXDTVjI16204ZM8PKOOY4zlWbOA8S
	 Xc3WCyzhW0kXZf/1PuWMAG9AoGJfKA2w5dgeFqSwx+rx1IEKh4I6o1LKT7N+ZI7fUB
	 Hc2FtkIUzkpjg2YQLxc5s8EQEJgADAQJJazK3daE=
Date: Mon, 15 Jun 2026 17:21:54 -0700
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
	dipayanroy@microsoft.com, leitao@debian.org, kees@kernel.org,
	john.fastabend@gmail.com, hawk@kernel.org, bpf@vger.kernel.org,
	daniel@iogearbox.net, ast@kernel.org, sdf@fomichev.me,
	yury.norov@gmail.com, pavan.chebbi@broadcom.com
Subject: Re: [PATCH net-next v10 0/2] net: mana: add ethtool private flag for
 full-page RX buffers
Message-ID: <ajCXIpDVaVcUcQwd@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260602202801.1873742-1-dipayanroy@linux.microsoft.com>
 <ajBRwYftEol8IE49@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260615134247.0bd7e16e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615134247.0bd7e16e@kernel.org>

On Mon, Jun 15, 2026 at 01:42:47PM -0700, Jakub Kicinski wrote:
> On Mon, 15 Jun 2026 12:25:53 -0700 Dipayaan Roy wrote:
> > Just a gentle ping on this series. The approach was agreed upon, and it
> > has picked up a few Reviewed-by tags as well.
> > 
> > Please let me know if you need anything else from me, or if I should
> > resend it to collect the tags.
> 
> Don't recall now what the exact sequence was but pretty sure this 
> no longer applied after some other mana series was merged.

I see, the net-next is closed now, I will rebase and resend this
once it opens on June 29th.

Regards
Dipayaan Roy
