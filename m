From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/15] Dual Port mlx5 IB Device for RoCE
Date: Wed, 27 Dec 2017 09:22:11 -0600
Message-ID: <382ba516-bf7b-0a0b-7a9f-604cbf805c80@mellanox.com>
References: <20171224125741.25464-1-leon@kernel.org>
 <CAJ3xEMhZgEee+VLpV4bV150siOdXwpcp64AGqeqr5Y2o--WRdw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMhZgEee+VLpV4bV150siOdXwpcp64AGqeqr5Y2o--WRdw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Saeed Mahameed <saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/24/2017 3:47 PM, Or Gerlitz wrote:
> On Sun, Dec 24, 2017 at 2:57 PM, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
>
>> From Daniel:
>>
>> This feature allows RDMA resources (pd, mr, cq, qp, etc) to be used with
>> both physical ports of capable mlx5 devices. When enabled a single IB
>> device with two ports will be registered instead of two single port
>> devices.
>>
>> There are still two PCI devices underlying the two port device, the
>> capabilities indicate which device is the "master" device and which is
>> the slave.
>>
>> When the add callback function is called for a slave device a list of IB
>> devices is searched for matching master device, indicated by the
>> capabilities
>> and the system_image_guid. If a match is found the slave is bound to the
>> master device, otherwise it's placed on a list, in case it's master becomes
>> available in the future. When a master device is added it searches the list
>> of available slaves for a matching slave device. If a match is found it
>> binds
>> the slave as its 2nd port. If no match as found the device still appears
>> as a dual port device, with the 2nd port down. RDMA resources can still
>> created that use the yet unavailable 2nd port.
>>
>> Commands related to IB resources are all routed through the master
>> mlx5_core
>> device. Port specific commands, like those for hardware counters are
>> routed to
>> their respective port mlx5_core device. Since devices can appear and
>> disappear
>> asynchronously a reference count on the underlying mlx5_core device is
>> maintained. Getting and putting this reference is only necessary for
>> commands
>> destined to a specific port, the master core device can be used freely,
>> as it will exist while the IB device exists.
>>
>>
> Daniel, so far you only talked on IB devices and a master/slave relation
> you introduce for the
> core devices
>
>
>
>> SR-IOV devices follow the same pattern as the physical ones. VFs of a
>> master
>> port can bind VFs of slave ports, if available, and operate as dual
>> port devices.
>>
> Not following.
>
> We still have two mlx5 EN devices, right?! and from libvirt point of view
> business are just as usual,
Yes, 2 netdevs.
> a VM will be assigned with one VF from any of the core devices (master
> only, slave only or both)
> and this will be an IB device with one port - correct?

No. If the PCI device passed to the VM is a master the VM will show an IB device with 2 ports, one of them down. If the PCI device were a slave there would be no IB device for it in the VM. If the VM is passed one master and one slave then there will be a 2 port IB device with both ports available.


> Note that most of us are ooo till early January (== early next week), so
> should be able to follow on your proposal then.
>
> Or.
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
