From: "Moni Shoua" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: RE: are IB port counters functioning over --IB-- with the RDMAoE  patch	set?
Date: Thu, 3 Jun 2010 15:06:10 +0300
Message-ID: <7E95F01E94AB484F83061FCFA35B39F854FBAA@exil.voltaire.com>
References: <4BFE35B7.80009@voltaire.com> <4C0796C1.1040106@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-class: urn:content-classes:message
In-Reply-To: <4C0796C1.1040106-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Shiri Franchi <shirif-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Did you try OFED-1.5.1 or even better, OFED-1.5.2?
I know patches for counters with RoCEE were submitted since OFED-1.5 and
I saw it working.


-----Original Message-----
From: Or Gerlitz 
Sent: Thursday, June 03, 2010 14:49
To: Eli Cohen; Vladimir Sokolovsky; Eli Cohen
Cc: Linux RDMA list; Moni Shoua; Shiri Franchi
Subject: Re: are IB port counters functioning over --IB-- with the
RDMAoE patch set?


> Hi Eli, Vlad,  Using some lab node here, I noticed that the IB port 
> counters were not functioning over --IB-- with the RDMAoE patches 
> present in an OFED drop named OFED-RDMAoE-1.5-rc6, see below.
> Was/is this a known issue? if yes, was it fixed? is/was there an ofa 
> bz case open for this? I didn't find such... I was told that under 
> ofed 1.5.1 this doesn't happen, but I wanted to 1st clarify with you.
Eli, Vlad, anything you can comment here?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
