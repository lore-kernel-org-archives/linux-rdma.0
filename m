From: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] opensm/osm_sa.c: In osm_sa_respond, only fill in attr
 offset if RMPP method
Date: Fri, 11 Jun 2010 09:44:10 -0700
Message-ID: <3F6F638B8D880340AB536D29CD4C1E1925634C8FE9@orsmsx501.amr.corp.intel.com>
References: <20100603134209.GA12225@comcast.net> <20100609054341.GK28549@me>
 <AANLkTilkr6KYG_TVJYwvNl7sZ8XBKmFljktxg8qCA9t9@mail.gmail.com>
 <20100609121036.GC20172@me>
 <AANLkTikTxpvb-Nw2V1PrBcX4rZ1GwElXV22CBtBZx1iK@mail.gmail.com>
 <20100609124848.GE20172@me>
 <AANLkTinxeLPtxYPvPBZfWq96BZjxDqcAlCzP2v_1VJnv@mail.gmail.com>
 <20100609171516.GI20172@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Smith, Stan wrote:
> <snip...>
>
> Following discussion is tangential to Hal's patch.
>
> Last night I came across an curious discovery.
> sizeof(ib_inform_info_t)        == 36.
> sizeof(ib_inform_info_record_t) == 64.
>
> My debug version of 'osmtest -f v' trips CL_ASSERT() in
> ib_get_attr_offset() osmteset.c::osmtest_informinfo_request()for
> ib_get_attr_offset(rec), where rec is ib_inform_info_t.
>
> The winOFED ib_types.h & OFED ib_types.h match w.r.t. definitions for
> ib_inform_info_t & ib_inform_info_record_t.
>
> Question: should ib_inform_info_t be 8-byte aligned with padding in
> ib_inform_info_record_t adjusted or should we remove the CL_ASSERT()
> from ib_get_attr_offset()?
>
> stan.

According to the IB spec, ib_inform_info_t is not 8-byte aligned, so removing the CL_ASSERT() makes sense.
Sorry about extra work incurred, I thought I had tested all cases.

stan.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
