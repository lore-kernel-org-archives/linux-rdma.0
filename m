Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEFC2D3EC7;
	Tue,  2 Jun 2026 17:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780421530; cv=none; b=fa/xMeeBYkrQmRRyymp/iNrovJGboLbjfwtYHVl3sYtxHjPxpCyIhzptNu2YOYkxskk9CmvtYuXoxL/IRdQBksAlY7F8Gfyk0JZg/rpBeUDsUXvwejJTrCSpOkRRa9yg9CZGw6VVYwwOh8ROlMUA4pIp33gcBQjuQT1xbJCeo7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780421530; c=relaxed/simple;
	bh=Q8RAfVmtkJ+IPg7BYVEkPBRKt9ntB+TJqcyjR3LZpv0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IYALg48I8NR8uvIV63vfJO3vzr1EDFpHMX9H6P0f4SA2jdTCH5klMkyYtTZ6c/k9KaTI9/g+7QGE/0Wv3VnSyB/hRGif+rZY7MPgtVPVJtMwKOleiXkTG4hSZHYKkJYSsnUoQSFDadUGnekAGkK155lNg8H6v1OilxhjzmPoGo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e7i8x2gO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e7i8x2gO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 018B61F00893;
	Tue,  2 Jun 2026 17:32:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780421529;
	bh=IT/hnXtjUfBU0YvE7YTAxpftFLi1PmAVY52XpGJ9Rvo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=e7i8x2gO5tbHBLsNcfUaXSL+6NHFT9g6XtATvuG3GNTWbVerEEtb7oJFYB66HRW05
	 73IR+ZTqDdsQfa2A0B97KQ1IycOMKVdCuqzHrVOcjbKO9wz55jnNAdXPH2WvHlEpCL
	 Ry5IElmuJXPoF5fQoUgt3A1rWDkF1CMME2Csm24pAKDcmsyjywt6YzKpYk36dTB/7N
	 kZKOvXyxvEBdMfq+QC29FZGZ4wngeoWTTY5kwl/sYvfgHujQor1MXZOb9TDde+zG+Z
	 zzAk7tGp/afF/b683OA31sm4ni/Y+98j6ef/xxGXCJthAu2zM3729ffJjoNDeN5tyH
	 yMS30FBAgv1ww==
Date: Tue, 2 Jun 2026 10:32:08 -0700
From: Kees Cook <kees@kernel.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Doug Ledford <dledford@redhat.com>,
	"Michael J. Ruhl" <michael.j.ruhl@intel.com>,
	Mike Marciniszyn <mike.marciniszyn@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Dean Luick <dean.luick@cornelisnetworks.com>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	llvm@lists.linux.dev
Subject: Re: [PATCH] [v2] RDMA/hfi1, rdmavt: open-code rvt_set_ibdev_name()
Message-ID: <202606021032.F864729@keescook>
References: <20260602140453.3542427-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260602140453.3542427-1-arnd@kernel.org>

On Tue, Jun 02, 2026 at 04:04:34PM +0200, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> clang warns about a function missing a printf attribute:
> 
> include/rdma/rdma_vt.h:457:47: error: diagnostic behavior may be improved by adding the 'format(printf, 2, 3)' attribute to the declaration of 'rvt_set_ibdev_name' [-Werror,-Wmissing-format-attribute]
>   447 | static inline void rvt_set_ibdev_name(struct rvt_dev_info *rdi,
>       | __attribute__((format(printf, 2, 3)))
>   448 |                                       const char *fmt, const char *name,
>   449 |                                       const int unit)
> 
> The helper was originally added as an abstraction for the hfi1 and
> qib drivers needing the same thing, but now qib is gone, and hfi1
> is the only remaining user of rdma_vt.
> 
> Avoid the warning and allow the compiler to check the format string by
> open-coding the helper and directly assigning the device name.
> 
> Fixes: 5084c8ff21f2 ("IB/{rdmavt, hfi1, qib}: Self determine driver name")
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook
