From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH ib-next 2/3] IB/core: IB/core: Allow legacy verbs through
 extended interfaces
Date: Mon, 9 Nov 2015 18:25:13 +0200
Message-ID: <20151109162513.GB116821@x-vnc01.mtx.labs.mlnx>
References: <1446745208-17733-1-git-send-email-eli@mellanox.com>
 <1446745208-17733-3-git-send-email-eli@mellanox.com>
 <CAAKD3BDq_o+J3yM1qAKg_x35Dps5Ne_ffaD_Mz55a272pwQcJg@mail.gmail.com>
 <20151109155539.GA116821@x-vnc01.mtx.labs.mlnx>
 <CAAKD3BAJi0XSU1VW10jogaHL7wYT6fcDSw=q1Zpu+4+Mf760nQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CAAKD3BAJi0XSU1VW10jogaHL7wYT6fcDSw=q1Zpu+4+Mf760nQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, matanbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Nov 09, 2015 at 06:11:49PM +0200, Matan Barak wrote:
> >
> > Like Haggai mentioned in the other response, checkpatch issues error
> > on this claiming that ENOSYS is reserved to unavailable system calls.
> > Is it applicable only for new implementations I am not sure. I don't
> > have clear preference for either ENOSYS or EINAVL.
> 
> I think it could break old applications:
> err = extended_verb(the_first_extension_we_added);
> if (err == ENOSYS)
>       err = legacy_verb();
> if (err)
>     return err;

Can you send a pointer to the code where this could happen?

> 
> Such applications used the first extension (that was added during the
> addition of the extended verb) and when they realized it's not
> supported, they dropped to the legacy verb. This change can now cause
> the return of -EINVAL an early termination with an error.
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
