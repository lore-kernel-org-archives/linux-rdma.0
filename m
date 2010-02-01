From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: opensm/complib: redundant redeclaration of functions
Date: Mon, 1 Feb 2010 11:46:16 -0700
Message-ID: <20100201184616.GC25902@obsidianresearch.com>
References: <4B66D189.2090500@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B66D189.2090500-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Feb 01, 2010 at 03:05:13PM +0200, Yevgeny Kliteynik wrote:

> In general, here's the problem:
> 
> We have cl_file.h and cl_file_osd.h.
> cl_file.h has include directive for cl_file_osd.h
> cl_file.h has the following definition of function:
> 	int foo();
> 
> cl_file_osd.h has another function definition, but
> this time it also has implementation:
> 	static inline int foo() { ..... }
> 
> Any preferable way to fix this?

It looks to me like using 'extern inline' is appropriate here:

extern inline int foo();

[..]

inline int foo()
{
   body
}

If no inline version is defined then the compiler just emits a normal
function call, if an inline version is defined then the compiler might
use it.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
