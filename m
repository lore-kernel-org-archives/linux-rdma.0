From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: Kernel panic under 3.2.14 Xen dom0 and SCST trunk
Date: Fri, 3 Aug 2012 01:45:15 +1000
Message-ID: <CAOzFzEgwkr5wvhVWeCS7FmTYhFeL3QaUtR=eZ1WKHKJga1c6NA@mail.gmail.com>
References: <CAOzFzEjjbofQZyubdpH10WKeoE3-grMVdEOqJhJtbRtMdgCr=Q@mail.gmail.com>
	<CAOzFzEjDHpTROUcKg9cOZkNSX1LnShSombgt26+VOptVdy5i-Q@mail.gmail.com>
	<501A5EB0.4060904@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <501A5EB0.4060904-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On 2 August 2012 21:04, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> On 07/24/12 15:43, Joseph Glanville wrote:
>> [35404.804723] BUG: unable to handle kernel NULL pointer dereference at (null)
>
> I've been able to reproduce this ib_srp crash. Apparently if an SRP
> response is received after srp_reset_host() has been invoked
> srp_process_rsp() tries to call scmnd->scsi_done(scmnd) with scsi_done
> == NULL, hence the kernel oops. A candidate fix is available in this
> (rebased) tree: http://github.com/bvanassche/linux/tree/srp-ha.
>
> Bart.
>

Nice work. :)

Sorry I haven't had time to do more testing, I will try get this
branch deployed on something tomorrow.

Joseph.

-- 
CTO | Orion Virtualisation Solutions | www.orionvm.com.au
Phone: 1300 56 99 52 | Mobile: 0428 754 846
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
