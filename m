From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: InfiniBand HCA loopback on a single host (subnet manager needed?)
Date: Thu, 31 Mar 2011 09:53:09 -0400
Message-ID: <4D948745.2080002@dev.mellanox.co.il>
References: <alpine.LRH.2.00.1103090903140.15803@pub1.ifh.de>	<20110309173005.GN22729@obsidianresearch.com> <AANLkTimTm2UgUr4A_XJYGJpGBnRAFE74Eu6At+n9Xnfd@mail.gmail.com> <4D94411F.2080008@desy.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D94411F.2080008-T5F83Mi6MZE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Konstantin Boyanov <konstantin.boyanov-T5F83Mi6MZE@public.gmane.org>
Cc: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Konstantin Boyanov <boyanov-/DgOsau14IQ@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 3/31/2011 4:53 AM, Konstantin Boyanov wrote:
> Hello,
>
> Thanks for the advices! I have gotten my hands on an QSFP loopback plug,
> and yestrday inserted it in the machine (sinlge slot IB card).
>
> Unfortunately I am having problems when starting the Subnet Manager.I
> believe I have installed and loaded all the necessary kernel modules
> needed.
>
> *# lsmod | grep ib
> ib_ipoib 78893 0
> ib_ucm 12567 0
> ib_uverbs 31293 6 rdma_ucm,ib_ucm
> ib_umad 12147 4
> ib_cm 36419 3 ib_ipoib,ib_ucm,rdma_cm
> ib_addr 6089 1 rdma_cm
> ib_sa 22820 4 ib_ipoib,rdma_ucm,rdma_cm,ib_cm
> mlx4_ib 52866 1
> ib_mad 40542 4 ib_umad,ib_cm,ib_sa,mlx4_ib
> ib_core 66295 11
> ib_ipoib,rdma_ucm,ib_ucm,ib_uverbs,ib_umad,rdma_cm,ib_cm,iw_cm,ib_sa,mlx4_ib,ib_mad
>
> ipv6 321509 72 ib_ipoib,ib_addr
> mlx4_core 93453 2 mlx4_ib,mlx4_en*
>
>
> But when I start the opensm via:
>
> *# /etc/init.d/opensm start*
>
> I see a lot of error messages at the end of /var/log/opensm.log:
>
> *Mar 30 12:50:05 622171 [1795B700] 0x80 -> SM port is down
> Mar 30 12:50:05 622184 [1795B700] 0x01 -> sm_state_mgr_signal_error: ERR
> 3207: Invalid signal OSM_SM_SIGNAL_DISCOVER in state DISCOVERING
> SM port is down
>
> Mar 30 12:50:15 622345 [1795B700] 0x80 -> SM port is down
> Mar 30 12:50:15 622356 [1795B700] 0x01 -> sm_state_mgr_signal_error: ERR
> 3207: Invalid signal OSM_SM_SIGNAL_DISCOVER in state DISCOVERING
> Errors on subnet. Duplicate GUID found by link from a port to itself.
> See verbose opensm.log for more details
>
> Mar 30 12:50:25 622645 [1C963700] 0x80 -> Errors on subnet. Duplicate
> GUID found by link from a port to itself. See verbose opensm.log for
> more details

My bad; can you cable this to some other IB port (either switch or other 
HCA port) ? If this is a 2 port HCA, then it's simple.

> After that, the port state is changed to PORT_INIT, but non of my test
> programs for the loopback (as well as thous in the OFED examples) can
> find a valid LID and oeprate properly.
>
> *# ibv_devinfo
> hca_id: mlx4_0
> transport: InfiniBand (0)
> fw_ver: 2.7.626
> node_guid: 0002:c903:000b:e242
> sys_image_guid: 0002:c903:000b:e245
> vendor_id: 0x02c9
> vendor_part_id: 26428
> hw_ver: 0xB0
> board_id: MT_0D90110009
> phys_port_cnt: 1
> port: 1
> state: PORT_INIT (2)
> max_mtu: 2048 (4)
> active_mtu: 2048 (4)
> sm_lid: 0
> port_lid: 0
> port_lmc: 0x00
>
> *I am using OFED drivers version 1.4 and the machine is as follows:
>
> *# uname -a
> Linux myhost.domain.de 2.6.32-71.18.2.el6.x86_64 #1 SMP Tue Mar 8
> 15:00:52 CST 2011 x86_64 x86_64 x86_64 GNU/Linux*
>
> It seems to me that the loopback connector is somehow tricking the
> openSM to think that there is something wrong with the ports. Am I right?

It's making the OpenSM think that the remote end of the port has a 
duplicate GUID; doesn't handle this case :-(

> Another thing: If I try to force bring the port to the ACTIVE state with
> ibportstate I get the following error:
>
> # ibportstate -G 0x0002c903000be243 1 enable
> ibwarn: [4824] mad_rpc_open_port: can't open UMAD port ((null):0)
> ibportstate: iberror: failed: Failed to open '(null)' port '0'

Let's fix the problems one at a time. You shouldn't need to do this.

-- Hal

>
> I am really a greenehorn to all this InfiniBand stuff, so please can
> someone decrypt the above error messages in the opensm.log? What should
> I do in order to have a running openSM and a port configured the right
> way, so I can loopback messages? Is there any documentation out there
> which describes the set up of an loopback on a single port, or at least
> the initial setup of an InfiniBand network?
>
> Thnaks in advance for your time and sorry if I am bothering you too much
> with my lame questions.
>
> Best regards,
> Konstantin Boyanov
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
