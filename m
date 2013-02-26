From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2] IB/mlx4: silence GCC warning
Date: Tue, 26 Feb 2013 09:57:04 +0200
Message-ID: <201302260957.04585.jackm@dev.mellanox.co.il>
References: <1348836538.3626.21.camel@x61.thuisdomein> <CAL1RGDWVAYCTNOOA+s_n5Pu7JgrR-6K+krcbSuARtEhgze_nqw@mail.gmail.com> <CAL1RGDWt2cgcwec-iQ9f8-YvC8fO2AncGBfQ2VUgPi3W49bKxg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWt2cgcwec-iQ9f8-YvC8fO2AncGBfQ2VUgPi3W49bKxg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Paul Bolle <pebolle-IWqWACnzNjzz+pZb47iToQ@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Monday 25 February 2013 19:23, Roland Dreier wrote:
> On Mon, Feb 25, 2013 at 8:54 AM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote:
> > I'm finally noticing that this is in the build_mlx_header() function,
> > which is pretty much a slow path.  Certainly another compare isn't
> > going to change performance given all the other stuff we do there.
> >
> > Let me look at the patches that have gone by and see what the cleanest
> > way to handle this is.
> 
> OK, after playing around a bit, I see that just initializing vlan
> doesn't really change the generated code (my gcc at least was already
> if effect setting vlan in the generated assembly code), so I'll just
> merge that.
> 
>  - R.

Thanks!

-Jack 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
