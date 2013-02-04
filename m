From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: [LSF/MM TOPIC] Reducing the SRP initiator failover time
Date: Mon, 04 Feb 2013 13:13:10 +0100
Message-ID: <510FA5D6.2050706@profitbricks.com>
References: <510BC68A.90708@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <510BC68A.90708-HInyCGIudOg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

thanks for approaching this! We're not the best mainline developers so I
guess we won't be there. But we have the big SRP setups and our
sysadmins really don't like reconnecting SRP hosts manually and putting
their devices complicated to the related dm-multipath devices again.

Think about > 200 SRP devices per server (already filtered by initiator
groups). We also consider the srptools as unmaintained, unreliable and
slow. It is possible that the srptools commands don't return. Therefore,
we send the SRP connection strings directly to the initiator within our
mapping jobs.

It would also be great not to develop a DDoS attack reconnect like
open-iscsi does. Rebooting the whole cluster to fix this isn't fun.
There must be a possibility to configure different reconnect intervals.

Btw.: We even had the case that the IPoIB stuff reconnected but the RDMA
part didn't with iSER. It was so broken then, that we couldn't
disconnect or reconnect anymore - only chance hard reboot.

So you know our point of view and we already develop it that way for us.
I'm looking forward what's the output of the discussion. At the current
state it's difficult to nag our bosses to publish what we have so far.

On 01.02.2013 14:43, Bart Van Assche wrote:
> It is known that it takes about two to three minutes before the upstream
> SRP initiator fails over from a failed path to a working path. This is
> not only considered longer than acceptable but is also longer than other
> Linux SCSI initiators (e.g. iSCSI and FC). Progress so far with
> improving the fail-over SRP initiator has been slow. This is because the
> discussion about candidate patches occurred at two different levels: not
> only the patches itself were discussed but also the approach that should
> be followed. That last aspect is easier to discuss in a meeting than
> over a mailing list. Hence the proposal to discuss SRP initiator
> failover behavior during the LSF/MM summit. The topics that need further
> discussion are:
> * If a path fails, remove the entire SCSI host or preserve the SCSI
>   host and only remove the SCSI devices associated with that host ?

Preserve SCSI hosts and SCSI devices unless they are removed explicitly
by disconnect request. Rescanning SCSI devices with "- - -" like
"iscsiadm -R" does for example may reorder the device names (sda becomes
sdb, etc.).

> * Which software component should test the state of a path and should
>   reconnect to an SRP target if a path is restored ? Should that be
>   done by the user space process srp_daemon or by the SRP initiator
>   kernel module ?

By the SRP kernel module. This is exactly the big advantage of SRP so
far: It is simple, it is RDMA and kernel only.

> * How should the SRP initiator behave after a path failure has been
>   detected ? Should the behavior be similar to the FC initiator with
>   its fast_io_fail_tmo and dev_loss_tmo parameters ?

Fine for us as long as it is possible to configure such times and the
behavior at all. For dm-multipath we need fast IO failing and that the
SRP initiator tries to automatically reconnect that path.

Cheers,
Sebastian
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
