From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [RFC] split struct ib_send_wr
Date: Tue, 4 Aug 2015 09:41:10 -0700
Message-ID: <20150804164110.GA31119@infradead.org>
References: <20150804143447.GA22172@infradead.org>
 <1828884A29C6694DAF28B7E6B8A82373A902272C@ORSMSX109.amr.corp.intel.com>
 <20150804162924.GA4867@infradead.org>
 <55C0EA21.2070609@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <55C0EA21.2070609-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 04, 2015 at 09:36:49AM -0700, Bart Van Assche wrote:
> >diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
> > [ ... ]
> >  struct ib_recv_wr {
> >+	struct ib_send_wr	wr;
> >  	struct ib_recv_wr      *next;
> >  	u64			wr_id;
> >  	struct ib_sge	       *sg_list;
> 
> Hello Christoph,
> 
> This part of the patch surprised me ?

It should.  It's a stupid cut & paste error, the new member isn't used
at all.  I'll fix it up.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
