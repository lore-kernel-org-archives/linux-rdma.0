From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: rnfs: rq_respages pointer is bad
Date: Wed, 05 May 2010 20:35:40 -0500
Message-ID: <4BE21CEC.1060408@opengridcomputing.com>
References: <1267489621.9774.41.camel@wilder.ibm.com> <ada6332arcw.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada6332arcw.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 5/5/10 5:58 PM, Roland Dreier wrote:
>   >  The source of the problem is in rdma_read_complete(), I am finding that
>   >  rqstp->rq_respages is set to point past the end of the rqstp->rq_pages
>   >  page list.  This results in a NULL reference in svc_process() when
>   >  passing rq_respages[0] to page_address().
>
> did this ever end up getting fixed upstream?
>    
I believe it did, but I'll check to be sure. It may be in Bruce's queue too.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
