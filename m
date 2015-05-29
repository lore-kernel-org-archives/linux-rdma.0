From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next V1 00/11] Add completion timestamping support
Date: Fri, 29 May 2015 18:47:08 +0300
Message-ID: <CAJ3xEMj-N7JjasWfpP+H+tMyGpbeWQKxnN_SWQngPpGW5YywRg@mail.gmail.com>
References: <1432220202-9834-1-git-send-email-ogerlitz@mellanox.com>
	<55678BA6.4050503@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55678BA6.4050503-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 29, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org> wrote:
> On 5/21/2015 9:56 AM, Or Gerlitz wrote:

>> A user-space application could get the current HW's clock by executing
>>
>> ibv_query_values_ex(struct ibv_context *context, uint32_t q_values,
>>                      struct ibv_values_ex *values)
>>
>> The function gets a mask of the values to query and return their values.
>> Vendors could either implement this as a uverb command or use their
>> user-space driver to return those values directly from the HW (the mlx4
>> way).


> I'm just reviewing this now, and I haven't looked at the user side, but it
> appears the CQE timestamp is available for all devices to support or not in
> a generic manner.  IE it is part of the extended CQ UAPI.  But the task of
> fetching the current timestamp value/mask seems to be device-specific.

Steve,

Since there are no kernel consumers at this point, the series only
implemented the IB core kernel parts which are needed for proper usage
@ user-space, namely: CQ creation with a time-stamping flag, and
extension of the query device verb which returns the clock mask and
frequency, etc.

In user-space, applications would work against libibverbs, all
standard. They would query the device, create their CQs, get the
completion time-stamp from the CQE (ibv_wc) and the current clock
sample from a new verb ibv_query_values_ex which was mentioned above,
the user-space code is still in internal review, but here's a ref to
early drop I posted here couple of days ago


https://github.com/matanb10/libibverbs timestamp-v0
https://github.com/matanb10/libmlx4 timestamp-v0


> Shouldn't that also be a standard operation that devices can choose to
> support or not?    IE an application can generically setup a CQ and get
> timestamps on CQEs, but it seems the application would have to have
> device-specific code to get the current timestamp/mask.  Perhaps I'm not
> understanding the design?

No, nothing device specific from the application POV

see the ibv_query_values_ex introduction

https://github.com/matanb10/libibverbs/commit/89c439e34ab234d5d58bd92804829a0aa6efb3ca
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
