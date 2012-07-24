From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: Kernel panic under 3.2.14 Xen dom0 and SCST trunk
Date: Tue, 24 Jul 2012 17:53:12 +0000
Message-ID: <500EE108.2090605@acm.org>
References: <CAOzFzEjjbofQZyubdpH10WKeoE3-grMVdEOqJhJtbRtMdgCr=Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAOzFzEjjbofQZyubdpH10WKeoE3-grMVdEOqJhJtbRtMdgCr=Q@mail.gmail.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 07/24/12 15:16, Joseph Glanville wrote:
> I have been seeing this KP occur about every 3 days on our staging cluster.
> I am not exactly sure what the root cause would be.. I assume this
> would be a bug in SCST.
> The kernel is a 3.2.14 with Ubuntu patch series applied and Bart's SRP
> HA patches.

It would help if you could tell us a bit more about your setup. It looks
like SCST is running in dom0, and an IB workload in domU ? If so, which
workload was running in domU ?

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
