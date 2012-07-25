From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: Kernel panic under 3.2.14 Xen dom0 and SCST trunk
Date: Tue, 24 Jul 2012 19:30:15 -0700
Message-ID: <CAL1RGDU8-2a8be7gsbvBu+sBR8PuYLqRy_1hA+cjysNdbJdTYQ@mail.gmail.com>
References: <CAOzFzEjjbofQZyubdpH10WKeoE3-grMVdEOqJhJtbRtMdgCr=Q@mail.gmail.com>
 <500EE108.2090605@acm.org> <CAOzFzEiiiEsUqLjRM-TFsVZhQyvQi=abX0ufS6obvuZxtWgB-Q@mail.gmail.com>
 <500EFEB3.5020806@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <500EFEB3.5020806-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, Jul 24, 2012 at 12:59 PM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> You might be hitting a device removal bug in the SCSI core. It would be
> appreciated if you could retest with the srp-ha branch of this kernel
> tree: http://github.com/bvanassche/linux. That tree contains Linux
> kernel 3.5 + SCSI 3.6-rc1 + latest (yet to be posted) srp-ha patch series.

The original crash is in a process name srpt_mlx4_0-2, so it seems more
likely to be an SCST bug.  In fact the crash doesn't even show ib_srp
loaded at all.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
