Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8240F308F05;
	Mon, 27 Apr 2026 22:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777329872; cv=none; b=q/TSrzFRt6jKdAHq47NxCtKV9jT6pSz/J1tpD4//G+BrMUk4Wdzi1BU5E+zV4h82T+l8vqEDigA/fSSA2IjsroL51PAUsvmRcnF6GRj2Dtl+k5aKxbdzpBU8i/gDnszBCDBplQGj7Yg+qzzvmffcJxEYp6IY18VXahCvnj8CUTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777329872; c=relaxed/simple;
	bh=R4LMRbc5mg+8UIeUjMdT+Efo6WUGtul9TLdlExK2ELg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b4I7Zo4AwGZQTno7qf7eXzV/7kFVPUuITcE82Py3Sa+r1x1fdKwopcKRG9v/yjZehScNvb6DFBCplKpqebH/LmNJ8SmE+w8KUSbsfdTrWBYRBROxFwaN+/exxMcg4rKmi88UarAjjc2tg5q4HNT4WrtYfTtVBTgdFHCDbkRcuHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c6RgOq+V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c6RgOq+V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4E5C19425;
	Mon, 27 Apr 2026 22:44:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777329872;
	bh=R4LMRbc5mg+8UIeUjMdT+Efo6WUGtul9TLdlExK2ELg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=c6RgOq+VoUwVn47JnHkDjnuu/vZqEpPZOlm1WZEXW/vRsvPtcEGYyFKv9mV4QRI4g
	 sHTuo03n9gQ59wKHHTU91b6z0CY/HRapOAxL2u/H9v68niu59kvE7L5CJ2Iy6q5Fcz
	 kZd2yb5mLU38GFtoTykuyYSTBnimjRDQyc3jh7DMUtOdDR3mxaT+iXvNAGF1i8Trea
	 iBZ4c3jzhxByCX3W8ZYweQjMeL1Muhoo7vEde1Ax8Q7FfB/RsIs7uz1aGjkDSFpWCl
	 r8WFeBXaND+y38YxAN8HcdklDfKfu+lLMFdQ1u/b4uYKWE6Ulb9sPXLQ7YyM35dihO
	 /dYNut8aAZ1Ng==
Date: Mon, 27 Apr 2026 15:44:29 -0700
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
 stephen@networkplumber.org, jacob.e.keller@intel.com,
 dipayanroy@microsoft.com, leitao@debian.org, kees@kernel.org,
 john.fastabend@gmail.com, hawk@kernel.org, bpf@vger.kernel.org,
 daniel@iogearbox.net, ast@kernel.org, sdf@fomichev.me, yury.norov@gmail.com
Subject: Re: [RFC PATCH net-next] net: mana: Force single RX buffer per page
 under SWIOTLB bounce modes
Message-ID: <20260427154429.6a141824@kernel.org>
In-Reply-To: <ae91hyrLf4n23XE6@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <ae91hyrLf4n23XE6@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 27 Apr 2026 07:41:11 -0700 Dipayaan Roy wrote:
> In both cases, sub-page RX buffer fragments allocated via page_pool may
> not be compatible with bounce buffering in this mode, leading to failures
> in the RX path.

What does it mean to not be compatible with swiotlb?
Normally that indicates that DMA API is mis-used.
