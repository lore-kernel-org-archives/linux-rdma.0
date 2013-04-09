From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: tune ib stack
Date: Tue, 09 Apr 2013 14:15:16 +0200
Message-ID: <51640654.1000009@profitbricks.com>
References: <CACaajQs7RHR9Uz_M46o+1zui8x=HneQFW-09V_XQbo8OQV3eoQ@mail.gmail.com> <5163FEF4.1000507@profitbricks.com> <CACaajQva3nUe+u3YpHoE4wgiR6-mDoQtnOhR4Cpeu4iwPK0HUQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACaajQva3nUe+u3YpHoE4wgiR6-mDoQtnOhR4Cpeu4iwPK0HUQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vasiliy Tolstov <v.tolstov-+9FY0jupvH6HXe+LvDLADg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 09.04.2013 13:51, Vasiliy Tolstov wrote:
>> Something like this:
>> echo 4096 > /sys/class/infiniband/mlx4_0/device/mlx4_port1_mtu
> 
> After doing this all srp connections down and port is down. I need to
> restart openibd

Sorry for that! It's much easier to set the IP MTU. Managed switches
support setting the RDMA MTU. So it could be possible that it is a
setting in the SM config. But I'm not sure.

$ man opensm
says that it can be set in the partitions.conf

>> You should see "40 Gb/sec (4X QDR)" here. Perhaps the OFED is too old so
>> that FDR and ConnectX 3 aren't supported, yet. "10 Gb/sec (4X)" seems to
>> be the default case if a rate isn't supported.
> 
> Yes, in older card with ConnecX i see this, but in case of ConnectX-3 only 10 Gb

The kernel version is okay. It depends on the user space.
There is a support note in OFED 3.5:
- ConnectX-3 (fw-ConnectX3 Rev 2.11.0500) (FDR and FDR10 Modes are
Supported)

Before OFED 3.5 these HCAs aren't supported. A look at the related
source code could be worth a try.

Cheers,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
