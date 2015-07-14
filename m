From: Alex Thorlton <athorlton-sJ/iWh9BUns@public.gmane.org>
Subject: Re: [BUG] mellanox IB driver fails to load on large config
Date: Tue, 14 Jul 2015 13:48:20 -0500
Message-ID: <20150714184820.GB58053@asylum.americas.sgi.com>
References: <20150710191506.GA52396@asylum.americas.sgi.com> <CAJ3xEMj82OtHcs+kDG_xrQZ4+x3Eih=YSNFR4+W-AoPNA=4jTw@mail.gmail.com> <20150714182234.GD17920@asylum.americas.sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20150714182234.GD17920-UiYq4lDBhggTG1waqwXmH7Cf4lofQVJ7@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: andrew banman <abanman-sJ/iWh9BUns@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Linux Kernel <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "David S. Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, athorlton-sJ/iWh9BUns@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 14, 2015 at 01:22:34PM -0500, andrew banman wrote:
> On Sat, Jul 11, 2015 at 11:20:19PM +0300, Or Gerlitz wrote:
> > On Fri, Jul 10, 2015 at 10:15 PM, andrew banman <abanman-sJ/iWh9BUns@public.gmane.org> wrote:
> > > I'm seeing a large number of allocation errors originating from the Mellanox IB
> > > driver when booting the 4.2-rc1 kernel on a 4096cpu 32TB memory system:
> > 
> > Just to make sure, mlx4 works fine on this small (...) system with 4.1
> > and 4.2-rc1 breaks, or 4.2-rc1 is the 1st time you're trying that
> > config?
> 
> I'll let Alex comment on that, he did some testing on that.

I started seeing this on a 4.1-rc8 kernel, so it's been around for a
little while.  It may have been around before 4.1-rc8, but I haven't run
any kernels older than that on the big machine for some time.

- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
