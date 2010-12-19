From: "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] libnes-1.1.1 release
Date: Sun, 19 Dec 2010 16:49:11 -0700
Message-ID: <2EFBCAEF10980645BBCFB605689E08E904B9611733@azsmsx506.amr.corp.intel.com>
References: <2EFBCAEF10980645BBCFB605689E08E904A23E3591@azsmsx506.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <2EFBCAEF10980645BBCFB605689E08E904A23E3591-uLM7Qlg6MbdZtRGVdHMbwrfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, OpenFabrics EWG <ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Cc: Vladimir Sokolovsky <vlad-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

New version of libnes v1.1.1 is available at:

http://www.openfabrics.org/downloads/nes/libnes-1.1.1.tar.gz

Changes since last release:
- Check # of sge posted for posting rcv buffers
- Fix for frames too long
- Fix handling of RAW QP Error state
- Fix handling of frames with VLAN flag set

libnes provides a device-specific userspace library for NetEffect
Ethernet Server Cluster Adapter for use with the libibverbs library.

Faisal


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
