From: Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH] opensm/osm_sa.c: In osm_sa_respond, only fill in attr
	offset if RMPP method
Date: Fri, 11 Jun 2010 15:04:28 -0400
Message-ID: <AANLkTil8nl63FCXz6nN4JSIM5l8VqemrQYx2fsAzSjll@mail.gmail.com>
References: <20100603134209.GA12225@comcast.net>
	<20100609054341.GK28549@me>
	<AANLkTilkr6KYG_TVJYwvNl7sZ8XBKmFljktxg8qCA9t9@mail.gmail.com>
	<20100609121036.GC20172@me>
	<AANLkTikTxpvb-Nw2V1PrBcX4rZ1GwElXV22CBtBZx1iK@mail.gmail.com>
	<20100609124848.GE20172@me>
	<AANLkTinxeLPtxYPvPBZfWq96BZjxDqcAlCzP2v_1VJnv@mail.gmail.com>
	<20100609171516.GI20172@me>
	<3F6F638B8D880340AB536D29CD4C1E1925634C8F42@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E1925634C8F42-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, Jun 11, 2010 at 12:02 PM, Smith, Stan <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wr=
ote:
> <snip...>
>
> Following discussion is tangential to Hal's patch.
>
> Last night I came across an curious discovery.
> sizeof(ib_inform_info_t) =C2=A0 =C2=A0 =C2=A0 =C2=A0=3D=3D 36.
> sizeof(ib_inform_info_record_t) =3D=3D 64.

Those match the IBA spec (InformInfoRecord being padded whereas
InformInfo is not).

> My debug version of 'osmtest -f v' trips CL_ASSERT() in ib_get_attr_o=
ffset() osmteset.c::osmtest_informinfo_request()for ib_get_attr_offset(=
rec), where rec is ib_inform_info_t.
>
> The winOFED ib_types.h & OFED ib_types.h match w.r.t. definitions for=
 ib_inform_info_t & ib_inform_info_record_t.
>
> Question: should ib_inform_info_t be 8-bye aligned with padding in ib=
_inform_info_record_t adjusted or should we remove the CL_ASSERT() from=
 ib_get_attr_offset()?

Why does osmtest need to call this routine ? I think most if not all
of those calls should be removed. Attribute offset only needs setting
when RMPP and most SA client invocations of things like Get and
GetTable are not RMPP (response is). I know osmtest does some negative
testing of SA like invalid methods for a given attribute.

-- Hal

>
> stan.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
