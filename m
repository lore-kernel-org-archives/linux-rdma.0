From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: possible recursive locking detected in the cma?
Date: Tue, 24 Apr 2012 21:58:09 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373469D81D6@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A82373469D8171@ORSMSX101.amr.corp.intel.com>
 <CAL1RGDUZMAOrAQG_sg9iuF4tEWSgb2Zaun01C1VXkm1RVC7WMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUZMAOrAQG_sg9iuF4tEWSgb2Zaun01C1VXkm1RVC7WMA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> The usual fix is to use mutex_lock_nested, cf "Exception: Nested data
> dependencies leading to nested locking" in
> Documentation/lockdep-design.txt.  I haven't looked at how easy that
> is to do in this case.

I think in this case, it's easier to just delay the call to rdma_destroy_id() until after the listen's handler_mutex has been released.  mutex_lock_nested() is still used within cma_req_handler() to deal with the more explicit locking.  I'll try to get a patch for that this week.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
