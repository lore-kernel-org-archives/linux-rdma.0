From: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v4 00/50] Add OPA gen1 driver
Date: Fri, 31 Jul 2015 02:05:06 +0300
Message-ID: <CAJ3xEMha-BKEkTRq5qUE8tt5MOpohRvrjY7_wW2u-ApayZZFpQ@mail.gmail.com>
References: <20150730191631.25256.95511.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150730191631.25256.95511.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Jul 30, 2015 at 10:17 PM, Mike Marciniszyn
<mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> The following patch series adds the OPA device driver.
[...]
>       IB/hfi1: add qp handling
>       IB/hfi1: add RC QP handling
>       IB/hfi1: add UC QP handling
>       IB/hfi1: add UD QP handling

On Wed, Jun 17, 2015, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
> This patch series adds the OPA gen1 driver.
[...]
>       IB/hfi1: add qp handling
>       IB/hfi1: add RC QP handling
>       IB/hfi1: add routines for RC/UC
>       IB/hfi1: add UC QP handling
>       IB/hfi1: add UD QP handling

Mike, nothing changed since your V3 in that respect, so repeating myself:

This is the 3rd time in a row {(1) ipath (2) qib (3) OPA Gen1} for you
guys to implement IB transports in SW @ your low-level drivers.

So... enough is enough, please put it in a kernel module residing in
the IB core and use it in this driver, to begin with. The fact that
ipath is going to go, makes the cope duplication "only" 2X vs the 3X,
but it's still 2X

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
