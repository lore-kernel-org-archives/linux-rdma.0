From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V1 FIXES for-3.11 0/4] Pkey fixes for IB core and IPoIB
Date: Wed, 31 Jul 2013 23:29:45 +0300
Message-ID: <CAJZOPZLVQhZtWyCJLt3W-COdHZnsrBaN+KOpj83d0GyS+RY+QA@mail.gmail.com>
References: <1374145352-27816-1-git-send-email-ogerlitz@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1374145352-27816-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, erezsh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 18, 2013 at 2:02 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:
> This set of fixes is critical for Virtualization environments when the VM
> para-virtualized PKEY table isn't fully configured at the time the
> VF is probed, or when the management pkey is provisioned to non-zero index
> in the VF pkey table.

Roland,

So what's about this series, any reason not to push it for 3.11 too
with the other changes you have picked into the for-next branch? ditto
for the iser patches to use fast-reg.

Or.

> The first three patches are pretty much few liners (two of them with somehow
> long change log...). The forth one a bit larger. Would be happy to see them
> all going to -stable, either by you adding a Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org when
> you push them or I can send them to Greg after they spend some time upstream.

> Changes from V0:
>   - applied feedback from Sean on the IB core patch and added his
> review-by
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
