From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH] libibmad: Fix conflict with new umad.h header
Date: Fri, 24 Feb 2017 11:24:49 -0700
Message-ID: <20170224182449.GE22491@obsidianresearch.com>
References: <1487914827-339-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1487914827-339-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Feb 24, 2017 at 12:40:27AM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Bleck, how did this ever work sanely like this??

This is the version you should copy:

#ifndef ntohll
#undef htonll
#undef ntohll
/* Users should use the glibc functions directly, not these wrappers */
static inline __attribute__((deprecated)) uint64_t htonll(uint64_t x) { return htobe64(x); }
static inline __attribute__((deprecated)) uint64_t ntohll(uint64_t x) { return be64toh(x); }
#define htonll htonll
#define ntohll ntohll
#endif

> +#define ntohll(x) x

missing () around the x.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
