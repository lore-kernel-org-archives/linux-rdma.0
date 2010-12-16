From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: Re: Possible bug on SRP device delete
Date: Wed, 15 Dec 2010 21:55:16 -0500
Message-ID: <1292468116.7532.15.camel@obelisk.thedillows.org>
References: <4D064A81.6000607@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4D064A81.6000607-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: torn5 <torn5-9AbUPqfR1/2XDw4h08c5KA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, 2010-12-13 at 17:32 +0100, torn5 wrote:
> I have been suggested to the RDMA mailing list as it might be an ib_srp bug:
> 
> >>         5) If I echo one line of ibsrpdm -c to
> >>         /sys/class/infiniband_srp/srp-mthca0-1/add_target so to add a
> >>         srp disk
> >>         to my system, what happens is that another srp_host gets
> >>         created. If I
> >>         later remove the drive with "echo 1 >
> >>         /sys/block/sdX/device/delete", the
> >>         /sys/class/srp_hosts/srp_hostXY remains. Now after having
> >>         remapped and
> >>         deleted a few times the disk I am totally polluted of srp_host's.
> >>         Another serious problem is that srp_daemon (from srptools)
> >>         thinks the
> >>         disk is still connected because it sees the previous
> >>         srp_host, and won't
> >>         reconnect it (won't recreate the sdX device).
> >>         So what is the proper way to unmap a srp drive also deleting
> >>         the srp_host?

There currently no way to disconnect a SRP connection without removing
the module. It's an issue, and I've been talking with some people about
addressing it, though it hasn't been terribly high on the priority list.

As was mentioned, if you force a host reset, it will drop the
connection. Unfortunately, it will also try to reconnect, so this may
not be terribly useful.

While it may be possible to use slave_alloc()/slave_destroy() from the
scsi_host_template to keep a count of the number of active devices and
tear down the connection, I'm not sure this is a good behavior to have,
either. I think it may be a bit surprising, and it may also cause
srp_daemon to keep re-adding a target that does not present devices to
your host.


> > Notes:
> > - IMHO ib_srp should be modified such that it reports SCSI commands as 
> > failed as soon as an IB error completion has been received instead of 
> > waiting until these commands time out. That would make ib_srp recover 
> > much more quickly from cable reconnects or SRP target restarts.

This is another area that is being worked currently. I don't think it
will be ready for 2.6.38, but hopefully for 2.6.39.

> > - Please don't use sg_reset on ib_srp, or you will hit this: 
> > https://bugzilla.kernel.org/show_bug.cgi?id=13893.

I have a tested patch that fixes this, and will try to post it later
tonight or tomorrow.

Dave

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
