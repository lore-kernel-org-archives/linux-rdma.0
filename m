Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEDF2E173D;
	Tue,  2 Jun 2026 21:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780434318; cv=none; b=ewEyxvV/7b2keE6+vxXGzMkVpPQcri1/tMYAOIEVtUcigwUHvgusW8qQa0tc8pCadNVNMTl38/uVg4N6vAcOzv+eXeHALEx6d/mwjz3y6uFlrlUs8rt/yf9OjnBZsqb/gwfdINYwXJeLXhZTtlVTk9BQZ4vZ8FfDKMOIn1gvFWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780434318; c=relaxed/simple;
	bh=xUDEVzA7dW2EFM7q7nsKhfV8kbLTLrhkVRoEHeV/Tyw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Vl8lbZA8+wDRfoKCgaHKZuYDuMUR7c1w31ckRe5HAiuF0kqVYEkVBIxpUZjT0HW8CofOhRiTKKY/B0kuP52+ufdIFzmxI03hL5uBAIpKppwoRyJbswKJyfciaULOUNh3L/pSu+h68qux2d5RDpD0rbQ20zXsQ4A05FLAMpKCxlg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=pass smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=fsRhb8rD; arc=none smtp.client-ip=198.175.65.18
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="fsRhb8rD"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1780434318; x=1811970318;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xUDEVzA7dW2EFM7q7nsKhfV8kbLTLrhkVRoEHeV/Tyw=;
  b=fsRhb8rD5fEgPNC1GtqiuU0ZOq2/x4Qu7RW37vG8onFtauqL5kk23dA8
   Vluk3Zep03TPTPMcUzXRVp1RlflF16zlu60JHjhErUY+k6bf8tv2yZoC9
   IG9Cem++fzO2FoB6M4vs6gD59u4fc71xf+DmpBjyrfXnoE2IIFRfroKjg
   sOTisvsJV+YB07VEIIWkvOft9KgbuBnrBZeDs4xuiPKPuXlJopjM9bN62
   JLEUO07MiGPt26kYy1G9IWkqbWSh+oKGJGYlmCmnMEHLwfOpgIzWiSrTu
   UocpZGXA45aRZR6TE83XoovuFWFDhWnMEOtsdjy9QpLQI3V3pFp5p2pDB
   Q==;
X-CSE-ConnectionGUID: N1n46YjJTtS/qMZI7KcRvg==
X-CSE-MsgGUID: UlMpEkRCTOWKKpcTmGrKmw==
X-IronPort-AV: E=McAfee;i="6800,10657,11805"; a="81293848"
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="81293848"
Received: from orviesa007.jf.intel.com ([10.64.159.147])
  by orvoesa110.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 14:05:17 -0700
X-CSE-ConnectionGUID: q3VK4G18SUSwPLf7/GZKLw==
X-CSE-MsgGUID: bWrAzEGVSu+fW6rQ4CFVNg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.24,183,1774335600"; 
   d="scan'208";a="244128076"
Received: from mkosciow-mobl1.ger.corp.intel.com (HELO localhost) ([10.245.245.229])
  by orviesa007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Jun 2026 14:05:11 -0700
Date: Wed, 3 Jun 2026 00:05:08 +0300
From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Arnd Bergmann <arnd@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Petr Mladek <pmladek@suse.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>,
	Arend van Spriel <arend.vanspriel@broadcom.com>,
	Miri Korenblit <miriam.rachel.korenblit@intel.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Rasmus Villemoes <linux@rasmusvillemoes.dk>,
	Sergey Senozhatsky <senozhatsky@chromium.org>,
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>,
	linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-trace-kernel@vger.kernel.org, llvm@lists.linux.dev
Subject: Re: [PATCH 1/2] tracing: work around -Wmissing-format-attribute
 warning
Message-ID: <ah9FhFfQWzYpB0oi@ashevche-desk.local>
References: <20260602150904.2258624-1-arnd@kernel.org>
 <ah8n-Nk305S5hRwN@ashevche-desk.local>
 <35c1ba62-e74d-4abc-aa73-ccd35968ff89@app.fastmail.com>
Precedence: bulk
X-Mailing-List: linux-rdma@vger.kernel.org
List-Id: <linux-rdma.vger.kernel.org>
List-Subscribe: <mailto:linux-rdma+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-rdma+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <35c1ba62-e74d-4abc-aa73-ccd35968ff89@app.fastmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - c/o Alberga Business Park, 6
 krs, Bertel Jungin Aukio 5, 02600 Espoo

On Tue, Jun 02, 2026 at 10:32:04PM +0200, Arnd Bergmann wrote:
> On Tue, Jun 2, 2026, at 20:59, Andy Shevchenko wrote:
> > On Tue, Jun 02, 2026 at 05:07:05PM +0200, Arnd Bergmann wrote:

...

> > Why the __printf() annotation is in the C file and not here?
> > Is this all about headers as the second paragraph in the commit message 
> > explains?
> > I would add a comment to explain it here, otherwise we might see false 
> > patches to "make things consistent" in a wrong way.
> 
> I've tried to come up with a kerneldoc comment now, similar to
> the one for the vsnprintf() function, and added a separate prototype
> in the header. Does this address your concern?

Yes, see one nit, though.

> -int __printf(3, 0) __vsnprintf(char *buf, size_t size, const char *fmt_str, va_list args)
> +/**
> + * __vsnprintf - vsnprintf() wrapper without __printf() attribute
> + * @buf: The buffer to place the result into
> + * @size: The size of the buffer, including the trailing null space
> + * @fmt_str: The format string to use
> + * @args: Arguments for the format string
> + *
> + * This has the exact same behavior as vsnprintf() but can be used in call
> + * sites that are missing a __printf() annotation, e.g. because they
> + * get a 'va_format' argument instead of format and varargs.
> + *
> + * For this to work, the attribute is added to the declaration here but
> + * not in the header.

+ *
+ * Return: ...

> + */
> +int __printf(3, 0) __vsnprintf(char *buf, size_t size, const char *fmt_str, va_list args);

> +
> +int __vsnprintf(char *buf, size_t size, const char *fmt_str, va_list args)

Something slipped here...

-- 
With Best Regards,
Andy Shevchenko


