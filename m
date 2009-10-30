From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: Sending large messages (> 100k) to the list
Date: Fri, 30 Oct 2009 08:27:27 -0700
Message-ID: <adafx9052cg.fsf@cisco.com>
References: <829ded920910300056w30fc76b6xa193eec6a1c8755e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <829ded920910300056w30fc76b6xa193eec6a1c8755e-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
	(Keshetti Mahesh's message of "Fri, 30 Oct 2009 13:26:46 +0530")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Keshetti Mahesh <keshetti.mahesh-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


 > Yesterday I have sent a mail which is around 250K to the list
 > and it didn't make it to the list yet. From one mail thread, I have
 > found that there is a 100k limit on the message size. So, what
 > is the best way to send large messages to the list ? Also, why
 > didn't I receive any bounce message ?

vger silently drops too-big messages, so you shouldn't expect a bounce.

Why were you trying to send a huge email?  In almost all cases there is
a better way to handle things rather than sending a huge email all the
list subscribers.  Could your send a link to the information instead?
Or you could try compressing it and sending as an attachment if you
really need to email it.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
