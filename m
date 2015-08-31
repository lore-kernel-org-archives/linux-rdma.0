From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH v4 09/14] IB/cm: Expose BTH P_Key in CM and SIDR request
 events
Date: Mon, 31 Aug 2015 09:50:37 +0300
Message-ID: <55E3F93D.6000400@mellanox.com>
References: <1438267826-32155-1-git-send-email-haggaie@mellanox.com>
 <1438267826-32155-10-git-send-email-haggaie@mellanox.com>
 <55E34A05.8040205@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <55E34A05.8040205-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 30/08/2015 21:23, Sagi Grimberg wrote:
> 
> Looks like for some reason cm_get_bth_pkey got pkey_index of 0xffff
> instead of 0 (working on the default pkey 0xffff at entry 0).

It looks like the mlx5 driver doesn't interpret the completion format
correctly. It takes a field defined in the programmer reference manual
as pkey, and interprets it as pkey_index [1].

> log:
> infiniband mlx5_0: ib_cm: Couldn't retrieve pkey for incoming request (port 1, pkey index 65535). -22
> ib_srpt Received SRP_LOGIN_REQ with i_port_id 0x0:0x2c90300ed0960, t_port_id 0x2c90300ed0950:0x2c90300ed0950 and it_iu_len 260 on port 1 (guid=0xfe80000000000000:0x2c90300ed0950)
> ib_srpt Session : kernel thread ib_srpt_compl (PID 8584) started
> infiniband mlx5_0: ib_cm: Couldn't retrieve pkey for incoming request (port 1, pkey index 65535). -22
> ib_srpt Received SRP_LOGIN_REQ with i_port_id 0x0:0x2c90300ed0960, t_port_id 0x2c90300ed0950:0x2c90300ed0950 and it_iu_len 260 on port 1 (guid=0xfe80000000000000:0x2c90300ed0950)
> ib_srpt Session : kernel thread ib_srpt_compl (PID 8585) started
> mlx5_0:dump_cqe:238:(pid 8584): dump error cqe
> 00000000 00000000 00000000 00000000
> 00000000 00000000 00000000 00000000
> 0000002b 00000000 00000000 00000000
> 00000000 94003004 0000002c 0000b8e0
> ib_srpt receiving failed for idx 0 with status 4
> 0000:04:00.0:poll_health:151:(pid 0): device's health compromised
> assert_var[0] 0x00000094
> assert_var[1] 0x00000000
> assert_var[2] 0x00000000
> assert_var[3] 0x00000000
> assert_var[4] 0x00000000
> assert_exit_ptr 0x0061d35c
> assert_callra 0x0067a5f4
> fw_ver 0xa0641900
> hw_id 0x000001ff
> irisc_index 2
> synd 0x1: firmware internal error
> ext_sync 0x0000
> 0000:04:00.0:health_care:76:(pid 7943): handling bad device here
> ib_srpt Received DREQ and sent DREP for session 0x00000000000000000002c90300ed0960.
> ib_srpt Received DREQ and sent DREP for session 0x00000000000000000002c90300ed0960.
> ib_srpt Received IB TimeWait exit for cm_id ffff88046d1fb200.
> ib_srpt Received IB TimeWait exit for cm_id ffff880454ffa000.
> ib_srpt Session 0x00000000000000000002c90300ed0960: kernel thread ib_srpt_compl (PID 8585) stopped

I don't know how that can cause all the other errors though.

Haggai

[1]
http://lxr.free-electrons.com/source/drivers/infiniband/hw/mlx5/cq.c?v=4.1#L230
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
