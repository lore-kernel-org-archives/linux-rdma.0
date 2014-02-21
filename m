From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: [PATCH 3/6] IB/srp: Fail SCSI commands silently
Date: Thu, 20 Feb 2014 19:55:37 -0800
Message-ID: <1392954937.26557.3.camel@haswell.thedillows.org>
References: <5305DE01.7030004@acm.org> <5305DE67.9070805@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5305DE67.9070805-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2014-02-20 at 11:52 +0100, Bart Van Assche wrote:
> Do not log SCSI command failures that are the result of a transport
> layer failure, a SCSI abort or SCSI reset. This patch is a slightly
> modified version of a patch posted by Sebastian Riemer in March 2013
> (see also http://thread.gmane.org/gmane.linux.drivers.rdma/15020/).
> 
> This patch avoids that a system becomes unresponsive during failover
> of a large number of LUNs when kernel messages are logged to a serial
> console.

While I can see the utility for slow consoles, this should probably be
done in the SCSI lib, with a separate flag for indicating it is a
failure due to transport issues. That would allow the functionality to
be used by multiple drivers and verbosity configured in one place,
rather than patched in driver-by-driver.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
