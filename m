From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next 1/2] IB/core: Add support for RX/TX checksum
 offload capabilities report
Date: Thu, 6 Aug 2015 01:29:47 +0300
Message-ID: <CAJ3xEMgzKdFVtFfXC93EH=gBVGCpVJzKWm=C4RYttc1uz+phhQ@mail.gmail.com>
References: <1438788867-18332-1-git-send-email-amirv@mellanox.com>
	<1438788867-18332-2-git-send-email-amirv@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A82373A9022CBD@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A9022CBD-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moshe Lazer <moshel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eric Dube <edube-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Aug 5, 2015 at 7:17 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> TPC and UDP should be separate flags.


Sean,

I don't think we should over-complex things vs. what the network stack
does for many (since kernel 2.4?!) years. They have basically three
flags

NETIF_F_IP_CSUM - device can checksum TCP/UDP over IPv4
NETIF_F_IP6_CSUM  - device can checksum TCP/UDP over IPv6
NETIF_F_HW_CSUM - device can checksum all packets

I would say that it makes sense to consider the IB_DEVICE_UD_IP_CSUM
dev cap we have for ~10 years to be equivalent for NETIF_F_IP_CSUM and
apply also for devices supports RAW PACKETs QPs.

Not sure if we need to add now the IPv6 support too, unless there are
real offload consumers, ditoo for the HW checksum. The focus better be
around building user space code that well supports the IPv5 device
cap.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
