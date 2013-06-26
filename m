From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH V2 for-next 1/4] IB/core: Add receive Flow Steering support
Date: Wed, 26 Jun 2013 16:33:59 -0500
Message-ID: <51CB5E47.7090404@opengridcomputing.com>
References: <1372251464-13394-1-git-send-email-ogerlitz@mellanox.com> <1372251464-13394-2-git-send-email-ogerlitz@mellanox.com> <1828884A29C6694DAF28B7E6B8A823736FD36FF3@ORSMSX109.amr.corp.intel.com> <CAJZOPZK_FkCJZxjyxEdk4WOTvbo8DQpcpqmuPUsqV=bZmU5W_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZK_FkCJZxjyxEdk4WOTvbo8DQpcpqmuPUsqV=bZmU5W_w-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <hadarh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/26/2013 4:13 PM, Or Gerlitz wrote:
> On Wed, Jun 26, 2013 at 10:56 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>>> The input to ib_create_flow is instance of struct ib_flow_attr which
>>> contain few mandatory control elements and optional flow specs.
>>>
>>> struct ib_flow_attr {
>>>        enum ib_flow_attr_type type;
>>>        u16      size;
>>>        u16      priority;
>>>        u8       num_of_specs;
>>>        u8       port;
>>>        u32      flags;
>> This structure could be aligned better.
> OK, I assume you mean arrange fields by decreasing size, correct? so
> here we need to  put the flags field before the size field.
>
>>>        /* Following are the optional layers according to user request
>>>         * struct ib_flow_spec_yyy
>>>         * struct ib_flow_spec_zzz
>>>         */
>>> };
>>>
>>> As these specs are eventually coming from user space, they are defined and
>>> used in a way which allows adding new spec types without kernel/user ABI
>>> change, and with a little API enhancement which defines the newly added spec.
>>>
>>> The flow spec structures are defined in a TLV (Type-Length-Value) manner,
>>> which allows to call ib_create_flow with a list of variable length of
>>> optional specs.
>>>
>>> For the actual processing of ib_flow_attr the driver uses the number of
>>> specs and the size mandatory fields along with the TLV nature of the specs.
>>>
>>> Steering rules processing order is according to rules priority. The user
>>> sets the 12 low-order bits from the priority field and the remaining
>>> 4 high-order bits are set by the kernel according to a domain the
>>> application or the layer that created the rule belongs to. Lower
>>> priority numerical value means higher priority.
>> Why are bit fields being exposed to the user in this way?
> Yes, this is probably not general enough. So what would you suggest,
> use a more integral division? e.g 16 bits for priority and 16 bits for
> location?

If the kernel driver is setting the "location", whatever that is, why 
would the application need access to it?  IE isn't a priority field 
enough to allow the application provide an ordering/prioritization to 
the rules?

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
