From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 00/16] IB/hfi1: Add a page pinning cache for PSM sdma
Date: Tue, 15 Mar 2016 15:37:31 -0400
Message-ID: <20160315193731.GA20662@phlsvsds.ph.intel.com>
References: <CAJ3xEMj8gz6Xw1bqA677fC8=U2ktLQ6b4W20SeNrztN7u6UKZg@mail.gmail.com> <20160309002157.GA20105@phlsvsds.ph.intel.com> <20160309050731.GM13396@leon.nu> <20160309192109.GB15031@phlsvsds.ph.intel.com> <20160310045609.GC1977@leon.nu> <20160314070951.GB26456@leon.nu> <20160314120152.GA30838@phlsvsds.ph.intel.com> <CAJ3xEMiSgXFT46r0Y7DZGr3mpJFSLrtYrMdz+DbCXDozbMYZRA@mail.gmail.com> <20160315012049.GA30055@phlsvsds.ph.intel.com> <CAJ3xEMhToYOBMo_nNi2fFpTexUmUqb3zBX7zWWYjCDfPWpWn-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAJ3xEMhToYOBMo_nNi2fFpTexUmUqb3zBX7zWWYjCDfPWpWn-w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Mar 15, 2016 at 09:03:49AM +0200, Or Gerlitz wrote:
>>> Doug, As Dennis noted, you already picked ~300 patches for 4.6 / hfi1
>>> driver from him. I don't see why picking this patch series there too
>>> and not letting us to further discuss it out, thoughts?

Forgot in my last reply but I did want to mention this again, we have not 
submitted 300 patches for hfi1.  We have submitted 300+ patches across 3 
different drivers.  Doug's GitHub branch says hfi1, but it is changes for 
hfi1, rdmavt, and qib.

>> I believe in taking an iterative approach to kernel development, if the code
>> doesn't cause problems I don't see any harm adding the series. If Doug
>> agrees with you and doesn't like this approach but is willing to let it
>> stand for now,  I think the changes can be done in a subsequent release.
>
>Iterative approach doesn't say we should pick code into the kernel and throw
>it away later. There are rare times it happens, when people were not able
>to agree on something for years and the maintainer say enough is enough,
>we'll take it and see later.

Never said anything about throwing it all away. My point is, we are talking 
about a single driver and exactly one user of it.  It's not like we are 
adding core kernel functionality here that impacts multiple drivers, or have 
to worry about changing ABIs across a bunch of different users. We have the 
freedom to fix and change things as needed.

Regardless that stuff aside, I wanted to talk to some folks who are
more familiar with the inner workings of psm than I. So I appreciate the 
patience while I gathered the feedback from interested parties. 

So basically what happens in this series is that psm calls into the kernel 
to do an sdma transfer, the caching is a side effect that happens under the 
covers.  We can see this from the code in this series. What may not be so 
apparent is that the user library does not have to do anything to take 
advantage of the cache. Further it doesn't even have to know about the 
cache.  Which is one of the appeals of this patch series. The other, and 
what trumps all, is performance.

Taking a performance standpoint we don't want this in user space. If the 
cache were at the user level there would end up being a system call to pin 
the buffer, another to do the SDMA transfer from said buffer, and another to 
unpin the buffer when the kernel notifier has invalidated that buffer.  This 
gets even more complex when you consider cache evictions due to reaching the 
limit on pinned pages. 

These extra system calls add overhead, which may be acceptable for a normal 
server or desktop environment, but are not acceptable when dealing with a 
high performance interconnect where we want the absolute best performance.

I should also point out that these extra calls would be done on a per-buffer 
basis, not per-context, or per-application.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
