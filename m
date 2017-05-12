From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core in Dabian
Date: Fri, 12 May 2017 13:51:04 -0600
Message-ID: <20170512195104.GA21227@obsidianresearch.com>
References: <20170507064349.GM22833@mtr-leonro.local>
 <1494351789.3752.5.camel@profitbricks.com>
 <1494352472.2518.10.camel@sandisk.com>
 <20170509181807.GB9715@obsidianresearch.com>
 <1494613473.14477.12.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494613473.14477.12.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "noas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <noas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, May 12, 2017 at 06:24:35PM +0000, Bart Van Assche wrote:

> When using systemd templates instead of the current approach it would
> become cumbersome for users to stop and start the srp_daemon on all ports
> simultaneously.

I think systemd PartOf dependencies is intended to solve that
problem..

       PartOf=

           Configures dependencies similar to Requires=, but limited
           to stopping and restarting of units. When systemd stops or restarts
           the units listed here, the action is propagated to this
           unit. Note that this is a one-way dependency -- changes to this unit
           do not affect the listed units.

So there could still be a service name that covered all of the
children (eg srp_daemon.service and srp_daemon_port@.service)

> Additionally, if an RDMA adapter is hot-added, should the srp_daemon
> be started or should it not be started for the newly added ports?

I'm not sure what is best for that policy..

Today it looks like srp_daemon defaults to explicitly opt-in to
running on ports. To continue that policy the admin would have to
explicitly opt in to each port. Eg perhaps something like:

 systemctl enable srp_daemon@mlx4_0/0

Instead of editing a /etc/ config file.

systemd has a '.device' system, which as I understand it, would allow
srp_daemon@mlx4_0/0 to depend on mlx4_0/0.device, which is created by
udev on hotplug, and would trigger running the service. 

(perhaps for this reason the template value would be umad0, not mlx4_0/0)

> An in-between program could indeed do the job of listening for udev events
> and actively managing srp_daemon children. Since we already have an
> in-between program, namely srp_daemon.sh, the simplest approach is to modify
> that shell script. Can you have a look at the attached patch?

This seems like a reasonable improvement, but as I said, the inbetween
program is a bit more complex that you probably want to do with a
script:

- Sites do not like things running on timers due to the introduced
  jitter, so the trivial sleep loop is not nice.
- Failure of a child should result in a sensible log message and a
  restart protocol like systemd has. Failure to SIGTERM the child should
  escalate to SIGKILL to prevent lockups during shutdown
- Dumping stderr/etc into /dev/null is a bad idea (eg glibc internal
  asserts are lost now). In a systemd world each child should get its
  own stderrr logger connection so this stuff works right.
- We still need to be able to configure which ports srp_daemon runs
  on and to 'reload' that configuration into the script
- Ideally hot removal of an adaptor requires halting just those
  daemons without triggering restart

Since so much of that overlaps with systemd capabilities it does make
some sense to have systemd manage the child processes directly.

For instance you could have the srp_daemon script like in the patch
but replace this:

  ${prog} -e -c -n [..]
with
  systemctl start srp_daemon_port@${hca_id}/${port}

Using PartOf dependencies.. The user experience would be very similar
to the script directly forking, but many more of the above areas are
covered off..

But.. in that case we don't even need the script. If the admin wishes
to run srp_daemon on all IB ports then a simple udev rule will do the
job:

SUBSYSTEM=="infiniband", TAG+="systemd", ATTRS{node_desc}=="*", ENV{SYSTEMD_WANTS}+="srp_daemon_port@$name.service"

[more or less]

And now the timer is gone too.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
