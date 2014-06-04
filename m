From: "Marciniszyn, Mike" <mike.marciniszyn@intel.com>
Subject: RE: [PATCH 9/10] IB/qib: use safer test on the result of
 find_first_zero_bit
Date: Wed, 4 Jun 2014 18:41:03 +0000
Message-ID: <32E1700B9017364D9B60AED9960492BC21BE92E6@fmsmsx120.amr.corp.intel.com>
References: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr>
 <1401872880-23685-10-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401872880-23685-10-git-send-email-Julia.Lawall@lip6.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>, infinipath <infinipath@intel.com>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Roland Dreier <roland@kernel.org>, "Hefty, Sean" <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

> Subject: [PATCH 9/10] IB/qib: use safer test on the result of find_first_zero_bit
> 
> From: Julia Lawall <Julia.Lawall@lip6.fr>

Thanks for the patch!

Roland, I'm marking this as stable since a memory corruption can occur in the _set_bit().

Cc: <stable@vger.kernel.org>
Acked-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
