From: Shiraz Saleem <shiraz.saleem@intel.com>
Subject: Re: [RFC 12/19] RDMA/irdma: Implement device supported verb APIs
Date: Fri, 15 Feb 2019 11:18:01 -0600
Message-ID: <20190215171801.GA14972@ssaleem-MOBL4.amr.corp.intel.com>
References: <20190212214402.23284-1-shiraz.saleem@intel.com>
 <20190212214402.23284-13-shiraz.saleem@intel.com>
 <20190212222707.GU24692@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20190212222707.GU24692@ziepe.ca>
Sender: netdev-owner@vger.kernel.org
To: Jason Gunthorpe <jgg@ziepe.ca>
Cc: dledford@redhat.com, davem@davemloft.net, linux-rdma@vger.kernel.org, netdev@vger.kernel.org, mustafa.ismail@intel.com, jeffrey.t.kirsher@intel.com
List-Id: linux-rdma@vger.kernel.org

On Tue, Feb 12, 2019 at 03:27:07PM -0700, Jason Gunthorpe wrote:
> On Tue, Feb 12, 2019 at 03:43:55PM -0600, Shiraz Saleem wrote:
> 
> > +/**
> > + * irdma_disassociate_ucontext - Disassociate user context
> > + * @context: ib user context
> > + */
> > +static void irdma_disassociate_ucontext(struct ib_ucontext *context)
> > +{
> > +	struct irdma_ucontext *ucontext = to_ucontext(context);
> > +
> > +	struct irdma_vma_data *vma_data, *n;
> > +	struct vm_area_struct *vma;
> > +
> > +	irdma_dev_info(&ucontext->iwdev->rf->sc_dev, "called\n");
> > +	mutex_lock(&ucontext->vma_list_mutex);
> > +	list_for_each_entry_safe(vma_data, n, &ucontext->vma_list, list) {
> > +		vma = vma_data->vma;
> > +		zap_vma_ptes(vma, vma->vm_start, PAGE_SIZE);
> > +
> > +		vma->vm_flags &= ~(VM_SHARED | VM_MAYSHARE);
> > +		vma->vm_ops = NULL;
> > +		list_del(&vma_data->list);
> > +		kfree(vma_data);
> > +	}
> > +	mutex_unlock(&ucontext->vma_list_mutex);
> > +}
> 
> You need to study all the changes that have been done in the core code
> and make sure this driver is using all the latest stuff, I do not want
> to review a driver and find it is full of obsolete APIs like this
> above.
> 

I submitted a revised version addressing this problem. There were a few changes.
*updated disassociate_ucontext API
*updated alloc/dealloc PD APIs
*query ports via core
*remove MODULE_VER
*remove create_single_threaded_workqueue
*remove list_empty checks in irdma_dealloc_ucontext
*change all uapi headers to use __aligned_u64

Shiraz
