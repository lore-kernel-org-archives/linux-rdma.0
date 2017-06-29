From: Andrea Righi <righi.andrea@gmail.com>
Subject: Re: [PATCH] ib_isert: prevent NULL pointer dereference in
 isert_login_recv_done()
Date: Thu, 29 Jun 2017 10:20:57 +0200
Message-ID: <20170629082057.GA2037@Dell>
References: <CAANLjFoaZ8ueEQet3Yu6LygmxXBbQ0cHUEYsb2xEON0o3N9=+w@mail.gmail.com>
 <CAANLjFp6Y8wvLvmWrk1ECjm-OoyEppxD1svNYKpg+HDEZevJig@mail.gmail.com>
 <CAANLjFoQcmfkjq9N1fehTC9Zi6aOC7ArOEPXz-he3EnOvWeEDw@mail.gmail.com>
 <20170622223757.GC28955@Dell>
 <1498435084.26123.66.camel@haakon3.risingtidesystems.com>
 <20170628175354.GB1769@Dell>
 <ac404f71-3f34-af4c-b7b2-2b19ae768f47@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ac404f71-3f34-af4c-b7b2-2b19ae768f47@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagi@grimberg.me>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Robert LeBlanc <robert@leblancnet.us>, Sean Jenkins <sean@betterservers.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma <linux-rdma@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jun 29, 2017 at 08:36:51AM +0300, Sagi Grimberg wrote:
> 
> >Just tested this patch, I wasn't able to reproduce the NULL pointer
> >dereference or any other bugs, so this fix seems safe enough to me.
> >
> >Tested-by: Andrea Righi <righi.andrea@gmail.com>
> 
> Can you test just the one liner fix below?
> 
> >>@@ -1452,7 +1452,7 @@
> >>  isert_login_recv_done(struct ib_cq *cq, struct ib_wc *wc)
> >>  {
> >>  	struct isert_conn *isert_conn = wc->qp->qp_context;
> >>-	struct ib_device *ib_dev = isert_conn->cm_id->device;
> >>+	struct ib_device *ib_dev = isert_conn->device->ib_device;
> >>  	if (unlikely(wc->status != IB_WC_SUCCESS)) {
> >>  		isert_print_wc(wc, "login recv");

I'll test also this one-liner fix as soon as I can.

But I can say that I'm pretty sure it will work as well, because all the
previous NULL pointer dereferences that we've got in the past happened
all 100% in isert_login_recv_done(). The other cases are probably a safe
precaution, but they can't really happen.

-Andrea
