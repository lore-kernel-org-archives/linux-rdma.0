Received: from fhigh-a8-smtp.messagingengine.com (fhigh-a8-smtp.messagingengine.com [103.168.172.159])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 654E845040D;
	Thu, 20 Aug 2026 13:27:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.159
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787232453; cv=none; b=CHCBVygG91nIukWYVIrGgbtXn/19dXwB+bpVtp2apttlFvEAqgAC6v/ciit10pDpHv9ewvo3LNBbmrwvUpi+2s2tjRFpqgXuoRFhU/9RBEvXWWqd3LEzuE0+htG8q8BSiHcvAun5+ONdcstEM42xKyyXZGe3zyvI/TxWyDGOLDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787232453; c=relaxed/simple;
	bh=TAqznz15wgPfHo3xEvzGtxlg0S2lx26s7Bov3a65OPc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KiQjkpJc3f6oSGyopmSH9ewo9yhpxqRFr5QRLpM0htk1ufwLVMWHvNYlohMIRuvFAALiKdDRfrN4hT0TaI8YlhKZ1xcj3fuzmEmYz775lowNTY2tP8oF9meSYgpqWklYJspM5IUyFPGcDBaaJ9fkaNRhoblvExrE0cDtKEqYCMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=EODRIw3P; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=d4z0BTyc; arc=none smtp.client-ip=103.168.172.159
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="EODRIw3P";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="d4z0BTyc"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 5DB0914000F9;
	Thu, 20 Aug 2026 09:27:30 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Thu, 20 Aug 2026 09:27:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1787232450; x=
	1787318850; bh=4Ozy3CczgOizZ3ooFCppKIjSA7fkYEtdaAuwRLg7kbU=; b=E
	ODRIw3P2o1acvpUAqB72OM7hK828HA4AEGL7JzwwmMOfO/ncvj6zaV25GHFUOXAd
	4alwM0WIJtrx/07sWpU0q9o0MlmoS516ZXhz5w0/TVVZV+h4s0z76t+RNZvQiA0a
	Ybqu/tJyb9RbnTHVhInmsdmjhPp1t5S3m7SFdi6LwCNGHyJO+wlfgflYvI1skpEG
	MwYd1YTdsRKAPowaxhTozYRGj1xkWy2ot/9mbsW9zfyfpT7evJQNWY8Kc36dzrG4
	X8rx28meskatUlgr9Dqrr/mOk3o0msUdGjuwIIqlzQhbQjGmnY+uw0H4U4Pxv8uy
	D2crUL7NA7JlIknhkw+Iw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787232450; x=1787318850; bh=4Ozy3CczgOizZ3ooFCppKIjSA7fkYEtdaAu
	wRLg7kbU=; b=d4z0BTycjChykZU1niYaj7gAn+TEb7PaorwazbN5uNjSN1Gklyz
	0bGJt0Kf6GrgD4StCK1QcI5v2cElqeLub/EdavWJJ+D0hTgfvOrCy67Z1G2+j31z
	d1euHASEcrF51Rlg8JkVcns9yvV5j6cwXH9nxjGlV6JUrzr5JN1R+De+iRqLRabn
	+2Qgt1/U3zwpAkFM9Fbut0v14Dkx/vKwxWrus7omgNVhSgp25LF8M9wMZyXG4Qz4
	bIVNSpCu87Z1RwXte9hLE611iQMYocKWW6CF/1JkQ1cXI5QDxQ6vBimhzAJlLuT7
	y1b7IfVWnzAgx1+Wy6oA4Sp+wwp3PXCbDCw==
X-ME-Sender: <xms:wQCHasFuB8LJ9TeH7QvEB3gn-XxmvGbmB7FDrkBxE5DvIeHl3ER_zw>
    <xme:wQCHaop8KbndauSCo9fxeOQHmHkV4fqeVRHg_B7zGMUmxX9DTsptntwkiAQkIMjpJ
    IAxCZY7vexw6rutRJQYXyGTsjWd_uTOOyP3VzLJkHyiL_r_d7co_sGW>
X-ME-Received: <xmr:wQCHaqOs_aXMJZKFYhML8XvvB3xnXVf-qSaaJVuCzk4umQEgTkIJ9ksI_r4>
X-ME-Proxy-Cause: dmFkZTEoKWm6bbmmfKi8x+K64Bxlg2CB2ySvnBwPrS1jXCXrk+eT4gF4UsCKBI5mmn6nm6
    60dm5WiLU3C4ooe5Pk2R042r9JhGRWPI4U8qW/2GOICA1YTtX5yENYuOuFlIecdJVuWR/w
    5JGXSbmyBZhjSNoTK2zFoJKBzMljg4Jc9hIgPbXyLQw7jrbietBBxSHh1AiAfo1n1bvrLW
    qn8jrbWy3WhtmSFEgBwZdQxOxJOXdzvw78mkoULr1Y6Q5l0wDkEO1Kdj+eWSSV6ljPRsZA
    CL5JMXuJcVo7h0NaIjspEMlNGtoTil/pue8HDKYy5THLX0778c/3xdRsjTjEuyjpul/QLt
    aF4PiCfx1WRJe4eFQAex2bzNi43lzQxmOeRwqDlQnAMimRgm0BpmnF4jgtVcZL+4xxeyYh
    tXBXiCYKLmv5WaqY5rlD2ICC3W6go5soIqOIegCyG6+m62SVB2j3G4tTKLEdrEX+MynZiF
    6/cAoU3xCRTJipaFsMy+2toLPoljjNDoqIpl+j3ouLTC5UgptPnjYOunOKRRno9OLqCyHk
    x2WY6lMCRD+gt8AIe28D55YhWoGNr2WLc7Ybsq8nQjIJQvL7M2ckIEU2Du+HOBNFtBj2yf
    WWAbNidtxuzP/HJSAAX+Bz8r/0LtsO7Jn68I2EmckseVmg6Ki4jxx5c3AJGg
X-ME-Proxy: <xmx:wQCHakc9MEuLFfvEzNeb5Pr9JuA039uguEI6PYwYrwEAEPMNl2TqFA>
    <xmx:wQCHaoQk4LldvSf0eRdTXHa74QTPOGcpuby8QszIaaprPncX9NpdDA>
    <xmx:wQCHajoqwx894LBwB-ltGDxUGmE992BMq71Jlys4T8xbbx4MtpZpow>
    <xmx:wQCHau6KVsNnv_pNePY2FqvioCzKQBg-lFQW5Wnhb6PWBbgI_n-cKQ>
    <xmx:wgCHamfXySBPmm6VzFXjELx3tJldPDBMdhRwZ9pl45wgFfqiBQ1nlqHs>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 20 Aug 2026 09:27:29 -0400 (EDT)
Date: Thu, 20 Aug 2026 14:27:27 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Qi Xi <xiqi2@huawei.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, longli@microsoft.com, 
	kotaranov@microsoft.com, jan.kiszka@siemens.com, kbingham@kernel.org, surenb@google.com, 
	mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, 
	linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, sunnanyong@huawei.com, 
	wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm: drop stale MAX_ORDER references
Message-ID: <aocAePwuxr4te2jG@thinkstation>
References: <20260818122408.4182417-1-xiqi2@huawei.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260818122408.4182417-1-xiqi2@huawei.com>

On Tue, Aug 18, 2026 at 08:24:08PM +0800, Qi Xi wrote:
> The treewide rename in commit 5e0a760b4441 ("mm, treewide: rename
> MAX_ORDER to MAX_PAGE_ORDER") left a few spots still using the old
> name:
> 
>   - two comments in include/net/mana/mana.h and mm/page_alloc.c;
>   - the gdb helper scripts/gdb/linux/mm.py, where self.MAX_ORDER is
>     a local mirror of the kernel's MAX_ORDER define.
> 
> Rename the leftover instances to MAX_PAGE_ORDER so the tree is
> consistent.
> 
> No functional changes.
> 
> Signed-off-by: Qi Xi <xiqi2@huawei.com>
> ---
>  include/net/mana/mana.h | 4 ++--
>  mm/page_alloc.c         | 2 +-
>  scripts/gdb/linux/mm.py | 8 ++++----
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
> index 04acb6791dbd..1d5bed71d6a7 100644
> --- a/include/net/mana/mana.h
> +++ b/include/net/mana/mana.h
> @@ -40,8 +40,8 @@ enum TRI_STATE {
>  #define COMP_ENTRY_SIZE 64
>  
>  /* This Max value for RX buffers is derived from __alloc_page()'s max page
> - * allocation calculation. It allows maximum 2^(MAX_ORDER -1) pages. RX buffer
> - * size beyond this value gets rejected by __alloc_page() call.
> + * allocation calculation. It allows maximum 2^(MAX_PAGE_ORDER -1) pages. RX

Should it reference MAX_ORDER_NR_PAGES instead?

> + * buffer size beyond this value gets rejected by __alloc_page() call.
>   */
>  #define MAX_RX_BUFFERS_PER_QUEUE 8192
>  #define DEF_RX_BUFFERS_PER_QUEUE 1024

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
