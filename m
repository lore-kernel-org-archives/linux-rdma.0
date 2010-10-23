From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC 11/12] ib-mgmt: move ntohll/htonll from mad.h to umad.h
Date: Sat, 23 Oct 2010 13:12:24 -0600
Message-ID: <20101023191224.GC10883@obsidianresearch.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7EE@orsmsx501.amr.corp.intel.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7FB@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7FB-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Oct 23, 2010 at 12:12:58AM -0700, Hefty, Sean wrote:

> +#if __BYTE_ORDER == __LITTLE_ENDIAN
> +  #ifndef ntohll
> +    #define ntohll(x) bswap_64(x)
> +  #endif
> +#elif __BYTE_ORDER == __BIG_ENDIAN
> +  #ifndef ntohll
> +    #define ntohll(x) (x)
> +  #endif
> +#endif
> +#ifndef htonll
> +  #define htonll ntohll
> +#endif
> +

The inline verions of these had the advantage that they enforce the
type, particularly on BE systems, it is a nice check to have..

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
