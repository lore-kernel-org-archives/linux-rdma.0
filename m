From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH 01/15] IB/rxe: Suppress sparse warnings
Date: Mon, 9 Jan 2017 14:27:03 +0000
Message-ID: <D499079D.9009%Andrew.Boyer@emc.com>
References: <1483353316.3592.14.camel@sandisk.com>
 <1483353409.3592.15.camel@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1483353409.3592.15.camel-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Content-Language: en-US
Content-ID: <9EA8C936EBCF7D4190BDD6DA01E7D6A7-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 1/2/17, 5:39 AM, "Bart Van Assche" <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:

>Avoid that sparse complains about using 0 as a pointer. Avoid that
>sparse complains about missing function declarations. Avoid that
>sparse complains about
>endianness.
>
>Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
>Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
>Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
>---
> drivers/infiniband/sw/rxe/rxe_net.c  | 8 ++++----
> drivers/infiniband/sw/rxe/rxe_recv.c | 2 +-
> 2 files changed, 5 insertions(+), 5 deletions(-)

Reviewed-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
