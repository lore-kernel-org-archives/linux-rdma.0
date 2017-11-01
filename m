From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/16] Flow counters support
Date: Wed, 1 Nov 2017 12:18:07 -0600
Message-ID: <20171101181807.GJ1030@ziepe.ca>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
 <20171023165118.GA18097@obsidianresearch.com>
 <b003f6e5-d7ce-3775-a1dc-0fd0f507a515@dev.mellanox.co.il>
 <20171025151734.GA15557@obsidianresearch.com>
 <AM6PR0502MB3783A1186AA0ABDCCD5359AEBD5A0@AM6PR0502MB3783.eurprd05.prod.outlook.com>
 <20171027155955.GA15922@obsidianresearch.com>
 <CAFgAxU-UcRapsoRn3hNUn27xgY370gUJ+WWE4URBq84ufkCXtA@mail.gmail.com>
 <20171029180019.GE4488@ziepe.ca>
 <CAFgAxU_CMxQ616wBd-vkvyJ905ndLHrabmWtJ-Ye_hgSwWqiag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAFgAxU_CMxQ616wBd-vkvyJ905ndLHrabmWtJ-Ye_hgSwWqiag-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 01, 2017 at 11:32:26AM +0200, Alex Rosenbaum wrote:

> Yes, the original suggestion was based on strings. but let's go with enum.
> We didn't plan on a global set from start (based on strings), but
> going with enum in verbs.h definitely makes sense to define some of
> these as global scope and additional vendor/DV will always be required
> (maybe above some IBV_COUNTER_VENDOR_RANGE value).

Well, I would have insisted on some well defined global strings...

> > If the 'add_sampling_point_x' doesn't work then the counter is not
> > supported by the driver. Simple.
> 
> Since we don't want the provider lib to go to Kernel each call, we
> need to keep the counter capability (aka: describe) uverbs command, at
> least for the provider lib usage to get the values of supported
> counters for its device.

How you do that is up to your driver, I don't think we need a fully
complex describe API from the kernel. Just some simple HW specific
bitsets that indicate what level of support the driver and hardware
have. mlx can't have that many permutations, right?

> application can test the support as you mentioned above. But it is
> always better to expose caps to user like most other verbs resources
> do and we'll need in for our mlx library any way.

There are many ways to approach cap testing, we don't always need to
return a huge struct, for instance:

 ibv_query_counter_cap(...)

Is probably much saner.

> I would suggest to move it to be part of struct ibv_device_attr_ex {
> struct ibv_counter_cap *counter_caps } retrieved from
> ibv_query_device_ex() instead of a dedicated API.
> Where struct ibv_counter_cap will hold an array of supported
> ibv_counter_type enums by the device and maybe some flags per type to
> indicate extra capabilities: volatile, cached.
> Maybe even a short "pretty" string.

This might ultimately make sense as a verbs API of some kind, but not
sure we need a kernel call to support it..

> There are 2 usage models I see which probably caused the misunderstanding here:
> 1. add/remove a counter during the verbs objects life cycle to measure
> during a short period. Main use case will be debug or periodic
> auto-tuning of resources. This matches your API design nicely.
> 2. measure the entire objects activity. OVS offload of flows must
> report back 100% of the activity (redirect or drop of all packets).
> This requires to create the flow/qp atomically bounded with the
> counter. Currently this does not match your suggested API. I guess
> that where our disagreement are coming from.

I said to pass NULL for the sampling point object and then pass the
counter object to the create:

> In case #2 we'll have to bind the counter handle to the verbs object
> while creating the object: ibv_create_flow(flow, attr{coutner}) or
> ibv_create_qp(qp, attr{counter}).

Which seems perfectly fine for all uses case.

Having the object argument, even if NULL, lets us scope the counters
to the object under use, so eg we can have more generic counts like
PACKETS_RECIEVED, and if you apply that to a flow group it is the
packets entering the flow group, and if you apply it to a QP it is the
packets entering the QP, etc.

Having QP*FLOW*COUNTS labels seems overly complicated.

It also allows the API to reject confusing request eg,

  ibv_set_sampling_point_qp(counters, 0, NULL, FLOW_DISCARDED);

Should fail, as 'FLOW_DISCARDED' is a counter specific only to flows,
and asking to associate it with a QP is wrong.

It makes it much clearer in the API excatly what thing is being
counted without having to consult a manual.

> > Can mlx do the 'add counter' for any counter??
> Not sure I understood your question exactly.

I mean, if I have an existing QP, can I start counting packets
received?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
