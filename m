From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH V2 2/5] infiniband-diags: Allow specification of an mkey
 to use on the command line
Date: Tue, 24 Apr 2012 10:21:03 -0700
Message-ID: <20120424102103.ea5c7ca9.weiny2@llnl.gov>
References: <1335228837.17237.302.camel@auk75.llnl.gov>
	<1335229017-10677-1-git-send-email-foraker1@llnl.gov>
	<1335229017-10677-2-git-send-email-foraker1@llnl.gov>
	<4F96B5F1.7080906@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F96B5F1.7080906-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Tue, 24 Apr 2012 10:17:21 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 4/23/2012 8:56 PM, Jim Foraker wrote:
> > Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
> > ---
> >  include/ibdiag_common.h                     |    1 +
> >  libibnetdisc/include/infiniband/ibnetdisc.h |    3 ++-
> >  libibnetdisc/src/ibnetdisc.c                |    1 +
> >  man/ibaddr.8                                |    2 ++
> >  src/ibaddr.c                                |    2 ++
> >  src/ibccconfig.c                            |    2 ++
> >  src/ibccquery.c                             |    2 ++
> >  src/ibdiag_common.c                         |   13 +++++++++++++
> >  src/iblinkinfo.c                            |    3 +++
> >  src/ibportstate.c                           |    2 ++
> >  src/ibqueryerrors.c                         |    3 +++
> >  src/ibroute.c                               |    2 ++
> >  src/ibsendtrap.c                            |    2 ++
> >  src/ibtracert.c                             |    2 ++
> >  src/perfquery.c                             |    2 ++
> >  src/sminfo.c                                |    2 ++
> >  src/smpquery.c                              |    2 ++
> >  17 files changed, 45 insertions(+), 1 deletion(-)
> 
> Why is only the ibaddr man page changed ? What about the man pages for
> all the other diags included here ? Shouldn't they be changed similarly
> ? Or maybe there should be an ibdiag_common man page and all the man
> pages should reference that ?

Before the next release it is on my list to refactor all the man pages and make sure they are up to date.

That said yes we should update the commands which support mkey for now.

Ira

> 
> -- Hal
> 
> <snip...>


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
