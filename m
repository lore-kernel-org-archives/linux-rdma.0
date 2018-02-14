From: Anuj Kalia <anujkaliaiitd-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Understanding UUAR calculations in mlx5 userspace driver
Date: Wed, 14 Feb 2018 17:08:04 -0500
Message-ID: <CADPSxAj11nY8Tyc+2ERw=0ziLiEm77yPkzPNeNO8HwnsekSuhg@mail.gmail.com>
References: <CAJ84Q-a428Whw3EvPRcbhpCf+fbbd-vAm0di7C4i32PcYSZrYQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ84Q-a428Whw3EvPRcbhpCf+fbbd-vAm0di7C4i32PcYSZrYQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Rohit Zambre <rzambre-sXc7qaQca9o@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Balaji, Pavan" <balaji-uKDnm65ik8M@public.gmane.org>, Aparna Chandramowlishwaran <amowli-sXc7qaQca9o@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

1. FP stands for fast path
2. Each UAR page has four BlueFlame registers. This is specific to the
NIC and firmware and is mentioned in the PRM. ConnectX-5 InfiniBand
has four, ConnectX-4 in Ethernet mode seems to have two according to
the online PRM.
3. No idea

I'm curious: are you seeing any performance impact of
"latency_sensitve" or "low latency UARs"? I've looked at this briefly
in the past and couldn't find perf impact. IIRC, the driver uses "fast
path" for only the first few QPs, but in my experiment even later QPs
got similar latency. But I might have missed something. If there's an
observable perf impact, you can probably figure out the answer to (3).

--Anuj





On Wed, Feb 14, 2018 at 10:35 AM, Rohit Zambre <rzambre-sXc7qaQca9o@public.gmane.org> wrote:
> Hi,
>
> I am trying to understand the uuar-related calculations of the
> userspace mlx5 driver (in mlx5_alloc_context) that use the various
> constants introduced in
> https://github.com/linux-rdma/rdma-core/commit/166d34841dd6a835e4f4f0196143880a73ce71bd.
>
> My understanding is that a uar is comprised of uuars. bfregs mean the
> same thing as uuars. A doorbell is written to the bfreg/uuar assigned
> to the QP.
>
> (1) W.r.t. MLX5_NUM_NON_FP_BFREGS_PER_UAR, what is a NON_FP_BFREG in a
> UAR? I am curious to know what FP stands for.
>
> (2) Is the value of NUM_BFREGS_PER_UAR set to 4 because the driver
> will have at least 4 low_lat_uuars for a context? This constant is
> used only in the calculation of gross_uuars. My assumption is that the
> NUM_BFREGS_PER_UAR value is not specific to the mlx5 device because of
> the missing MLX5_ prefix. Please correct me if I am wrong.
>
> (3) Given that the value of tot_uuars and low_lat_uuars can be
> configured through the MLX5_TOTAL_UUARS and MLX5_NUM_LOW_LAT_UUARS
> environment variables respectively, it is possible for me to have, in
> 1 context, 512 tot_uuars (=MLX5_MAX_BFREGS) and set all 511 of them as
> low_lat_uuars. Is this correct?
>
> Thanks,
>
> Rohit Zambre
> Ph.D. Student, Computer Engineering
> University of California, Irvine
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
