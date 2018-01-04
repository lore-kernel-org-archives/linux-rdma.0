From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next v2 00/14] index e382a3ca759e..d4a471a76d82
 100644
Date: Thu, 4 Jan 2018 15:50:05 -0600
Message-ID: <2618f285-6fa4-06ac-4b4a-51d0b2660b61@mellanox.com>
References: <20180104152544.28919-1-leon@kernel.org>
 <CAJ3xEMjptQf99ZdGxkB6kTh9LkQ7-pjiObMh+knDWXFStPOg7Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMjptQf99ZdGxkB6kTh9LkQ7-pjiObMh+knDWXFStPOg7Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/4/2018 1:53 PM, Or Gerlitz wrote:
> On Thu, Jan 4, 2018 at 5:25 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>>  v1 -> v2:
>>   * Dropped "IB/mlx5: Use correct mdev for vport queries in ib_virt"
>>  v0 -> v1:
>>   * Rebased to latest rdma/for-next
>>   * Enriched commit messages.
> The V2 post LGTM re the points I was commenting on: the IB virt patch
> removed and
> the  cover letter + change-log properly elaborate on how the feature
> is configured and
> what would be the resulted IB devices under the different variations,
> see one followup below:
>
> [..]
>
>> SR-IOV devices follow the same pattern as the physical ones. VFs of a
>> master port can bind VFs of slave ports, if available, and operate as
>> dual port devices.
>>
>> Examples of devices passed to a VM:
>> (master)         - One net device, one IB device that has two ports. The slave
>>                    port will always be down.
>> (slave)          - One net device, no IB devices.
>> (slave, slave)   - Two net devices and no IB devices.
>> (master, master) - Two net devices, two IB devices, each with two ports.
>>                    The slave port of each device will always be down.
>> (master, slave)  - Two net devices, one IB device, with two ports. Both
>>                     ports can be used.
>>
>> There are no changes to the existing design for net devices.
>>
>> The feature is disabled by default and it is enabled in firmware with mlxconfig.
> Dan, so what happens w.r.t to the different combinations specified above, if on
> SRIOV setup where the admin enabled the feature, VFs land in VMs whose
> mlx5 driver doesn't have these changes?

In this case it would looks the same as it does today. One IB device per PCI device with one port each. The old driver doesn't know about the new capabilities, so it wouldn't bind the ports. Operating this way isn't ideal though.  In DPR mode the FW biases the schedule queue allocation to the master port. Performance could be worse on the VFs that could be slave ports if they are used as normal IB devices.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
