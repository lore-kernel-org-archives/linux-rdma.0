From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC v1 12/19] RDMA/irdma: Implement device supported verb APIs
Date: Wed, 20 Feb 2019 09:51:29 -0700
Message-ID: <20190220165129.GF8429@ziepe.ca>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-13-shiraz.saleem@intel.com>
 <20190215173539.GD30706@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7A5A460A0@fmsmsx124.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7A5A460A0@fmsmsx124.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
To: "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ismail, Mustafa" <mustafa.ismail@intel.com>, "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 20, 2019 at 02:52:31PM +0000, Saleem, Shiraz wrote:

> >All lists of things should be sorted. I saw many examples of unsorted lists.
> 
> OK. We weren't aware of this rule in kernel drivers. Is this subsystem specific?

It is a general kernel preference - it helps avoid unnecessary merge
conflicts. Lists in kconfig, makefiles, etc should all be
sorted. Other order-independent lists, like ops, and what not should
be sorted for the same reasons.

> >> +	iwibdev->ibdev.iwcm->add_ref = irdma_add_ref;
> >> +	iwibdev->ibdev.iwcm->rem_ref = irdma_rem_ref;
> >> +	iwibdev->ibdev.iwcm->get_qp = irdma_get_qp;
> >> +	iwibdev->ibdev.iwcm->connect = irdma_connect;
> >> +	iwibdev->ibdev.iwcm->accept = irdma_accept;
> >> +	iwibdev->ibdev.iwcm->reject = irdma_reject;
> >> +	iwibdev->ibdev.iwcm->create_listen = irdma_create_listen;
> >> +	iwibdev->ibdev.iwcm->destroy_listen = irdma_destroy_listen;
> >
> >Huh. These should probably be moved into the ops structure too.
> 
> Not sure. It looks cleaner this way. These are iWARP CM
> specific. Why allocate them for all devices?

Not sure a few bytes really matter.

Jason
