From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: tune ib stack
Date: Tue, 09 Apr 2013 15:16:45 +0200
Message-ID: <516414BD.4020407@profitbricks.com>
References: <CACaajQs7RHR9Uz_M46o+1zui8x=HneQFW-09V_XQbo8OQV3eoQ@mail.gmail.com> <51640E72.3010202@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51640E72.3010202-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09.04.2013 14:49, Hal Rosenstock wrote:
> On 4/9/2013 7:12 AM, Vasiliy Tolstov wrote:
>> Hello. I have some servers, with mellanox ConnectX-3 and have some questions:
>> Why max_mtu differs with active_mtu? 
> 
> What does peer port say for max MTU ?
> 
>> How can i set active mtu?
> 
> SM sets active MTU to min of peer ports max MTUs.

So with "peer port max MTU" do you mean this file?:

/sys/class/infiniband/mlx4_0/device/mlx4_port1_mtu

I've seen that it can be set as well. I've got two ConnectX-2 machines
connected back2back. In general these have 4K max and active.

So let's try something:

Host1:
$ echo 2048 > /sys/class/infiniband/mlx4_0/device/mlx4_port1_mtu
# Port is not active, let's reactivate it.
$ echo 1 > /sys/class/infiniband/mlx4_0/device/enable

ibv_devinfo Host1:
max_mtu:	2048 (4)
active_mtu:	2048 (4)

Host2:
max_mtu:	4096 (5)
active_mtu:	2048 (4)

Both had "4096 (5)" before everywhere.
So that's the recommended way to reduce the MTU?

I've heard that reducing the MTU in a fabric can help fighting
congestion issues. As congestion control doesn't work yet, could this
help against congestion?

Cheers,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
