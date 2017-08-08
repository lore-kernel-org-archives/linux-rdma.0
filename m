From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH rdma-next v3 7/7] IB/core: Change wc.slid from 16 to 32
 bits
Date: Tue, 08 Aug 2017 15:05:43 -0400
Message-ID: <1502219143.3002.10.camel@redhat.com>
References: <1496943469-44017-1-git-send-email-don.hiatt@intel.com>
         <1496943469-44017-8-git-send-email-don.hiatt@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496943469-44017-8-git-send-email-don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Don Hiatt <don.hiatt-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-06-08 at 13:37 -0400, Don Hiatt wrote:
> slid field in struct ib_wc is increased to 32 bits.
> This enables core components to use larger LIDs if needed.
> The user ABI is unchanged and return 16 bit values when queried.

Hi Don,

My comments here are not really about this particular patch, I just
grabbed it from the pile as one to respond to.  But my question is
this:

Multiple of these patch say the user ABI is unchanged and return 16 bit
values when queried.  What's your plan for a long term solution to
this?  Eventually, the user ABI will need to be extended to support
32bit LIDs, yes?  Or do you plan to try and hide this forever?

As for the kernel to user space driver API, I waffled a bit about
whether we shouldn't go ahead and return the 32bit value to the driver
and let it do the conversion to 16 bit for the user ABI, then decided
this method provides a cleaner means of supporting newer kernels with
older verbs OPA drivers and so didn't object, but it still leaves the
question about the long term plans here.

-- 
Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
    GPG KeyID: B826A3330E572FDD
    Key fingerprint = AE6B 1BDA 122B 23B4 265B  1274 B826 A333 0E57 2FDD

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
