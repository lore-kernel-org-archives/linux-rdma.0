From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: libmlx4 and setting the doorbell qpn
Date: Mon, 10 Oct 2011 19:36:30 +0200
Message-ID: <CAO+b5-ojgHpLJL7V0C51mN_qTwTSWN8qP+RhhcRxERAnZW9bkA@mail.gmail.com>
References: <CAO+b5-pXXBmVBomOFed7Js4LqyRqseoPEeVCsoeinA1VSTT==Q@mail.gmail.com>
 <CAL1RGDVJFwzv8ggnEYbOXtGriLKxYyFxbV9tGOF1ah8rcG9gvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDVJFwzv8ggnEYbOXtGriLKxYyFxbV9tGOF1ah8rcG9gvQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 10, 2011 at 6:28 PM, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>=
 wrote:
> actually I think the relevant definitions are:
>
> =A0 =A0 =A0 =A0struct mlx4_wqe_ctrl_seg *ctrl;
>
> and
>
> struct mlx4_wqe_ctrl_seg {
> =A0 =A0 =A0 =A0uint32_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0owner_opcode;
> =A0 =A0 =A0 =A0uint8_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 reserved[3];
> =A0 =A0 =A0 =A0...
>
> so reserved actually is a pointer to a 3-byte area.
>
> So aliasing rules aside, I think the code is fine and
> can be fixed by inserting a cast to void * before the
> cast to uint32_t *.

I agree that that would be sufficient to suppress the compiler warning.

However, in general I'm not enthusiast about inserting such casts
because that can lead to incorrect code generation. A quote from the
gcc manual (http://gcc.gnu.org/onlinedocs/gcc-4.6.1/gcc/Optimize-Option=
s.html):

<quote>
-fstrict-aliasing Allow the compiler to assume the strictest aliasing
rules applicable to the language being compiled. For C (and C++), this
activates optimizations based on the type of expressions. In
particular, an object of one type is assumed never to reside at the
same address as an object of a different type, unless the types are
almost the same. For example, an unsigned int can alias an int, but
not a void* or a double. A character type may alias any other type.
</quote>

If I interpret the above correctly, if two pointers point to the same
memory location but have different types (other than char *) and both
pointers are used to store a value, then with -fstrict-aliasing
enabled the compiler is allowed to interchange the two store
operations. Something that would have unexpected effects of course.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
