From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] iba/ib_types.h: remove assertion in ib_get_attr_offset()
Date: Mon, 14 Jun 2010 09:16:41 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF259E0EB4FF@orsmsx501.amr.corp.intel.com>
References: <20100603134209.GA12225@comcast.net> <20100609054341.GK28549@me>
 <AANLkTilkr6KYG_TVJYwvNl7sZ8XBKmFljktxg8qCA9t9@mail.gmail.com>
 <20100609121036.GC20172@me>
 <AANLkTikTxpvb-Nw2V1PrBcX4rZ1GwElXV22CBtBZx1iK@mail.gmail.com>
 <20100609124848.GE20172@me>
 <AANLkTinxeLPtxYPvPBZfWq96BZjxDqcAlCzP2v_1VJnv@mail.gmail.com>
 <20100609171516.GI20172@me>
 <3F6F638B8D880340AB536D29CD4C1E1925634C8FE9@orsmsx501.amr.corp.intel.com>
 <20100614130404.GZ20172@me>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100614130404.GZ20172@me>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Since not all SA attributes should be multiple of 8 bytes (specifically
> InformInfo).

I thought the issue was that the C-struct definition was required to be a multiple of 8-bytes, not the actual SA attribute definition, ..

>  static inline ib_net16_t OSM_API ib_get_attr_offset(IN const uint32_t
> attr_size)
>  {
> -	CL_ASSERT((attr_size & 0x07) == 0);
>  	return (cl_hton16((uint16_t) (attr_size >> 3)));
>  }

which causes this to fail, since it lops off the lower bits of the size, rather than rounding up.

I would either expect the assert to always work or the code to round up properly.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
