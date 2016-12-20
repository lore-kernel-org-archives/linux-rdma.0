From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH infiniband-diags] Add Bull device ID support to device white lists
Date: Tue, 20 Dec 2016 11:56:18 -0500
Message-ID: <20161220165617.GB29564@phlsvsds.ph.intel.com>
References: <e5ad4256-53fe-9ecc-f880-89347134ec42@dev.mellanox.co.il> <20161207145338.GD24724@phlsvsds.ph.intel.com> <584A8823.4070506@atos.net> <703b953b-7165-72d1-3c1e-c3b1f8c54f28@dev.mellanox.co.il> <584ABFE6.4070902@atos.net> <46fac349-4687-961a-4d63-697064f391da@dev.mellanox.co.il> <2807E5FD2F6FDA4886F6618EAC48510E3C611A58@CRSMSX101.amr.corp.intel.com> <58579DFD.2040206@atos.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <58579DFD.2040206-BUmcmmAb0Fc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vincent Ficet <jean-vincent.ficet-BUmcmmAb0Fc@public.gmane.org>
Cc: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Dec 19, 2016 at 09:44:45AM +0100, Vincent Ficet wrote:
> Hello,
> 
> On 12/19/2016 08:10 AM, Weiny, Ira wrote:
> >> On 12/9/2016 9:29 AM, Vincent Ficet wrote:
> >>>> Would it be better to combine Bull Switch-IB and Switch-IB2 ranges
> >>>> into one check rather than keeping them separate as the device IDs
> >>>> are contiguous ?
> >>> I just wanted to separate SwitchIB and SwitchIB2 for clarity, but we can gather
> >> them if you wish to do so.
> >>> Which option do you prefer, together or split ?
> >> I prefer together.
> > Together is fine by me.
> >
> > I was expecting a v2 of this patch.  Was that your intention?
> I attached the v3 of this patch to this mail following Hal's remarks and suggestions.
> 
> The new code has been fully tested on our cluster and no regression was found.
> 
> Please let me know whether the changes I made are acceptable.

This was not a valid patch format.  The patch applied with git am just fine
but...

I did not have a signed off by from you nor was there a good commit message.

I went ahead and fixed both of those issues.  So consider this applied.

However, in the future could you please:

1) send the patch inline
2) use a proper signed off by line
3) have a proper commit message.

Thanks,
Ira

> 
> 
> Best Regards,
> 
> Vincent
> 
> 
> >
> > Ira
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
