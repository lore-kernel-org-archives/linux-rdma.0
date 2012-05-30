From: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH V3 8/8] infiniband-diags: Add sa_smkey option to config
	file
Date: Wed, 30 May 2012 15:17:26 -0700
Message-ID: <1338416246.17237.869.camel@auk75.llnl.gov>
References: <1338398414.11948.29.camel@auk75.llnl.gov>
	 <1338398497-12444-1-git-send-email-foraker1@llnl.gov>
	 <1338398497-12444-8-git-send-email-foraker1@llnl.gov>
	 <4FC66196.5030704@dev.mellanox.co.il>
	 <1338403407.17237.860.camel@auk75.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338403407.17237.860.camel-mxTxeWJot8FliZ7u+bvwcg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira K." <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

     I just posted a "V3.1" for patches 7 and 8, which converts variable
ibd_sa_smkey to ibd_sakey and config parameter sa_smkey to sa_key.

     Jim

On Wed, 2012-05-30 at 11:43 -0700, Jim Foraker wrote:
> On Wed, 2012-05-30 at 11:06 -0700, Hal Rosenstock wrote:
> > On 5/30/2012 1:21 PM, Jim Foraker wrote:
> > > Defines a default for the smkey used in SA requests
> > > 
> > > Signed-off-by: Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
> > > ---
> > >  etc/ibdiag.conf     |    3 +++
> > >  src/ibdiag_common.c |    3 +++
> > >  2 files changed, 6 insertions(+)
> > > 
> > > diff --git a/etc/ibdiag.conf b/etc/ibdiag.conf
> > > index 2a2334f..1e6149d 100644
> > > --- a/etc/ibdiag.conf
> > > +++ b/etc/ibdiag.conf
> > > @@ -17,3 +17,6 @@
> > >  
> > >  # define a default m_key
> > >  #m_key=0x00
> > > +
> > > +# default smkey to be used for SA requests
> > > +#sa_smkey=0x00
> > > diff --git a/src/ibdiag_common.c b/src/ibdiag_common.c
> > > index c40490a..1301810 100644
> > > --- a/src/ibdiag_common.c
> > > +++ b/src/ibdiag_common.c
> > > @@ -160,6 +160,9 @@ void read_ibdiag_config(const char *file)
> > >  			}
> > >  		} else if (strncmp(name, "m_key", strlen("m_key")) == 0) {
> > >  			ibd_mkey = strtoull(val_str, 0, 0);
> > > +		} else if (strncmp(name, "sa_smkey",
> > > +				   strlen("sa_smkey")) == 0) {
> > 
> > For consistency with OpenSM naming, how about sa_key for this ?
>      That's fine by me.  IIRC, that was actually my first choice, but I
> thought there might be some objections, since it's called smkey in the
> spec.
> 
>      Jim
> 
> > 
> > -- Hal
> > 
> > > +			ibd_sa_smkey = strtoull(val_str, 0, 0);
> > >  		}
> > >  	}
> > >  
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
