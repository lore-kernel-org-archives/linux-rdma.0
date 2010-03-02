From: Tom Tucker <tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: rnfs: rq_respages pointer is bad
Date: Mon, 01 Mar 2010 21:35:00 -0600
Message-ID: <4B8C8764.9080409@opengridcomputing.com>
References: <1267489621.9774.41.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1267489621.9774.41.camel-XfwDJb4SXxnMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pradeep-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi David:

That looks like a bug to me and it looks like what you propose is the 
correct fix. My only reservation is that if you are correct then how did 
this work at all without data corruption for large writes on x86_64?

I'm on the road right now, so I can't dig too deep until Wednesday, but 
at this point your analysis looks correct to me.

Tom


David J. Wilder wrote:
> Tom
>
> I have been chasing an rnfs related Oops in svc_process().  I have found
> the source of the Oops but I am not sure of my fix.  I am seeing the
> problem on ppc64, kernel 2.6.32, I have not tried other arch yet.
>
> The source of the problem is in rdma_read_complete(), I am finding that
> rqstp->rq_respages is set to point past the end of the rqstp->rq_pages
> page list.  This results in a NULL reference in svc_process() when
> passing rq_respages[0] to page_address().
>
> In rdma_read_complete() we are using rqstp->rq_arg.pages as the base of
> the page list then indexing by page_no, however rq_arg.pages is not
> pointing to the start of the list so rq_respages ends up pointing to:
>
> rqstp->rq_pages[(head->count+1) + head->hdr_count]
>
> In my case, it ends up pointing one past the end of the list by one.
>
> Here is the change I made.
>
> static int rdma_read_complete(struct svc_rqst *rqstp,
>                               struct svc_rdma_op_ctxt *head)
> {
>         int page_no;
>         int ret;
>
>         BUG_ON(!head);
>
>         /* Copy RPC pages */
>         for (page_no = 0; page_no < head->count; page_no++) {
>                 put_page(rqstp->rq_pages[page_no]);
>                 rqstp->rq_pages[page_no] = head->pages[page_no];
>         }
>         /* Point rq_arg.pages past header */
>         rqstp->rq_arg.pages = &rqstp->rq_pages[head->hdr_count];
>         rqstp->rq_arg.page_len = head->arg.page_len;
>         rqstp->rq_arg.page_base = head->arg.page_base;
>
>         /* rq_respages starts after the last arg page */
> -       rqstp->rq_respages = &rqstp->rq_arg.pages[page_no];
> +	rqstp->rq_respages = &rqstp->rq_pages[page_no];
> .
> .
> .
>
> The change works for me, but I am not sure it is safe to assume the
> rqstp->rq_pages[head->count] will always point to the last arg page.
>
> Dave.
>   

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
