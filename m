Received: from fhigh-a1-smtp.messagingengine.com (fhigh-a1-smtp.messagingengine.com [103.168.172.152])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D44AB8635D;
	Thu, 20 Aug 2026 15:00:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.152
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787238037; cv=none; b=riKrfh6lenirNzYO3IoqF8ZaQNZrG3k86l2wpr8ZXA4SwIsTJRgHE1TBPhlmgy94lmipeBKgAOvPUSDUy8SGPIAM/osEAepieJrKc3CXicE8BSwMx4EPdyWheofpsyrfqFj4O8bOX9pm9IctO4E5WW7JiHhWfE59WCAGhofetvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787238037; c=relaxed/simple;
	bh=XY4JzP5ma2KQH4gyE4kaYXAqEKpyo5FR9wDQl00t85Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PwcIJxUqElhfnRXuKMVsFctffTGR2LmApDjVrhYCY5OX1FuuUfLgalH+NI9ztWAgsQR3nIbmhcvpEZZtEe0pqT7cgne/EBzLEm4RHKjMUBMJIrNZbtTSRQKe5tlbEIGrGCzsTATNrgJZHipHIYc08SeG3YAXQDnlXLbyAbV7LB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name; spf=pass smtp.mailfrom=shutemov.name; dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b=ybSy9LUp; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=PHxqwqwy; arc=none smtp.client-ip=103.168.172.152
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=shutemov.name
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=shutemov.name
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=shutemov.name header.i=@shutemov.name header.b="ybSy9LUp";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="PHxqwqwy"
Received: from phl-compute-10.internal (phl-compute-10.internal [10.202.2.50])
	by mailfhigh.phl.internal (Postfix) with ESMTP id CED8F14000F9;
	Thu, 20 Aug 2026 11:00:34 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-10.internal (MEProxy); Thu, 20 Aug 2026 11:00:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-type:content-type:date:date:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm1; t=1787238034; x=
	1787324434; bh=9NHH3MAtXegQM8wmmdhADbFPM8G3Gs+3JvKoiIEVOUc=; b=y
	bSy9LUpE2TURrJNCOInPhz/J81lPAqVQADV0DEAbsVj6h+mjSiK+Pl5c2no3xAln
	ZT+pzGa5KiN3qQ1x3RGqaD2pT7iMHj66SjHDcH4vpCe+WtG9UYs1/w1HQt3DgXYw
	ItJLSrzyMCOODVb9vONn/rL509AB5VFE8/QGOMilyEcJ4sDB3ebU1+mbDFlpyRkA
	zjdEmsD+LkS6yLwImrIg6rHzcVhXV2236J9+up/B3D0Avpxf0iUqUZosYUgX1Idt
	LOAcDc3RVspuEr9GEoy+OVY0Lgf6FmLe97KGYBiI9H4Yj5GiICPjiwyAL5TNkSPP
	v6j3URIh8hBHdCcpwVcOw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
	1787238034; x=1787324434; bh=9NHH3MAtXegQM8wmmdhADbFPM8G3Gs+3JvK
	oiIEVOUc=; b=PHxqwqwynGL8tEvQeE+15D03uaZFylAb8AkxfjH8V5Vt6Jbvlp7
	AhiFrpT+7afJNlj81D3/Iq4+NDqmGfRvB5Rr11IX8jH0uj85Dr62ruGO/6sQxZOR
	g+kdENZsyo9MQ8rah61ds4e2rrVYWo6P+hlDTmsrRUYVubr7bffCwgDcM7qei2SA
	NWuR1t7zRwAeoEM4wWKYT/BILWDwM8huFhdZiSxg2fSTQsHuyt04/fcxKlpuggyX
	IuAbbyI85ALz3lifCqJPfyXbX6yD7d+OJAnM2dcgWhVYHjuYRhxBaOwxwU9d0Wl/
	wCP27Dpn5O/7UcZHkAShrBw+OxBleBUYP9g==
X-ME-Sender: <xms:khaHamGnNRiFZlkdmJZ4zuJg3rhsgAjyObmc5LXpP_-6mO31if4RTQ>
    <xme:khaHaqpYN-WTlny29pDASt1_ZFQWgmW1Fx5qHl0s9tyr4ADGxZvU9Yho15Y3g-CAs
    JIeKX93VxZmhF21HB-OIrBa57AdC_Ofhw_hIgAgUeZhzYKJX4a138E>
X-ME-Received: <xmr:khaHakMmKYlYiSlWPA-bm_BW25GZzfm-WBHlsMm4cBrPFLv_40aJgT8Rmp0>
X-ME-Proxy-Cause: dmFkZTE0/9X7WIzT7v0cJ1Q68jjWE24R4f9YD+0vv/l4GrYIP7tL5wuv093UaXVgVH30E8
    80/ZyKNSEHmGq7ojjVQqWlktXNiRKQYT8pxO4ERvYN1NOvSqsMenUQKZxDhs+dHKXEVPI6
    UQQI3Cnxqx257NeEinkkbSMAgIyrxGy+3LyIVGD662Q9JoUG3XYDJGL2sXVXCbPKO39QrX
    iwCOxpG2/06ZaIhxY9r4yHvNjqDfm/OrVj93wsPLClOa0UNxBIXUehNGDPpbqr4MpNbeSo
    /3U46K13FXumbfTWf33t2x28XQ8MR5zuXgJxJvRFw/xeMsvO6a64SnRydROJmhGIrt/wFH
    +K37V1yOAoB6fwsiRq0cHC06gi2Y2E1FBp+ddRUkRsBuF3CEoKbKmiOMyflSStNRWTUL1p
    4YxUt6h0cGoKGpPXs2vMr7wzHwnBvtaQ7z07Q8Nqk4q+/UZeJf/45TWikhigUxinmx3azV
    gkxUA+qHp/NWcZnaPXxmyxVm/KlKpppJOftyEkqSyzEpWyk6VjF4dxF89yrWKVjrYxs38c
    6SDNc5ybBk5uGxQycyp0kY3hDW8o0WKvG928wnqhTqjl4XLvTrfde9HVu8Cstdt+S4DcNQ
    xqQredZLSBYoxAqpvtNV5sv1zjhBl6xxcp0rcFpHtzkKB8a9BpAwcFFa2+RA
X-ME-Proxy: <xmx:khaHamfGePOUDx_KIr-CYt3fgla9L8ETY60ZgWHB3MG9ENcYDXguvw>
    <xmx:khaHaiRHdbUzGdikB4dUgxAaZ50EPlCYGgwP-F2hKm_OH9Y37ujDog>
    <xmx:khaHalqo3uZVoZSbr8MTIBVao_ZEKKDSTO4_xcKgfOBhGywwyYHwSg>
    <xmx:khaHao7-20IRSnV_KugpYALdKzVrKpiwHmYgttlohevlP5g-tGBAJQ>
    <xmx:khaHao0eLrIu1KQhhVdJ-QeLxcqyJPJ_P4rsas9Zlo6hPkmOBkTLIK4J>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 20 Aug 2026 11:00:32 -0400 (EDT)
Date: Thu, 20 Aug 2026 16:00:31 +0100
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Zi Yan <ziy@nvidia.com>
Cc: Qi Xi <xiqi2@huawei.com>, akpm@linux-foundation.org, vbabka@kernel.org, 
	longli@microsoft.com, kotaranov@microsoft.com, jan.kiszka@siemens.com, 
	kbingham@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, 
	hannes@cmpxchg.org, linux-hyperv@vger.kernel.org, linux-rdma@vger.kernel.org, 
	netdev@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	sunnanyong@huawei.com, wangkefeng.wang@huawei.com
Subject: Re: [PATCH] mm: drop stale MAX_ORDER references
Message-ID: <aocWWrK_K1iCtq4P@thinkstation>
References: <20260818122408.4182417-1-xiqi2@huawei.com>
 <aocAePwuxr4te2jG@thinkstation>
 <AF9812A4-550F-4E3A-B67C-EAF6F9F56982@nvidia.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AF9812A4-550F-4E3A-B67C-EAF6F9F56982@nvidia.com>

On Thu, Aug 20, 2026 at 09:52:03AM -0400, Zi Yan wrote:
> On 20 Aug 2026, at 9:27, Kiryl Shutsemau wrote:
> 
> > On Tue, Aug 18, 2026 at 08:24:08PM +0800, Qi Xi wrote:
> >> The treewide rename in commit 5e0a760b4441 ("mm, treewide: rename
> >> MAX_ORDER to MAX_PAGE_ORDER") left a few spots still using the old
> >> name:
> >>
> >>   - two comments in include/net/mana/mana.h and mm/page_alloc.c;
> >>   - the gdb helper scripts/gdb/linux/mm.py, where self.MAX_ORDER is
> >>     a local mirror of the kernel's MAX_ORDER define.
> >>
> >> Rename the leftover instances to MAX_PAGE_ORDER so the tree is
> >> consistent.
> >>
> >> No functional changes.
> >>
> >> Signed-off-by: Qi Xi <xiqi2@huawei.com>
> >> ---
> >>  include/net/mana/mana.h | 4 ++--
> >>  mm/page_alloc.c         | 2 +-
> >>  scripts/gdb/linux/mm.py | 8 ++++----
> >>  3 files changed, 7 insertions(+), 7 deletions(-)
> >>
> >> diff --git a/include/net/mana/mana.h b/include/net/mana/mana.h
> >> index 04acb6791dbd..1d5bed71d6a7 100644
> >> --- a/include/net/mana/mana.h
> >> +++ b/include/net/mana/mana.h
> >> @@ -40,8 +40,8 @@ enum TRI_STATE {
> >>  #define COMP_ENTRY_SIZE 64
> >>
> >>  /* This Max value for RX buffers is derived from __alloc_page()'s max page
> >> - * allocation calculation. It allows maximum 2^(MAX_ORDER -1) pages. RX buffer
> >> - * size beyond this value gets rejected by __alloc_page() call.
> >> + * allocation calculation. It allows maximum 2^(MAX_PAGE_ORDER -1) pages. RX
> >
> > Should it reference MAX_ORDER_NR_PAGES instead?
> 
> It is fixed in v2[1].

It is not :)

My point is that 2^MAX_PAGE_ORDER is MAX_ORDER_NR_PAGES.

But v2 is good enough.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
