From: "Tung, Chien Tin" <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] libnes-1.1.0 release
Date: Thu, 2 Sep 2010 14:51:00 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E904A23E3591@azsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New version of libnes v1.1.0 is available at:

http://www.openfabrics.org/downloads/nes/libnes-1.1.0.tar.gz

sha1sum 5af05ede3fe11d30c49671ebc5263efbb1881cbe

Changes since last release:

- Add support for iWarp Multicast Acceleration (IMA).
- Rearm  CQ event notification only after a poll.
- Add option to control doorbell read in nes_upoll_cq.
- Fix total payload calculation in nes_upost_recv.
- Fix Firmware version in query device.


libnes provides a device-specific userspace library for NetEffect
Ethernet Server Cluster Adapter for use with the libibverbs library.


Chien

--
Chien Tung | chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org





--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
