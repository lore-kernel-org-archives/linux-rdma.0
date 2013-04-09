From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: tune ib stack
Date: Tue, 09 Apr 2013 10:23:26 -0400
Message-ID: <5164245E.2030208@dev.mellanox.co.il>
References: <CACaajQs7RHR9Uz_M46o+1zui8x=HneQFW-09V_XQbo8OQV3eoQ@mail.gmail.com> <51640E72.3010202@dev.mellanox.co.il> <516414BD.4020407@profitbricks.com> <516418F4.4040908@dev.mellanox.co.il> <51641E0D.2050009@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51641E0D.2050009-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/9/2013 9:56 AM, Sebastian Riemer wrote:
> On 09.04.2013 15:34, Hal Rosenstock wrote:
>> On 4/9/2013 9:16 AM, Sebastian Riemer wrote:
>>> On 09.04.2013 14:49, Hal Rosenstock wrote:
>>>> On 4/9/2013 7:12 AM, Vasiliy Tolstov wrote:
>>>>> Hello. I have some servers, with mellanox ConnectX-3 and have some questions:
>>>>> Why max_mtu differs with active_mtu? 
>>>>
>>>> What does peer port say for max MTU ?
>>>>
>>>>> How can i set active mtu?
>>>>
>>>> SM sets active MTU to min of peer ports max MTUs.
>>>
>>> So with "peer port max MTU" do you mean this file?:
>>>
>>> /sys/class/infiniband/mlx4_0/device/mlx4_port1_mtu
>>
>> I meant NeighborMTU from PortInfo as active MTU and MTUCap there is
>> supported MTU.
> 
> So these values are exactly the same as in "ibv_devinfo" and can be set
> in /sys/class/infiniband/mlx4_0/device/mlx4_port1_mtu.
> 
> I've found the PortInfo with the command
> "smpquery portinfo -C mlx4_0 3 1"
> where I'm using the first HCA to contact the SM. I tell the SM the
> destination LID ('3' here in my case) and the destination port ('1').
> 
> Is there another method to set the max MTU?

That doesn't set max MTU (MTUCap) but merely reads it (for that port).

> I know that switches can also set the max MTU for their switch ports
> where most of them use 2048 as default.

You would need to contact your CA and/or switch vendor(s) (see below).

> How to change these switch port MTUs for unmanaged switches?
> 
> On managed switches this can be done over the web front-end.

Yes. MTUCap is RO in terms of the SM so there are only "out of band"
mechanisms to change this which are vendor specific like a web front end.

-- Hal

> Cheers,
> Sebastian
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
