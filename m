From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-3.3 0/6] IB: set of fixes and additions
Date: Wed, 15 Feb 2012 22:24:14 +0200
Message-ID: <CAJZOPZ+r+1K64OaTU9woU=_5uWQ0t8kD_7wDQr_uEx2YkaYLzw@mail.gmail.com>
References: <alpine.LRH.2.00.1201111850330.10264@ogerlitz.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <alpine.LRH.2.00.1201111850330.10264-VYr5/9ddeaGSIdy2EShu12Xnswh1EIUO@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jan 11, 2012 at 6:52 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> The series is made of four elements

Hi Roland,

Can you provide feedback / comment on these patches? I've got Sean's
okay on patches #1 saying I need one fix, and also I addressed your
comment and posted V2 @
http://marc.info/?l=linux-rdma&m=132639997703455&w=2 also for #5 Sean
provided reviewed-by @
http://marc.info/?l=linux-rdma&m=132630851219457&w=2

Or.



> This subset (patches 1-3) fixes two bugs port info related bugs, where
> the first patch is just making following code related to speed possible...

> [PATCH 1/6] IB: use central enum for speed instead of hard-coded values
> [PATCH 2/6] IB/core: fix wrong display of rate in sysfs
> [PATCH 3/6] IB/mlx4: fix wrong info returned when querying IBoE ports
>
> This patch comes to address the long pending patch for 4k mtu
> along the lines of what was requested over the last review
> [PATCH 4/6] net/mlx4: allow for dynamic mtu configuration for IB ports
>
> This patch is simple and comes to unify the approach for checksum
> indication with possible / hopefully soon changes in libibverbs
>
> [PATCH 5/6] IB: change CQ TCP/IP checksum offload mark to use bit flag indication instead of integer
>
> This patch extends the IPoIB child scheme, and will serve as
> a building block when using IPoIB in the Virtualization space.
>
> [PATCH 6/6] IB/ipoib: add support for clones / multiple childs on the same partition
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
