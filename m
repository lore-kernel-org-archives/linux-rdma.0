From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: tune ib stack
Date: Tue, 09 Apr 2013 09:34:44 -0400
Message-ID: <516418F4.4040908@dev.mellanox.co.il>
References: <CACaajQs7RHR9Uz_M46o+1zui8x=HneQFW-09V_XQbo8OQV3eoQ@mail.gmail.com> <51640E72.3010202@dev.mellanox.co.il> <516414BD.4020407@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <516414BD.4020407-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/9/2013 9:16 AM, Sebastian Riemer wrote:
> On 09.04.2013 14:49, Hal Rosenstock wrote:
>> On 4/9/2013 7:12 AM, Vasiliy Tolstov wrote:
>>> Hello. I have some servers, with mellanox ConnectX-3 and have some questions:
>>> Why max_mtu differs with active_mtu? 
>>
>> What does peer port say for max MTU ?
>>
>>> How can i set active mtu?
>>
>> SM sets active MTU to min of peer ports max MTUs.
> 
> So with "peer port max MTU" do you mean this file?:
> 
> /sys/class/infiniband/mlx4_0/device/mlx4_port1_mtu

I meant NeighborMTU from PortInfo as active MTU and MTUCap there is
supported MTU.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
