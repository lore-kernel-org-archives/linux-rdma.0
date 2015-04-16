From: Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH v4 10/27] IB/Verbs: Reform cm related part in IB-core
 cma/ucm
Date: Thu, 16 Apr 2015 13:21:48 -0400
Message-ID: <552FEFAC.6080402@talpey.com>
References: <552F6CF2.4000606@profitbricks.com> <552F6DEA.9080701@profitbricks.com> <552FB4D0.5080302@dev.mellanox.co.il> <552FB6EF.80107@profitbricks.com> <1828884A29C6694DAF28B7E6B8A82373A8FC22C3@ORSMSX109.amr.corp.intel.com> <552FD3BE.4090204@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <552FD3BE.4090204-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, infinipath <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Latif, Faisal" <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 4/16/2015 11:22 AM, Michael Wang wrote:
>
>
> On 04/16/2015 04:31 PM, Hefty, Sean wrote:
>>>> This is equivalent to today where the checks are per node rather than
>>>> per port.
>>>>
>>>> Should all checks here be port 1 based or only certain ones like listen
>>>> ? For example, in connect/reject/disconnect, don't we already have port
>>>> ? Guess this can be dealt with later as this is not a regression from
>>>> the current implementation.
>>>
>>> Yeah, these parts of cma may need more carve in future, like some new
>>> callback
>>> for different CM type as Sean suggested.
>>>
>>> Maybe directly using 1 could help to highlight the problem ;-)
>>
>> Only a few checks need to be per device.  I think I pointed those out previously.  Testing should show anywhere that we miss fairly quickly, since port would still be 0.  For the checks that can be updated to be per port, I would rather go ahead and convert them.
>
> Got it, will be changed in next version :-)
>
> To be confirmed:
> 				PORT ASSIGNED
> 	rdma_init_qp_attr	Y
> 	rdma_destroy_id		unknown
> 	cma_listen_on_dev	N
> 	cma_bind_loopback	N
> 	rdma_listen		N

Why "N"? rdma_listen() can be constrained to a single port, right?
And even if wildcarded, it needs to act on multiple ports, which is
to say, it will fail only if no ports are eligible.

Tom.


> 	rdma_connect		Y
> 	rdma_accept		Y
> 	rdma_reject		Y
> 	rdma_disconnect		Y
> 	ib_ucm_add_one		N
>
> Is this list correct?
>
> Regards,
> Michael Wang
>
>>
>> - Sean
>>
>
>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
