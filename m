From: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 0/6] IB/mad: Support devices taking pkey_index from the
 GSI QP
Date: Wed, 14 Oct 2015 21:42:54 +0000
Message-ID: <2807E5FD2F6FDA4886F6618EAC48510E1CBC650D@CRSMSX101.amr.corp.intel.com>
References: <1444811388-22486-1-git-send-email-haggaie@mellanox.com>
 <20151014175410.GB28534@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151014175410.GB28534-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I was writing my own objection to this but Jason beat me too it.  More comments below.

> 
> On Wed, Oct 14, 2015 at 11:29:42AM +0300, Haggai Eran wrote:
> > respect the pkey_index in ib_send_wr.ud for GSI packets. Apparently
> > having the pkey_index in a work request isn't required by the IBA
> > specifications,
> 
> I disagree. The spec is very clear, 13.5.3.2.1 perscribes how GMP replies must
> be generated and there are only two ways to follow that
> perscription:
>  - Have some mechanism to set the pkey on outgoing QP1 GMPs
>  - Support only one pkey

Agree with Jason.

In addition Section 9.6.1.1.3 C9-42 specifically states that inbound Packets for QP1 are allowed on any PKey of which the port is a member.  What you are proposing widely deviates from the intent of QP1 processing.

> 
> What this series is doing (src QPN != 1) is absolutely not complainant with the
> spec.

Agree.

> 
> If hardware doesn't have the ability to set the pkey on outbound, then it can
> only support 1 pkey. This may be why reading other parts of the spec is
> confusing. pkey_index in the verbs section is optional, but without it an
> implementation cannot support multiple pkeys. Thus when multiple pkeys are
> supported it is not optional at all.

Agree.

> 
> This proposed hack violates parts of 13.5.3.2.1 so I don't think it is acceptable
> for core code to endorse ignoring the spec so badly. Especially when the
> violations are visible on the wire.
> 
> Put the hack in the driver, and obsolete it when the hardware is fixed to follow
> the spec. Even better would be to fix this in firmware and leave the kernel
> alone.

Agree.

One final point, this extends the MAD layer to do things it was not intended to do.  The MAD layer was designed to handle the special QPs (0 and 1) we should keep it that way.  Even if we had a valid use case to create multiple UD QPs for GSI traffic it should be done via a new "QP pool" mechanism rather than hiding it like it was part of QP1.

Ira

> 
> FWIW, IMHO, no device that works like this should be a candidate for the IBTA
> Interop Logo.
> 
> Jason
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body
> of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
