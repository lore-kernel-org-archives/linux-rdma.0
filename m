From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Subject: Re: libmlx4 and setting the doorbell qpn
Date: Mon, 10 Oct 2011 11:11:42 -0700
Message-ID: <CAL1RGDWM2m-_3vTrWf6pUmLPLbahe8GsCAxJYALgxDdZtYjS8A@mail.gmail.com>
References: <CAO+b5-pXXBmVBomOFed7Js4LqyRqseoPEeVCsoeinA1VSTT==Q@mail.gmail.com>
 <CAL1RGDVJFwzv8ggnEYbOXtGriLKxYyFxbV9tGOF1ah8rcG9gvQ@mail.gmail.com> <CAO+b5-ojgHpLJL7V0C51mN_qTwTSWN8qP+RhhcRxERAnZW9bkA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-ojgHpLJL7V0C51mN_qTwTSWN8qP+RhhcRxERAnZW9bkA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 10, 2011 at 10:36 AM, Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org> wrote:
> If I interpret the above correctly, if two pointers point to the same
> memory location but have different types (other than char *) and both
> pointers are used to store a value, then with -fstrict-aliasing
> enabled the compiler is allowed to interchange the two store
> operations. Something that would have unexpected effects of course.

My impression was that void* casts tell gcc it can't make any
aliasing assumptions about a pointer.  So I think getting rid of
the warning actually makes sure we don't have bad code generation
here as well.  But I wouldn't swear to that...

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
