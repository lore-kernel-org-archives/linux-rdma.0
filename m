From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: Problem running rping over Intel adapters
Date: Wed, 3 Oct 2012 22:02:31 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A98E8E@FMSMSX151.amr.corp.intel.com>
References: <506CB0E9.90201@redhat.com>
 <1828884A29C6694DAF28B7E6B8A8237346A98E58@FMSMSX151.amr.corp.intel.com>
 <506CB4D8.4010604@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <506CB4D8.4010604-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> >> 1) rping, on the client side, clears the conn_params for the newly to be
> >> attempted connection, then sets:
> >>
> >> 	conn_param.responder_resources = 1;
> >> 	conn_param.initiator_depth = 1;
> >> 	conn_param.retry_count = 10;
> >
> >
> >> 2) the qib driver enforces a maximum of 7 for retry_count.  I don't see
> >> anything in the spec that specifies a maximum for this entry, and in
> >> particular I know it doesn't call out for 7 to mean infinite retries
> >> like it does for rnr_retry_count.
> >
> > On IB, retry count is a 3-bit value.  See the CM REQ message.
> >
> > The kernel rdma cm should probably check for a valid value and reduce it
> accordingly.
> 
> Then it's also fair to say that right now rping passes a known invalid
> value and needs fixed ;-)

For IB, but I wasn't sure about iWarp.  It doesn't look like it's used there though.

If not, I'll apply a patch to rping, plus submit a fix for the kernel to validate the value.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
