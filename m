From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH 12/13] staging/rdma/hfi1: Read EFI variable for device
 description
Date: Wed, 11 Nov 2015 17:39:21 +0300
Message-ID: <20151111143921.GG18797@mwanda>
References: <1447227213-15122-1-git-send-email-jubin.john@intel.com>
 <1447227213-15122-12-git-send-email-jubin.john@intel.com>
 <20151111084439.GA18797@mwanda>
 <4AF12E8016D2BF46BCDFCE8FAA77A3580BC19F69@FMSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AF12E8016D2BF46BCDFCE8FAA77A3580BC19F69-AtyAts71sc9cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luick, Dean" <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "John, Jubin" <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 11, 2015 at 02:03:02PM +0000, Luick, Dean wrote:
> 
> 
> > -----Original Message-----
> > From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> > owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Dan Carpenter
> > Sent: Wednesday, November 11, 2015 2:45 AM
> > To: John, Jubin <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org; devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org; linux-
> > rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
> > Subject: Re: [PATCH 12/13] staging/rdma/hfi1: Read EFI variable for device
> > description
> > 
> > On Wed, Nov 11, 2015 at 02:33:32AM -0500, Jubin John wrote:
> > > +static int read_efi_var(const char *name, unsigned long *size,
> > > +			void **return_data)
> > > +{
> > > +	int ret;
> > > +
> > > +	/* set failure return values */
> > > +	*size = 0;
> > > +	*return_data = NULL;
> > > +
> > > +	/*
> > > +	 * Use EFI run-time support to obtain an EFI variable.  Support may
> > > +	 * be compiled out, so declare all variables inside.
> > > +	 */
> > > +	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> > 
> > 
> > Flip this around:
> > 
> > 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> > 		return -ENOSYS;
> 
> The style here is very deliberate.
> 
> The issue is how efi_enabled() is defined via CONFIG options.
>  The function can be turned into a 0 if certain CONFIG variables are
> not set.  The code is structured to make all of the dependent
> variables disappear if efi_enabled() becomes 0.

This all understand.

>  If the code is shifted as you suggest, we will get builds from the
> automatic builders that try all combinations with unused variables.
>  This was done to avoid that.

I'm not sure I understand.  You are doing this to try tricking the
autobuilders into not testind certain configs?  What?  I don't
understand what you mean by unused variables.  There shouldn't be any
unused variable warnings.  If you are getting unused variable warnings
can you post one so that I can take a look?

Maybe you are worried the function is a waste of memory if you declare
the variables earlier before the if enabled check?  It's not a problem.
The compiler is smart enough to see the immediate return and removes
the dead code.

Perhaps I am not seeing your concern.

regards,
dan carpenter

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
