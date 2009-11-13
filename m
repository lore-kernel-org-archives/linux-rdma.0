From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_state_mgr.c: force heavy sweep when fabric
 consists of single switch
Date: Fri, 13 Nov 2009 17:20:11 +0200
Message-ID: <20091113152011.GP7192@me>
References: <4AF27EDB.6070604@dev.mellanox.co.il>
 <4AF6D619.8000908@gmail.com>
 <4AF7D040.2060807@dev.mellanox.co.il>
 <4AF7F22D.9010609@gmail.com>
 <4AF7F864.6030809@dev.mellanox.co.il>
 <4AF81F15.1080205@gmail.com>
 <4AFA80A5.8080809@dev.mellanox.co.il>
 <4AFBC1B7.8090509@gmail.com>
 <4AFC04A8.1040808@dev.mellanox.co.il>
 <694d48600911130024vd803e5fhf835690742f14ba7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <694d48600911130024vd803e5fhf835690742f14ba7-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Eli Dorfman <dorfman.eli-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, Line Holen <Line.Holen-xsfywfwIY+M@public.gmane.org>, Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10:24 Fri 13 Nov     , Eli Dorfman wrote:
> On Thu, Nov 12, 2009 at 2:50 PM, Yevgeny Kliteynik
> <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> > Eli Dorfman (Voltaire) wrote:
> >>
> >> Yevgeny Kliteynik wrote:
> >>>
> >>> Eli Dorfman (Voltaire) wrote:
> >>>>
> >>>> Yevgeny Kliteynik wrote:
> >>>>>
> >>>>> Eli Dorfman (Voltaire) wrote:
> >>>>>>
> >>>>>> Yevgeny Kliteynik wrote:
> >>>>>>>
> >>>>>>> Eli Dorfman (Voltaire) wrote:
> >>>>>>>>
> >>>>>>>> Yevgeny Kliteynik wrote:
> >>>>>>>>>
> >>>>>>>>> Yevgeny Kliteynik wrote:
> >>>>>>>>>>
> >>>>>>>>>> Line Holen wrote:
> >>>>>>>>>>>
> >>>>>>>>>>> On 11/ 4/09 04:54 PM, Yevgeny Kliteynik wrote:
> >>>>>>>>>>>>
> >>>>>>>>>>>> Line Holen wrote:
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> On 11/ 4/09 10:47 AM, Yevgeny Kliteynik wrote:
> >>>>>>>>>>>>>>
> >>>>>>>>>>>>>> Sasha Khapyorsky wrote:
> >>>>>>>>>>>>>>>
> >>>>>>>>>>>>>>> On 12:26 Tue 03 Nov =A0 =A0 , Yevgeny Kliteynik wrote=
:

This is a nice and productive discussion. But please remove a context
which is not related to the current point - it helps to follow thread.

[snip]

> >> The PSC bit should be cleared before SM reads the PortInfo from th=
at
> >> switch.
> >
> > This may be true, but do you really want to require
> > Set(SwitchInfo) *completion* before getting other PortInfo
> > MADs from this switch?
>=20
> I don't see any other good alternative and I'm sure this will solve
> all race conditions.

I agree with Eli - if we want to prevent PSC bit loss (which can be
relevant for any subnet/SM topology), we need to clear it first and tha=
n
to fetch PortInfo. Obviously this may have some performance penalty, bu=
t
proper discovery is more important.

> I suggest that when PSC bit is set in SwitchInfo response we will sen=
d
> Set(SwitchInfo) to clear the PSC bit and
> in SwitchInfo response send Get(PortInfo) - this requires adding
> another flag to the mad context.

Another flag or reusing one of existing flag.

> If PSC bit is not set or SM is not in Master state Get(PortInfo) will
> be done in the immediately.
>=20
> what do you think?

Another potential issue is to avoid a secondary trap triggered sweep fo=
r
cases when PSC change is already cached.

Basically looks like a right direction for me.

Sasha
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
