From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v4 10/27] IB/Verbs: Reform cm related part in IB-core
 cma/ucm
Date: Fri, 17 Apr 2015 10:27:31 +0200
Message-ID: <5530C3F3.5040708@profitbricks.com>
References: <552F6CF2.4000606@profitbricks.com> <552F6DEA.9080701@profitbricks.com> <552FB4D0.5080302@dev.mellanox.co.il> <552FB6EF.80107@profitbricks.com> <1828884A29C6694DAF28B7E6B8A82373A8FC22C3@ORSMSX109.amr.corp.intel.com> <552FD3BE.4090204@profitbricks.com> <552FEFAC.6080402@talpey.com> <1828884A29C6694DAF28B7E6B8A82373A8FC2508@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A8FC2508-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 04/16/2015 07:30 PM, Hefty, Sean wrote:
>>> To be confirmed:
>>> 				PORT ASSIGNED
>>> 	rdma_init_qp_attr	Y
>>> 	rdma_destroy_id		unknown
>>> 	cma_listen_on_dev	N
>>> 	cma_bind_loopback	N
> 
> Bind loopback will attach to a port, but the id does not have on entry.
> 
>>> 	rdma_listen		N
>>
>> Why "N"? rdma_listen() can be constrained to a single port, right?
>> And even if wildcarded, it needs to act on multiple ports, which is
>> to say, it will fail only if no ports are eligible.
> 
> Rdma listen should be unknown.  The id may be assigned to a port.  It depends on the source address.

Agree, so for those 'N' or 'unknow', let's use port 1 directly.

> 
>>> 	rdma_connect		Y
>>> 	rdma_accept		Y
>>> 	rdma_reject		Y
>>> 	rdma_disconnect		Y
>>> 	ib_ucm_add_one		N
> 
> Others look correct.
> 
> Btw, thanks for your work on this.  I know this is becoming a much bigger change than you originally intended.  :)

My pleasure :-) It do exceeded my expectations, fortunately I have you guys
on my side, without your comments, it's impossible to make it so far :-)

Regards,
Michael Wang

> 
> - Sean
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
