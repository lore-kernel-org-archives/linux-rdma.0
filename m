From: Youngjae Lee <dhrkaeh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: With rxe, udaddy hangs and ibv_rc_pingpong fails.
Date: Thu, 16 Feb 2017 16:13:18 -0600
Message-ID: <CA+1F3TOxmYLO8Ae2-Czq8WnFgmH_PpeUJgsYfDGPScs+5FMO8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi, all.

I've been testing soft roce (i.e. rxe) on 2 physical machines running
kernel 4.10-rc8 with the latest rdma-core.
It seems that a rxe0 device is properly setup on each machine, but any
test application from the rdma-core package, for example uddady and
ibv_rc_pingpong, fails as you can see below.
I've seen a post about similar issues a few weeks ago...any body has
had the same issues before ?? or any advice to solve this issue ??

BTW, I've investigated it at the rxe kernel module level.
I found that the opcode and wr_id of wr are always 0 in the
rxe_requester(), no matter what value its "original" value (that is of
struct ibv_send_wr coming from the user space..) is.
So, in the ibv_rc_pingpong case, at the user-level, the
ibv_rc_pingpong client intends to send a wr whose opcode is
IBV_WR_SEND, but in the rxe kernel module, it sends to
IB_WR_RDMA_WRITE wr to the server because opcode is always set to 0 at
the kernel module level.
Then, on the server side, the corresponding qp fails since the the
qp's attr is not properly setup for IB_WR_RDMA_WRITE operations. In
rxe_responder(), the check_op_valid failes and the qp is moved to the
err state, then at the user-level, the ibv_rc_pingpong exits with
failure.


On machine A,
$ sudo ./rxe_cfg status
  Name         Link  Driver     Speed   NMTU  IPv4_addr     RDEV  RMTU
  enp0s20u1u5  no    cdc_ether          1500
  ens3f0       yes   bnx2x      10GigE  9000  192.168.1.11  rxe0  4096  (5)
  ens3f1       no    bnx2x      10GigE  1500
$ ./build/bin/ibv_devinfo
hca_id:    rxe0
    transport:            InfiniBand (0)
    fw_ver:                0.0.0
    node_guid:            020e:1eff:feb3:e8d0
    sys_image_guid:            0000:0000:0000:0000
    vendor_id:            0x0000
    vendor_part_id:            0
    hw_ver:                0x0
    phys_port_cnt:            1
        port:    1
            state:            PORT_ACTIVE (4)
            max_mtu:        4096 (5)
            active_mtu:        4096 (5)
            sm_lid:            0
            port_lid:        0
            port_lmc:        0x00
            link_layer:        Ethernet

On machine B,
$ sudo ./rxe_cfg status
  Name         Link  Driver     Speed   NMTU  IPv4_addr     RDEV  RMTU
  enp0s20u1u5  no    cdc_ether          1500
  ens8f0       yes   bnx2x      10GigE  9000  192.168.1.12  rxe0  4096  (5)
  ens8f1       no    bnx2x      10GigE  1500
$ ./build/bin/ibv_devinfo
hca_id:    rxe0
    transport:            InfiniBand (0)
    fw_ver:                0.0.0
    node_guid:            020e:1eff:feb3:e030
    sys_image_guid:            0000:0000:0000:0000
    vendor_id:            0x0000
    vendor_part_id:            0
    hw_ver:                0x0
    phys_port_cnt:            1
        port:    1
            state:            PORT_ACTIVE (4)
            max_mtu:        4096 (5)
            active_mtu:        4096 (5)
            sm_lid:            0
            port_lid:        0
            port_lmc:        0x00
            link_layer:        Ethernet

ensXfX is a physical 10G nic from broadcom.


The udaddy hangs like this on both machines. I confirmed that it keeps
polling with ibv_poll_cq() on both machines.

On machine A, (a client)
$ ./build/bin/udaddy -s 192.168.1.12
udaddy: starting client
udaddy: connecting
initiating data transfers
receiving data transfers
^C
$

On machine B, (a server)
$ ./build/bin/udaddy
udaddy: starting server
receiving data transfers
^C
$

The ibv_rc_pingpong hangs on the client side and it fails with a err
msg on a server side,

On machine A, (a client)
$ ./build/bin/ibv_rc_pingpong -d rxe0 -g 1 192.168.1.12
  local address:  LID 0x0000, QPN 0x000011, PSN 0x8ac288, GID
::ffff:192.168.1.11
  remote address: LID 0x0000, QPN 0x000011, PSN 0x2726bc, GID
::ffff:192.168.1.12
^C
$

On machine B, (a server)
$ ./build/bin/ibv_rc_pingpong -d rxe0 -g 1
  local address:  LID 0x0000, QPN 0x000011, PSN 0x2726bc, GID
::ffff:192.168.1.12
  remote address: LID 0x0000, QPN 0x000011, PSN 0x8ac288, GID
::ffff:192.168.1.11
Completion for unknown wr_id 0
parse WC failed 1
$
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
