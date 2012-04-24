From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH V2 3/5] ib-diags/saquery: Fix smkey handling
Date: Tue, 24 Apr 2012 16:42:51 -0700
Message-ID: <1335310971.17237.407.camel@auk75.llnl.gov>
References: <1335228837.17237.302.camel@auk75.llnl.gov>
	 <1335229017-10677-1-git-send-email-foraker1@llnl.gov>
	 <1335229017-10677-3-git-send-email-foraker1@llnl.gov>
	 <4F96B5F8.8070801@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F96B5F8.8070801-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Tue, 2012-04-24 at 07:17 -0700, Hal Rosenstock wrote:
> On 4/23/2012 8:56 PM, Jim Foraker wrote:
> > smkey is already defined as a global inside saquery.c, so remove
> > broken support for passing it around as a function parameter
> > 
> > Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
> > ---
> >  src/saquery.c |   59 ++++++++++++++++++++++++++++-----------------------------
> >  1 file changed, 29 insertions(+), 30 deletions(-)
> > 
> > diff --git a/src/saquery.c b/src/saquery.c
> > index e5fdb25..029228c 100644
> > --- a/src/saquery.c
> > +++ b/src/saquery.c
> > @@ -85,7 +85,7 @@ struct query_cmd {
> >  
> >  static char *node_name_map_file = NULL;
> >  static nn_map_t *node_name_map = NULL;
> > -static uint64_t smkey = 1;
> > +static uint64_t smkey = 0;
> 
> Why is the default for smkey being changed from 1 to 0 ? Note that even
> though the name is smkey (due to the spec), it is really the default SA key.
     Previous to the patch, smkey was defined as 1, but rarely passed
thru to functions.  In particular, the only SA requests that were using
the default value of 1 were MCMember records, via either the -m option
or the MCMR query.  All other types were hard coded to smkey values of
0, and hence executing untrusted SA requests, regardless of either the
smkey variable defaulting to 1 or of any "--smkey" being passed on the
command line.
     Changing the variable default to 0 causes the patch to effect the
least change in observable behavior.  In particular, for commands not
specifying a smkey on the command line, the visible changes are limited
to MCMember records.  For subnets not using partitioning, the change in
MCMember records is limited to the specifics for that record type
covered in C15-0.2-1.16.
     Setting the default to 1 may provide better behavior, in terms of
making the diags "just work" for an out-of-the-box OpenSM config, but it
seems to me that the continued existence of this bug shows that
authenticated requests might not be particularly important for simple
configs.  Plus, it extracts a penalty -- post-patch, if the default is
set to 1, a user who chooses to change their SA smkey will be penalized
in the sense that they will always need to pass an smkey on the command
line, either the correct one or "--smkey 0" to execute an untrusted
request (packets with incorrect smkeys are dropped, not considered
untrusted).  With a default of 0, we are not providing users
encouragement to leave their SA smkey (which in turn protects other
authentication keys on the fabric) at a well-known, insecure value.
     A compromise would be for someone to write a patch that adds
support for a default SA smkey to the diags config file.  In that case,
I think the right behavior would be for the compiled utility to still
default to 0 so that saquery works on hosts without an smkey set in the
conf (the default config file might set the value to 1), which means
this patch as written does not get in the way.

     Jim

> 
> -- Hal
> 
> <snip...>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
