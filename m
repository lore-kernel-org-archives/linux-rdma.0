From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH] IB/srp: disconnect to SRP target before removing SCSI
 host
Date: Mon, 07 Jan 2013 13:17:56 -0500
Message-ID: <1357582676.14098.1.camel@frustration.ornl.gov>
References: <1357394162-26316-1-git-send-email-dongsu.park@profitbricks.com>
	 <50EAB2E1.7050702@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50EAB2E1.7050702-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2013-01-07 at 06:34 -0500, Bart Van Assche wrote:
> Sorry but this patch looks wrong to me, and that because of the 
> following reasons:
> - A root cause analysis is missing. It has been mentioned in the patch
>    description that device_del() did hang but an analysis of why that
>    hang occurred is missing.
> - An explanation of why the above patch prevents device_del() to hang is
>    missing.

Agreed, this needs more explanation -- at least in the email thread, and
boiled down in the commit message.

> - Invoking srp_disconnect_target() before scsi_remove_host() is wrong
>    because it prevents the SYNCHRONIZE CACHE command issued by
>    sd_shutdown() to reach the SRP target.

Exactly; we need to understand the hang so that we get a proper
shutdown.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
