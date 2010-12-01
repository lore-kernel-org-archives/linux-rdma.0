From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2] mlx4: Protocol distinction
Date: Wed, 1 Dec 2010 23:12:22 +0200
Message-ID: <AANLkTinwpuUis2Xj_U3PNSmZcM3LFr+A9V3JXanvH2Jr@mail.gmail.com>
References: <4CF67444.4080001@senin.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4CF67444.4080001-192fA4vuk7xBDLzU/O5InQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "Aleksey Senin\"" <alekseys-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Aleksey Senin <alex-192fA4vuk7xBDLzU/O5InQ@public.gmane.org> wrote:
> Newest firmware does a IB/ETH protocol distiction.
> There are two bits in members_count field of multicast group table
> that store this info and its meaning : 0 - Infiniband, 1 - Ethernet. While changing
> members count for particular multicast group it important not to reset this information.

Two quesions for this patch and et al friend patches to come somehow
soon: what happens if someone burns the new firmware on an IB system
which runs the mlx4 code before the patch? also, what happens if
someone runs the patched mlx4 on a system on which the firmware isn't
this newest, shouldn't a check for the firmware version to be >= X be
added to the driver? As for the 1st case (old code, new firmware), I
recall there was a similar situation couple of months or maybe little
more ago, Jack, I think you were involved in the solution, correct?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
