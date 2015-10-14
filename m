From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: Create a common verbs transport library
Date: Wed, 14 Oct 2015 14:49:04 -0400
Message-ID: <20151014184903.GA12463@phlsvsds.ph.intel.com>
References: <20150929125648.GA3433@phlsvsds.ph.intel.com> <CAG9sBKPqXk671c7obj4wd8drNaxPU3gue428y3Es_BJfuC-sVQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAG9sBKPqXk671c7obj4wd8drNaxPU3gue428y3Es_BJfuC-sVQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Oct 13, 2015 at 08:32:25AM +0300, Moni Shoua wrote:
>We initially thought to implement a shared library that contains the
>transport logic.
>
>However, it seems that a SW Verbs transport driver would allow better
>code sharing.
>
>In fact, the VT driver would need only a single user-space driver for
>all "backends". Any direct HW access from user-space should be exposed
>by the corresponding backend driver and accessed by a different
>library (e.g., psm).

I assume by user-space driver we are talking about libverbs? We have 
separate libraries for ipath/qib and hfi. We should probably coalesce these 
into a single library but that is a separate issue. PSM is also unrelated to 
the work here since PSM is not verbs.

>At a high-level, it seems that we should do as follows:
>
>- Decide on an initial code base for VT (rxe/hfi/qib), clone it, and
>rename to VT
>
>- Split the code to VT and backend and create the initial backend APIs, e.g.:

We have been planning a bit of a different approach. My thoughts are we make 
VT a completely new kmod. It will start out life lettings verbs calls from 
the core go into the drivers to do their thing, but will contain a bunch of 
the duplicated code that we have in hfi1/qib/ipath. The next step is to move 
piece by piece the rest of the verbs code.

>-- Send packet
>
>-- Deliver packet (receive)
>
>-- Attach multicast
>
>-- Packet buffer allocation
>
>-- Notify when more send space is available
>
>- In parallel, prepare the backends of other drivers while enhancing
>VT as needed.

Yes, we need to come up with an API, I'm not fully sure what that should 
look like yet, it is a work in progress.

>Do you have any preferences to the initial code base?
>
>Do you already have some code that we can look at?

We'll be starting out with making changes to hfi1 and qib to follow shortly 
behind. No code just yet, but I should have something to post as an RFC very 
soon (in the next two weeks).

Thanks

-Denny

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
