From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH 7/7] IB/rxe: Avoid ICRC errors by copying into the skb first
Date: Thu, 27 Jul 2017 16:25:58 +0300
Message-ID: <CAG9sBKN35tGYYcGU_yFfu4PXjpqbrtmoVdDqDZRabE5ehs4mRA@mail.gmail.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
 <1500989968-30889-8-git-send-email-andrew.boyer@dell.com> <CAJ3xEMi7qiygVwngd-1q0x7xOf=whGb667t0RQpZ0uRbchw=oA@mail.gmail.com>
 <D59CFD43.1B523%Andrew.Boyer@emc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <D59CFD43.1B523%Andrew.Boyer-mb1K0bWo544@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hubbe, Allen" <Allen.Hubbe-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This seems like very strange/reckless client behavior, but whether the
> client has mangled the buffer or not RXE should be able to transfer it
> reliably.
>
And what if was overwritten during the memcpy? Then we end up with
wrong ICRC again, right?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
