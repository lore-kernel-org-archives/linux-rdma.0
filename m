From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: tune ib stack
Date: Tue, 09 Apr 2013 09:00:29 -0400
Message-ID: <516410ED.7050705@dev.mellanox.co.il>
References: <CACaajQs7RHR9Uz_M46o+1zui8x=HneQFW-09V_XQbo8OQV3eoQ@mail.gmail.com> <5163FEF4.1000507@profitbricks.com> <CACaajQva3nUe+u3YpHoE4wgiR6-mDoQtnOhR4Cpeu4iwPK0HUQ@mail.gmail.com> <51640654.1000009@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51640654.1000009-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 4/9/2013 8:15 AM, Sebastian Riemer wrote:
> On 09.04.2013 13:51, Vasiliy Tolstov wrote:
>>> Something like this:
>>> echo 4096 > /sys/class/infiniband/mlx4_0/device/mlx4_port1_mtu
>>
>> After doing this all srp connections down and port is down. I need to
>> restart openibd
> 
> Sorry for that! It's much easier to set the IP MTU. Managed switches
> support setting the RDMA MTU. So it could be possible that it is a
> setting in the SM config. But I'm not sure.

IP MTU is different than link MTU. For UD mode, it's link MTU - 4. For
RC (connected) mode, this can be a much larger number than the link MTU
as the HCA does the segmentation/reassembly down to the path MTU.

> $ man opensm
> says that it can be set in the partitions.conf

Yes, MTU for the IPoIB interface is set in the partition file. This
would need configuring for the larger (4K) MTU assuming all ports
support the 4K MTU. If not, some ports won't be able to join the IPoIB
broadcast (or other) IB multicast groups and IPoIB won't work.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
