From: Nikolay Borisov <kernel@kyup.com>
Subject: ref count of ib_ipoib.ko not incremented when an ip address is set
Date: Fri, 22 Jul 2016 11:16:02 +0300
Message-ID: <5791D642.9050609@kyup.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: netdev@vger.kernel.org
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, David Miller <davem@davemloft.net>, sean.hefty@intel.com, dledford@redhat.com, SiteGround Operations <operations@siteground.com>
List-Id: linux-rdma@vger.kernel.org

Hello, 

I accidentally saw that even having an ip address on an 
ipoib interface doesn't increment the usage count of the 
ib_ipoib.ko module: 

ip a l dev ib0
14: ib0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 65520 qdisc pfifo_fast state UP qlen 256
    link/infiniband 80:00:02:d4:fe:80:00:00:00:00:00:00:e4:1d:2d:03:00:00:f8:31 brd 00:ff:ff:ff:ff:12:40:1b:ff:ff:00:00:00:00:00:00:ff:ff:ff:ff
    inet 172.16.0.150/24 brd 172.16.0.255 scope global ib0
       valid_lft forever preferred_lft forever

lsmod | grep ib_ipoib
ib_ipoib               79026  0 
ib_cm                  34144  3 ib_ipoib,ib_ucm,rdma_cm
ib_sa                  26598  5 ib_ipoib,rdma_ucm,rdma_cm,ib_cm,mlx4_ib
ib_core                97620  10 ib_ipoib,ib_ucm,ib_uverbs,rdma_cm,iw_cm,ib_umad,ib_cm,mlx4_ib,ib_sa,ib_mad
ipv6                  374806  259 ib_ipoib,rdma_cm,ib_addr,[permanent]


In this case I can rmmod ib_ipoib.ko which would remove, 
but in practice I've observed that when an ip address is set
the underlying module providing the interface usually gets
its ref count incremented. Is this normal or is a 
refcount increment is amiss?

Regards, 
Nikolay 
