From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core in Dabian
Date: Tue, 9 May 2017 12:05:17 -0600
Message-ID: <20170509180517.GA9715@obsidianresearch.com>
References: <20170507064349.GM22833@mtr-leonro.local>
 <1494351789.3752.5.camel@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494351789.3752.5.camel-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Benjamin Drung <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Talat Batheesh <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Noa Spanier <noas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 09, 2017 at 07:43:09PM +0200, Benjamin Drung wrote:

> * Can we upstream some redhat files, i.e. move them out of the redhat
> directory and maintain them in their corresponding code? Following
> files fall in this category:

Anything in the redhat directory could be moved out if it is going to
be used by another distro. It is there waiting for other distros to
look at it.

> * Can we provide an upstream rdma-core "package" that contains the rdma
> service and the following files from the redhat directory?
> ** rdma.conf
> ** rdma.kernel-init
> ** rdma.service
> ** rdma.udev-rules

Do you mean adding a 'rdma-core' package to debian/?

We could move the relevant stuff out of redhat/ and into, say,
kernel-boot/ or something.

IMHO there is no reason not to do that..

> Patches for improved descriptions are welcome.
> 
>   W: iwpmd: init.d-script-missing-start etc/init.d/iwpmd 2 4
> 
> Any objections to add 2 and 4?

Debian and RH6 are the only places I know of that use init.d scripts,
so I think most changes Debian needs would be fine.

>   W: ibverbs-providers: package-name-doesnt-match-sonames libmlx5-1
> 
> I think we should just ignore this warning since using libmlx5-1 is
> just one part of ibverbs-providers that shouldn't be use alone, should
> it?

Probably.. It is has become a bit odd with mlx5 being directly
linkable now..

>   W: ibverbs-providers: non-dev-pkg-with-shlib-symlink usr/lib/x86_64-
>      linux-gnu/libmlx5.so.1.1.14 usr/lib/x86_64-linux-gnu/libmlx5.so
> 
> This libmlx5.so symlink should be part of a development package. Should
> I add a new binary libmlx5-dev package or should it be moved to
> libibverbs-dev (where already the header files are)?

It should be with the headers, so I suggest libibverbs-dev

> * Bonus points: consolidate the srp daemon. Debian ships a different
> service file than upstream, but I am against an additional layer
> introduced by srp_daemon.sh. It would also be nice to have a systemd
> service shipped by upstream (and not just in the redhat directory)

The srp daemon needs proper native systemd support, not via a shell
script wrapper. More like rdma-ndd. This is probably a bigger
project..

I didn't think debian had a .service file for it at all?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
