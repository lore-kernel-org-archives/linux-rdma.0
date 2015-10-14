From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 0/6] IB/mad: Support devices taking pkey_index from the
 GSI QP
Date: Wed, 14 Oct 2015 11:54:10 -0600
Message-ID: <20151014175410.GB28534@obsidianresearch.com>
References: <1444811388-22486-1-git-send-email-haggaie@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1444811388-22486-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 14, 2015 at 11:29:42AM +0300, Haggai Eran wrote:
> respect the pkey_index in ib_send_wr.ud for GSI packets. Apparently having
> the pkey_index in a work request isn't required by the IBA
> specifications,

I disagree. The spec is very clear, 13.5.3.2.1 perscribes how GMP
replies must be generated and there are only two ways to follow that
perscription:
 - Have some mechanism to set the pkey on outgoing QP1 GMPs
 - Support only one pkey

What this series is doing (src QPN != 1) is absolutely not complainant
with the spec.

If hardware doesn't have the ability to set the pkey on outbound, then
it can only support 1 pkey. This may be why reading other parts of the
spec is confusing. pkey_index in the verbs section is optional, but
without it an implementation cannot support multiple pkeys. Thus when
multiple pkeys are supported it is not optional at all.

This proposed hack violates parts of 13.5.3.2.1 so I don't think it
is acceptable for core code to endorse ignoring the spec so
badly. Especially when the violations are visible on the wire.

Put the hack in the driver, and obsolete it when the hardware is fixed
to follow the spec. Even better would be to fix this in firmware and
leave the kernel alone.

FWIW, IMHO, no device that works like this should be a candidate for
the IBTA Interop Logo.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
