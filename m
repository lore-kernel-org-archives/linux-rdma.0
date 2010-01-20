From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: IB/documentation: fix typo in include/rdma/ib_verbs.h
Date: Wed, 20 Jan 2010 11:16:24 -0800
Message-ID: <adamy088u47.fsf@roland-alpha.cisco.com>
References: <e2e108261001200456r470e7e51p67504454acbc3258@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108261001200456r470e7e51p67504454acbc3258-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Bart Van Assche's message of "Wed, 20 Jan 2010 13:56:13 +0100")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Linux-RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > - *   may also be |ed in to request a hint about missed events, as
 > + *   may also be passed in to request a hint about missed events, as

I don't think this is a typo -- the comment is trying to say that the
"report missed events" flag can be OR-ed in, ie |ed in.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
