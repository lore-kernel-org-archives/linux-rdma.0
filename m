From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: "Unicast, no dst" warning from IPoIB
Date: Mon, 22 Mar 2010 11:55:18 +0200 (IST)
Message-ID: <Pine.LNX.4.64.1003221142430.5956@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland,

Recently (e.g now with 2.6.34-rc2) I came across this warning from ipoib_start_xmit.
I wasn't sure if it suggests that there's some real problem or not. It happens
few times and then vanishes, for some reason the type is always 0002 (ETH_P_AX25)

	ib0: Unicast, no dst: type 0002, QPN 200800 1404:0001:8000:0048:fe80:0000:0000:0000
	ib1: Unicast, no dst: type 0002, QPN 200800 1404:0001:8000:0049:fe80:0000:0000:0000

bringing up the driver with debug messages on, it happens few times but
not with specific correlation to something I can point on

Or.


ib%d: max_srq_sge=31
ib%d: max_cm_mtu = 0xfff0, num_frags=16
ib%d: max_srq_sge=31
ib%d: max_cm_mtu = 0xfff0, num_frags=16
ib1: bringing up interface
ib1: starting multicast thread
ib1: joining MGID ff12:401b:ffff:0000:0000:0000:ffff:ffff
ib1: restarting multicast task
ib1: stopping multicast thread
ib1: adding multicast entry for mgid ff12:401b:ffff:0000:0000:0000:0000:0001
ib1: adding multicast entry for mgid ff12:601b:ffff:0000:0000:0000:0000:0001
ib1: starting multicast thread
ib1: join completion for ff12:401b:ffff:0000:0000:0000:ffff:ffff (status 0)
ib1: Created ah ffff880223b0e000
ib1: MGID ff12:401b:ffff:0000:0000:0000:ffff:ffff AV ffff880223b0e000, LID 0xc000, SL 0
ib1: joining MGID ff12:401b:ffff:0000:0000:0000:0000:0001
ADDRCONF(NETDEV_UP): ib1: link is not ready
ADDRCONF(NETDEV_CHANGE): ib1: link becomes ready
ib1: restarting multicast task
ib1: stopping multicast thread
ib0: bringing up interface
ib1: adding multicast entry for mgid ff12:601b:ffff:0000:0000:0001:ff02:6be8
ib1: starting multicast thread
ib1: join completion for ff12:401b:ffff:0000:0000:0000:0000:0001 (status 0)
ib1: joining MGID ff12:601b:ffff:0000:0000:0000:0000:0001
ib1: Created ah ffff88022eed00c0
ib1: MGID ff12:401b:ffff:0000:0000:0000:0000:0001 AV ffff88022eed00c0, LID 0xc001, SL 0
ib1: join completion for ff12:601b:ffff:0000:0000:0000:0000:0001 (status 0)
ib1: Created ah ffff88022d05d680
ib1: MGID ff12:601b:ffff:0000:0000:0000:0000:0001 AV ffff88022d05d680, LID 0xc008, SL 0
ib0: starting multicast thread
ib1: joining MGID ff12:601b:ffff:0000:0000:0001:ff02:6be8
ADDRCONF(NETDEV_UP): ib0: link is not ready
ib1: successfully joined all multicast groups
ib0: joining MGID ff12:401b:ffff:0000:0000:0000:ffff:ffff
ib0: restarting multicast task
ib0: stopping multicast thread
ib0: adding multicast entry for mgid ff12:401b:ffff:0000:0000:0000:0000:0001
ib0: adding multicast entry for mgid ff12:601b:ffff:0000:0000:0000:0000:0001
ib0: starting multicast thread
ib1: join completion for ff12:601b:ffff:0000:0000:0001:ff02:6be8 (status 0)
ib0: join completion for ff12:401b:ffff:0000:0000:0000:ffff:ffff (status 0)
ib1: Created ah ffff88022d05dc00
ib1: MGID ff12:601b:ffff:0000:0000:0001:ff02:6be8 AV ffff88022d05dc00, LID 0xc009, SL 0
ib0: Created ah ffff88022d05dec0
ib0: MGID ff12:401b:ffff:0000:0000:0000:ffff:ffff AV ffff88022d05dec0, LID 0xc000, SL 0
ib0: joining MGID ff12:401b:ffff:0000:0000:0000:0000:0001
ib0: join completion for ff12:401b:ffff:0000:0000:0000:0000:0001 (status 0)
ib1: Unicast, no dst: type 0002, QPN 200800 1404:0001:8010:0049:fe80:0000:0000:0000
ib0: Created ah ffff880223b0e200
ib0: MGID ff12:401b:ffff:0000:0000:0000:0000:0001 AV ffff880223b0e200, LID 0xc001, SL 0
ADDRCONF(NETDEV_CHANGE): ib0: link becomes ready
ib0: joining MGID ff12:601b:ffff:0000:0000:0000:0000:0001
ib0: restarting multicast task
ib0: stopping multicast thread
ib0: adding multicast entry for mgid ff12:601b:ffff:0000:0000:0001:ff02:6be7
ib0: starting multicast thread
ib0: join completion for ff12:601b:ffff:0000:0000:0000:0000:0001 (status 0)
ib0: joining MGID ff12:601b:ffff:0000:0000:0001:ff02:6be7
ib0: Created ah ffff88022d05d480
ib0: MGID ff12:601b:ffff:0000:0000:0000:0000:0001 AV ffff88022d05d480, LID 0xc008, SL 0
ib0: join completion for ff12:601b:ffff:0000:0000:0001:ff02:6be7 (status 0)
ib0: successfully joined all multicast groups
ib0: Created ah ffff88022d05d980
ib0: MGID ff12:601b:ffff:0000:0000:0001:ff02:6be7 AV ffff88022d05d980, LID 0xc012, SL 0
ib0: Unicast, no dst: type 0002, QPN 200800 1404:0001:8010:0048:fe80:0000:0000:0000
ib1: setting up send only multicast group for ff12:601b:ffff:0000:0000:0000:0000:0016
ib1: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting join
ib1: multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
ib0: setting up send only multicast group for ff12:601b:ffff:0000:0000:0000:0000:0016
ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting join
ib0: multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
ib0: Unicast, no dst: type 0002, QPN 200800 1404:0001:8010:0048:fe80:0000:0000:0000
ib1: Unicast, no dst: type 0002, QPN 200800 1404:0001:8010:0049:fe80:0000:0000:0000
ib1: setting up send only multicast group for ff12:601b:ffff:0000:0000:0000:0000:0002
ib1: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0002, starting join
ib1: multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0002, status -22
ib1: restarting multicast task
ib1: stopping multicast thread
ib1: adding multicast entry for mgid ff12:601b:ffff:0000:0000:0000:0000:00fb
ib1: starting multicast thread
ib1: joining MGID ff12:601b:ffff:0000:0000:0000:0000:00fb
ib1: join completion for ff12:601b:ffff:0000:0000:0000:0000:00fb (status 0)
ib1: Created ah ffff88022d05da00
ib1: MGID ff12:601b:ffff:0000:0000:0000:0000:00fb AV ffff88022d05da00, LID 0xc005, SL 0
ib1: successfully joined all multicast groups
ib1: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting join
ib1: multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
ib0: restarting multicast task
ib0: stopping multicast thread
ib0: adding multicast entry for mgid ff12:401b:ffff:0000:0000:0000:0000:00fb
ib0: starting multicast thread
ib0: joining MGID ff12:401b:ffff:0000:0000:0000:0000:00fb
ib0: join completion for ff12:401b:ffff:0000:0000:0000:0000:00fb (status 0)
ib0: Created ah ffff88022d05dd80
ib0: MGID ff12:401b:ffff:0000:0000:0000:0000:00fb AV ffff88022d05dd80, LID 0xc004, SL 0
ib0: Unicast, no dst: type 0002, QPN 200800 1404:0002:8010:0048:fe80:0000:0000:0000
ib1: Unicast, no dst: type 0002, QPN 200800 1404:0002:8010:0049:fe80:0000:0000:0000
ib0: successfully joined all multicast groups
ib1: restarting multicast task
ib1: stopping multicast thread
ib1: adding multicast entry for mgid ff12:401b:ffff:0000:0000:0000:0000:00fb
ib1: starting multicast thread
ib1: joining MGID ff12:401b:ffff:0000:0000:0000:0000:00fb
ib1: join completion for ff12:401b:ffff:0000:0000:0000:0000:00fb (status 0)
ib1: Created ah ffff88022d05d300
ib1: MGID ff12:401b:ffff:0000:0000:0000:0000:00fb AV ffff88022d05d300, LID 0xc004, SL 0
ib1: successfully joined all multicast groups
ib0: setting up send only multicast group for ff12:401b:ffff:0000:0000:0000:0000:0016
ib0: no multicast record for ff12:401b:ffff:0000:0000:0000:0000:0016, starting join
ib1: setting up send only multicast group for ff12:401b:ffff:0000:0000:0000:0000:0016
ib1: no multicast record for ff12:401b:ffff:0000:0000:0000:0000:0016, starting join
ib0: multicast join failed for ff12:401b:ffff:0000:0000:0000:0000:0016, status -22
ib1: multicast join failed for ff12:401b:ffff:0000:0000:0000:0000:0016, status -22
ib0: setting up send only multicast group for ff12:601b:ffff:0000:0000:0000:0000:0002
ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0002, starting join
ib0: multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0002, status -22
ib0: restarting multicast task
ib0: stopping multicast thread
ib0: adding multicast entry for mgid ff12:601b:ffff:0000:0000:0000:0000:00fb
ib0: starting multicast thread
ib0: joining MGID ff12:601b:ffff:0000:0000:0000:0000:00fb
ib0: join completion for ff12:601b:ffff:0000:0000:0000:0000:00fb (status 0)
ib0: Created ah ffff88022e40cbc0
ib0: MGID ff12:601b:ffff:0000:0000:0000:0000:00fb AV ffff88022e40cbc0, LID 0xc005, SL 0
ib0: successfully joined all multicast groups
ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting join
ib0: multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
ib1: Unicast, no dst: type 0002, QPN 200800 1404:0001:8010:0049:fe80:0000:0000:0000
ib0: Unicast, no dst: type 0002, QPN 200800 1404:0001:8010:0048:fe80:0000:0000:0000
ib1: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0002, starting join
ib1: multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0002, status -22
ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0002, starting join
ib0: multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0002, status -22
ib1: no multicast record for ff12:401b:ffff:0000:0000:0000:0000:0016, starting join
ib1: multicast join failed for ff12:401b:ffff:0000:0000:0000:0000:0016, status -22
ib1: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting join
ib1: multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
ib0: no multicast record for ff12:401b:ffff:0000:0000:0000:0000:0016, starting join
ib0: multicast join failed for ff12:401b:ffff:0000:0000:0000:0000:0016, status -22
ib0: no multicast record for ff12:601b:ffff:0000:0000:0000:0000:0016, starting join
ib0: multicast join failed for ff12:601b:ffff:0000:0000:0000:0000:0016, status -22
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
