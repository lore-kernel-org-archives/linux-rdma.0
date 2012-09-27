From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] IB/iser: add more RX CQs to scale out processing of SCSI responses
Date: Fri, 28 Sep 2012 00:08:50 +0200
Message-ID: <CAJZOPZJ5k+bC1MNJQsPE-r+0B_+TgPO-y-uTxB+PgDgVZThm3g@mail.gmail.com>
References: <1348413464-25792-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348413464-25792-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Alex Tabachnik <alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Sep 23, 2012 at 5:17 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> From: Alex Tabachnik <alext-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>
> RX/TX CQs will now be selected from a per HCA pool, for the RX flow
> this has the effect of using different interrupt vectors over low level
> drivers (such as mlx4) who map the "vector" param provided by the ULP on
> CQ creation to a dedicated IRQ/MSI-X vector. Once this is made, the RX flow
> processing of IO responses will now be  distributed across multiple CPUs.
>
> QPs (--> iser sessions) are assigned to CQs in round robin manner
> using the current CQ with minimal number of sessions attached to it.


Roland,

Just wondered if you need anything re this one for 3.7?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
