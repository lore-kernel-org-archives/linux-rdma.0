From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH rdma-next 5/5] IB: Query port through the core instead of
 directly calling the driver handler
Date: Thu, 19 Jan 2017 11:51:37 +0200
Message-ID: <CAJ3xEMj9nq6PLGX3sG8uPuJ15jEuzOgrpYTaURvBNcj-19+CQQ@mail.gmail.com>
References: <20170119054102.20135-1-leon@kernel.org> <20170119054102.20135-6-leon@kernel.org>
 <HE1PR0502MB3004E6D28AED46720C428576D17E0@HE1PR0502MB3004.eurprd05.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <HE1PR0502MB3004E6D28AED46720C428576D17E0-692Kmc8YnlL9PhveBwpv4cDSnupUy6xnnBOFsp37pqbUKgpGm//BTAC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 19, 2017 at 8:06 AM, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> Minor nit for safer code.

>> --- a/drivers/infiniband/hw/mlx4/alias_GUID.c
>> +++ b/drivers/infiniband/hw/mlx4/alias_GUID.c
>> @@ -499,6 +499,7 @@ static int set_guid_rec(struct ib_device *ibdev,
>>       struct list_head *head =
>>               &dev->sriov.alias_guid.ports_guid[port - 1].cb_list;
>>
>> +     memset(&attr, 0, sizeof(struct ib_port_attr));
>
> Can you please change above code to,
>         memset(&attr, 0, sizeof(attr));

sure, same for the rest of the places

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
