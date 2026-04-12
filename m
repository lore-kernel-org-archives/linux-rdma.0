Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E623137CD3C;
	Sun, 12 Apr 2026 19:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776023961; cv=none; b=RVmC9lQRbqqRlB7mPyb8h3YM+obPh+lkiQG4M1LyG4IVqOG2xSdk6k0c+8Bx8J07MOcwybyDTahw7lrZBzpDUY1SaKUBymwbG61NR+qNCyXX+i8jL08a1EYEJGOzdcMv5ZIOrjYiqZzJ0w+XnauNkzZfoLRt+9kpSNZSW5kCKvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776023961; c=relaxed/simple;
	bh=5JFGMjojVLjVjBuXH5cwllbciCfN+kWLL0KPdVKa2C8=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SEklIZKgYitKGQ1QE/TNz/xIuSut2rEnJnWfG8e+9nUZbVNCLdzgy43XSlFFMq0m0HgQBSzbqbFrbT1Xtyw1QjAJN/rQrEFzdEUJOvYyhnItFN9IjMq/rxPUKdLYFANWbKmab2RRyo4qbd+/xTvPypfgHjPm1GvsYVjSuw1+VjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SJK2fyDo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SJK2fyDo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7F10C19424;
	Sun, 12 Apr 2026 19:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776023960;
	bh=5JFGMjojVLjVjBuXH5cwllbciCfN+kWLL0KPdVKa2C8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SJK2fyDoSooRHzLNt5CadoC2V/OLevsHmQiX/kwT/hgDiCMZW47r0vtntQ5y5dPsX
	 FUAjq5nH42WG1qkmVtNMKRCGqTlM5d8iDQIQFaQ/13fh+wMVHAggqU8y3hvTkcBe3n
	 uYg3WHRpNVBKr/cr9eSeX82hsA78TSYOXNLfcLoekJFloux2HRtLUM7Cf8xjSuvWIF
	 v8lsRzCaMsab/lUygANYwMTUqb9Bt5I7kQEuH7dq9TmnN2x+AMIfUWxl2IzcjHRi5G
	 LPAfcQhTkXsAd0KJcx5+qEXaSEsnlBJJYK79GEqu0WJo6skejxRwcSOkzeLiFdvGB+
	 XX8BuDDmOFIwQ==
Date: Sun, 12 Apr 2026 12:59:17 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Dipayaan Roy <dipayanroy@linux.microsoft.com>
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, andrew+netdev@lunn.ch, davem@davemloft.net,
 edumazet@google.com, pabeni@redhat.com, leon@kernel.org,
 longli@microsoft.com, kotaranov@microsoft.com, horms@kernel.org,
 shradhagupta@linux.microsoft.com, ssengar@linux.microsoft.com,
 ernis@linux.microsoft.com, shirazsaleem@microsoft.com,
 linux-hyperv@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org,
 stephen@networkplumber.org, jacob.e.keller@intel.com, leitao@debian.org,
 kees@kernel.org, john.fastabend@gmail.com, hawk@kernel.org,
 bpf@vger.kernel.org, daniel@iogearbox.net, ast@kernel.org, sdf@fomichev.me,
 dipayanroy@microsoft.com
Subject: Re: [PATCH net-next v6 0/2] net: mana: add ethtool private flag for
 full-page RX buffers
Message-ID: <20260412125917.4fa8fc8d@kernel.org>
In-Reply-To: <20260409183509.0b24dea6@kernel.org>
References: <20260407200216.272659-1-dipayanroy@linux.microsoft.com>
	<20260409183509.0b24dea6@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 9 Apr 2026 18:35:09 -0700 Jakub Kicinski wrote:
> On Tue,  7 Apr 2026 12:59:17 -0700 Dipayaan Roy wrote:
> > This behavior is observed on a single platform; other platforms
> > perform better with page_pool fragments, indicating this is not a
> > page_pool issue but platform-specific.  
> 
> Well, someone has to run some experiments and confirm other ARM
> platforms are not impacted, with data. I was hoping to do it myself
> but doesn't look like that will happen in time for the merge window :(

Please repost with the perf analysis on other commercially available
ARM platform. Something like:

  This is a workaround applicable to only some platforms. Modifying
  driver X to use a similar workaround on [Ampere Max|nVidia
  Grace|Amazon Graviton 3|..] the performance for split pages is
  y% higher than when using single pages.
-- 
pw-bot: cr
