From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v3 00/49] Add OPA gen1 driver
Date: Fri, 19 Jun 2015 13:55:47 +0300
Message-ID: <CAJ3xEMiire8aFGr8FkcA_PEELAGpF7fxwWNwS3_L4wvK9s+Pkw@mail.gmail.com>
References: <20150617122755.8744.44665.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150617122755.8744.44665.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jun 17, 2015, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> This patch series adds the OPA gen1 driver.

>       IB/hfi1: add qp handling
>       IB/hfi1: add RC QP handling
>       IB/hfi1: add routines for RC/UC
>       IB/hfi1: add UC QP handling
>       IB/hfi1: add UD QP handling

Mike,

This is the 3rd time in a row {(1) ipath (2) qib (3) OPA Gen1} for you
guys to implement IB transports in SW @ your low-level drivers.

So... enough is enough, please put it in a (say) libibtrans kernel
module residing in the IB core and use it in this driver, to begin
with.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
