From: Dan Carpenter <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: IB/usnic: Add Cisco VIC low-level hardware driver
Date: Thu, 12 Dec 2013 12:26:14 +0300
Message-ID: <20131212092614.GT5443@mwanda>
References: <20131211223834.GA3955@elgon.mountain>
 <BC9EAC3B-33A6-482B-9CF4-DF1E1353AB3B@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <BC9EAC3B-33A6-482B-9CF4-DF1E1353AB3B-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: "<linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 12, 2013 at 01:59:00AM +0000, Upinder Malhi (umalhi) wrote:
> Hi Dan,
> 	Can I ask what static checker you are using for these?
> 

In this email, the released version of Smatch will only warn about the
actual bug and not the others.  It requires that you build the cross
function database though before you test the code.

~/smatch/smatch_scripts/build_kernel_data.sh

> > drivers/infiniband/hw/usnic/usnic_uiom.c
> >   469          pd->domain = domain = iommu_domain_alloc(&pci_bus_type);
> >                                      ^^^^^^^^^^^^^^^^^^^
> > This function returns NULL on error not error pointers.
> > 
> >   470          if (IS_ERR_OR_NULL(domain)) {
> >   471                  usnic_err("Failed to allocate IOMMU domain with err %ld\n",
> >   472                                  PTR_ERR(pd->domain));
> >   473                  kfree(pd);
> >   474                  return ERR_PTR(domain ? PTR_ERR(domain) : -ENOMEM);
> >   475          }
> > 
> > Similar harmless but crappy slop in:
> [UM] - Unless I'm missing something, I think this is OK and preferred
> in case iommu_domain_alloc in future starts returning ERR_PTRs.

It doesn't cause a bug, but it's unusual and considered sloppy.  APIs
should be clear about what error codes they return and they should
almost always return either ERR_PTRs *or* NULL but not *both*.  The
exceptions are when NULL is a valid return which means something.  For
example, maybe you are looking for a file and you return NULL if the
file is not found but ERR_PTR(-ENOMEM) if you have an error.

In linux if we decide that iommu_domain_alloc() should return ERR_PTRs
instead of NULL pointers, then it's up to the person who decides that
to change all the callers as well.

Also if you trust the lower levels to print their error messages
correctly then the error handling here could be much simpler.  kzalloc()
for example, has very extensive error messages.

	pd->domain = domain = iommu_domain_alloc(&pci_bus_type);
	if (!domain) {
		kfree(pd);
		return -ENOMEM;
	}

regards,
dan carpenter


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
