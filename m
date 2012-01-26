From: Joseph Glanville <joseph.glanville-2MxvZkOi9dvvnOemgxGiVw@public.gmane.org>
Subject: Re: memory region limit at 32 GB?
Date: Fri, 27 Jan 2012 09:37:33 +1100
Message-ID: <CAOzFzEi=Q2kZvTBt9RN=1c4irzGWeSDeN2qULbL_ep5G9_j5Vw@mail.gmail.com>
References: <CALfB72D_bp-XEBtAyntZzxF6RvxGyHJjsmsVEzjP8LyVxgAi7A@mail.gmail.com>
	<CAL1RGDV8R1S3L-RH-fWH=LfFegJzwNZPhdNyoQG0ZBEtQQwPjQ@mail.gmail.com>
	<CAL1RGDWKg_+VZ0Gxqvf9-4W9O-YU_6euE7jOqbmdN6=zWiNS8A@mail.gmail.com>
	<CALfB72DdN9onmiqUhWqbPNC6Qf00TB_pC3UkM0xKQQJMg+zMKA@mail.gmail.com>
	<CAL1RGDU8sFGyx9WQtLQ6kYN9HhhCctQvm+_dYthpAmMUs2RmkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDU8sFGyx9WQtLQ6kYN9HhhCctQvm+_dYthpAmMUs2RmkQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

Romley is likely to support >1TB in 2 and 4 socket boards.
I rememeber when it was hard to fit 1TB in a rack let alone a 1U chasis=
=2E.

Joseph.

On 21 January 2012 05:38, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org> wrote:
> On Fri, Jan 20, 2012 at 10:30 AM, Albert Strasheim <fullung-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org=
> wrote:
>> FYI, new Sandy Bridge motherboards will be out soon that do 512 GB a=
nd
>> even 768 GB.
>
> Yeah, Cisco UCS C260 goes up to 1TB in a 2socket 2U already so we rea=
lly
> should fix this. =A0I'll cook something up.
>
> The good news is that the overhead is that we use more memory for ada=
pter
> context, but if you have 1TB of RAM you probably don't care about a f=
ew
> more MB over overhead :)
>
> =A0- R.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"=
 in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html



--=20
=46ounder | Director | VP Research
Orion Virtualisation Solutions=A0|=A0www.orionvm.com.au=A0| Phone: 1300=
 56
99 52 | Mobile: 0428 754 846
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
