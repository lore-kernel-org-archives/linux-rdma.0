From: Alex Rosenbaum <rosenbaumalex-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/16] Flow counters support
Date: Wed, 1 Nov 2017 11:32:26 +0200
Message-ID: <CAFgAxU_CMxQ616wBd-vkvyJ905ndLHrabmWtJ-Ye_hgSwWqiag@mail.gmail.com>
References: <1508424118-27205-1-git-send-email-yishaih@mellanox.com>
 <20171023165118.GA18097@obsidianresearch.com> <b003f6e5-d7ce-3775-a1dc-0fd0f507a515@dev.mellanox.co.il>
 <20171025151734.GA15557@obsidianresearch.com> <AM6PR0502MB3783A1186AA0ABDCCD5359AEBD5A0@AM6PR0502MB3783.eurprd05.prod.outlook.com>
 <20171027155955.GA15922@obsidianresearch.com> <CAFgAxU-UcRapsoRn3hNUn27xgY370gUJ+WWE4URBq84ufkCXtA@mail.gmail.com>
 <20171029180019.GE4488@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171029180019.GE4488-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Cc: Guy Shattah <sguy-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Raed Salem <raeds-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Alex Rosenbaum <alexr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Oct 29, 2017 at 8:00 PM, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org> wrote:
> On Sun, Oct 29, 2017 at 05:21:20PM +0200, Alex Rosenbaum wrote:
>> On Fri, Oct 27, 2017 at 5:59 PM, Jason Gunthorpe wrote:
>> > On Fri, Oct 27, 2017 at 03:46:57PM +0000, Guy Shattah wrote:
>> >> On Wed, Oct 25, 2017 at 06:17:15PM +0300, Jason Gunthorpe wrote:
>> >> >On Wed, Oct 25, 2017 at 05:58:15PM +0300, Yishai Hadas wrote:

> Leon suggested a global documented enum, perhaps augmented with
> enum's from the DV headers? The original series suggested a string?

Yes, the original suggestion was based on strings. but let's go with enum.
We didn't plan on a global set from start (based on strings), but
going with enum in verbs.h definitely makes sense to define some of
these as global scope and additional vendor/DV will always be required
(maybe above some IBV_COUNTER_VENDOR_RANGE value).


> If the 'add_sampling_point_x' doesn't work then the counter is not
> supported by the driver. Simple.

Since we don't want the provider lib to go to Kernel each call, we
need to keep the counter capability (aka: describe) uverbs command, at
least for the provider lib usage to get the values of supported
counters for its device.
I agree that it is not a must for user to use the describe API and
application can test the support as you mentioned above. But it is
always better to expose caps to user like most other verbs resources
do and we'll need in for our mlx library any way.

I would suggest to move it to be part of struct ibv_device_attr_ex {
struct ibv_counter_cap *counter_caps } retrieved from
ibv_query_device_ex() instead of a dedicated API.
Where struct ibv_counter_cap will hold an array of supported
ibv_counter_type enums by the device and maybe some flags per type to
indicate extra capabilities: volatile, cached.
Maybe even a short "pretty" string.


>> >> >?ibv_add_sampling_point_flow(counters, 1, NULL, [..])
>>
>> so do we really need the flow object handle is this API (the
>> 'NULL')?
>
> I had original drafted it with the idea that counters would be added/removed
> to pre-existing verbs objects. This would support a fairly usual 'turn
> on performance monitoring/turn off performance monitoring' kind of
> application flow, when the counters were being used for monitoring.
>
> I think mlx has designed the chip and was thinking of the API for some
> other purpose where the counters always exist.

There are 2 usage models I see which probably caused the misunderstanding here:
1. add/remove a counter during the verbs objects life cycle to measure
during a short period. Main use case will be debug or periodic
auto-tuning of resources. This matches your API design nicely.
2. measure the entire objects activity. OVS offload of flows must
report back 100% of the activity (redirect or drop of all packets).
This requires to create the flow/qp atomically bounded with the
counter. Currently this does not match your suggested API. I guess
that where our disagreement are coming from.
In case #2 we'll have to bind the counter handle to the verbs object
while creating the object: ibv_create_flow(flow, attr{coutner}) or
ibv_create_qp(qp, attr{counter}).


> Having the argument allows both use models if hardware comes along.
yes, agreed. At least I'm not against it, but definitely would like to
see a global scope add API which fits better a flat counter enum
model.
As I mentioned in previously email: ibv_add_sampling_point(counters, 1, [..])


> Can mlx do the 'add counter' for any counter??
Not sure I understood your question exactly.
mlx5 devices has counter-sets which can be bound to a flow object, and
other kind of counter-sets which can be bound to a QP, and some
additional ones too.
We can create both in HW (attached to flow and qp respectfully) and in
driver copy the relevant values to the user's counter object in the
correct location.


These changes will require some time to re-work the code.
Once we agree on the model, we'll go back to a more details arch and
implementation cycle and update on ML.

Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
