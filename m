From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] staging/rdma/hfi1: Reduce number of parameters passed to send handlers
Date: Wed, 11 Nov 2015 08:39:08 -0500
Message-ID: <20151111133907.GA21044@phlsvsds.ph.intel.com>
References: <1447220077-8325-1-git-send-email-ira.weiny@intel.com> <20151111062535.GG4023@leon.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20151111062535.GG4023-2ukJVAZIZ/Y@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-2ukJVAZIZ/Y@public.gmane.org>
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 11, 2015 at 08:25:35AM +0200, Leon Romanovsky wrote:
>On Wed, Nov 11, 2015 at 12:34:37AM -0500, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org wrote:
>> From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
>> 
>> +int snoop_send_dma_handler(struct hfi1_qp *qp, struct hfi1_pkt_state *ps,
>> +			   u64 pbc)
>>  {
>> -	pr_alert("Snooping/Capture of  Send DMA Packets Is Not Supported!\n");
>> +	pr_alert("Snooping/Capture of Send DMA Packets Is Not Supported!\n");
>>  	snoop_dbg("Unsupported Operation");
>Is it really necessary to do both print alert to message log (pr_alert) and to
>trace buffer (snoop_dbg)?

Well yes, and no. They serve two different purposes. One for users of the
snoop feature the other for developers.

However, I don't think we really even need to keep this function around
anymore. How about we just remove it in a follow on patch, and let this one
stand as is?

-Denny
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
