From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 05/9] ib/iser: simplify send flow/descriptors
Date: Thu, 04 Feb 2010 13:23:02 +0200
Message-ID: <4B6AAE16.8040100@Voltaire.com>
References: <Pine.LNX.4.64.1002031721280.11944@zuben.voltaire.com> <Pine.LNX.4.64.1002031737090.11944@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <Pine.LNX.4.64.1002031737090.11944-aDiYczhfhVLdX2U7gxhm1tBPR1lH4CV8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Or Gerlitz wrote:
> Simplify and shrink the logic/code used for the send descriptors.
> Changes include removal of struct iser_dto which is unnecessary
> abstraction, use struct iser_regd_buf only for handling SCSI commands,
> use dma_sync instead of dma_map/unmap, etc.

it turns out that bunch of white-spaces slipped into this patch, will fix in V2

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
