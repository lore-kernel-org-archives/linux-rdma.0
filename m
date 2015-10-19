From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 0/6] IB/mad: Support devices taking pkey_index from the
 GSI QP
Date: Mon, 19 Oct 2015 20:59:23 +0300
Message-ID: <56252F7B.4000300@mellanox.com>
References: <1444811388-22486-1-git-send-email-haggaie@mellanox.com>
 <20151014175410.GB28534@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151014175410.GB28534-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10/14/2015 08:54 PM, Jason Gunthorpe wrote:
> What this series is doing (src QPN != 1) is absolutely not complainant
> with the spec.

Hal convinced me that the spec implicitly requires that. Originally I
thought that it was allowed, based this paragraph from Section 13.5.1
(MAD Interfaces):
> Note that it is not required by IBA that GS managers use QP1 as the
> source QP used to send management packets to GS agents. GS managers
> may send packets from any QP other than QP0. QP1's primary purpose
> is to be a known QP target to which GS managers can send packets
> to initially contact a GS agent on a node.

On 10/14/2015 08:54 PM, Jason Gunthorpe wrote:
> If hardware doesn't have the ability to set the pkey on outbound, then
> it can only support 1 pkey. This may be why reading other parts of the
> spec is confusing. pkey_index in the verbs section is optional, but
> without it an implementation cannot support multiple pkeys. Thus when
> multiple pkeys are supported it is not optional at all.
I wouldn't say that pkey_index is optional. If you look at section
11.4.1.1 (Post Send Request), there is simply no mention of a pkey index
in the input modifier list.

> Put the hack in the driver, and obsolete it when the hardware is fixed
> to follow the spec. Even better would be to fix this in firmware and
> leave the kernel alone.
We will move the code to create multiple QPs to the driver, and make
sure it uses SQPN == 1 on all created QPs. Note that a side effect will
be that MADs could be sent out of order (if they are put on different
QPs), however we would make sure that completions are in the right order.

> FWIW, IMHO, no device that works like this should be a candidate for
> the IBTA Interop Logo.
I would expect interop tests to test the BTH pkey, but my guess is that
it isn't tested today. That would explain how both the mlx5 and the
ipath drivers have been able to hide this issue so far.

I think most of the kernel code only looks at the BTH pkey to decide on
what pkey to send a response. It is only with our cma demux patches that
we started to look a the BTH pkey field for validating a connection, and
so the issue surfaced.

Since the change to the driver will take some time, I suggest that for
in order to fix the issue in 4.3 we change cma to look at the CM request
payload pkey and not at the BTH. After mlx5 and ipath are fixed we can
change cma back again.

Regards,
Haggai
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
