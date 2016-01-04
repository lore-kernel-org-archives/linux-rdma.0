From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH] staging: rdma: hfi1: diag: constify hfi1_filter_array
 structure
Date: Mon, 4 Jan 2016 15:48:54 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC259E41B4@fmsmsx120.amr.corp.intel.com>
References: <1450903377-27803-1-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1450903377-27803-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Doug Ledford <dledford@redhat.com>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

> From: devel [mailto:driverdev-devel-bounces@linuxdriverproject.org] On
> Behalf Of Julia Lawall
> Subject: [PATCH] staging: rdma: hfi1: diag: constify hfi1_filter_array
> structure
> 
> The hfi1_filter_array structure is never modified, so declare it as const.
> 
> Done with the help of Coccinelle.
> 
> Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> 

Thanks for the patch!

Acked-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
