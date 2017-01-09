From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH 14/15] IB/rxe: Remove a pointless indirection layer
Date: Mon, 9 Jan 2017 15:09:08 +0000
Message-ID: <D49911A7.9096%Andrew.Boyer@emc.com>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353755.3592.40.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483353755.3592.40.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Content-ID: <A0A85934FC768B4C984AEAA190E1F97D-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/2/17, 5:43 AM, "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:

>Neither rxe->ifc_ops nor any of the function pointers in struct
>struct rxe_ifc_ops ever change. Hence remove the rxe->ifc_ops
>indirection mechanism.
>
>Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
>---
> drivers/infiniband/sw/rxe/rxe.c       |  2 +-
> drivers/infiniband/sw/rxe/rxe_loc.h   | 20 ++++++++++++++--
> drivers/infiniband/sw/rxe/rxe_mcast.c |  4 ++--
> drivers/infiniband/sw/rxe/rxe_net.c   | 43
>+++++++++++------------------------
> drivers/infiniband/sw/rxe/rxe_req.c   |  4 ++--
> drivers/infiniband/sw/rxe/rxe_resp.c  |  4 ++--
> drivers/infiniband/sw/rxe/rxe_verbs.c | 10 ++++----
> drivers/infiniband/sw/rxe/rxe_verbs.h | 22 ------------------
> 8 files changed, 42 insertions(+), 67 deletions(-)

Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
