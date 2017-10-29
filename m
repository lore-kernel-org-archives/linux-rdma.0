From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/16] Flow counters support
Date: Sun, 29 Oct 2017 17:21:20 +0200
Message-ID: <CAFgAxU-UcRapsoRn3hNUn27xgY370gUJ+WWE4URBq84ufkCXtA@mail.gmail.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
 <20171023165118.GA18097@obsidianresearch.com> <b003f6e5-d7ce-3775-a1dc-0fd0f507a515@dev.mellanox.co.il>
 <20171025151734.GA15557@obsidianresearch.com> <AM6PR0502MB3783A1186AA0ABDCCD5359AEBD5A0@AM6PR0502MB3783.eurprd05.prod.outlook.com>
 <20171027155955.GA15922@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171027155955.GA15922-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 27, 2017 at 5:59 PM, Jason Gunthorpe
<jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org> wrote:
> On Fri, Oct 27, 2017 at 03:46:57PM +0000, Guy Shattah wrote:
>> On Wed, Oct 25, 2017 at 06:17:15PM +0300, Jason Gunthorpe wrote:
>> >On Wed, Oct 25, 2017 at 05:58:15PM +0300, Yishai Hadas wrote:
>>
>> counters are not group in hardware unique but in an intuitive way.
>
> I don't think you understand my remark.
>
> I do not want to expose the idea of hardware limited groupings of
> counters to the user at all.
>
> If the user needs counters 1,2 then the user should request those
> counters only. Hardware that needs to sample, say, counter 1,2,3,4 to
> get those will have to figure that out internally.

Since this is all about measuring verbs objects, it seems sensible for
us to group the counters by that same verbs sets.
But we don't have to go that way.
We can keep a flat list describing all available counters for all verbs objects.
Or maybe you're thinking of some other method for the user to learn
about available counters and their respectful objects?

> If the API requires a complex query interface just for the user it use
> it at all, then it is a total failure in my view. And that seems to be
> what is proposed here.
>
>> >That is unfortunate, and kind of lame, but you can still use the
>> >proposed API by re-ordering things. Continue to have
>> >ibv_add_sampling_point_flow, however a NULL flow argument will make
>> >the counters become added when the flow is created:
>> >
>> >?counters = ibv_create_counters([..]);

to clarify, does this create a single counter collection? what is
referred to as counter_set in the RFC/patches? or multiple counter's'?
I assume the '[..]' is ibv_context.


>> >?ibv_add_sampling_point_flow(counters, 1, NULL, [..])

so do we really need the flow object handle is this API (the 'NULL')?
why not go with a 'ibv_set_sampling_point(counters, 1, [..])' which
covers any/all counter definition for any object?
and when needed add the ibv_attach_sampling_point_qp().

and we need to clear the definition of '[..]'... does user learns what
inputs are valid from a describe API, or some other method (re the
above describe API question)?


>> >?flow_attr.counters = counters;
>> >?ibv_create_flow(qp, &flow_attr);

Works OK for mlx5 HW/driver

>> As mentioned earlier - current hardware support attachment of counters
>> only during the creation of the object (flow/qp/etc).
>
> And as I explained, the above addresses that.
>
>> Your proposal could be useful in the case where a structure of a dynamic
>> counter set is to be modified. However - since it is not the current case,
>> there is no benefit in dividing the build of such a counter-set into
>> several steps.
>
> The purpose is to make the API less dependent on specific
> implementation details.
>
> Mellanox drivers may wish to implement ibv_add_sampling_point_* as
> some kind of internal bookkeeping in userspace, other drives may wish
> to do kernel calls. It depends on how each type of hardware works.

Yes, we definitely need to make sure the API allows this u.s.
bookkeeping and reduce the amount system calls.
So the verbs CMD will allow 1 or more sampling points definitions.
In an OVS use case there can be many 10,000'nd of flows + counters and
this needs to be fast.

> You need to stop looking at the API through a Mellanox only lense.

In our patches we listed all vendor specific counter types in the
vendor driver code, and allow access to this set through generic verbs
in the describe API.
In our api, any vendor could utilize the same api to expose their
vendor specific counters.
In your suggestion, how do vendors add their specific HW dependent counters?

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
