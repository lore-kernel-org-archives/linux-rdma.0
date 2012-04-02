From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 2/2] IB/core: add missing string for the display of SDR
 rates in sysfs
Date: Mon, 2 Apr 2012 21:50:19 +0300
Message-ID: <CAJZOPZLWmBDBc7HpzWYa9etiiq4ZKeqP6XTYOat6mino8en3aA@mail.gmail.com>
References: <1333377921-8349-1-git-send-email-ogerlitz@mellanox.com>
	<1333377921-8349-3-git-send-email-ogerlitz@mellanox.com>
	<CAL1RGDUCO+ijdYyaPsx7X9eYssj-qDEqeYm-gSAY30NwYo1Qpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDUCO+ijdYyaPsx7X9eYssj-qDEqeYm-gSAY30NwYo1Qpg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Mon, Apr 2, 2012 at 8:42 PM, Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> wrote=
:
> On Mon, Apr 2, 2012 at 7:45 AM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wr=
ote:
> > =A0 =A0 =A0 =A0switch (attr.active_speed) {
> > =A0 =A0 =A0 =A0case IB_SPEED_SDR:
> > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 speed =3D " SDR";
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0rate =3D 25;
> > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0break;
> > =A0 =A0 =A0 =A0case IB_SPEED_DDR:
>
> I don't think we want this -- old kernels didn't print "SDR" so I thi=
nk
> we shouldn't change the interface at this point.

Oh, I see what you mean - and I don't think we need to consider this
as interface change - these is an interface - namely "nGbs (mX DDD)
where n is number  m is number and DDD is string (SDR, DDR, QDR,
=46DR10, etc) and this interface was buggy to wrong print certain cases=
,
which we fixed in the two commits I mentioned. Now we found another
bug ("SDR" not printed) and we fix it (hopefully the last one in this
function) - that's all. I don't think we should assume there are
apps/libs up their who set their code to match the exact bugs we had
in sysfs, it was just not important enough the report on, or they
didn't hit it (e.g SDR is pretty not common now), thoughts?

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
