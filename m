From: =?UTF-8?Q?Xavier_Gu=C3=A9rin?= <xrguerin-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: ConnectX-3 VPI ETH issues
Date: Tue, 2 Oct 2012 20:59:15 -0400
Message-ID: <CAHBb3iuhfZxGPX+zKMahLYeRwD9B4038-+8eRWWmRdfO_9MZrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi list,

I am afraid I am stuck with a very stupid problem, and I am at my wit's ends.

I am deploying a set a blades loaded with ConnectX-3 VPI adapters. The
blades run under RHEL 6.3 and the connectors are driven using the
MLNX_OFED 1.5.3.3 stack.

When the ports are configured in IB (default), the physical state of
the ports is POLLING, which is expected since the adapters are
connected with Ethernet wires and switches:

$ ibstat
CA 'mlx4_0'
        CA type: MT4099
        Number of ports: 2
        Firmware version: 2.10.2322
        Hardware version: 0
        Node GUID: 0x0002c90300f31160
        System image GUID: 0x0002c90300f31163
        Port 1:
                State: Down
                Physical state: Polling
                Rate: 40
                Base lid: 0
                LMC: 0
                SM lid: 0
                Capability mask: 0x02514868
                Port GUID: 0x0002c90300f31161
                Link layer: InfiniBand
        Port 2:
                State: Down
                Physical state: Polling
                Rate: 40
                Base lid: 0
                LMC: 0
                SM lid: 0
                Capability mask: 0x02514868
                Port GUID: 0x0002c90300f31162
                Link layer: InfiniBand

But when I enable the ports as ETH, the physical state shows up as DISABLED:

$ ibstat
CA 'mlx4_0'
        CA type: MT4099
        Number of ports: 2
        Firmware version: 2.10.2322
        Hardware version: 0
        Node GUID: 0x0002c90300f31160
        System image GUID: 0x0002c90300f31163
        Port 1:
                State: Down
                Physical state: Disabled
                Rate: 40
                Base lid: 0
                LMC: 0
                SM lid: 0
                Capability mask: 0x00010000
                Port GUID: 0x0202c9fffef31160
                Link layer: Ethernet
        Port 2:
                State: Down
                Physical state: Disabled
                Rate: 40
                Base lid: 0
                LMC: 0
                SM lid: 0
                Capability mask: 0x00010000
                Port GUID: 0x0202c9fffef31161
                Link layer: Ethernet

Besides, ibportstate fails opening the port in ETH mode:

$ ibportstate -C mlx4_0 -L 0 -P 1 q

Finally, if that helps, when set in auto mode, the port configuration
stick with IB.

I went through any possible user guide without help. Any clue about
what I am doing wrong?

Thanks,
Xavier
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
