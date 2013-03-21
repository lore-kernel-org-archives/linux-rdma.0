From: brendan doyle <brendan.doyle-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [Fwd: Re: [PATCH] libibmad: Fixes for failures when not all ports
 of HCA are connected]
Date: Thu, 21 Mar 2013 22:07:22 +0000
Message-ID: <514B849A.3090401@oracle.com>
References: <514A0156.2070009@oracle.com> <20130320190208.GA23478@obsidianresearch.com> <2807E5FD2F6FDA4886F6618EAC48510EBB4214@CRSMSX102.amr.corp.intel.com> <514A3169.7000501@oracle.com> <20130320222422.GA30100@obsidianresearch.com> <514A3BDF.2090105@oracle.com> <20130320231923.GA32300@obsidianresearch.com> <514A5C07.3080308@oracle.com> <20130321052122.GB20882@obsidianresearch.com> <514B6F74.9020707@oracle.com> <20130321212703.GA8431@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130321212703.GA8431-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Boris Chiu <boris.chiu-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Pramod Gunjikar <pramod.gunjikar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 21/03/2013 21:27, Jason Gunthorpe wrote:
> On Thu, Mar 21, 2013 at 08:37:08PM +0000, brendan doyle wrote:
>
>>> The 'old' POSIX convention had int functions return 0 on success and
>>> set errno. Some function will restrict error returns to -1, others
>>> leave it open.
>> OK so then the inconsistency is further down the stack..
> No doubt there would be many places requiring various levels of
> fixing, I don't think anybody ever thought about how to do error return
> when this was written.
>
>> But mad_encode() does not set errno, and also retuning +errno
>> instead of -1 would break the existing API usage.
> The existing API is 0 on success != 0 on failure - if code tests for
> -1 it is wrong :) The question is, do we care?

Well, I'm not sure all the utilities in the diags pkg have if (ret != 0) 
fail, the point is
that if any have if (ret <0) fail then fixing this function could cause 
diag utilities to
fail, and fixing the library also involves fixing all our internal OFED 
consumers
(diags, utils etc, ) and notifying our external consumers of the API 
change. And I'm not
saying that should not be done, but I don't have the bandwidth to under 
take that
task  and I'd question what is the ROI.

So I understand introducing another non POSIX function return/use of 
errno just
further propagates non compliance, however unless we intend to fix the 
whole lib
and its consumers then I don't see that this is too big a deal. This is 
the current way
consumers use the API, so it won't break current usage, and if/when the 
whole
lib is overhauled to be POISX compliant then this new non POISX 
compliant code
can be fixed as part of that effort.

Essentially we wanted to add something that is quick and useful to the 
consumer
but we don't want to have to rebuild the whole house to do that.

Brendan.


>> break the easting API and cause consumers to fail, but also to add
>> the ability to distinguish between types of failures for a specific
>> failure mode.
> Well, somebody needs to decide how it would ideally look and migrate
> things in that direction 'new' vs 'old' POSIX style..
>
> Once you introduce an 'old' style return, you are going to start using
> it and then we are stuck with this inconsistency forever. Pick a
> direction and go there, consistently :)
>
> 'new' POSIX is *much* safer to use, you don't have the risk of library
> code stomping errno, particularly during error unwind.
>
>>> The specs say functions set errno on error return. They say nothing
>>> about clearing it on success return. Assuming errno is ever 0 is
>>> absolutely not portable, and IIRC, doesn't work on Linux anyhow.
>> Humm, again, take a look at umad, it sets errno to 0 before calling
>> the write() system call.
> Gah, that is so incredibly fragile and wrong. write isn't guaranteed
> to not kill errno - eg ERESTARTSYS might get written into errno in
> some cases (not sure on Linux, POSIX allows errno to be stomped though).
>
> Further, look up the unwind chain. There are *lots* of function
> calls. This is a classic errno mistake, read 'man errno':
>
>         A common mistake is to do
>
>             if (somecall() == -1) {
>                 printf("somecall() failed\n");
>                 if (errno == ...) { ... }
>             }
>
>         where errno no longer needs to have the value it had upon return from
>         somecall() (i.e., it may have been changed by the printf(3)).  If the value
>         of errno should be preserved across a library call, it must be saved:
>
> This is why the 'new' POSIX method is so desirable. It avoids people
> inadvertently creating these kinds of mistakes. :)
>
> Jason

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
