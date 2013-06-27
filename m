From: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Subject: Re: [PATCH 05/14] IB/srp: Maintain a single connection per I_T nexus
Date: Thu, 27 Jun 2013 17:10:32 -0400
Message-ID: <1372367432.32164.36.camel@frustration.ornl.gov>
References: <51B87501.4070005@acm.org> <51B876BF.4070400@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <51B876BF.4070400-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2013-06-12 at 15:25 +0200, Bart Van Assche wrote:
> An SRP target is required to maintain a single connection between
> initiator and target. This means that if the 'add_target' attribute
> is used to create a second connection to a target that the first
> connection will be logged out and that the SCSI error handler will
> kick in. The SCSI error handler will cause the SRP initiator to
> reconnect, which will cause I/O over the second connection to fail.
> Avoid such ping-pong behavior by disabling relogins. Note: if
> reconnecting manually is necessary, that is possible by deleting
> and recreating an rport via sysfs.

Will wait for the second version of this as well.

Was an agreement reached on the pkey issue?
I also would rather we mimic the current messages rather than
regurgitate the user's login string back at them.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
