From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] mlx4: Limit num of fast reg WRs
Date: Tue, 12 Oct 2010 00:13:26 +0200
Message-ID: <AANLkTinKiBHOT2sSA+_s5CGhqC8nEoDTp2_pGmo6MrQp@mail.gmail.com>
References: <20101007142416.GA11518@mtldesk30>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101007142416.GA11518@mtldesk30>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> Fix the limit of max fast regisreation WRs that can be posted to CX to match
> hardware capabilities.

Guys, can you clarify if the hardware limitation is 511 entries or its
(PAGE_SIZE / sizeof(pointer)) - 1 which is 4096 / 8  - 1 = 511 but can
change if the page size  gets bigger or smaller?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
