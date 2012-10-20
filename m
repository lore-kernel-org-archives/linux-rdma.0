From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-3.7 0/4] mlx4 SRIOV fixes, 64B CQE/EQE patches re-spin
Date: Sat, 20 Oct 2012 15:06:23 +0200
Message-ID: <CAJZOPZK=JPmMkPN=760F6hQs7GdwKPmk3iuse3ng=euXkVg5vg@mail.gmail.com>
References: <1350492181-13471-1-git-send-email-ogerlitz@mellanox.com>
	<CAL1RGDVxogkdm0BUOE6nrFsJiSOWtqG_BrQ6p8qZddixgwaL+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVxogkdm0BUOE6nrFsJiSOWtqG_BrQ6p8qZddixgwaL+Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 19, 2012 at 1:58 AM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> [...] So I think we need some flag passed to the mlx4_core (that drives the
> PPF) that lets the user opt into 64B CQEs.  I would suggest that we
> start with the default value be "disabled" and then flip that after a few
> kernel versions (and print something in the kernel log when we detect
> 64B-CQE-capable HW when we're running with 64B CQEs disabled).

Also, any other feedback/comment on the patch except for  the need in
that module param and the notice in the kernel log?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
