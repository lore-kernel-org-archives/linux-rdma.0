From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/2] RDMA/core: Initialize port_num in qp_attr
Date: Fri, 14 Jul 2017 08:47:51 +0200
Message-ID: <20170714064751.GA16816@kroah.com>
References: <1499974658-6180-1-git-send-email-mustafa.ismail@intel.com>
 <1499974658-6180-3-git-send-email-mustafa.ismail@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <stable-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1499974658-6180-3-git-send-email-mustafa.ismail@intel.com>
Sender: stable-owner@vger.kernel.org
To: Mustafa Ismail <mustafa.ismail@intel.com>
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com, swise@opengridcomputing.com, linux-kernel@vger.kernel.org, stable@vger.kernel.org, shiraz.saleem@intel.com
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 13, 2017 at 02:37:38PM -0500, Mustafa Ismail wrote:
> Initialize the port_num for iWARP in rdma_init_qp_attr.
> 
> Signed-off-by: Mustafa Ismail <mustafa.ismail@intel.com>
> ---
>  drivers/infiniband/core/cma.c | 2 ++
>  1 file changed, 2 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
