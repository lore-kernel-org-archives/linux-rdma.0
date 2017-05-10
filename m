From: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: rdma-core in Dabian
Date: Wed, 10 May 2017 11:35:47 +0200
Message-ID: <1494408947.3739.2.camel@profitbricks.com>
References: <20170507064349.GM22833@mtr-leonro.local>
         <1494351789.3752.5.camel@profitbricks.com>
         <20170509180517.GA9715@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170509180517.GA9715-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Spanier <noas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Am Dienstag, den 09.05.2017, 12:05 -0600 schrieb Jason Gunthorpe:
> On Tue, May 09, 2017 at 07:43:09PM +0200, Benjamin Drung wrote:
> 
> > * Can we upstream some redhat files, i.e. move them out of the
> > redhat
> > directory and maintain them in their corresponding code? Following
> > files fall in this category:
> 
> Anything in the redhat directory could be moved out if it is going to
> be used by another distro. It is there waiting for other distros to
> look at it.

* The ifdown-ib and ifup-ib scripts are redhat-specific. It won't work
with ifupdown from Debian.

* The files related to mlx4 look like a special handling for mlx4 to me
and they do not following the KISS principle.

* What's the purpose of the cxgb{3,4} modprobe files?

* rdma.modules-setup.sh is not needed since Debian does not use dracut.

Everything else should be moved.

> > * Can we provide an upstream rdma-core "package" that contains the
> > rdma
> > service and the following files from the redhat directory?
> > ** rdma.conf
> > ** rdma.kernel-init
> > ** rdma.service
> > ** rdma.udev-rules
> 
> Do you mean adding a 'rdma-core' package to debian/?
> 
> We could move the relevant stuff out of redhat/ and into, say,
> kernel-boot/ or something.

I meant a directory ('kernel-boot' sounds good) where these files live
and a corresponding binary package where these files are installed
into.

Jarod already created a rdma-core package in debian/control in commit
8df5873b9. Currently we do not have a rdma-core package in Debian and
no package with a kernel-boot service file. I know that the openibd and
 mlnx-ofed-kernel-utils packages shipped a openibd service that does
similar job.

Do we want to call the binary package that contains the kernel-boot
service 'rdma-core' or simplify that to 'rdma'? We should use the same
binary package name across the distributions (unless it's conflicting
with a naming convention).

Can you come up with a patch set? I will be happy to review it. Note
that paths like /usr/libexec/rdma-init-kernel (in rdma.service) needs
to be made configurable. In Debian, we would install these helper
scripts in /usr/lib/$packagename/$filename.

> IMHO there is no reason not to do that..
> 
> > Patches for improved descriptions are welcome.
> > 
> >   W: iwpmd: init.d-script-missing-start etc/init.d/iwpmd 2 4
> > 
> > Any objections to add 2 and 4?
> 
> Debian and RH6 are the only places I know of that use init.d scripts,
> so I think most changes Debian needs would be fine.

Thanks. I will create a patch then.

> >   W: ibverbs-providers: package-name-doesnt-match-sonames libmlx5-1
> > 
> > I think we should just ignore this warning since using libmlx5-1 is
> > just one part of ibverbs-providers that shouldn't be use alone,
> > should
> > it?
> 
> Probably.. It is has become a bit odd with mlx5 being directly
> linkable now..
> 
> >   W: ibverbs-providers: non-dev-pkg-with-shlib-symlink
> > usr/lib/x86_64-
> >      linux-gnu/libmlx5.so.1.1.14 usr/lib/x86_64-linux-
> > gnu/libmlx5.so
> > 
> > This libmlx5.so symlink should be part of a development package.
> > Should
> > I add a new binary libmlx5-dev package or should it be moved to
> > libibverbs-dev (where already the header files are)?
> 
> It should be with the headers, so I suggest libibverbs-dev

Okay. I will put it there.

> > * Bonus points: consolidate the srp daemon. Debian ships a
> > different
> > service file than upstream, but I am against an additional layer
> > introduced by srp_daemon.sh. It would also be nice to have a
> > systemd
> > service shipped by upstream (and not just in the redhat directory)
> 
> The srp daemon needs proper native systemd support, not via a shell
> script wrapper. More like rdma-ndd. This is probably a bigger
> project..
> 
> I didn't think debian had a .service file for it at all?

Yes. I referred to the sysvinit script when I wrote "service file" (and
not to a .service systemd file). ;) It would be nice if Debian ships
both: a sysvinit script (legacy support and users that do not want to
use systemd) and a systemd .service file.

-- 
Benjamin Drung
System Developer
Debian & Ubuntu Developer

ProfitBricks GmbH
Greifswalder Str. 207
D - 10405 Berlin

Email: benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org
Web: https://www.profitbricks.com

Sitz der Gesellschaft: Berlin.
Registergericht: Amtsgericht Charlottenburg, HRB 125506B.
Geschäftsführer: Achim Weiss.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
