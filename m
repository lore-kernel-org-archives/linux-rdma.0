From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/3] read_config: skip file/directory with unsecure
 permissions
Date: Mon, 12 Aug 2013 13:05:45 -0600
Message-ID: <20130812190545.GA7968@obsidianresearch.com>
References: <cover.1369085762.git.ydroneaud@opteya.com>
 <0a6888edc9d7899fe3b4af249c4f25088e196422.1369085762.git.ydroneaud@opteya.com>
 <20130521205713.GB11318@obsidianresearch.com>
 <1375989856.27609.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1375989856.27609.10.camel-bi+AKbBUZKY6gyzm1THtWbp2dZbC/Bob@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Aug 08, 2013 at 09:24:16PM +0200, Yann Droneaud wrote:
> Hi,
> 
> Le mardi 21 mai 2013 ?? 14:57 -0600, Jason Gunthorpe a ??crit :
> > On Mon, May 20, 2013 at 11:43:05PM +0200, Yann Droneaud wrote:
> > > libibverbs must refuse to load arbitrary shared objects.
> > > 
> > > This patch check the configuration directory and files for
> > > - being owned by root;
> > > - not being writable by others.
> > 
> > I really don't like this. Is there some exploit against /etc/ now that
> > requires this sort of checking?
> > 
> 
> Loading shared object as part of a setuid binary should be handled
> with extra care.  Adding checks to the configuration loader is
> required so that only trusted shared object get loaded.

Well, still, I'm not sure this is required. IBV_CONFIG_DIR is
hardwired and not overriable (via environment, etc), so it is a simple
installation error to have the wrong permissions for your environment
on these files.

But lots of files need to have the correct permissions for setuid to
be secure (the binary, the library itself, the libraries it dlopens,
the directories that contain all of these things, etc) - not sure it
makes any sense at all to single out the config files for special
checking.

In any event, if these checks really are necessary they should be only
done if running in a setuid context, and they almost certainly need to
extend to the dlopen paths as well..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
