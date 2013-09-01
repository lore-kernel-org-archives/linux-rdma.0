From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V4 for-next 3/4] IB/core: Export ib_create/destroy_flow
 through uverbs
Date: Sun, 1 Sep 2013 12:18:00 +0300
Message-ID: <52230648.5000302@mellanox.com>
References: <1377694075-29287-1-git-send-email-matanb@mellanox.com> <1377694075-29287-4-git-send-email-matanb@mellanox.com> <20130828162050.GA31381@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130828162050.GA31381-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Hadar Hen Zion <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <shawn.bohrer-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tzahi Oved <tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 28/8/2013 7:21 PM, Jason Gunthorpe wrote:
> On Wed, Aug 28, 2013 at 03:47:54PM +0300, Matan Barak wrote:
>> +
>> +	if (cmd.comp_mask)
>> +		return -EINVAL;
>
> So, how do you propose to interoperate with new user space/old
> kernels?
>
> How will user space know what comp_mask values the kernel will
> support?
>

struct ib_uverbs_create_flow_resp contains a comp_mask value. This value
should contain the supported comp_masks fields.
Currently, we don't support any extensions, so we zero this field by 
doing "memset(&resp, 0, sizeof(resp));"

I suggest returning an error and setting the response comp_mask field.

> The notion that was established in the verbs patches is that extra
> structure fields are ignored by old software.
>
I'm not aware of any such concrete example. Could you please point out ?
I think it's safer to return an error. Imagine that ibv_modify_qp was 
extended for some crucial field, say IB_QP_AV2. Creating a QP without 
indicating its AV (or AV2 in that case) is an invalid behavior. This 
example is a bit artificial, though some future extensions could have 
such mandatory fields.
The user should do ibv_query_device before requesting features that 
might be unsupported.

>> +	if ((cmd.flow_attr.type == IB_FLOW_ATTR_SNIFFER &&
>> +	     !capable(CAP_NET_ADMIN)) || !capable(CAP_NET_RAW))
>> +		return -EPERM;
>> +
>> +	if (cmd.flow_attr.num_of_specs < 0 ||
>> +	    cmd.flow_attr.num_of_specs > IB_FLOW_SPEC_SUPPORT_LAYERS)
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ > checked here
>> +		return -EINVAL;
>> +
>> +	kern_attr_size = cmd.flow_attr.size - sizeof(cmd) -
>> +			 sizeof(struct ib_uverbs_cmd_hdr_ex);
>> +
>> +	if (cmd.flow_attr.size < 0 || cmd.flow_attr.size > in_len ||
>> +	    kern_attr_size < 0 || kern_attr_size >
>> +	    (cmd.flow_attr.num_of_specs * sizeof(struct ib_kern_spec)))
>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>
> Watch out for integer overflow here..
I don't think there's a risk of integer overflow since sizeof(struct 
ib_kern_spec) is a constant of ~50 bytes long and 
cmd.flow_attr.num_of_specs is checked above and is at most 4.
>
> Jason
>

Since the code was already merged, I'll post an incremental patch and I 
suggest that we'll continue things there.

- Matan

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
