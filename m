From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v3 25/28] IB/Verbs: Use management helper cap_af_ib()
Date: Thu, 16 Apr 2015 17:28:39 +0200
Message-ID: <552FD527.4060507@profitbricks.com>
References: <552BB470.4090407@profitbricks.com> <552BB801.2010506@profitbricks.com> <CAJ3xEMiEoosZzHhpoJOLdxmdhRrjOfB=HV6bHhus7E=QmHiwPQ@mail.gmail.com> <552FC441.5070500@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A82373A8FC23BF@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FC23BF-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 04/16/2015 05:09 PM, Hefty, Sean wrote:
[snip]
>>> Sean, can you please put a precise writeup what does it take to
>>> support AF_IB... I am a bit
>>> confused here and wasn't sure if this can be supported with RoCE.
>>
>> I think this means IB GID addressing is checked (Native Infiniband
>> Address) and not AF_IB (which is socket address/protocol family like
>> INET and INET6).
>>
>> I think this naming is confusing and maybe cap_ib_gid is better ?
> 
> I need to trace back through the code to see where this is used, but I thought the check was determining if an address conveyed using sockaddr_ib applied to the port.  Sockaddr_ib was intended to target IB-classic specifically.  It should apply to RoCE/IBoE as well.  I don't think it applies to RoCEv2/IBoUDP without a translation.

The usage is:

	rdma_resolve_addr
	{
		...
                if dst_addr->sa_family == AF_IB                                       
                        cma_resolve_ib_addr --> cma_resolve_ib_dev                             
                else                                                                  
                        rdma_resolve_ip
		...
	}

So I guess IBoE using ib address rather than ip?

Regards,
Michael Wang

> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
