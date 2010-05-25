From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH] ib_types.h add debug assert
Date: Tue, 25 May 2010 14:24:02 +0300
Message-ID: <20100525112402.GQ28549@me>
References: <3F6F638B8D880340AB536D29CD4C1E192562EBBC01@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3F6F638B8D880340AB536D29CD4C1E192562EBBC01-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Smith, Stan" <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 10:49 Fri 21 May     , Smith, Stan wrote:
> 
> Add a debug assert to catch incorrect MAD attr offset size.
> This proved to be useful in catching incorrect struct sizes as MAD attrs need to be a multiple of 8 bytes.

Could you clarify where was it useful and where such errors were seen?

> 
> signed-off-by: stan smith <stan.smith-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Applied (again - by hands). Thanks.

Sasha

> 
> diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib_types.h
> index e1bc102..203c319 100644
> --- a/opensm/include/iba/ib_types.h
> +++ b/opensm/include/iba/ib_types.h
> @@ -4395,6 +4395,7 @@ static inline uint32_t OSM_API ib_get_attr_size(IN const ib_net16_t attr_offset)
> 
>  static inline ib_net16_t OSM_API ib_get_attr_offset(IN const uint32_t attr_size)
>  {
> +       CL_ASSERT((attr_size & 0x07) == 0);
>         return (cl_hton16((uint16_t) (attr_size >> 3)));
>  }
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
