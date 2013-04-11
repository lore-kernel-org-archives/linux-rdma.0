From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Mellanox/RoCE - VLAN support
Date: Fri, 12 Apr 2013 02:13:04 +0300
Message-ID: <CAJZOPZLjE_7e+-M4P1gu8EFO9M0618_NSLJkpGAVYTAfJ=_wLw@mail.gmail.com>
References: <OF5B0D4E67.C42BB7AC-ONC1257B4A.00569ED8-C1257B4A.0057F075@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <OF5B0D4E67.C42BB7AC-ONC1257B4A.00569ED8-C1257B4A.0057F075-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org> wrote:
> Hi all, we are doing a project on IBM x-blades using Mellanox/RoCE. I have some
> difficulties to get RoCE based VLANs to run.
> We are currently on Linux 3.8. No OFED material involved.
> While non-VLAN devices work ok, i experience the following on VLAN devs
> - a GID for the VLAN is created and we use the proper index for gid source addr.
> - a ping on the VLAN-device runs ok
> - rdma/roce traffic fails in that the sender overruns the send retry count.

Do you have any evidence that the packets are actually crossing the
switch? the way we debug RoCE connectivity issues is configuring port
mirroring on the switch and
capture the mirrored packets on the host where packets are mirrored,
and feed them to wireshark (the official/latest versions support
parsing of RoCE/IB packets), on that host you can also observe  L2
mac/vlan header of the packets to see if it matches what you expected.
But even before that, I would check the switch counters to see the
packets aren't dropped.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
