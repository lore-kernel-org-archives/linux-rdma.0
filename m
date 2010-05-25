From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] ibnetdisc: Separate calls to umad and mad layer to
 avoid race condition on response MAD's
Date: Tue, 25 May 2010 10:45:35 -0700
Message-ID: <20100525104535.412009b1.weiny2@llnl.gov>
References: <20100511164812.e16e41e6.weiny2@llnl.gov>
	<20100522144010.GR28549@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100522144010.GR28549@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, 22 May 2010 07:40:10 -0700
Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> On 16:48 Tue 11 May     , Ira Weiny wrote:
> >
> > From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > Date: Tue, 11 May 2010 15:36:08 -0700
> > Subject: [PATCH] ibnetdisc: Separate calls to umad and mad layer to avoid race condition on response MAD's
> >
> >       Specify CA/Port to use which allows parallel scanning to other operations.
> >
> > Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> 
> Applied. Thanks.
> 
> However see a minor comment below.
> 
> > ---
> >  .../libibnetdisc/include/infiniband/ibnetdisc.h    |   15 ++--
> >  infiniband-diags/libibnetdisc/src/ibnetdisc.c      |   52 +++++++-----
> >  infiniband-diags/libibnetdisc/src/internal.h       |   11 ++-
> >  infiniband-diags/libibnetdisc/src/query_smp.c      |   83 ++++++++++++++++----
> >  infiniband-diags/libibnetdisc/test/testleaks.c     |   16 +---
> >  infiniband-diags/src/iblinkinfo.c                  |    8 +-
> >  infiniband-diags/src/ibnetdiscover.c               |   14 +---
> >  infiniband-diags/src/ibqueryerrors.c               |   11 ++-
> >  8 files changed, 134 insertions(+), 76 deletions(-)
> 
> [snip]
> 
> > diff --git a/infiniband-diags/libibnetdisc/src/internal.h b/infiniband-diags/libibnetdisc/src/internal.h
> > index 2cfde02..d037a60 100644
> > --- a/infiniband-diags/libibnetdisc/src/internal.h
> > +++ b/infiniband-diags/libibnetdisc/src/internal.h
> > @@ -54,6 +54,8 @@
> >  #define MAXHOPS         63
> >
> >  #define DEFAULT_MAX_SMP_ON_WIRE 2
> > +#define DEFAULT_TIMEOUT 1000
> > +#define DEFAULT_RETRIES 3
> >
> >  typedef struct ibnd_scan {
> >       ib_portid_t selfportid;
> > @@ -76,16 +78,19 @@ struct ibnd_smp {
> >
> >  struct smp_engine {
> >       struct ibmad_port *ibmad_port;
> 
> After this patch ibmad_port is not used by smp_engine, but instead by an
> "upper" layer (ibnetdisc). So I would suggest to move this there (for
> example to be a member of scan struct).

Agreed.  I was trying to minimize the changes by this patch because it was
mainly a bug fix.

Ira

> 
> Sasha
> 

[snip]

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
