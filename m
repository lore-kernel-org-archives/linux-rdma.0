From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: When is it safe to release connection resources?
Date: Thu, 5 Jan 2012 09:29:31 -0800
Message-ID: <CAL1RGDXtZA=6uvCE73isD7cu2=LU4b3CGPs4g7UMPmW=1xqgww@mail.gmail.com>
References: <4EFC987B.6070901@list-group.com> <1828884A29C6694DAF28B7E6B8A8237325662B63@ORSMSX102.amr.corp.intel.com>
 <CAO+b5-qHFFg-KKQQkEZ2sS_+TWAFCJ0Ed4XGV15cs==_9zttSw@mail.gmail.com>
 <1828884A29C6694DAF28B7E6B8A823732566B335@ORSMSX101.amr.corp.intel.com> <CAO+b5-pk8v-1+STkYXmwTv2nKyQJcZd575dJW6Hipfo5_AchwA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-pk8v-1+STkYXmwTv2nKyQJcZd575dJW6Hipfo5_AchwA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jan 5, 2012 at 3:23 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> Sorry if I wasn't clear enough, but I was referring to the case where
> the kernel completion handler gets invoked after
> ib_uverbs_destroy_cq() has started but before that function has
> invoked ib_destroy_cq().

That should be OK.  ib_uverbs_destroy_cq() doesn't really do anything
until ib_destroy_cq() has returned, and at that point it is guaranteed
that the completion handler for the CQ is done.

> More in general - assuming that completion notifications have been
> enabled - I'm wondering whether it is possible to shut down a queue
> pair without triggering a race condition if that queue pair hasn't
> been transitioned to the reset or error state first.

destroying a QP is pretty much equivalent to transitioning it to the
reset state.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
