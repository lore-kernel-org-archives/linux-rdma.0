From: Richard Sharpe <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Can I call routines like ib_post_{send,recv} from completion
 queue callbacks?
Date: Mon, 23 Sep 2013 20:13:50 -0700
Message-ID: <CACyXjPz=V0PXEm761t0PsbFNLqhKpnsJr00A70zgnSh2osevXw@mail.gmail.com>
References: <CACyXjPxMsw=dMGzH7pycit5=1oEv4dOUjiWbQFz5+LjwuVRS6Q@mail.gmail.com>
	<CACyXjPyGBC=bBZ6fWGe_LeHMNpHqDk+hPttA6RFDBaVC=5BZ-Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CACyXjPyGBC=bBZ6fWGe_LeHMNpHqDk+hPttA6RFDBaVC=5BZ-Q-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Sep 23, 2013 at 10:55 AM, Richard Sharpe
<realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> On Mon, Sep 23, 2013 at 5:02 AM, Richard Sharpe
> <realrichardsharpe-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> Hi folks,
>>
>> I am trying to figure out the reason for the latest hang in my SMB
>> Direct driver for Linux.
>>
>> Should I be calling ib_post_{send,recv} from completion queue
>> callbacks or should I be doing it from a different context, like a
>> work queue?
>
> Just to clarify, calling ib_post_recv from a CM callback seems fine.
>
> My problem has been with calling ib_post_send from within the callbac=
k
> resulting from the completion of a RECV.
>
> Is that appropriate to do?

=46irst, it was a copy-paste error. This is not the memory region you
are looking for.

Next. Scheduling while atomic. Clearly, not appropriate.

--=20
Regards,
Richard Sharpe
(=A6=F3=A5H=B8=D1=BC~=A1H=B0=DF=A6=B3=A7=F9=B1d=A1C--=B1=E4=BE=DE)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
