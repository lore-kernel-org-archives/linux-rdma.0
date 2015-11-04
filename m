From: Somnath Kotur <somnath.kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
Subject: Re: IB/core: Use GID table in AH creation and dmac resolution
Date: Wed, 4 Nov 2015 09:58:33 +0530
Message-ID: <CAOBf=mtGaVPvaFu6pJ36knhbK0e-UWmQ5R59KW+eyBFJhxu3cQ@mail.gmail.com>
References: <20151103131140.GA12150@mwanda> <5638BA57.6050203@mellanox.com> <CAOBf=msvVXCw129URdiWTLogGOpAjzboCB=h0haTh4wJZG5XXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOBf=msvVXCw129URdiWTLogGOpAjzboCB=h0haTh4wJZG5XXw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Thanks Dan and Matan.

We will take a look and revert on this

Thanks
Som

On Wed, Nov 4, 2015 at 9:31 AM, Somnath Kotur
<somnath.kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org> wrote:
> Thanks Dan and Matan.
>
> We will take a look and revert on this
>
> Thanks
> Som
>
> On Tue, Nov 3, 2015 at 7:14 PM, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
>>
>>
>>
>> On 11/3/2015 3:11 PM, Dan Carpenter wrote:
>>>
>>> Hello Matan Barak,
>>>
>>> This is a semi-automatic email about new static checker warnings.
>>>
>>> The patch dbf727de7440: "IB/core: Use GID table in AH creation and
>>> dmac resolution" from Oct 15, 2015, leads to the following Smatch
>>> complaint:
>>>
>>> drivers/infiniband/hw/ocrdma/ocrdma_ah.c:157 ocrdma_create_ah()
>>>          error: we previously assumed 'sgid_attr.ndev' could be null (see
>>> line 146)
>>>
>>> drivers/infiniband/hw/ocrdma/ocrdma_ah.c
>>>     145         }
>>>     146         if (sgid_attr.ndev) {
>>>                      ^^^^^^^^^^^^^^
>>> Patch introduces a NULL check.
>>>
>>>     147                 if (is_vlan_dev(sgid_attr.ndev))
>>>     148                         vlan_tag =
>>> vlan_dev_vlan_id(sgid_attr.ndev);
>>>     149                 dev_put(sgid_attr.ndev);
>>>     150         }
>>>     151
>>>     152         if ((pd->uctx) &&
>>>     153             (!rdma_is_multicast_addr((struct in6_addr
>>> *)attr->grh.dgid.raw)) &&
>>>     154             (!rdma_link_local_addr((struct in6_addr
>>> *)attr->grh.dgid.raw))) {
>>>     155                 status = rdma_addr_find_dmac_by_grh(&sgid,
>>> &attr->grh.dgid,
>>>     156                                                     attr->dmac,
>>> &vlan_tag,
>>>     157
>>> sgid_attr.ndev->ifindex);
>>>
>>> ^^^^^^^^^^^^^^^^
>>> Patch introduces this new dereference.  The warning might be a false
>>> positive if "pd->uctx" or rdma_is_multicast_addr() imply it's non-NULL
>>> but I don't know this code well enough to say for sure.  Hence this
>>> email.  :)
>>>
>>>     158                 if (status) {
>>>     159                         pr_err("%s(): Failed to resolve dmac from
>>> gid."
>>>
>>> regards,
>>> dan carpenter
>>>
>>
>> Thanks for the catch Dan.
>> As I wrote in the commit message - "ocrdma driver changes were done by
>> Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>"
>> Somnath, RoCE implies non-NULL ndev, but dereferencing ifindex after
>> dev_put doesn't seem to be safe.
>> Could you please take a look?
>>
>> Thanks,
>> Matan
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
