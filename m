From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: rdma-core in Dabian
Date: Tue, 9 May 2017 12:18:07 -0600
Message-ID: <20170509181807.GB9715@obsidianresearch.com>
References: <20170507064349.GM22833@mtr-leonro.local>
 <1494351789.3752.5.camel@profitbricks.com>
 <1494352472.2518.10.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1494352472.2518.10.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: "benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org" <benjamin.drung-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, "leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "noas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <noas-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <talatb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 09, 2017 at 05:54:33PM +0000, Bart Van Assche wrote:
> > * Bonus points: consolidate the srp daemon. Debian ships a different
> > service file than upstream, but I am against an additional layer
> > introduced by srp_daemon.sh. It would also be nice to have a systemd
> > service shipped by upstream (and not just in the redhat directory)
> 
> I will have a look at this too.

My thoughts..

It looked to me like srp_daemon needed one process per port.

The best path looked to me like using systemd templates (eg
srp_daemon@mlx4_0/0) to allow systemd to directly manage the per port
srp_daemon.

Then the question is how to request the right templates are
created.. Perhaps udev rules can do this directly, but I'm not sure
about how to get the port #, perhaps an udev triggered script or
something can do it.

Perhaps there could be an inbetween progarm that took the udev events
and asked systemd to make the right units.

Another option is to have a srp_daemon 'runner' that monitors udev and
actively manages a set of fork'd childern so that the children cover
all required ports. But this is actually somewhat hard to do well..

The big issue with the redhat script is that it is not hotplug safe,
and needs special boot ordering, which we really need to get away from
in general for robustness.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
