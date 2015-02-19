From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 09/30] IB/core: Modify ib_verbs and cma in order to use roce_gid_cache
Date: Thu, 19 Feb 2015 16:00:12 +0200
Message-ID: <CAJ3xEMj3ZLqOTXu-cEF4ia5DKBwuVtwm63mDHup1bSTK07hNKA@mail.gmail.com>
References: <1424383365-19337-1-git-send-email-somnath.kotur@emulex.com>
	<f91c8ed3-f6a4-4b63-85f9-870d9687a14f@CMEXHTCAS2.ad.emulex.com>
	<54E5DC82.1090805@mellanox.com>
	<54E5E381.5000105@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <54E5E381.5000105-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <somnath.kotur-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Feb 19, 2015 at 3:22 PM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> On 2/19/2015 2:52 PM, Haggai Eran wrote:
>> On 20/02/2015 00:02, Somnath Kotur wrote:
>>> --- a/drivers/infiniband/core/uverbs_cmd.c
>>> +++ b/drivers/infiniband/core/uverbs_cmd.c
>>> @@ -2089,15 +2089,16 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file
>>> *file,
>>>         attr->alt_ah_attr.port_num          = cmd.alt_dest.port_num;
>>>
>>>         if (qp->real_qp == qp) {
>>> -               ret = ib_resolve_eth_l2_attrs(qp, attr, &cmd.attr_mask);
>>> +               ret = ib_resolve_eth_dmac(qp, attr, &cmd.attr_mask);
>>>                 if (ret)
>>> -                       goto out;
>>> +                       goto out_put;
>>>                 ret = qp->device->modify_qp(qp, attr,
>>>                         modify_qp_mask(qp->qp_type, cmd.attr_mask),
>>> &udata);
>>>         } else {
>>>                 ret = ib_modify_qp(qp, attr, modify_qp_mask(qp->qp_type,
>>> cmd.attr_mask));
>>>         }
>>>
>>> +out_put:
>>>         put_qp_read(qp);
>>
>>
>> This seem to solve a leak of QP references when dmac resolution fails.
>> I'm not sure it belongs with the rest of the patch.
>
>
> I'll remove the fix from this patch.

we just pushed a fix to this leak

http://git.kernel.org/cgit/linux/kernel/git/roland/infiniband.git/commit/?id=0fb8bcf022f19a375d7c4bd79ac513da8ae6d78b
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
