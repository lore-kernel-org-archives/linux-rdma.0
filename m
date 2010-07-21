From: Josh England <jjengla-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: NULL pointer dereference in rdma_ucm
Date: Tue, 20 Jul 2010 17:14:55 -0700
Message-ID: <AANLkTimdl7BRoX7O_T68BwjUGSIQ7c0X5Syn4eDDkk9K@mail.gmail.com>
References: <AANLkTikwDEJY_F1ziGNPhYMBJEBC5UqD2XOLM7wSByj1@mail.gmail.com>
	<adazkxlq3jn.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <adazkxlq3jn.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

My kernel selections are limited to which versions I can get a panfs
module for.  The most recent kernel I see support for is a 2.6.31
variant from FC12.  I could ask them for a custom port for a newer
mainline kernel but the turn-around will likely be several weeks.
I'll go ahead and ask for one I guess.

It looks like 2.6.18 WARN_ON doesn't really do much:
#define WARN_ON(condition) do { if (condition) ; } while (0)

-JE

On Tue, Jul 20, 2010 at 1:52 PM, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrot=
e:
> =A0> I'm experimenting with an rdma_cm application to push data aroun=
d
> =A0> between nodes on an ~1000 node cluster (CentOS-5.3 with 2.6.18-1=
28.el5
> =A0> and OFED-1.4.2). =A0Under heavy load, I'm seeing several nodes p=
er day
> =A0> kernel panic due to a NULL pointer dereference. =A0It may be tha=
t the
> =A0> in-kernel field cm_id_priv has a NULL ->alt_av.port , causing th=
e
> =A0> Oops, but I don't know for sure. =A0Any ideas on how to debug th=
is?
>
> You have a pretty unsupportable combination of ancient kernel and old
> OFED stack. =A0Is there any way you can test this with a recent mainl=
ine
> kernel?
>
> If I were debugging this I guess I would try to find out for sure whe=
re
> the NULL dereference occurs -- I guess ib_cm_init_qp_attr() has all t=
he
> leaf functions (cm_init_qp_init_attr etc) inlined, so the first step
> would be to figure out which one of those functions you're crashing i=
n
> (and also confirm that it's always the same one). =A0You could do tha=
t by
> marking them noinline, or just put a WARN_ON(!<ptr>) before every
> pointer dereference (does 2.6.18 even have WARN_ON?).
>
> =A0- R.
> --
> Roland Dreier <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> || For corporate legal information =
go to:
> http://www.cisco.com/web/about/doing_business/legal/cri/index.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
