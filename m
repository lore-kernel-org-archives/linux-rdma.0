From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v7 00/23] IB/Verbs: IB Management Helpers
Date: Thu, 30 Apr 2015 09:48:00 +0200
Message-ID: <5541DE30.6070705@profitbricks.com>
References: <1430233823-7075-1-git-send-email-yun.wang@profitbricks.com> <1430324895.102408.23.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430324895.102408.23.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Devesh Sharma <Devesh.Sharma-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Dave Goodell <dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



On 04/29/2015 06:28 PM, Doug Ledford wrote:
> On Tue, 2015-04-28 at 17:10 +0200, Michael Wang wrote:
>> Since v6:
>>   * Thanks to Ira, Devesh for the review and testing :-)
>>   * Thanks for the comments from Sean, Tom, Jason, Doug, Devesh, Ira,
>>     Liran :-) Please remind me if anything missed :-P
>>   * Use query_protocol() and enum protocol type in 1#
>>   * Use rdma_protocol_XX() in 2#
>>   * Drop cma_set_legacy_transport()
>>   * Reserve rdma_ib_or_iboe() and rdma_node_get_transport()
>>   * Updated github repository to v7
> 
> I've taken your patchset and threw it into a for-4.2 branch in my repo.
> This will get it 0day testing.  I've also pulled it into my test cluster
> and done minimal testing (bootup, finds devices, gets IP address via
> dhcp).  Here are the hardware types it passed on:
> 
> mthca (yes, I still have these...only just barely, but I do)
> mlx4 (IB/RoCE, in both standalone and SRIOV usage)
> mlx5 (IB only, I don't have the Eth capable mlx5 hardware yet)
> cxgb3
> cxgb4
> qib
> ocrdma

My appreciation :-) Please let me know if there are anything broken.

Regards,
Michael Wang

> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
