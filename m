From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] IB/hfi1: Remove write() and use ioctl() for user access
Date: Mon, 18 Apr 2016 08:00:27 -0400
Message-ID: <20160418120026.GA17987@phlsvsds.ph.intel.com>
References: <20160414164550.GC6247@obsidianresearch.com> <20160414174830.GA11641@rhel.sc.intel.com> <20160415040126.GB10689@leon.nu> <20160415161754.GA21549@rhel> <20160415173035.GC10689@leon.nu> <20160415173401.GA10868@infradead.org> <20160415212328.GF10689@leon.nu> <20160415233732.GB25662@obsidianresearch.com> <20160416060042.GA6349@leon.nu> <20160416191917.GY25498@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160416191917.GY25498-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Al Viro <viro-3bDd1+5oDREiFSDQTTA3OLVCufUGDwFn@public.gmane.org>
Cc: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sat, Apr 16, 2016 at 08:19:17PM +0100, Al Viro wrote:

>While we are at it, could the person who'd come up with ui_lseek() be located
>and made to stand up and explain the rationale behind the SEEK_END semantics
>therein?  To quote the manpage (and paraphrase just about any introductory
>textbook):
>       SEEK_END
>              The file offset is set to the size of the file plus offset bytes.
>
>I'm really curious - which part of "plus" might have lead to
>        case SEEK_END:
>                offset = ((dd->kregend - dd->kregbase) + DC8051_DATA_MEM_SIZE) -
>                        offset;
>and, if its author has decided that of course it _must_ have meant "minus",
>why had he or she failed to post a correction to the manpage?  Or, on the

Original author of that code confirmed it is just a coding mistake and we 
will fix it.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
