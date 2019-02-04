From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH] IB/{hfi1,qib}: Add limit test for RC/UC send via
 loopback
Date: Mon, 4 Feb 2019 16:25:38 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC70C49CCA@fmsmsx120.amr.corp.intel.com>
References: <20190204153639.2555.41856.stgit@scvm10.sc.intel.com>
 <20190204154454.GB14330@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190204154454.GB14330@kroah.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: Re: [PATCH] IB/{hfi1,qib}: Add limit test for RC/UC send via loopback
> 
> What stable kernel(s) is this backport for?
> 
> thanks,
> 
> greg k-h

The original patch has already been backported to 4.20.

The kernels that require the ported patch are older ones: 4.19.x, 4.14.x, and 4.9.x.

Mike
