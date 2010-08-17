From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCHv9 09/12] ib_core: Add VLAN support to IBoE
Date: Tue, 17 Aug 2010 21:29:51 +0300
Message-ID: <AANLkTinK2XMGpJHCSvDAeQ9D55JJY96uuLjc7CvWg1Rj@mail.gmail.com>
References: <20100806144153.GJ20588@mtldesk30>
	<20100806164915.GL11306@obsidianresearch.com>
	<20100816125128.GB22111@mtldesk30>
	<adaeidyw6bd.fsf@roland-alpha.cisco.com>
	<20100817143623.GA626@mtldesk30>
	<adatymtur55.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adatymtur55.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 17, 2010 at 7:43 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
>
> OK but as I said I don't see what that has to do with this patch.
We thought it was appropriate to put this info here. Maybe we should
move it to PATCH0?

>
> With current API at least the consumer only specifies the SGID index.
> How does the consumer get a GID with a given VLAN into the local GID table?

It's the HW driver that populates the GID table in response to net
device events.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
