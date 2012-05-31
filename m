From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH V3.1 8/8] infiniband-diags: Add sa_smkey option to
 config file
Date: Thu, 31 May 2012 16:54:36 -0700
Message-ID: <20120531165436.650d9fa5.weiny2@llnl.gov>
References: <1338398497-12444-8-git-send-email-foraker1@llnl.gov>
	<1338416114-14068-1-git-send-email-foraker1@llnl.gov>
	<4FC75C61.7060408@dev.mellanox.co.il>
	<20120531152515.410a999a.weiny2@llnl.gov>
	<4FC7FF07.6090207@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4FC7FF07.6090207-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, 31 May 2012 19:30:15 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 5/31/2012 6:25 PM, Ira Weiny wrote:
> > On Thu, 31 May 2012 07:56:17 -0400
> > Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> > 
> >> On 5/30/2012 6:15 PM, Jim Foraker wrote:
> >>> Defines a default for the smkey used in SA requests
> >>>
> >>> Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
> >>> ---
> >>>  etc/ibdiag.conf     |    3 +++
> >>>  src/ibdiag_common.c |    3 +++
> >>>  2 files changed, 6 insertions(+)
> >>>
> >>> diff --git a/etc/ibdiag.conf b/etc/ibdiag.conf
> >>> index 2a2334f..9686d14 100644
> >>> --- a/etc/ibdiag.conf
> >>> +++ b/etc/ibdiag.conf
> >>> @@ -17,3 +17,6 @@
> >>>  
> >>>  # define a default m_key
> >>>  #m_key=0x00
> >>> +
> >>> +# default smkey to be used for SA requests
> >>> +#sa_key=0x00
> >>
> >> I think we're in for support questions here mostly around MCMemberRecord :-(
> >>
> >> If this is to be done, at a minimum, the change in admin expectation
> >> needs to be clearly documented in the infiniband-diags release notes.
> >> I'm not sure that's sufficient to have it noticed.
> >>
> > 
> > I will.  Also I have added the following patch to document the default better.
> 
> I meant the difference in the default behavior due to sakey now being 0
> in saquery. Before with OpenSM and the old saquery, one got all members
> of a multicast group whereas now with the new saquery one gets only one
> group member unless trust is configured.

Yes, I planned to mention the differences in the release notes.

As for the tool itself, I thought this patch was necessary to make it clear what the default was.  While it is painful that one will have to read the specification to see what is included with an "untrusted" request, I felt it was too much to try and document that fully.

Ira

> 
> -- Hal
> 
> > 
> > Ira
> > 
> > 
> > infiniband-diags: saquery clarify default smkey option value
> > 
> > Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > ---
> >  doc/rst/saquery.8.in.rst |    5 ++++-
> >  src/saquery.c            |    4 +++-
> >  2 files changed, 7 insertions(+), 2 deletions(-)
> > 
> > diff --git a/doc/rst/saquery.8.in.rst b/doc/rst/saquery.8.in.rst
> > index 79c8bd3..1a11965 100644
> > --- a/doc/rst/saquery.8.in.rst
> > +++ b/doc/rst/saquery.8.in.rst
> > @@ -82,7 +82,10 @@ OPTIONS
> >  **--smkey <val>**
> >          use SM_Key value for the query. Will be used only with "trusted"
> >          queries.  If non-numeric value (like 'x') is specified then saquery
> > -        will prompt for a value.
> > +	will prompt for a value.
> > +	Default (when not specified here or in
> > +	@IBDIAG_CONFIG_PATH@/ibdiag.conf) is to use SM_Key == 0 (or
> > +	\"untrusted\")
> >  
> >  .. include:: common/opt_K.rst
> >  
> > diff --git a/src/saquery.c b/src/saquery.c
> > index 5f535fc..6e09374 100644
> > --- a/src/saquery.c
> > +++ b/src/saquery.c
> > @@ -1571,7 +1571,9 @@ int main(int argc, char **argv)
> >  		{"smkey", 4, 1, "<val>",
> >  		 "SA SM_Key value for the query."
> >  		 " If non-numeric value (like 'x') is specified then"
> > -		 " saquery will prompt for a value"},
> > +		 " saquery will prompt for a value. "
> > +		 " Default (when not specified here or in ibdiag.conf) is to "
> > +		 " use SM_Key == 0 (or \"untrusted\")"},
> >  		{"slid", 5, 1, "<lid>", "Source LID (PathRecord)"},
> >  		{"dlid", 6, 1, "<lid>", "Destination LID (PathRecord)"},
> >  		{"mlid", 7, 1, "<lid>", "Multicast LID (MCMemberRecord)"},
> 


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
