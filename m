From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/16] Flow counters support
Date: Wed, 25 Oct 2017 09:17:34 -0600
Message-ID: <20171025151734.GA15557@obsidianresearch.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
 <20171023165118.GA18097@obsidianresearch.com>
 <b003f6e5-d7ce-3775-a1dc-0fd0f507a515@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <b003f6e5-d7ce-3775-a1dc-0fd0f507a515-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 25, 2017 at 05:58:15PM +0300, Yishai Hadas wrote:

> Hi Jason, please go over the patches/uapi, we believe that you'll find it
> quite easy to be used by an application, however we plan to improve as of
> below.

No, it is not, this proposal relies too much on device-specific
information to make sense in a multi-vendor context. Counters should
not be grouped in a hardware unique way.

But it is still hard to understand what you are talking about, so
maybe if you provide a short and clearer example..

> #The create API:
> We found it better to stay with our suggested API with few changes, below
> notes were considered.
> 
> 1) There might be a hardware that doesn't support attaching a counter object
> to an existing object, your suggested API to set sampling points relay on
> that ability.

That is unfortunate, and kind of lame, but you can still use the
proposed API by re-ordering things. Continue to have
ibv_add_sampling_point_flow, however a NULL flow argument will make
the counters become added when the flow is created:

 counters = ibv_create_counters([..]);
 ibv_add_sampling_point_flow(counters, 1, NULL, [..])
 flow_attr.counters = counters;
 ibv_create_flow(qp, &flow_attr);

> 2) We prefer using one single system call to create the ib_counter object
> with its required counters instead of creating it with sampling points which
> might involve many system calls.

No. More system calls are good for something like this, there is a lot
of possibly future variety here. Systems calls are better than huge
structs and comp mask.

It allows you to ditch the silly describe API by making the creation
side more granular.

> 3) We don't have at the moment a customer use case to remove a sampling
> point, we expect an application to create an IB counter with its relevant
> counters and use it. This ability can be added in the future upon demand, on
> objects that support that by some modify API.

Ok

> 4) Currently the API introduces vendor ordering based on the describe output
> and exposes only the option to read all counters from the given counter
> type. For day one we find it enough as for now there is only one counted
> type that is supported (i.e. Flow) by mlx5 driver and it exposes
> only 2 counters. However, as the API is extensible we can extend it with
> comp_mask to get some other input which may control the ordering/partial
> counters/compound objects in the future based on demand.

I don't understand this remark, why would irderubg ever matter for
counters?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
