From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH for-next V1 00/11] Add completion timestamping support
Date: Thu, 28 May 2015 16:41:58 -0500
Message-ID: <55678BA6.4050503@opengridcomputing.com>
References: <1432220202-9834-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432220202-9834-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 5/21/2015 9:56 AM, Or Gerlitz wrote:
> Hi Doug,
>
> This patchset adds completion timestamping supports for verbs consumers.
>
> Timestamping is used by applications in order to know when a WQE was
> received/transmitted by the HW. The value is given is HCA hardware cycles,
> but could be easily converted as the hardware's core clock frequecny is
> available through extension of query device.
>
> Moreover, we add an ability to read the HCA's current clock. This could be
> useful on order to synchronize events to the wall clock.
>
> This functionality is achieved by adding/extending the following verbs:
>
> create_cq - create_cq is extended in order to allow passing creation flags
> to the CQ creation function. We change IB/core --> vendors API
> to be easily extendible by passing a struct which contains
> comp_vectors, cqe and the new flags parameter. In order to create
> CQ which supports timestamping, IB_CQ_FLAGS_TIMESTAMP should be given.
>
> query_device - We extend query_device uverb further by giving the hardware's
> clock frequency and the timestamp mask (the number of timestamp
> bits which are supported). If timestamp isn't supported, 0 is returned.
>
> In order to read the timestamp in the WQE, the user needs to query the device
> for support, create an appropriate CQ (using the extanded uverb with
> IB_CQ_FLAGS_TIMESTAMP) and poll the CQ with an extended poll_cq verb (currently,
> only implemented in user-space).
>
> In mlx4, allowing the user to read the core clock efficiently involves mapping
> this area of the hardware to user-space (being done by using a mmap command)
> and reading the clock from the correct offset of the page.
>
> This offset is returned in the vendor's specific data from mlx4's kernel driver
> to the mlx4's user-space driver. query_device is modified in order to support
> passing this vendor specific data. A user-space application could use a new
> verb in order to read the hardware's clock.
>
> Translating the hardware's clock into ms could be done by dividing this
> value by hca_core_clock (which is returned by the extended version of
> query_device uverb).
>
> A user-space application could get the current HW's clock by executing
>
> ibv_query_values_ex(struct ibv_context *context, uint32_t q_values,
>                      struct ibv_values_ex *values)
>
> The function gets a mask of the values to query and return their values.
> Vendors could either implement this as a uverb command or use their
> user-space driver to return those values directly from the HW (the mlx4 way).

I'm just reviewing this now, and I haven't looked at the user side, but 
it appears the CQE timestamp is available for all devices to support or 
not in a generic manner.  IE it is part of the extended CQ UAPI.  But 
the task of fetching the current timestamp value/mask seems to be 
device-specific.   Shouldn't that also be a standard operation that 
devices can choose to support or not?    IE an application can 
generically setup a CQ and get timestamps on CQEs, but it seems the 
application would have to have device-specific code to get the current 
timestamp/mask.  Perhaps I'm not understanding the design?

Steve.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
