From: Chet Murthy <chet-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org>
Subject: OFED 1.5.4.1 on Ubuntu 10.04 with Mellanox cards?
Date: Thu, 21 Jun 2012 17:46:12 -0700
Message-ID: <1565389.HptLAFPzES@twitter>
Reply-To: chet-aZOuKsOsJu3MbYB6QlFGEg@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Hi,

A long while ago, I got OFED 1.5.2 working on Ubuntu 10.04 (Lucid) on
Opterons with Mellanox DDR cards.  It was a little messy, getting the
RPMs compiled, but it was pretty straightforward.  Basically, I (a)
built a kernel with neither infiniband nor mellanox ethernet drivers,
and (b) ran the OFED install.pl with some minor modifications to
convert the RPMs into DEBs as they were built.  And everything worked,
smooth as a whistle.

Today, I tried to do the same thing with OFED 1.5.4.1, and while the
process of -building- was straightforward, once I get done, the card's
state is all zeroes:

chet@memstore3:~$ sudo ibstatus
Infiniband device 'mlx4_0' port 1 status:
        default gid:     0000:0000:0000:0000:0000:0000:0000:0000
        base lid:        0x0
        sm lid:          0x0
        state:           1: DOWN
        phys state:      3: Disabled
        rate:            2.5 Gb/sec (1X)
        link_layer:      Ethernet

Infiniband device 'mlx4_0' port 2 status:
        default gid:     0000:0000:0000:0000:0000:0000:0000:0000
        base lid:        0x0
        sm lid:          0x0
        state:           1: DOWN
        phys state:      3: Disabled
        rate:            2.5 Gb/sec (1X)
        link_layer:      Ethernet

The card's a modern ConnectX

1f:00.0 Ethernet controller: Mellanox Technologies MT26448 [ConnectX EN 
10GigE, PCIe 2.0 5GT/s] (rev b0)

and on identical RedHat machines, the card's status is quite
different:


[root@memstore4 chet]# ibstatus
Infiniband device 'mlx4_0' port 1 status:
        default gid:     fe80:0000:0000:0000:0202:c9ff:fe4b:5890
        base lid:        0x0
        sm lid:          0x0
        state:           1: DOWN
        phys state:      3: Disabled
        rate:            10 Gb/sec (1X QDR)
        link_layer:      Ethernet

Infiniband device 'mlx4_0' port 2 status:
        default gid:     fe80:0000:0000:0000:0202:c9ff:fe4b:5891
        base lid:        0x0
        sm lid:          0x0
        state:           4: ACTIVE
        phys state:      5: LinkUp
        rate:            10 Gb/sec (1X QDR)
        link_layer:      Ethernet

I'm not even sure how to go about debugging this.  Has anybody gotten
OFED to work on Ubuntu with such modern cards?

Thanks,
--chet--


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
