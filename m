From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH v2] IB/hfi1: Protect the global dev_cntr_names and
 port_cntr_names
Date: Tue, 23 May 2017 21:55:33 +0200
Message-ID: <20170523195533.GA17694@kroah.com>
References: <20170523194407.28059.59929.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170523194407.28059.59929.stgit@phlsvslse11.ph.intel.com>
Sender: stable-owner@vger.kernel.org
To: Mike Marciniszyn <mike.marciniszyn@intel.com>
Cc: stable@vger.kernel.org, linux-rdma@vger.kernel.org, stable-commits@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

On Tue, May 23, 2017 at 03:44:29PM -0400, Mike Marciniszyn wrote:
> From: Tadeusz Struk <tadeusz.struk@intel.com>
> 
> commit 62eed66e98b4c2286fef2ce5911d8d75b7515f7b upstream.
> 
> Protect the global dev_cntr_names and port_cntr_names with the global
> mutex as they are allocated and freed in a function called per device.
> Otherwise there is a danger of double free and memory leaks.
> 
> Cc: stable <stable@vger.kernel.org> # v4.10

Why resend this???
