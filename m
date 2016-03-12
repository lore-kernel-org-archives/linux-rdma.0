From: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: sg_map failures when tuning SRP via ib_srp module parameters for
 maximum SG entries
Date: Sun, 13 Mar 2016 00:06:40 +0200
Message-ID: <56E492F0.1070609@dev.mellanox.co.il>
References: <1195068688.21605141.1457794577569.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1195068688.21605141.1457794577569.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: James Hartsock <hartsjc-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> Hello
>
> I am seeing and issue with 100Gbit EDR Infiniband (mlx5_ib and ConnectX-4) and connecting to high speed arrays when we tune the ib_srp parameters to maximum allowed values.
>
> The tuning is being done to maximize performance using:
>
> options ib_srp cmd_sg_entries=255 indirect_sg_entries=2048
>
> We get into a situation where in srp_queuecommand we fail the srp_map_data().
>
> [  353.811594] scsi host4: ib_srp: Failed to map data (-5)
> [  353.811619] scsi host4: Could not fit S/G list into SRP_CMD

I'd say that's an unusual limit to hit? What is your workload?
with CX4 (fr by default) you'd need a *very* unaligned SG layout
or a huge transfer size (huge).

> On the array
>
> [ 6097.205716] ib_srpt IB send queue full (needed 68)
> [ 6097.233325] ib_srpt srpt_xfer_data[2731] queue full -- ret=-12

Is this upstream srpt? And if all the srp commands contain ~255
(or even ~50) descriptors then I'm not at all surprised you get queue
overrun. Each command includes num_sg_entries worth of rdma posts...
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
