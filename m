From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [PATCH 02/20] IB/hfi1: Remove hyper-thread siblings by walking
 CPU mask
Date: Fri, 21 Apr 2017 03:48:15 -0700
Message-ID: <20170421104815.GA13124@infradead.org>
References: <20170409171329.10579.92775.stgit@scvm10.sc.intel.com>
 <20170409171537.10579.68545.stgit@scvm10.sc.intel.com>
 <20170410074904.GA26626@infradead.org>
 <5CDA63463B33C94CA80846587415F07704076B86@ORSMSX111.amr.corp.intel.com>
 <20170420173420.GR14088@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20170420173420.GR14088-U/DQcQFIOTAAJjI8aNfphQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "Sanchez, Sebastian" <sebastian.sanchez-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, "Dalessandro, Dennis" <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Struk, Tadeusz" <tadeusz.struk-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Apr 20, 2017 at 08:34:20PM +0300, Leon Romanovsky wrote:
> On Thu, Apr 20, 2017 at 05:20:18PM +0000, Sanchez, Sebastian wrote:
> > The irq layer PCI_IRQ_AFFINITY flag makes pci_alloc_irq_vectors() spread all the interrupts around the available CPUs, however, the API doesn't allow to exclude the hyper threading CPU cores or limit the CPUs to use for the affinity mask. If the API had a way to provide an affinity hint into this function instead of having them automatically generated it provide more flexibility to the hfi1 driver.
> 
> It is open source, add it if you need it.

Exactly.  And it's not like hfi1 is a super special beast. IFF the
hyperthread magic makes sense it will be useful for other device aswell.

So I'd like to repeat my NAK for "improving" any irq affinity magic
in drivers.  Move to the common code and improve it as needed instead of
making the mess worse.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
