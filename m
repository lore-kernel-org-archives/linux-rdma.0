From: Bart Van Assche <Bart.VanAssche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH 04/15] IB/rxe: Remove an unused variable
Date: Wed, 4 Jan 2017 10:37:07 +0000
Message-ID: <1483526210.3048.6.camel@sandisk.com>
References: <1483353316.3592.14.camel@sandisk.com>
         <1483353498.3592.20.camel@sandisk.com>
         <CAG53R5WnJy1cLdEZOpzk03aAE2L6v86n_-qEBpoaG+arymCxPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG53R5WnJy1cLdEZOpzk03aAE2L6v86n_-qEBpoaG+arymCxPw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <CE4AF1F858ABD942AC7C8FF38C6AB028-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org" <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "andrew.boyer-8PEkshWhKlo@public.gmane.org" <andrew.boyer-8PEkshWhKlo@public.gmane.org>, "monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org" <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, 2017-01-03 at 12:39 -0600, Parav Pandit wrote:
> Additionally, since struct rxe_send_wqe is not used in get_mtu() function=
,
> Can you please update signature to just have rxe_qp* as input argument?

Thanks for the feedback Leon and Parav. BTW, feedback for the other patches
of this series would also be welcome.

Bart.=
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
