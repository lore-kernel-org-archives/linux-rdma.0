From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH] RDMA/ucma.c: Different fix for ucma context uid=0,
 causing iWarp RDMA applications to fail in connection establishment
Date: Fri, 10 Aug 2012 13:04:16 -0700
Message-ID: <CAL1RGDWwxLEaUfPbop+vyXEJukDWRSAaJwLra4Z7V769ijOKyQ@mail.gmail.com>
References: <20120803235940.GA4912@TENIKOLO-MOBL> <1828884A29C6694DAF28B7E6B8A8237346A7CA42@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A7CA42-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Lacombe, John S" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Aug 4, 2012 at 11:48 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> Roland, there's a race here where ucma_set_event_context() copies ctx->uid to the event structure outside of the mutex.  Once the mutex is acquired, ctx->uid is checked.  However, the uid could have changed between saving it off to the event and checking it.

OK.  So then this patch, which moves the mutex acquire up to cover
ucma_set_event_context() seems like a sensible fix?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
