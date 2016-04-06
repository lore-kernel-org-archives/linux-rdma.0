From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 08/10] IB/qib: Remove qp and mr functionality from qib
Date: Wed, 6 Apr 2016 14:29:29 -0400
Message-ID: <20160406182928.GA24948@phlsvsds.ph.intel.com>
References: <20160122204145.2022.26449.stgit@scvm10.sc.intel.com> <20160122204525.2022.20568.stgit@scvm10.sc.intel.com> <20160404074703.GA28637@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160404074703.GA28637-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 04, 2016 at 12:47:03AM -0700, Christoph Hellwig wrote:
>On Fri, Jan 22, 2016 at 12:45:59PM -0800, Dennis Dalessandro wrote:
>> Remove qp and mr support from qib and use rdmavt. These two changes
>> cannot be reasonably be split apart into separate patches because they
>> depend on each other in mulitple places. This paves the way to remove
>> even more functions in subsequent patches.
>
>This seems to have removed support for mapping MRs in the QIB drivers,
>as there doesn't seem to be any map_mr_sg method in either rdmavt
>or qib in the current tree.

I think this is the stuff that didn't actually even work in qib and when I 
moved stuff to rdmavt I just left it out. Actually I ported it then dropped 
that patch:
https://www.mail-archive.com/linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org/msg30636.html

>Whilke we're at it: the mess in check_driver_override and check_support
>will break the first time someone changes any method calls.  Type safety
>exists for a dricking reason - fix this mess to write a little more
>code but be type savfe and don't rely on the ordering of fields or you
>can keep the pieces as soon as this junk breaks.  And it will break
>soon!

We'll look into this. I'm certainly not opposed to adding more code and if 
you have any ideas to improve it, feel free to throw them out.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
