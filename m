From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 2/5] IB/srp: implement SRP_CRED_REQ and SRP_AER_REQ
Date: Sat, 23 Oct 2010 12:47:20 +0200
Message-ID: <AANLkTi=M9swgmnMUBdd71yCde3xXh81GweUL-F1-ROho@mail.gmail.com>
References: <1287285925-11710-1-git-send-email-dillowda@ornl.gov>
 <1287285925-11710-3-git-send-email-dillowda@ornl.gov> <AANLkTimvHRLr5YaCxeuLpQPMW7tY7cHsF9RrrSuMOmgS@mail.gmail.com>
 <1287407410.10438.46.camel@lap75545.ornl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1287407410.10438.46.camel-FqX9LgGZnHWDB2HL1qBt2PIbXMQ5te18@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: "rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 18, 2010 at 3:10 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote=
:
>
> [ ... ]
> While looking at this, I noticed that we didn't do any syncs in
> srp_send_tsk_mgmt(), so I've pushed this patch for now. We can remove
> the *_sync_for_cpu() calls later if it turns out we really don't need
> them.
> [ ... ]
> + =A0 =A0 =A0 ib_dma_sync_single_for_cpu(dev, iu->dma, sizeof *tsk_mg=
mt,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
DMA_TO_DEVICE);

Hello Dave,

Sorry for the late comment, but I just noticed that the above code
performs a partial buffer synchronization. If I remember correctly,
the DMA API doesn't allow this and the "size" argument must match the
size argument passed to the corresponding ib_dma_map_single() call,
that is, target->max_ti_iu_len ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
