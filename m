From: "gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org" <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH 12/13] staging/rdma/hfi1: Read EFI variable for device
 description
Date: Wed, 11 Nov 2015 09:24:11 -0800
Message-ID: <20151111172411.GA20481@kroah.com>
References: <1447227213-15122-1-git-send-email-jubin.john@intel.com>
 <1447227213-15122-12-git-send-email-jubin.john@intel.com>
 <20151111084439.GA18797@mwanda>
 <4AF12E8016D2BF46BCDFCE8FAA77A3580BC19F69@FMSMSX102.amr.corp.intel.com>
 <20151111143921.GG18797@mwanda>
 <4AF12E8016D2BF46BCDFCE8FAA77A3580BC19FC8@FMSMSX102.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4AF12E8016D2BF46BCDFCE8FAA77A3580BC19FC8-AtyAts71sc9cIJlls4ac1rfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Luick, Dean" <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org" <devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org>, "John, Jubin" <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Nov 11, 2015 at 03:03:12PM +0000, Luick, Dean wrote:
> > -----Original Message-----
> > From: Dan Carpenter [mailto:dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org]
> > Sent: Wednesday, November 11, 2015 8:39 AM
> > To: Luick, Dean <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> > Cc: John, Jubin <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>; devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org;
> > gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org; dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org; linux-
> > rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > Subject: Re: [PATCH 12/13] staging/rdma/hfi1: Read EFI variable for device
> > description
> > 
> > > > > +	if (efi_enabled(EFI_RUNTIME_SERVICES)) {
> > > >
> > > >
> > > > Flip this around:
> > > >
> > > > 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
> > > > 		return -ENOSYS;
> > >
> > > The style here is very deliberate.
> > >
> > > The issue is how efi_enabled() is defined via CONFIG options.
> > >  The function can be turned into a 0 if certain CONFIG variables are
> > > not set.  The code is structured to make all of the dependent
> > > variables disappear if efi_enabled() becomes 0.
> > 
> > This all understand.
> > 
> > >  If the code is shifted as you suggest, we will get builds from the
> > > automatic builders that try all combinations with unused variables.
> > >  This was done to avoid that.
> > 
> > I'm not sure I understand.  You are doing this to try tricking the
> > autobuilders into not testind certain configs?  What?
> 
> Certainly not.  I did not explain this well.
> 
> > I don't
> > understand what you mean by unused variables.  There shouldn't be any
> > unused variable warnings.  If you are getting unused variable warnings
> > can you post one so that I can take a look?
> 
> If you move the variables to the top and have the early return as you suggest, then in some CONFIG cases, there will be all those automatic variables declared but they are never used - the compiler has short-circuited the rest of the function.  Will not the compiler complain about unused variables in those cases?  That is the situation I was trying to avoid.

Try it and see (hint, I don't think so...)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
