From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: RE:[PATCH 05/14] IB/srp: Maintain a single connection per I_T nexus
Date: Wed, 12 Jun 2013 16:29:27 +0200
Message-ID: <51B885C7.1020701@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> An SRP target is required to maintain a single connection between
> initiator and target. This means that if the 'add_target' attribute
> is used to create a second connection to a target that the first
> connection will be logged out and that the SCSI error handler will
> kick in. The SCSI error handler will cause the SRP initiator to
> reconnect, which will cause I/O over the second connection to fail.
> Avoid such ping-pong behavior by disabling relogins. Note: if
> reconnecting manually is necessary, that is possible by deleting
> and recreating an rport via sysfs.
> 
> Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
> Cc: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> Cc: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
> Cc: Vu Pham <vu-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Cc: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>

Thanks Bart for refreshing this new patch set. I think you should add
Signed-off-by for Sebastian ?

Best regards,
Jack
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
