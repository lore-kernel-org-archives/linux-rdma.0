From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: Mellanox/RoCE - VLAN support
Date: Sun, 14 Apr 2013 09:46:19 +0300
Message-ID: <201304140946.20180.jackm@dev.mellanox.co.il>
References: <OF5B0D4E67.C42BB7AC-ONC1257B4A.00569ED8-C1257B4A.0057F075@de.ibm.com> <CAJZOPZLjE_7e+-M4P1gu8EFO9M0618_NSLJkpGAVYTAfJ=_wLw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZLjE_7e+-M4P1gu8EFO9M0618_NSLJkpGAVYTAfJ=_wLw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Friday 12 April 2013 02:13, Or Gerlitz wrote:
> Klaus Wacker <Klaus.Wacker-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org> wrote:
> > Hi all, we are doing a project on IBM x-blades using Mellanox/RoCE. I have some
> > difficulties to get RoCE based VLANs to run.
> > We are currently on Linux 3.8. No OFED material involved.
> > While non-VLAN devices work ok, i experience the following on VLAN devs
> > - a GID for the VLAN is created and we use the proper index for gid source addr.
> > - a ping on the VLAN-device runs ok
> > - rdma/roce traffic fails in that the sender overruns the send retry count.
> 
> Do you have any evidence that the packets are actually crossing the
> switch? the way we debug RoCE connectivity issues is configuring port
> mirroring on the switch and
> capture the mirrored packets on the host where packets are mirrored,
> and feed them to wireshark (the official/latest versions support
> parsing of RoCE/IB packets), on that host you can also observe  L2
> mac/vlan header of the packets to see if it matches what you expected.
> But even before that, I would check the switch counters to see the
> packets aren't dropped.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
Thanks, Or!

Klaus,
In addition, please provide us with the following information:
1. Which ConnectX FW version are you using?
2. Are you using RC or UD qp? (I assume RC if you have a retry count failure, but I would like to be sure).
3. Can you successfully run ucmatose? (tests rdma library for RC connections).
	To run ucmatose:
  		on server:  ucmatose
		on client:  ucmatose -s <IP of desired Mellanox ETH device (ethXX)>

-Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
