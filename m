From: Tadeusz Struk <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 03/12] IB/hfi1: Fix an Oops on pci device force remove
Date: Wed, 19 Oct 2016 11:01:26 -0700
Message-ID: <da4554b2-fb63-71f3-ada2-506807a96756@intel.com>
References: <20161017103326.7934.21558.stgit@scvm10.sc.intel.com>
 <20161017111918.7934.72325.stgit@scvm10.sc.intel.com>
 <20161017160731.GA5679@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161017160731.GA5679-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Jason,
On 10/17/2016 09:07 AM, Jason Gunthorpe wrote:
>> +		atomic_inc(&dd->user_refcount);
> This doesn't look like enough locking on acquire.. What prevents the
> driver from already having been unloaded at this point?

Thanks for your feedback. We will address this in v2.

> 
> Shouldn't this be a while loop to avoid races?
> 
> .. and shouldn't the inc 'latch off' once the removal process starts?
> 
> I think you need to study how kernfs_drain is implemented and
> basically copy that approach, including the locking.

as to kernfs_drain approach, I think the same mechanism as in ib_verbs
will work better here.

> 
> FWIW, it is much easier and probably long term better to arrange
> things so the FD can remain open but just return ENODEV to all calls.
> Eg the srcu based approach in uverbs.

We need to hold the device because not all the clients will talk to the
device via the FD. The PIO clients for instance don't go to kernel.
Thanks,
-- 
TS
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
