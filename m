From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v2 01/17] IB/Verbs: Implement new callback query_transport()
 for each HW
Date: Thu, 09 Apr 2015 11:34:04 +0200
Message-ID: <5526478C.9030304@profitbricks.com>
References: <5523CCD5.6030401@profitbricks.com>	 <5523D098.3020007@profitbricks.com> <1428517786.2980.180.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1428517786.2980.180.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, PJ Waskiewicz <pj.waskiewicz-PrFOU5CTvK1l57MIdRCFDg@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, Bart Van Assche <bvana>
List-Id: linux-rdma@vger.kernel.org

On 04/08/2015 08:29 PM, Doug Ledford wrote:
> On Tue, 2015-04-07 at 14:42 +0200, Michael Wang wrote:
>> Add new callback query_transport() and implement for each HW.
> 
> My response here is going to be a long email, but that's because it's
> easier to respond to the various patches all in one response in order to
> preserve context.  So, while I'm responding to patch 1 of 17, my
> response will cover all 17 patches in whole.

Thanks for the review :-)

> 
>> Mapping List:
[snip]
>>
>> diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
>> index 18c1ece..a9587c4 100644
>> --- a/drivers/infiniband/core/device.c
>> +++ b/drivers/infiniband/core/device.c
>> @@ -76,6 +76,7 @@ static int ib_device_check_mandatory(struct ib_device *device)
>>  	} mandatory_table[] = {
>>  		IB_MANDATORY_FUNC(query_device),
>>  		IB_MANDATORY_FUNC(query_port),
>> +		IB_MANDATORY_FUNC(query_transport),
>>  		IB_MANDATORY_FUNC(query_pkey),
>>  		IB_MANDATORY_FUNC(query_gid),
>>  		IB_MANDATORY_FUNC(alloc_pd),
> 
> I'm concerned about the performance implications of this.  The size of
> this patchset already points out just how many places in the code we
> have to check for various aspects of the device transport in order to do
> the right thing.  Without going through the entire list to see how many
> are on critical hot paths, I'm sure some of them are on at least
> partially critical hot paths (like creation of new connections).  I
> would prefer to see this change be implemented via a device attribute,
> not a functional call query.  That adds a needless function call in
> these paths.

That's exactly the first issue come into my mind while working on this.

Mostly I was influenced by the current device callback mechanism, we have
plenty of query callback and they are widely used in hot path, thus I
finally decided to use query_transport() to utilize the existed mechanism.

Actually I used to learn that the bitmask operation is somewhat expensive
too, while the callback may only cost two register, one instruction and
twice jump, thus I guess we may need some benchmark to tell the difference
on performance, so I just pick the easier way as first step :-P

> 
>> diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
>> index f93eb8d..83370de 100644
>> --- a/drivers/infiniband/core/verbs.c
>> +++ b/drivers/infiniband/core/verbs.c
>> @@ -133,14 +133,16 @@ enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device, u8 port_
>>  	if (device->get_link_layer)
>>  		return device->get_link_layer(device, port_num);
>>  
>> -	switch (rdma_node_get_transport(device->node_type)) {
>> +	switch (device->query_transport(device, port_num)) {
>>  	case RDMA_TRANSPORT_IB:
>> +	case RDMA_TRANSPORT_IBOE:
>>  		return IB_LINK_LAYER_INFINIBAND;
> 
> If we are perserving ABI, then this looks wrong.  Currently, IBOE
> returnsi transport IB and link layer Ethernet.  It should not return
> link layer IB, it does not support IB link layer operations (such as MAD
> access).

That's my bad, IBOE is ETH link layer.

> 
[snip]
>>  };
> 
> I'm also concerned about this.  I would like to see this enum
> essentially turned into a bitmap.  One that is constructed in such a way
> that we can always get the specific test we need with only one compare
> against the overall value.  In order to do so, we need to break it down
> into the essential elements that are part of each of the transports.
> So, for instance, we can define the two link layers we have so far, plus
> reserve one for OPA which we know is coming:

The idea sounds interesting, but frankly speaking I'm already starting to
worried about the size of this patch set...

I really prefer to move optimizing/reforming work like this into next stage,
after this pioneer patch set settle down and working stably, after all, we
have already get rid of the old transport helpers, reforming based on
that should be far more easier and clear.

Next version will be reorganized to separate the implementation and wrapper
replacement, which make the patch set even bigger, fortunately, since the logical
is not very complex, we are still able to handle it, I really prefer we can
focus on performance and concise after infrastructure built up.

> 
> RDMA_LINK_LAYER_IB       = 0x00000001,
> RDMA_LINK_LAYER_ETH      = 0x00000002,
> RDMA_LINK_LAYER_OPA      = 0x00000004,
> RDMA_LINK_LAYER_MASK     = 0x0000000f,
[snip]
> 
> From patch 2/17:
> 
> 
>> +static inline int rdma_ib_mgmt(struct ib_device *device, u8 port_num)
>> +{
>> +       enum rdma_transport_type tp = device->query_transport(device,
>> port_num);
>> +
>> +       return (tp == RDMA_TRANSPORT_IB || tp == RDMA_TRANSPORT_IBOE);
>> +}
> 
> This looks wrong.  IBOE doesn't have IB management.  At least it doesn't
> have subnet management.

This helper actually could be erased at last :-) after Sean's suggestion on cma
stuff, no where need this raw helper anymore, just cap_ib_cm(), cap_iw_cm()
and cap_ib_mad() is enough.

> 
> Actually, reading through the remainder of the patches, there is some
> serious confusion taking place here.  In later patches, you use this as
> a surrogate for cap_cm, which implies you are talking about connection
> management.  This is very different than the rdma_dev_ib_mgmt() test
> that I create above, which specifically refers to IB management tasks
> unique to IB/OPA: MAD, SM, multicast.
[snip]
>> +static inline int cap_ib_mad(struct ib_device *device, u8 port_num)
>> +{
>> +       return rdma_ib_mgmt(device, port_num);
>> +}
>> +
> 
> Why add cap_ib_mad?  It's nothing more than rdma_port_ib_fabric_mgmt
> with a new name.  Just use rdma_port_ib_fabric_mgmt() everywhere you
> have cap_ib_mad.

That will be excellent if we use more concise semantic to address the
requirement, but I really want to make this as next stage since it sounds
like not a small topic...

At this stage I suggest we focus on:
1. erase all the scene using old transport/link-layer helpers
2. classify helpers for each management branch somewhat accurately
3. make sure it's table and works well (most important!)

So we can do further reforming based on that milestone in future ;-)

> 
[snip]
> 
> rdma_port_get_read_sge(dev, port)
> {
> 	if (rdma_transport_is_iwarp)
> 		return 1;
> 	return dev->port[port]->max_sge;
> }
> 
> Then, as Jason points out, if at some point in the future the kernel is
> modified to support devices with assymetrical read/write SGE sizes, this
> function can be modified to support those devices.

This part is actually a big topic too... frankly speaking I prefer some
expert in that part to reform the stuff in future and give a good testing :-)

> 
> Patch 10/17:
> 
> As Sean pointed out, force_grh should be rdma_dev_is_iboe().  The cm
> handles iw devices, but you notice all of the functions you modify here
> start with ib_.  The iwarp connections are funneled through iw_ specific
> function variants, and so even though the cm handles iwarp, ib, and roce
> devices, you never see anything other than ib/iboe (and opa in the
> future) get to the ib_ variants of the functions.  So, they wrote the
> original tests as tests against the link layer being ethernet and used
> that to differentiate between ib and iboe devices.  It works, but can
> confuse people.  So, everyplace that has !rdma_transport_ib should
> really be rdma_dev_is_iboe instead.  If we ever merge the iw_ and ib_
> functions in the future, having this right will help avoid problems.

Exactly, we noticed that the name transport do confusing peoples, next
version will use rdma_tech_iboe() to distinguish from transport stuff,
I guess that will make thing more clear :-)

> 
> Patch 11/17:
> 
> I wouldn't reform the link_layer_show except to make it compile with the
> new defines I used above.  

This is try to erase the old transport/link-layer helpers, so we could have
a clean stage for further reforming ;-)

> 
[snip]
> 
> OK.
> 
> Patch 17/17:
> 
> I would drop this patch.  In the future, the mlx5 driver will support
> both Ethernet and IB like mlx4 does, and we would just need to pull this
> code back to core instead of only in mlx4.

Actually we don't need that helper anymore, mlx4 can directly using it's own
implemented get_link_layer(), I just leave it there as a remind.

It doesn't make sense to put it in core level if only mlx4/5 using it, mlx5
would have it's own get_link_layer() implementation too if it's going to support
ETH port, they just need to use that new one :-)


Regards,
Michael Wang

> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
