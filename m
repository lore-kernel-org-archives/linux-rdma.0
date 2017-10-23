From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/16] Flow counters support
Date: Mon, 23 Oct 2017 10:51:18 -0600
Message-ID: <20171023165118.GA18097@obsidianresearch.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1508424118-27205-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 19, 2017 at 05:41:42PM +0300, Yishai Hadas wrote:

> More specifically,
> A generic interface with the following functionality is presented:
> - An option to know per device how many counter sets it exposes by using some
>   extension of the ib_query_device_ex() verb. (i.e. max_counter_sets).
> - Per counter set there is an API to get its metadata by using a new verb named
>    ib_describe_counter_set(), it gets a counter set id in range of 
>    [0,max_counter_sets - 1] and return the counter set information.
>    Some of the metadata is IB generic (e.g. counter set type, num counters in the set, etc.)
>    while other is some specific driver information (e.g. counters names).
> - Introduce counter set object named 'ib_counter_set' and its create/destroy
>   verbs. Post a successful creation the counter_set object can  be attached to
>   an IB object based on its type. (e.g. Flow, QP, etc.) 
> - Introduce the ib_query_counter_set() verb, it enables the user to read the
>   hardware counters which are associated with the counter set.
> - Introduce a new steering specification from type count 
>   (i.e. ib_flow_spec_action_count) which gets a previously created counter_id.
>   By creating a flow steering object with a counter, its counters can be read
>   by the ib_query_counter_set() verb.

I haven't seen the uapi yet, but I don't like the direction this is
going, this looks much too hard for applications to acutally use.

My suggestion for the verbs interface is:

// Create an object to hold the counters
counters = ibv_create_counters([..]);

// Sample a specific counter linked to a QP in counter index 0
ibv_set_sampling_point_qp(counters, 0, qp, [..])

// Sample a specific counter linked to a flow steering object in counter index 1
ibv_add_sampling_point_flow(counters, 1, flow, [..])

// Stop reading anything associated with index 1
ibv_clear_sampling_point(counters, 1);

// Sample global device PMA counters
ibv_add_sampling_point_device(counters, 2, verbs, port, [..])

// Retreive the counters from hardware or from cache
uint64_t data[2];
ibv_read_counters(counters, data, NELEMS(data), [..]);
printf("QP counter is %u\n", data[0]);

I don't want to expose this goofy idea of a 'counter set' to the user,
that is a some weird device spcecific thing, and every device will be
different. No way the user should have to deal with this.

To implement the above, your driver will have to determine the
hardware specific counter sets to instantiate under the covers, and
map their contents to the indexes the user is asking for with the above list.

If for some reason it cannot satisfy some combination of counters then
it should fail the add_sampling_point call.

There is not much reason to have a complex query API, use the 'setup
and catch failure' approach to detect what features the device
supports.

[..] will have to be something sensible to define the sampling
point, maybe an enum, or maybe a string? Not sure.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
