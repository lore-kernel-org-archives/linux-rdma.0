From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/5] srp_daemon.service: Add support for
 hot-plugging
Date: Mon, 15 May 2017 17:25:51 -0600
Message-ID: <20170515232551.GA10834@obsidianresearch.com>
References: <20170515224733.29586-1-bart.vanassche@sandisk.com>
 <20170515224733.29586-12-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170515224733.29586-12-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, May 15, 2017 at 03:47:33PM -0700, Bart Van Assche wrote:
> srp_daemon.service is modified such that instead of starting
> /usr/sbin/srp_daemon.sh that it does not start any process. A new
> template service is added, namely srp_daemon_port@.service. This
> service replaces srp_daemon.sh and controls /usr/sbin/srp_daemon
> for a single port. A udev rule is added that instantiates the
> srp_daemon_port@.service every time an RDMA port is hot-added.
> Since the per-port service depends on the srp_daemon service,
> starting or stopping the srp_daemon service affects all per-port
> services.

This looks pretty good to me ... You are happy with how the user experience works?

A few minor thoughts

> +++ b/srp_daemon/90-srp-daemon.rules
> @@ -0,0 +1 @@
> +ACTION=="add", SUBSYSTEM=="infiniband_mad", PROGRAM:="/usr/bin/systemctl show srp_daemon -p UnitFileState", RESULT=="UnitFileState=enabled", TAG+="systemd", ENV{SYSTEMD_WANTS}+="srp_daemon_port@$attr{ibdev}:$attr{port}.service"

I think we should have a main rdma udev rules file that always creates
.device targets inside systemd for umad, unconditionally. This should
be useful for other things like opensm/etc.

So we'd have a line like:

ACTION=="add", SUBSYSTEM=="infiniband_mad", TAG+="systemd", ENV{SYSTEMD_ALIAS}="/dev/infiniband/umad/$attr{ibdev}:$attr{port}"

So we get (unescaped)

/dev/infiniband/umad0.device
/dev/infiniband/umad/mlx4_0:0.device

Then the srp-daemon.rule would just be the wants:

ACTION=="add", SUBSYSTEM=="infiniband_mad", PROGRAM:="/usr/bin/systemctl show srp_daemon -p UnitFileState", RESULT=="UnitFileState=enabled", ENV{SYSTEMD_WANTS}+="srp_daemon_port@$attr{ibdev}:$attr{port}.service"

> index 00000000..666400ab
> +++ b/srp_daemon/srp_daemon_port@.service
> @@ -0,0 +1,18 @@
> +[Unit]
> +Description=SRP daemon that monitors port %i
> +Documentation=man:srp_daemon file:/etc/rdma/rdma.conf file:/etc/srp_daemon.conf
> +DefaultDependencies=false
> +Conflicts=emergency.target emergency.service
> +Requires=rdma.service
> +Wants=opensm.service
> +After=rdma.service opensm.service srp_daemon.service
> +After=network.target
> +Before=remote-fs-pre.target
> +BindsTo=srp_daemon.service

Using the new .device, we can add a requires:

Requires: -dev-infiniband-umad0-%i.device

Now, systemd will never start the port service until udev says that
the umad is available for that port. It will actually wait until udev
says that umad is present if something requires it.

This would allow the admin to setup various things to guarentee
ordering, most directly, adding a
    Requires: srp_daemon_port@mlx4_0:1
To a .mount unit will make everything very reliable. (Suggest adding
notes about this to a man page)

I also wonder if the systemd activation protocol should be used by
srp_daemon, this should defer mount until srp_daemon has done the
right stuff, but that might be no good if the 'right stuff' requires a
link up?

However, if the admin is using the above .mount unit Requires then
they would want to wait until the link is up and the SM has been
contacted before attempting the first mount? systemd obnoxiously does
not have mount retries so everything should be perfect before mount is
done.

Probably something about this should be in the man page?

[You could also consider using umad0 as the %I, which would avoid the
alias, unclear to me if that good/bad for an admin.]

With the other changes you did, this means we can drop this:

> +After=rdma.service opensm.service srp_daemon.service

rdma.service would now be obsolete because the Requires on the .device
guarentees this will not start until something has loaded the modules.

Also, when you fixed the port state issue, I think that solved the need for
opensm.service.

Thus, the after should be:

After=srp_daemon.service

Which is good because rdma.service or opensm.service should not appear
outside the redhat/ directory.

> +The srp_daemon_port@\&.service controls whether or not an srp_daemon process
> +is monitoring the RDMA port specified as template argument. The format for the
> +RDMA port name is \fIdev:port\fR where \fIdev\fR is the name of an RDMA device
> +and \fIport\fR is an port number starting from one. Starting an instance of
> +this template will start an srp_daemon process. Stopping an instance of this
> +template will stop the srp_daemon process for the specified port.  Here is an
> +example of how to obtain a list of all RDMA device and port number
> pairs:

Does
  sysemctl mask srp_daemon_port@mlx4_0:1

Work to inhibit the daemon on a specific port? If yes that should be
mentioned in here I think. Otherwise, we probably still need a way to
do that.

The final bits would be to see if any security sandboxing options are
appropriate for the .unit file, since srp_daemon is network
facing. Drop caps, ro filesystems, etc. It should also dump root

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
