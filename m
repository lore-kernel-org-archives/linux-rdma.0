From: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next v3 7/7] IB/core: Change wc.slid from 16 to 32
 bits
Date: Wed, 9 Aug 2017 09:46:35 -0700
Message-ID: <772a7324-5d42-3259-7881-483722fc1f2e@intel.com>
References: <1496943469-44017-1-git-send-email-don.hiatt@intel.com>
 <1496943469-44017-8-git-send-email-don.hiatt@intel.com>
 <1502219143.3002.10.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1502219143.3002.10.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 8/8/2017 12:05 PM, Doug Ledford wrote:
> On Thu, 2017-06-08 at 13:37 -0400, Don Hiatt wrote:
>> slid field in struct ib_wc is increased to 32 bits.
>> This enables core components to use larger LIDs if needed.
>> The user ABI is unchanged and return 16 bit values when queried.
> Hi Don,
>
> My comments here are not really about this particular patch, I just
> grabbed it from the pile as one to respond to.  But my question is
> this:
>
> Multiple of these patch say the user ABI is unchanged and return 16 bit
> values when queried.  What's your plan for a long term solution to
> this?  Eventually, the user ABI will need to be extended to support
> 32bit LIDs, yes?  Or do you plan to try and hide this forever?
>
> As for the kernel to user space driver API, I waffled a bit about
> whether we shouldn't go ahead and return the 32bit value to the driver
> and let it do the conversion to 16 bit for the user ABI, then decided
> this method provides a cleaner means of supporting newer kernels with
> older verbs OPA drivers and so didn't object, but it still leaves the
> question about the long term plans here.
>
Hi Doug,

Our long term plan is to use the new verbs 2 API for extending
the LID size. We do not plan to keep this hidden forever and plan to
use the new API once it's available.

Thanks.

don



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
