From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: opensm/complib: redundant redeclaration of functions
Date: Tue, 2 Feb 2010 11:33:38 -0700
Message-ID: <20100202183338.GA15648@obsidianresearch.com>
References: <4B66D189.2090500@dev.mellanox.co.il> <20100201184616.GC25902@obsidianresearch.com> <4B68247E.6070405@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4B68247E.6070405-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 02, 2010 at 03:11:26PM +0200, Yevgeny Kliteynik wrote:
> >If no inline version is defined then the compiler just emits a normal
> >function call, if an inline version is defined then the compiler might
> >use it.
> 
> Thanks for the idea.
> I read some documentation about it, and it does look that
> your suggestion should fix the problem, but it didn't :(

> Probably because they both are in .h files.

No, but they do have to be in the right order.

first header:

extern inline int foo();
inline int foo()
{
    body
}

2nd header:
extern inline int foo();

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
