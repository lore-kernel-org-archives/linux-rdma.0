From: Mike Marciniszyn <mike.marciniszyn@qlogic.com>
Subject: RE: [PATCH 1/4] drivers/infiniband/hw/qib/qib_iba6120.c: convert
 GFP_KERNEL to GFP_ATOMIC
Date: Mon, 9 Jan 2012 08:49:56 -0800
Message-ID: <35AAF1E4A771E142979F27B51793A4888885970586@AVEXMB1.qlogic.org>
References: <1326102050-30265-1-git-send-email-Julia.Lawall@lip6.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1326102050-30265-1-git-send-email-Julia.Lawall@lip6.fr>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Julia Lawall <Julia.Lawall@lip6.fr>, Dept_Infinipath <Dept_Infinipath@qlogic.com>
Cc: "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>, Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org


> Subject: [PATCH 1/4] drivers/infiniband/hw/qib/qib_iba6120.c: convert
> GFP_KERNEL to GFP_ATOMIC
>
> From: Julia Lawall <julia.lawall@lip6.fr>
>
> The function is called with locks held and thus should not use
> GFP_KERNEL.
>
> The semantic patch that makes this report is available
> in scripts/coccinelle/locks/call_kern.cocci.
>
> More information about semantic patching is available at
> http://coccinelle.lip6.fr/
>
> Signed-off-by: Julia Lawall <julia.lawall@lip6.fr>

Thanks for the patch!

Acked-by: Mike Marciniszyn <mike.marciniszyn@qlogic.com>

This message and any attached documents contain information from QLogic Corporation or its wholly-owned subsidiaries that may be confidential. If you are not the intended recipient, you may not read, copy, distribute, or use this information. If you have received this transmission in error, please notify the sender immediately by reply e-mail and then delete this message.
