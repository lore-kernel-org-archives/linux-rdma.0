From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: ibv_create_qp() and max_inline_data behavior
Date: Thu, 29 Aug 2013 09:33:13 +0300
Message-ID: <20130829093313.272a651f@jpm-OptiPlex-GX620>
References: <d7685e13978f93890b2939c5ac2d5c7f@meuh.org>
	<dd17b84e216b2b8d578fca0f6fd0567b.squirrel@email.fatcow.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <dd17b84e216b2b8d578fca0f6fd0567b.squirrel-x2CLHAACdUlE/1XJwoXD2w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dotan-Hqos5LYUzRNWk0Htik3J/w@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanba-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 28 Aug 2013 13:45:17 -0400
dotan-Hqos5LYUzRNWk0Htik3J/w@public.gmane.org wrote:

> Hi Yann.
>=20
>=20
> >
> > I'd like the behavior of ibv_create_qp() regarding
> > cap.max_inline_data be clearer:
> >
> > 1) Should ibv_create_qp() failed if max_inline_data requested being
> > greater than supported ?
> Since the max_inline_data is an extension, the InfiniBand spec doesn'=
t
> specify the expected behavior.  However, the spirit of the spec is to
> return a failure if not all of the requested attributes can be
> satisfied.
>=20

In the Infiniband Spec revision 1.2.1, section 11.2.4.1 CREATE QUEUE
PAIR, we see that the output modifiers specify that for all input
parameters, the queue be created with at least the number of resources
specified.
=46or example:
=E2=80=A2 The actual number of scatter/gather elements that can be spec=
i-
  fied in Work Requests submitted to the Send Queue. If an error is
  not returned, this is guaranteed to be greater than or equal to the
  number requested.

Thus, although the max_inline_data is an extension, it should clearly
behave in exactly the same fashion.

-Jack


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
