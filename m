From: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Subject: Re: tune ib stack
Date: Tue, 14 May 2013 14:02:00 +0400
Message-ID: <CACaajQsMsZL-13aS39Asi7Z+4chXreZk5zy9QNuJM_4GcBFFBA@mail.gmail.com>
References: <CACaajQs7RHR9Uz_M46o+1zui8x=HneQFW-09V_XQbo8OQV3eoQ@mail.gmail.com>
 <51640E72.3010202@dev.mellanox.co.il> <516414BD.4020407@profitbricks.com>
 <516418F4.4040908@dev.mellanox.co.il> <51641E0D.2050009@profitbricks.com>
 <5164245E.2030208@dev.mellanox.co.il> <51642795.1070208@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51642795.1070208-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Sorry for bumping old thread, i'm solve my problems with new firmware.
I have supermicro servers that rebrand mellanox firmware (recompile
and change some bits)
Now all works fine i have 40 gb/s QDR instead of 10 Gb/s

2013/4/9 Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>:
> On 09.04.2013 16:23, Hal Rosenstock wrote:
>>> So these values are exactly the same as in "ibv_devinfo" and can be set
>>> in /sys/class/infiniband/mlx4_0/device/mlx4_port1_mtu.
>>>
>>> I've found the PortInfo with the command
>>> "smpquery portinfo -C mlx4_0 3 1"
>>> where I'm using the first HCA to contact the SM. I tell the SM the
>>> destination LID ('3' here in my case) and the destination port ('1').
>>>
>>> Is there another method to set the max MTU?
>>
>> That doesn't set max MTU (MTUCap) but merely reads it (for that port).
>
> Sorry, copy and paste error. I've meant the mlx4 file:
> /sys/class/infiniband/mlx4_0/device/mlx4_port1_mtu
>
> But you've answered that by "vendor specific". Thanks for the valuable
> information!
>
> For us most interesting would be if the MTU can be changed live without
> any service disruption. Looks like the mlx4 driver can't provide that.
> Perhaps switches can do that.
>
> Cheers,
> Sebastian
>



-- 
Vasiliy Tolstov,
e-mail: v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
jabber: vase-+9FY0jupvH6HXe+LvDLADg@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
