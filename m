From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v2] IB/mlx4: silence GCC warning
Date: Mon, 25 Feb 2013 08:54:12 -0800
Message-ID: <CAL1RGDWVAYCTNOOA+s_n5Pu7JgrR-6K+krcbSuARtEhgze_nqw@mail.gmail.com>
References: <1348836538.3626.21.camel@x61.thuisdomein> <511B9A1C.6000402@acm.org>
 <1361437377.1341.33.camel@x61.thuisdomein> <201302241434.17586.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201302241434.17586.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, Feb 24, 2013 at 4:34 AM, Jack Morgenstein
<jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> However, this approach does add the line below to processing for an IB port (ETH/RoCE port stays same, more or less).
> Processing time is therefore increased (at least on the IB side) relative to just living with the warning.
>
> Roland?

I'm finally noticing that this is in the build_mlx_header() function,
which is pretty much a slow path.  Certainly another compare isn't
going to change performance given all the other stuff we do there.

Let me look at the patches that have gone by and see what the cleanest
way to handle this is.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
