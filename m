From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: [PATCH 2/2] opensm: Protect against spurious wakeups when calling cl_event_wait_on
Date: Thu, 1 Nov 2012 00:59:58 -0700
Message-ID: <CAL1RGDXg39pKOaUcmsZA_HBdFH0XX313PzONDXgEv9F51JrCRQ@mail.gmail.com>
References: <1351554302.25353.21.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1351554302.25353.21.camel-akkeaxHeDKRliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 29, 2012 at 4:45 PM, Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org> wrote:
> @@ -525,8 +525,8 @@ static void cc_poller_send(osm_congestion_control_t *p_cc,
>         status = osm_vendor_send(p_cc->bind_handle, p_madw, TRUE);
>         if (status == IB_SUCCESS) {
>                 cl_atomic_inc(&p_cc->outstanding_mads_on_wire);
> -               if (p_cc->outstanding_mads_on_wire >
> -                   (int32_t)p_opt->cc_max_outstanding_mads)
> +               while (p_cc->outstanding_mads_on_wire >
> +                      (int32_t)p_opt->cc_max_outstanding_mads)
>                         cl_event_wait_on(&p_cc->sig_mads_on_wire_continue,
>                                          EVENT_NO_TIMEOUT,
>                                          TRUE);

I've never looked at the opensm code -- I'm just guessing based on this patch.

But is this (both original and patched) code susceptible to a missed
wakeup race?

ie

    if (outstanding_mads > max) // <-- decide to go to sleep here

// other thread signals wakeup, we're not asleep yet

        cl_event_wait_on(...); // <-- we've already missed the wakeup,
sleep forever.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
