From: "Boyer, Andrew" <Andrew.Boyer-8PEkshWhKlo@public.gmane.org>
Subject: Re: [PATCH 7/7] IB/rxe: Avoid ICRC errors by copying into the skb
 first
Date: Tue, 25 Jul 2017 18:00:19 +0000
Message-ID: <D59CFD43.1B523%Andrew.Boyer@emc.com>
References: <1500989968-30889-1-git-send-email-andrew.boyer@dell.com>
 <1500989968-30889-8-git-send-email-andrew.boyer@dell.com>
 <CAJ3xEMi7qiygVwngd-1q0x7xOf=whGb667t0RQpZ0uRbchw=oA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJ3xEMi7qiygVwngd-1q0x7xOf=whGb667t0RQpZ0uRbchw=oA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <05B1C2751311CC4E830F031796F28557-/m+UfqrgI5Tvk4DGDgVwFwC/G2K4zDHf@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Hubbe, Allen" <Allen.Hubbe-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 7/25/17, 1:34 PM, "Or Gerlitz" <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

>On Tue, Jul 25, 2017 at 4:39 PM, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
>wrote:
>> If the buffer contents are changing,
>
>can you please elaborate on that a little further? what are unchanged
>contents and what are changing contents?

In qperf, the ud_bi_bw test allocates a single buffer on each side. Then
it posts that one buffer 1024 times for receive and 1024 times for send.
While RXE is building up the send packet, the buffer is being overwritten
by incoming receives.


The current process of first calculating the CRC and then copying the
buffer into the packet leaves a window in which the contents and the CRC
can get out of sync. By copying the buffer into the packet and then
calculating the CRC based on the packet contents we eliminate the window.

This seems like very strange/reckless client behavior, but whether the
client has mangled the buffer or not RXE should be able to transfer it
reliably.

Thanks,
Andrew

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
