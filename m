From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH V3 4/8] infiniband-diags: Allow specification of an
	mkey to use on the command line
Date: Thu, 31 May 2012 12:08:17 -0700
Message-ID: <1338491297.19133.30.camel@auk75.llnl.gov>
References: <1338398414.11948.29.camel@auk75.llnl.gov>
	 <1338398497-12444-1-git-send-email-foraker1@llnl.gov>
	 <1338398497-12444-4-git-send-email-foraker1@llnl.gov>
	 <4FC75A97.7080106@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC75A97.7080106-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Thu, 2012-05-31 at 04:48 -0700, Hal Rosenstock wrote:
> On 5/30/2012 1:21 PM, Jim Foraker wrote:
> > Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
> > ---
> >  doc/rst/common/opt_m.rst                    |    6 ++++++
> >  doc/rst/ibaddr.8.in.rst                     |    1 +
> >  doc/rst/ibccconfig.8.in.rst                 |    1 +
> >  doc/rst/ibccquery.8.in.rst                  |    1 +
> >  doc/rst/iblinkinfo.8.in.rst                 |    1 +
> >  doc/rst/ibnetdiscover.8.in.rst              |    1 +
> >  doc/rst/ibportstate.8.in.rst                |    1 +
> >  doc/rst/ibqueryerrors.8.in.rst              |    1 +
> >  doc/rst/ibroute.8.in.rst                    |    1 +
> >  doc/rst/ibtracert.8.in.rst                  |    6 ++++++
> >  doc/rst/perfquery.8.in.rst                  |    1 +
> >  doc/rst/sminfo.8.in.rst                     |    1 +
> >  doc/rst/smpquery.8.in.rst                   |    1 +
> >  include/ibdiag_common.h                     |    1 +
> >  libibnetdisc/include/infiniband/ibnetdisc.h |    3 ++-
> >  libibnetdisc/src/ibnetdisc.c                |    1 +
> >  src/ibaddr.c                                |    2 ++
> >  src/ibcacheedit.c                           |    2 +-
> >  src/ibccconfig.c                            |    2 ++
> >  src/ibccquery.c                             |    2 ++
> >  src/ibdiag_common.c                         |   13 +++++++++++++
> >  src/iblinkinfo.c                            |    3 +++
> >  src/ibnetdiscover.c                         |    2 +-
> >  src/ibping.c                                |    2 +-
> >  src/ibportstate.c                           |    2 ++
> >  src/ibqueryerrors.c                         |    3 +++
> >  src/ibroute.c                               |    2 ++
> >  src/ibsendtrap.c                            |    2 ++
> >  src/ibstat.c                                |    2 +-
> >  src/ibsysstat.c                             |    2 +-
> >  src/ibtracert.c                             |    4 +++-
> >  src/perfquery.c                             |    2 ++
> >  src/saquery.c                               |    2 +-
> >  src/sminfo.c                                |    2 ++
> >  src/smpquery.c                              |    2 ++
> >  src/vendstat.c                              |    2 +-
> >  36 files changed, 74 insertions(+), 9 deletions(-)
> >  create mode 100644 doc/rst/common/opt_m.rst
> 
> Do all these tools require mkeys ? AFAIK ibping, ibstat, ibsysstat,
> perfquery, and vendstat don't.
     As Ira alluded to, for many of the tools, the only change in this
patch is to exclude the mkey flag from their options processing.
     That said, I'm about to post a new version of this patch with two
changes.  The small one is a fix to mkey handling in libibnetdiscover.
The big one is a change from using '-m' for the mkey short flag to '-y'.
It was pointed out that ibnetdiscover has a conflict with -m (display
max hops).  ibnetdiscover being a popular tool, we didn't want to
require users to use the long form '--m_key', so we decided to change
the short flag to one that had no conflicts -- unfortunately, no more
obvious letters were available, so '-y' it is.

     Jim
> 
> Also, for ibccquery/config why is mkey needed ? What about cckey ?
> 
> -- Hal

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
