From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 2/2] opensm: Protect against spurious wakeups when
 calling cl_event_wait_on
Date: Thu, 8 Nov 2012 14:14:43 +0200
Message-ID: <20121108121443.GA25740@calypso>
References: <1351554302.25353.21.camel@auk59.llnl.gov>
 <CAL1RGDXg39pKOaUcmsZA_HBdFH0XX313PzONDXgEv9F51JrCRQ@mail.gmail.com>
 <20121101180834.GA20151@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20121101180834.GA20151-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12:08 Thu 01 Nov     , Jason Gunthorpe wrote:
> On Thu, Nov 01, 2012 at 12:59:58AM -0700, Roland Dreier wrote:
> > On Mon, Oct 29, 2012 at 4:45 PM, Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org> wrote:
> > > @@ -525,8 +525,8 @@ static void cc_poller_send(osm_congestion_control_t *p_cc,
> > >         status = osm_vendor_send(p_cc->bind_handle, p_madw, TRUE);
> > >         if (status == IB_SUCCESS) {
> > >                 cl_atomic_inc(&p_cc->outstanding_mads_on_wire);
> > > -               if (p_cc->outstanding_mads_on_wire >
> > > -                   (int32_t)p_opt->cc_max_outstanding_mads)
> > > +               while (p_cc->outstanding_mads_on_wire >
> > > +                      (int32_t)p_opt->cc_max_outstanding_mads)
> > >                         cl_event_wait_on(&p_cc->sig_mads_on_wire_continue,
> > >                                          EVENT_NO_TIMEOUT,
> > >                                          TRUE);
> > 
> > I've never looked at the opensm code -- I'm just guessing based on this patch.
> 
> The event objects have a hidden built in state that ensures a wake up
> is not lost, so long as only one thread ever calls wait_on. If it is
> possible two threads could be sleeping on the same event then the
> system is unfixably-broken-by-design, since on thread will eat the
> internal event and the other will thus miss it, in a racy way.
> 
> I've had to clean this kind of a mess up in other code bases, and now
> always discourage this kind of interface. Use POSIX condition
> variables, they have cleaner locking semantics and are easier to audit
> for correctness.
> 

Right now only one thread is sleeping on the signal (for both CC and PM), so
it's safe to apply the patch as is. However improvements in that area are more
than welcomed.

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
