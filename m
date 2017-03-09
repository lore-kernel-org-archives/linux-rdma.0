From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH 2/3] RDMA/vmw_pvrdma: Dont hardcode QP header page
Date: Thu, 9 Mar 2017 17:06:25 +0000
Message-ID: <D4E6F54E.1382F%Andrew.Boyer@emc.com>
References: <cover.1487812849.git.aditr@vmware.com>
 <cc8a5acd38cd34668540135aea616c4217e30ecf.1487812849.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cc8a5acd38cd34668540135aea616c4217e30ecf.1487812849.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Content-Language: en-US
Content-ID: <EA9E1BEECC091846AA2C79BAE67BA95C-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Ranadive, Adit (VMware)" <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org" <pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On 2/22/17, 8:22 PM, "linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of Adit
Ranadive" <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org on behalf of aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
wrote:

>Moved the header page count to a macro.
>
>Reported-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
>Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
>---
> drivers/infiniband/hw/vmw_pvrdma/pvrdma.h    | 1 +
> drivers/infiniband/hw/vmw_pvrdma/pvrdma_qp.c | 9 +++++----
> 2 files changed, 6 insertions(+), 4 deletions(-)

Tested-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
