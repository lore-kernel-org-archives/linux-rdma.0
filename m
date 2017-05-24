From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH rdma-core 5/5] srp_daemon.service: Add support for
 hot-plugging
Date: Wed, 24 May 2017 15:12:33 -0600
Message-ID: <20170524211233.GB30878@obsidianresearch.com>
References: <20170515224733.29586-1-bart.vanassche@sandisk.com>
 <20170515224733.29586-12-bart.vanassche@sandisk.com>
 <20170515232551.GA10834@obsidianresearch.com>
 <1495658010.2823.36.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1495658010.2823.36.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, May 24, 2017 at 08:33:32PM +0000, Bart Van Assche wrote:
> On Mon, 2017-05-15 at 17:25 -0600, Jason Gunthorpe wrote:
> > On Mon, May 15, 2017 at 03:47:33PM -0700, Bart Van Assche wrote:
> > > srp_daemon.service is modified such that instead of starting
> > > /usr/sbin/srp_daemon.sh that it does not start any process. A new
> > > template service is added, namely srp_daemon_port@.service. This
> > > service replaces srp_daemon.sh and controls /usr/sbin/srp_daemon
> > > for a single port. A udev rule is added that instantiates the
> > > srp_daemon_port@.service every time an RDMA port is hot-added.
> > > Since the per-port service depends on the srp_daemon service,
> > > starting or stopping the srp_daemon service affects all per-port
> > > services.
> > 
> > This looks pretty good to me ... You are happy with how the user experience works?
> 
> Yes, except for one aspect, namely that starting srp_daemon does not
> start the per-port services. I have addressed that as follows in
> srp_daemon.service:

Interesting.. What use case do have in mind for start on all ports?

>    nohup /usr/bin/systemctl start "srp_daemon_port@${p/\/ports\//:}" </dev/null >&/dev/null &

I wonder, does this defeat the 'systemctl mask srp_daemon_port@mlx4_0:1' ?

Anyhow, I think it looks pretty good, the 'BindsTo' is a nice touch to
support hot-removal as well.

> > However, if the admin is using the above .mount unit Requires then
> > they would want to wait until the link is up and the SM has been
> > contacted before attempting the first mount? systemd obnoxiously does
> > not have mount retries so everything should be perfect before mount is
> > done.
> 
> I think that systemd mount units should have a dependency on
> /dev/disk/by-id or /dev/disk/by-uuid instead of srp_daemon. Even
> after an srp_daemon_port@ service has been started it can take some
> time before login occurs. Using a dependency on /dev/disk/by-*id
> avoids that the mount service gets started before the path it needs
> is available.

That makes some sense.

> > The final bits would be to see if any security sandboxing options are
> > appropriate for the .unit file, since srp_daemon is network
> > facing. Drop caps, ro filesystems, etc. It should also dump root.
> 
> Sorry but since srp_daemon writes into /sys/class/infiniband_srp/*/add_target
> I don't think it's possible to drop root privileges for the srp_daemon_port@
> service.

Dropping root is something that has to be done inside the daemon.. eg
it would open the required files as root and never close them, then
drop root. So eg it would lseek,write to add_target instead of
open,write. Similar with /dev/umad.

The sandboxing options are different, these do not have to impact
DAC_OVERRIDE for root, but permanently limit other things the daemon
can do.

Eg for reference here is what timesyncd.service sets:

CapabilityBoundingSet=CAP_SYS_TIME CAP_SETUID CAP_SETGID CAP_SETPCAP CAP_CHOWN CAP_DAC_OVERRIDE CAP_FOWNER
PrivateTmp=yes
PrivateDevices=yes
ProtectSystem=full
ProtectHome=yes
ProtectControlGroups=yes
ProtectKernelTunables=yes
MemoryDenyWriteExecute=yes
RestrictRealtime=yes
RestrictAddressFamilies=AF_UNIX AF_INET AF_INET6
SystemCallFilter=~@cpu-emulation @debug @keyring @module @mount @obsolete @raw-io

Some subset of those ideas may ultimately apply to srp-daemon.

Anyhow, I think the series is basically fine by me..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
