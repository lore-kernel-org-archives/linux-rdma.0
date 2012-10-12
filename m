From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] infiniband-diags: Fix SA error reporting for common MAD
 errors
Date: Fri, 12 Oct 2012 09:34:20 -0700
Message-ID: <20121012093420.93f0e7ee2455bb91912814ae@llnl.gov>
References: <20120921150259.5fb75a794fae33ac60e5f0d9@llnl.gov>
	<50758622.3030607@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50758622.3030607-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 10 Oct 2012 10:28:50 -0400
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 9/21/2012 6:02 PM, Ira Weiny wrote:
> > 
> > 
> > Signed-off-by: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
> > ---
> >  src/ibdiag_sa.c |   30 +++++++++++++++++++++++++++---
> >  1 files changed, 27 insertions(+), 3 deletions(-)
> > 
> > diff --git a/src/ibdiag_sa.c b/src/ibdiag_sa.c
> > index 2b84bfa..2a9f008 100644
> > --- a/src/ibdiag_sa.c
> > +++ b/src/ibdiag_sa.c
> > @@ -192,19 +192,43 @@ static inline const char *ib_sa_err_str(IN uint8_t status)
> >  	return (ib_sa_error_str[status]);
> >  }
> >  
> > +static const char *ib_mad_inv_field_str[] = {
> > +	"MAD No invalid fields",
> > +	"MAD Bad version",
> > +	"MAD Method specified is not supported",
> > +	"MAD Method/Attribute combination is not supported",
> > +	"MAD Reserved",
> > +	"MAD Reserved",
> > +	"MAD Reserved",
> > +	"MAD fields or attribute modifier; invalid value"
> 
> Perhaps "MAD Invalid value in field(s) of Attribute or Attribute Modifier" ?

Ok, that's better.  Slight modification:

   "MAD Invalid value in Attribute field(s) or Attribute Modifier"

Ira

> 
> -- Hal
> 
> > +	"MAD UNKNOWN ERROR"
> > +};
> > +#define MAD_ERR_UNKNOWN (ARR_SIZE(ib_mad_inv_field_str) - 1)
> > +
> > +static inline const char *ib_mad_inv_field_err_str(IN uint8_t f)
> > +{
> > +	if (f > MAD_ERR_UNKNOWN)
> > +		f = MAD_ERR_UNKNOWN;
> > +	return (ib_mad_inv_field_str[f]);
> > +}
> > +
> >  void sa_report_err(int status)
> >  {
> >  	int st = status & 0xff;
> > -	char sm_err_str[64] = { 0 };
> > +	char mad_err_str[64] = { 0 };
> >  	char sa_err_str[64] = { 0 };
> >  
> >  	if (st)
> > -		sprintf(sm_err_str, " SM(%s)", ib_get_err_str(st));
> > +		sprintf(mad_err_str, " (%s; %s; %s)",
> > +			(st & 0x1) ? "BUSY" : "",
> > +			(st & 0x2) ? "Redirection Required" : "",
> > +			ib_mad_inv_field_err_str(st>>2));
> > +
> >  
> >  	st = status >> 8;
> >  	if (st)
> >  		sprintf(sa_err_str, " SA(%s)", ib_sa_err_str((uint8_t) st));
> >  
> >  	fprintf(stderr, "ERROR: Query result returned 0x%04x, %s%s\n",
> > -		status, sm_err_str, sa_err_str);
> > +		status, mad_err_str, sa_err_str);
> >  }
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


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
