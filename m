From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH libibverbs v5 3/7] livibverbs: Add support for XRC SRQs
Date: Tue, 04 Jun 2013 09:13:55 -0500
Message-ID: <51ADF623.9080008@opengridcomputing.com>
References: <1364332466-22786-1-git-send-email-sean.hefty@intel.com> <1364332466-22786-4-git-send-email-sean.hefty@intel.com> <51AD0528.6000900@opengridcomputing.com> <1828884A29C6694DAF28B7E6B8A823736FD2CB36@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736FD2CB36-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/3/2013 6:30 PM, Hefty, Sean wrote:
>>>    enum verbs_context_mask {
>>>    	VERBS_CONTEXT_XRCD	= 1 << 0,
>>> -	VERBS_CONTEXT_RESERVED	= 1 << 1
>>> +	VERBS_CONTEXT_SRQ	= 1 << 1,
>>> +	VERBS_CONTEXT_RESERVED	= 1 << 2
>>>    };
>> Would VERBS_CONTEXT_XSRQ or VERBS_CONTEXT_SRQ_EX be more clear?
> The structure being extended is ibv_srq, so I think just 'SRQ' is clearer.  The same holds for VERBS_CONTEXT_QP.
>
> - Sean

k.  Will you be posting a new series soon for libibverbs and libmlx4 
against the new releases? The old series' do not apply...

thanks,

Steve.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
