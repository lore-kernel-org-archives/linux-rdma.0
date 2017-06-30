From: "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Subject: Re: [PATCH] ib_isert: prevent NULL pointer dereference in
 isert_login_recv_done()
Date: Thu, 29 Jun 2017 22:53:05 -0700
Message-ID: <1498801985.24896.4.camel@haakon3.risingtidesystems.com>
References: <CAANLjFoaZ8ueEQet3Yu6LygmxXBbQ0cHUEYsb2xEON0o3N9=+w@mail.gmail.com>
         <CAANLjFp6Y8wvLvmWrk1ECjm-OoyEppxD1svNYKpg+HDEZevJig@mail.gmail.com>
         <CAANLjFoQcmfkjq9N1fehTC9Zi6aOC7ArOEPXz-he3EnOvWeEDw@mail.gmail.com>
         <20170622223757.GC28955@Dell>
         <1498435084.26123.66.camel@haakon3.risingtidesystems.com>
         <20170628175354.GB1769@Dell>
         <ac404f71-3f34-af4c-b7b2-2b19ae768f47@grimberg.me>
         <20170629082057.GA2037@Dell>
         <7f1b1f07-0670-10ee-620d-0ab3b1a6c2bf@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <7f1b1f07-0670-10ee-620d-0ab3b1a6c2bf-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Andrea Righi <righi.andrea-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, Sean Jenkins <sean-v0B6Y9onFlloq1w47eu9iAC/G2K4zDHf@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, lkml <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2017-06-29 at 11:28 +0300, Sagi Grimberg wrote:
> >> Can you test just the one liner fix below?
> >>
> >>>> @@ -1452,7 +1452,7 @@
> >>>>   isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
> >>>>   {
> >>>>   	struct isert_conn *isert_conn = wc->qp->qp_context;
> >>>> -	struct ib_device *ib_dev = isert_conn->cm_id->device;
> >>>> +	struct ib_device *ib_dev = isert_conn->device->ib_device;
> >>>>   	if (unlikely(wc->status != IB_WC_SUCCESS)) {
> >>>>   		isert_print_wc(wc, "login recv");
> > 
> > I'll test also this one-liner fix as soon as I can.
> > 
> > But I can say that I'm pretty sure it will work as well, because all the
> > previous NULL pointer dereferences that we've got in the past happened
> > all 100% in isert_login_recv_done(). The other cases are probably a safe
> > precaution, but they can't really happen.
> 
> Agree, I'd prefer to start with a surgical fix before moving forward.

Sounds fine.  The single line fix above in isert_login_recv_done() has
been queued up in target-pending/for-next with Andrea's Tested-by and
your Reviewed-by:

https://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git/commit/?h=for-next&id=702c0f17403765cc5aa1c18f6ea6eb549c1bac9b

Please let me know if there are any other issues wrt the surgical fix.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
