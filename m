From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: RE: [PATCH v2 rdma-next 00/29] Soft RoCE driver
Date: Thu, 16 Jun 2016 09:30:21 -0500
Message-ID: <00bf01d1c7db$9cbecbd0$d63c6370$@opengridcomputing.com>
References: <1466084751-29901-1-git-send-email-monis@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1466084751-29901-1-git-send-email-monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Moni Shoua' <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Changes from V1
> ====================================================================
> ===========
> - Rebase to kernel 4.7-rc2
> - Fix error code in rxe_srq_from_init() (from Dan Carpenter
> <dan.carpenter-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>)
> - Fix 32-bit build warnings (from Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>)
> - Add UDP_TUNNEL dependency (from Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>)
> - Avoid 64-bit division (from Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>)
> - Changed deprecated module_param_call() to module_param_cb()
> - Add description to module params 'add' and 'remove'
> - Hold list of RXE devices in list instead of array
> - Fix race when received before wqe state update
> - Add prefix "rxe" to memory cache names
> - Rename ib_rxe.h to ib_user_rxe.h (comes with same change in librxe).
> - Fix copyright date issue
> 
> Note: The FMR interface is left in until the fast memory registration
interface
> will be added so iSER can still work with Soft RoCE.
>

Hey Moni, do you plan to pull in the fast memory registration and other patches
from Sagi?  

commit d06f9c6029cca2a21e5248fc3e65657352d59fc0
Author: Sagi Grimberg <sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

    IB/rxe: Initial fast memory registraion (and remote invalidation) support

commit 029ec12f3dd921fd5400471f5b04b8da3e24d46e
Author: Sagi Grimberg <sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

    IB/rxe: Support ib_drain_qp

commit 9a93bff887457d364c9232492793cf8562848a9c
Author: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>

    IB/rxe: Report missed events in case they are missed

Steve.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
