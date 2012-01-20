From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: Re: cq-event kernel panic
Date: Fri, 20 Jan 2012 17:17:37 +0100
Message-ID: <4F1993A1.3030707@itwm.fraunhofer.de>
References: <4F194ABE.5080108@itwm.fraunhofer.de> <1828884A29C6694DAF28B7E6B8A823732DC11554@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823732DC11554-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/20/2012 05:04 PM, Hefty, Sean wrote:
>> We are still seeing kernel panics with linux-3.2, this time initiated
>> from mthca_cq_event(). I'm unsure if this is somehow related to the
>> yesterdays cq_completion patch. In any case, I'm CCing Sean therefore.
>
> Was your patch applied when testing?  mthca uses kmalloc to allocate the QP structure.
>
>

Yes, therefore the kernel build name updated to 3.2.0+. But please see 
the mail I just sent, it probably explains the underlying issue.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
