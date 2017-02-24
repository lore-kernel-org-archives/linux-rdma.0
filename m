From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] libibmad: Fix conflict with new umad.h header
Date: Fri, 24 Feb 2017 21:23:26 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E67C5743A@CRSMSX101.amr.corp.intel.com>
References: <1487914827-339-1-git-send-email-ira.weiny@intel.com>
 <20170224182449.GE22491@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170224182449.GE22491-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> On Fri, Feb 24, 2017 at 12:40:27AM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
> > From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> 
> Bleck, how did this ever work sanely like this??

I don't know...

Libibmad should have been combined into infinband-diags years ago...  I just never seem to have the time...

> 
> This is the version you should copy:
> 
> #ifndef ntohll
> #undef htonll
> #undef ntohll
> /* Users should use the glibc functions directly, not these wrappers */ static
> inline __attribute__((deprecated)) uint64_t htonll(uint64_t x) { return
> htobe64(x); } static inline __attribute__((deprecated)) uint64_t ntohll(uint64_t
> x) { return be64toh(x); } #define htonll htonll #define ntohll ntohll #endif

Perhaps...

The question is do you want to rely on BSD or gnu extensions?  My reading of the various man pages leads me to the same path as you.  That the BSD htobe* has become the standard in glibc.

However, anyone currently using libibmad must have bswap_*.  Therefore this will not break them.

> 
> > +#define ntohll(x) x
> 
> missing () around the x.

Yea missed that...

Thanks,
Ira

> 
> Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
