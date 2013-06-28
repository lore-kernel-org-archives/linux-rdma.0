From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 13/14] IB/srp: Make transport layer retry count
 configurable
Date: Fri, 28 Jun 2013 08:07:07 -0400
Message-ID: <1372421227.28740.17.camel@haswell.thedillows.org>
References: <51B87501.4070005@acm.org> <51B8794F.6050003@acm.org>
	 <1372368138.32164.40.camel@frustration.ornl.gov> <51CD4933.5080709@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51CD4933.5080709-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2013-06-28 at 10:28 +0200, Bart Van Assche wrote:
> On 06/27/13 23:22, David Dillow wrote:
> > On Wed, 2013-06-12 at 15:36 +0200, Bart Van Assche wrote:
> >> From: Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> >>
> >> Allow the InfiniBand RC retry count to be configured by the user
> >> as an option in the target login string. The transport layer
> >> timeout in nanoseconds is computed as follows from the retry count:
> >>
> >> rc_timeout = rc_retry_count * 4 * 4096 * (1 << qp->timeout)
> >>
> >> The default value for tl_retry_count is changed from 7 into 2.
> >
> > I'm not sure you should change the default, but I've not thought about
> > it much.
> >
> > It should probably also have a default set via module parameter similar
> > to the indirect_command_descriptors, etc. Unless srp_daemon is patched,
> > this won't be usable without that. I'm not tied to this position, though
> > -- we should be moving in the direction of more control via the login
> > string.
> 
> Hello Dave,
> 
> Are you perhaps aware of any IB networks where it is necessary to set 
> the RC retry count above 2 ? 

I'm not aware of all IB networks in the world. The default has been 7
since the beginning of time, and I'm reluctant to change it without good
reasons, especially when it is now configurable and a user can drop it
as needed.

> Anyway, I can prepare an srp_daemon patch 
> that makes it easy to configure this parameter if you want.

That's a separate issue, but we've been accumulating options so it needs
to be done eventually, by someone. I won't hold up a patch for it,
though.

This does need to be documented in
Documentation/ABI/stable/sysfs-driver-ib_srp, though.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
