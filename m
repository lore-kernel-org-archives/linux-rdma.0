From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 06/10] IB/hfi1: Add ioctl() interface for user commands
Date: Mon, 23 May 2016 08:22:08 -0400
Message-ID: <20160523122207.GA16764@phlsvsds.ph.intel.com>
References: <20160519122318.22041.58871.stgit@scvm10.sc.intel.com> <20160519122622.22041.41686.stgit@scvm10.sc.intel.com> <20160521123404.GB25500@leon.nu> <20160521162301.GA16770@phlsvsds.ph.intel.com> <20160522120129.GC25500@leon.nu> <20160522140351.GA10696@phlsvsds.ph.intel.com> <20160522175715.GD25500@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20160522175715.GD25500-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, May 22, 2016 at 08:57:15PM +0300, Leon Romanovsky wrote:
>On Sun, May 22, 2016 at 10:03:52AM -0400, Dennis Dalessandro wrote:
>> On Sun, May 22, 2016 at 03:01:29PM +0300, Leon Romanovsky wrote:
>> >>>I think the overall consensus over participants in OFVWG call was to use
>> >>>one IOCTL to enter into device specific handler which will do all
>> >>>necessary parsing and not spamming common IOCTL interface.
>> >>
>> >>That was for the verbs working group and the verbs 2.0 uAPI. This is for
>> >>psm.
>> >
>> >I'm glad that you are supporting my point.
>> >It is vendor specific implementation for vendor specific driver and not
>> >for whole IB core, so there is no need to pollute general IB ioctls.
>> 
>> It is making use of and applying a proper classification.  Is there a
>> technical concern with this other than that's not how verbs may end up doing
>> it?
>> 
>> I'm not completely opposed to the single ioctl, I just don't necessarily see
>> that as better in this case but am willing to listen to a technical
>> justification for why it's incorrect.
>
>it will simplify internal and external development by removing the
>tensions over ioctls numbers. Do you plan to take the block of ioctls
>for future expansion? Do you plan to mix hfi's ioctls with verbs's ioctls
>based on acceptance of new code?

I'm still not sure what you are getting at here. Can you explain what you 
mean by tensions over ioctl numbers?  I guess I don't understand why the 
hfi1_x device's use of icotl numbers has any bearing at all on the 
ibcore/verbs ioctl(s). 

If and when new code is accepted and hfi1 converges its API to go through a 
common character device, then hfi1 would surely change to match whatever is 
there whether that's a single ioctl with a command type embedded or 
something that has not even yet been proposed.

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
