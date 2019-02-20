From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: Re: [RFC v1 17/19] RDMA/irdma: Add ABI definitions
Date: Wed, 20 Feb 2019 09:50:11 -0700
Message-ID: <20190220165011.GE8429@ziepe.ca>
References: <20190215171107.6464-1-shiraz.saleem@intel.com>
 <20190215171107.6464-18-shiraz.saleem@intel.com>
 <20190215171638.GA30706@ziepe.ca>
 <9DD61F30A802C4429A01CA4200E302A7A5A46077@fmsmsx124.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <9DD61F30A802C4429A01CA4200E302A7A5A46077@fmsmsx124.amr.corp.intel.com>
Sender: netdev-owner@vger.kernel.org
To: "Saleem, Shiraz" <shiraz.saleem@intel.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>, "davem@davemloft.net" <davem@davemloft.net>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>, "Ismail, Mustafa" <mustafa.ismail@intel.com>, "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>
List-Id: linux-rdma@vger.kernel.org

On Wed, Feb 20, 2019 at 02:52:03PM +0000, Saleem, Shiraz wrote:
> >Subject: Re: [RFC v1 17/19] RDMA/irdma: Add ABI definitions
> >
> >On Fri, Feb 15, 2019 at 11:11:04AM -0600, Shiraz Saleem wrote:
> >> From: Mustafa Ismail <mustafa.ismail@intel.com>
> >>
> >> Add ABI definitions for irdma.
> 
> [....]
> >>
> >> +
> >> +#include <linux/types.h>
> >> +
> >> +#define IRDMA_ABI_VER	6
> >
> >Starting with high numbers?
> 
> It's a bump on the current i40iw ABI ver. of 5 since we
> want to be compatible and support current rdma-core's libi40iw
> for Gen1 (X722) device.

i40iw is one of the drivers that doesn't do ABI versions right, so
this is all meaningless. You should probably fix it:

static const struct verbs_device_ops i40iw_udev_ops = {
        .name = "i40iw",
        .match_min_abi_version = 0,
        .match_max_abi_version = INT_MAX,

0 and INT_MAX need to be something sensible.

> >This won't even compile like this - don't forget you have to send the rdma-core
> >PR along with the kernel patches. You should already be running the travis
> >checks yourself. rdma-core should detect malformed user space headers..
> 
> Yes. We will be sending the rdma-core patches soon.
> Maybe we are missing something here, but this did compile with libirdma
> in rdma-core-v22, but we havent run travis checks yet.

travis does the tests.

Jason
