From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH rdma-next 01/10] IB: Replace ib_umem page_size by page_shift
Date: Wed, 5 Apr 2017 10:30:11 -0500
Message-ID: <0c8601d2ae21$8441bc20$8cc53460$@opengridcomputing.com>
References: <20170403100640.3332-1-leon@kernel.org> <20170403100640.3332-2-leon@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170403100640.3332-2-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Leon Romanovsky' <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, 'Doug Ledford' <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Artemy Kovalyov' <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, 'Selvin Xavier' <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, 'Steve Wise' <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, 'Lijun Ou' <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, 'Shiraz Saleem' <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Adit Ranadive' <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, 'Dennis Dalessandro' <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, 'Ram Amrani' <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


> From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> 
> Size of pages are held by struct ib_umem in page_size field.
> 
> It is better to store it as an exponent, because page size by nature
> is always power-of-two and used as a factor, divisor or ilog2's argument.
> 
> The conversion of page_size to be page_shift allows to have portable
> code and avoid following error while compiling on ARM:
> 
>   ERROR: "__aeabi_uldivmod" [drivers/infiniband/core/ib_core.ko]
> undefined!
> 
> CC: Selvin Xavier <selvin.xavier-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>
> CC: Steve Wise <swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
> CC: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
> CC: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> CC: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
> CC: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
> CC: Ram Amrani <Ram.Amrani-74tsMCuadCbQT0dZR+AlfA@public.gmane.org>
> Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
> ---
>  drivers/infiniband/core/umem.c                 | 15 ++++++---------
>  drivers/infiniband/core/umem_odp.c             | 12 ++++++------
>  drivers/infiniband/hw/bnxt_re/ib_verbs.c       | 12 ++++++------
>  drivers/infiniband/hw/cxgb3/iwch_provider.c    |  4 ++--
>  drivers/infiniband/hw/cxgb4/mem.c              |  4 ++--

For the cxgb parts:

Acked-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
