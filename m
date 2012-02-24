From: Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>
Subject: IBoE on vlan question
Date: Fri, 24 Feb 2012 11:56:18 -0600
Message-ID: <20120224175618.GA2515@BohrerMBP.rgmadvisors.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I'm running into some issues using IBoE on a vlan with an upstream
kernel and libraries (works fine with OFED).  I'm mostly curious if
I'm simply running into a feature not yet implemented upstream, or if
I've found a bug.  I'm currently testing this on Fedora 16 with:

3.1.9 kernel
librdmacm-1.0.15-1.fc16.x86_64
libibverbs-1.1.6-1.fc16.x86_64
libmlx4-1.0.2-3.rgm.fc16.x86_64 (includes patch http://permalink.gmane.org/gmane.linux.drivers.rdma/10979)

$ ibv_devinfo 
hca_id: mlx4_0
        transport:                      InfiniBand (0)
        fw_ver:                         2.10.600
        node_guid:                      0002:c903:0031:8a40
        sys_image_guid:                 0002:c903:0031:8a43
        vendor_id:                      0x02c9
        vendor_part_id:                 4099
        hw_ver:                         0x0
        board_id:                       MT_1090110018
        phys_port_cnt:                  2
                port:   1
                        state:                  PORT_ACTIVE (4)
                        max_mtu:                2048 (4)
                        active_mtu:             1024 (3)
                        sm_lid:                 0
                        port_lid:               0
                        port_lmc:               0x00
                        link_layer:             Ethernet

                port:   2
                        state:                  PORT_DOWN (1)
                        max_mtu:                2048 (4)
                        active_mtu:             1024 (3)
                        sm_lid:                 0
                        port_lid:               0
                        port_lmc:               0x00
                        link_layer:             Ethernet

So far I've found that everything works as long as I bind to an IP on
the NIC itself.  However if I bind to an IP on a vlan some things
don't work.  For example if I run two instances of udaddy on the
_same_ host bound to a vlan they both just hang and never complete:

$ /sbin/ifconfig vlan816
vlan816   Link encap:Ethernet  HWaddr 00:02:C9:31:8A:30  
          inet addr:10.8.16.40  Bcast:10.8.23.255  Mask:255.255.248.0
          inet6 addr: fe80::202:c9ff:fe31:8a30/64 Scope:Link
          UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
          RX packets:1443086 errors:0 dropped:64 overruns:0 frame:0
          TX packets:446986 errors:0 dropped:0 overruns:0 carrier:0
          collisions:0 txqueuelen:0 
          RX bytes:110558152 (105.4 MiB)  TX bytes:110977699 (105.8 MiB)

$ udaddy -b 10.8.16.40
udaddy: starting server
receiving data transfers

$ udaddy -b 10.8.16.40 -s 10.8.16.40
udaddy: starting client
udaddy: connecting
initiating data transfers
receiving data transfers

Similarly if I run two instances of udaddy bound to the vlan IP on two
_different_ hosts they also never complete, but they also don't get as
far:

$ udaddy -b 10.8.16.40
udaddy: starting server

$ udaddy -b 10.8.16.41 -s 10.8.16.40
udaddy: starting client
udaddy: connecting
udaddy: event: RDMA_CM_EVENT_UNREACHABLE, error: -110
test complete
return status -110

I would say at this point maybe vlans just aren't supported yet but I
using mckey provides some different results which makes me think this
may just be a bug.  When I use mckey between two different hosts bound
to the vlan IP it most of the time it works fine and sometimes the
receiver does not complete.

So is this a know issue?  Does anyone have any suggestions on where to
start debugging, or anything I may have overlooked?

Thanks,
Shawn

-- 

---------------------------------------------------------------
This email, along with any attachments, is confidential. If you 
believe you received this message in error, please contact the 
sender immediately and delete all copies of the message.  
Thank you.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
