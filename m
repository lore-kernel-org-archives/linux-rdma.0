From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH rdma-next 00/29] Soft RoCE driver
Date: Thu, 9 Jun 2016 16:17:15 +0300
Message-ID: <CAG9sBKPa0qQ4uuhoWLfZaXP9E+DnLrkOcU-2yNXbdZFQKppN8w@mail.gmail.com>
References: <1464886657-14258-1-git-send-email-monis@mellanox.com> <021601d1bcf9$63dbe8d0$2b93ba70$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <021601d1bcf9$63dbe8d0$2b93ba70$@opengridcomputing.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, leon-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>
> Hey Moni,
>
> I wonder if rxe can utilize the rdmavt library?
>
> Steve.
>
Hi Steve

I don=E2=80=99t find rdmavt helpful for rxe.

1.  I find the design of rdmavt serves the purpose of eliminating code
duplications in QIB/HF1 drivers (which was the initial goal of this
project). So it feels like the design is tied to IB/HF1 architecture
and not to a general device model. To give an example, there is hardly
InfiniBand transport logic implementation in rvt as expected.

2.  Trying to force SoftRoCE on this model will end up with rxe driver
registers to rvt with all ib_device hooks implemented. This makes the
reason to use rvt irrelevant in this case.

3.  Modifying rvt model to make it more suitable for a generic lower
driver model can have a big effect on QIB/HF1 performance. This
probably will raise objections from QIB/HF1 owners. In that context I
want to say that attempts to influence rvt model months ago, when rvt
was still an idea, were rejected with this exact reason (being bad for
QIB/HF1 performance).

4.  The model of userspace library is not clear to me yet but I
suspect that again, there is benefit here for SoftRoCE.

thanks

Moni
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
