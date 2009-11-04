From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags/ibqueryerrors: Fix realloc size to
 prevent core
Date: Tue, 3 Nov 2009 16:50:14 -0800
Message-ID: <20091103165014.0717a0e0.weiny2@llnl.gov>
References: <20091103132003.112e10b0.weiny2@llnl.gov>
	<1257284362.580.59.camel@auk31.llnl.gov>
	<20091103222218.GG29388@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091103222218.GG29388@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Al Chu <chu11-i2BcT+NCU+M@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 4 Nov 2009 00:22:18 +0200
Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org> wrote:

> On 13:39 Tue 03 Nov     , Al Chu wrote:
> > Need to check for NULL?  Manpage says its possible:
> > 
> > ---
> > realloc()  returns  a  pointer to the newly allocated memory, which is
> > suitably aligned for any kind of variable and may be different from ptr,
> > or NULL if the request fails.
> > ---
> > 
> > Al
> > 
> > On Tue, 2009-11-03 at 13:20 -0800, Ira Weiny wrote:
> > > From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > > Date: Tue, 3 Nov 2009 13:19:33 -0800
> > > Subject: [PATCH] infiniband-diags/ibqueryerrors: Fix realloc size to prevent core
> > > 
> > > 	Realloc size was wrong causing a core when enough errors were
> > > 	suppressed.  Reproduced by running:
> > > 
> > > 	ibqueryerrors -c -s RcvSwRelayErrors,LinkDowned,VL15Dropped,XmtWait,SymbolErrors,LinkRecovers,RcvErrors
> > > 
> > > Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > > ---
> > >  infiniband-diags/src/ibqueryerrors.c |    3 ++-
> > >  1 files changed, 2 insertions(+), 1 deletions(-)
> > > 
> > > diff --git a/infiniband-diags/src/ibqueryerrors.c b/infiniband-diags/src/ibqueryerrors.c
> > > index f83f29e..aac7087 100644
> > > --- a/infiniband-diags/src/ibqueryerrors.c
> > > +++ b/infiniband-diags/src/ibqueryerrors.c
> > > @@ -381,7 +381,8 @@ void print_node(ibnd_node_t * node, void *user_data)
> > >  
> > >  static void add_suppressed(enum MAD_FIELDS field)
> > >  {
> > > -	suppressed_fields = realloc(suppressed_fields, sizeof(enum MAD_FIELDS));
> > > +	suppressed_fields = realloc(suppressed_fields,
> > > +				    (sup_total+1)*sizeof(enum MAD_FIELDS));
> 
> Also it is never freed. Maybe just to have a static array (0-terminated)
> and to not bother with realloc()?

I thought we were not worrying about freeing things in the diags.  I am all for doing proper clean up but there was a long thread on this where Hal was shot down for wanting everything free'ed properly.

<sigh>  I will figure out how to make the static array later.  Look for the patch.

Ira

> 
> Sasha
> 
> > >  	suppressed_fields[sup_total] = field;
> > >  	sup_total++;
> > >  }
> > -- 
> > Albert Chu
> > chu11-i2BcT+NCU+M@public.gmane.org
> > Computer Scientist
> > High Performance Systems Division
> > Lawrence Livermore National Laboratory
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://*vger.kernel.org/majordomo-info.html
> > 
> 


-- 
Ira Weiny
Math Programmer/Computer Scientist
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
