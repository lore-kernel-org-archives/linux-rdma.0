From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH] IB/core: Fix for core panic
Date: Wed, 28 Nov 2018 13:42:59 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC70B9EF75@ORSMSX160.amr.corp.intel.com>
References: <20181127233541.30944.84676.stgit@scvm10.sc.intel.com>
 <20181128105700.GB1822@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181128105700.GB1822@kroah.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>
Cc: "stable@vger.kernel.org" <stable@vger.kernel.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "stable-commits@vger.kernel.org" <stable-commits@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> > Reviewed-by: Yuval Shaia <yuval.shaia@oracle.com>
> > Fixes: 523633359224 ("IB/core: Fix the validations of a multicast LID in attach
> or detach operations")
> > Cc: stable@kernel.org # 4.9
> 
> Now queued up, thanks.
> 
> greg k-h

Thanks!!   We continuously test long terms and caught this, although not as quickly as I would have liked.

We are not quite sure what happened here, but when Alex made his upstream patch, the fix wasn't required in 4.9.

Mike
