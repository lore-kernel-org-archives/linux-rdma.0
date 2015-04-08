From: Michael Wang <yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [PATCH v2 09/17] IB/Verbs: Use helper cap_read_multi_sge() and
 reform svc_rdma_accept()
Date: Wed, 08 Apr 2015 10:51:32 +0200
Message-ID: <5524EC14.9030304@profitbricks.com>
References: <5523CCD5.6030401@profitbricks.com> <5523CEE4.5060901@profitbricks.com> <5523FBF1.80304@talpey.com> <20150407174223.GB15704@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150407174223.GB15704-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Tom Talpey <tom-CLs1Zie5N5HQT0dZR+AlfA@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Hoang-Nam Nguyen <hnguyen-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Christoph Raisch <raisch-tA70FqPdS9bQT0dZR+AlfA@public.gmane.org>, Mike Marciniszyn <infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Upinder Malhi <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Trond Myklebust <trond.myklebust-7I+n7zu2hftEKMMhf/gKZA@public.gmane.org>, "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, PJ Waskiewicz <pj.waskiewicz-PrFOU5CTvK1l57MIdRCFDg@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 04/07/2015 07:42 PM, Jason Gunthorpe wrote:
[snip]
>>> @@ -992,8 +992,8 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
>>>  			dma_mr_acc = IB_ACCESS_LOCAL_WRITE;
>>>  		} else
>>>  			need_dma_mr = 0;
>>> -		break;
>>> -	case RDMA_TRANSPORT_IB:
>>> +	} else if (rdma_ib_mgmt(newxprt->sc_cm_id->device,
>>> +				newxprt->sc_cm_id->port_num)) {
>>>  		if (!(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG)) {
>>>  			need_dma_mr = 1;
>>>  			dma_mr_acc = IB_ACCESS_LOCAL_WRITE;
>>
>> Now I'm even more confused. How is the presence of IB management
>> related to needing a privileged lmr?
> 
> Agree, this needs to be someone else. 
> 
> I think the test is probably based on this comment:
> 
>         * NB:  iWARP requires remote write access for the data sink
>         *      of an RDMA_READ. IB does not.
> 
> So the if should be:
> 
>           if (cap_rdma_read_needs_write(..) && 
> 	  !(newxprt->sc_dev_caps & SVCRDMA_DEVCAP_FAST_REG)) {
>                        need_dma_mr = 1;
>                        dma_mr_acc =
>                                (IB_ACCESS_LOCAL_WRITE |
>                                 IB_ACCESS_REMOTE_WRITE);
> 
> And the identical if blocks merged.
> 
> Plus the
> 	if (rdma_transport_iwarp(newxprt->sc_cm_id->device,
> 				 newxprt->sc_cm_id->port_num))
>   		newxprt->sc_dev_caps |= SVCRDMA_DEVCAP_READ_W_INV

Sounds good :-) I'll give this part a reform in next version.

Regards,
Michael Wang

> 
> Jason
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
