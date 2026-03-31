Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 17D8D2D77F5;
	Tue, 31 Mar 2026 17:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774979905; cv=none; b=JVeF8dyrG3Gy56iK0eFcUXwAZQntkqL8ufaTZPTWomhPUoKy7NRWK+rtO5TARBWKIVy5hg9s6soMhfsZYChPldcJoZrGYnjq/d8PlZ7FFRpwK3AJTxVLvvNgV2B50nZ8CwEWlXead7Q9Cevc4evF3KtjA3jVyjDL/emcBSsy3p4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774979905; c=relaxed/simple;
	bh=o4JQSRMSrZkTH0rTDnWxywy+ATTRE1+/o1CIMTObSyc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UXF4JkX65SJGX5l4/KU/VEpEzINO/Sswgjg1/jk2ucVav1+jAPKCN6ZG6kEQBHd+R6Fx0JlmsIwvsnGxHAXOyUo2pvlr0n7AGToR5r2CYIoAM9CuQNjNyNGimRuC1Gv8RCEQtDlqc0Q+/WIwJYcxHt9kBxzCwXITYxCQlaFexNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=gH4zDWf3; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="gH4zDWf3"
Received: by linux.microsoft.com (Postfix, from userid 1173)
	id 373DE20B712B; Tue, 31 Mar 2026 10:58:24 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 373DE20B712B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1774979904;
	bh=DP28GbdRwa/FfrIzPEzx5BeaVDcFUHdYnAJ06F+116I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gH4zDWf3vg47RlWXfZ/asHM8JIoBOB7S7tUJr4DZ3WB+O3TIdsJH90ZxlMoPqj/CA
	 UjrCrsbUWowNNBe6yImcEjMKWFKzEfwLTLQ6GCZ0cXgGFTJpB0a4iuP3Q8wNuyFFLQ
	 PaECQJZkRFINwtHeaboT/LLgU6Fz+vuxuIbpRk7o=
Date: Tue, 31 Mar 2026 10:58:24 -0700
From: Erni Sri Satya Vennela <ernis@linux.microsoft.com>
To: Jakub Kicinski <kuba@kernel.org>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
	decui@microsoft.com, longli@microsoft.com, andrew+netdev@lunn.ch,
	davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
	kotaranov@microsoft.com, horms@kernel.org,
	shradhagupta@linux.microsoft.com, shirazsaleem@microsoft.com,
	dipayanroy@linux.microsoft.com, yury.norov@gmail.com,
	kees@kernel.org, ssengar@linux.microsoft.com,
	gargaditya@linux.microsoft.com, linux-hyperv@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org
Subject: Re: [PATCH net-next v4] net: mana: Expose hardware diagnostic info
 via debugfs
Message-ID: <acwLQMvJc/Q25mJa@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <20260319070926.1459515-1-ernis@linux.microsoft.com>
 <20260323174444.2717da3d@kernel.org>
 <acK56AlPfVW8cDPe@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <acrKgG0USsGABqYT@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <20260330152318.144c1b30@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260330152318.144c1b30@kernel.org>

On Mon, Mar 30, 2026 at 03:23:18PM -0700, Jakub Kicinski wrote:
> On Mon, 30 Mar 2026 12:09:52 -0700 Erni Sri Satya Vennela wrote:
> > Just a quick follow‑up on this. Since these issues were pre‑existing and
> > not introduced by this patch, would you prefer that I send them as a
> > separate fix patch, or fold the fixes into the current patch?
> 
> Anything that's pre-existing should be a separate patch, before any new
> code. If the bug exists only in net-next - earlier in the same series,
> if the bug exists in net - posted separately for the net tree.

Thankyou for the explanation. 
I will send it in a separate patch.

- Vennela
