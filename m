From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH 1/3] RDMA/vmw_pvrdma: Cleanup unused variables
Date: Thu, 9 Mar 2017 17:07:08 +0000
Message-ID: <D4E6F5CA.13833%Andrew.Boyer@emc.com>
References: <cover.1487812849.git.aditr@vmware.com>
 <83baafed74beeee75a6a1342d4b37fac50b85b31.1487812849.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <83baafed74beeee75a6a1342d4b37fac50b85b31.1487812849.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <9127EA63A82B304DAA165DCA54658D42-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Ranadive, Adit (VMware)" <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 2/22/17, 8:22 PM, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of Adit
Ranadive" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
wrote:

>Removed the unused nreq and redundant index variables.
>Moved hardcoded async and cq ring pages number to macro.
>
>Reported-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>---
> drivers/infiniband/hw/vmw_pvrdma/pvrdma.h      |  2 ++
> drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c |  4 ++--
> drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c   | 33
>++++++++++----------------
> 3 files changed, 17 insertions(+), 22 deletions(-)

Tested-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
