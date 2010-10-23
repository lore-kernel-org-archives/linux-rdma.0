From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [RFC 2/12] ib-mgmt: provide MAD definitions with libibumad
Date: Sat, 23 Oct 2010 13:06:01 -0600
Message-ID: <20101023190601.GA10883@obsidianresearch.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7EE@orsmsx501.amr.corp.intel.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7F1@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7F1-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sat, Oct 23, 2010 at 12:00:59AM -0700, Hefty, Sean wrote:
> The only definitions for MAD data types are in ib_types.h, which
> is an opensm file.  The libibumad interface is essentially useless
> without these data types.  Add new header files to libibumad
> with basic MAD data types.

This is nice, lots of work! Wow!

> +/* Management base version */
> +#define UMAD_BASE_VERSION		1

Could you elaborate in the comment what you see this being used for?

> +struct umad_hdr {

Could we agree on a naming scheme? I was thinking umad_hdr_NE or
somesuch to identify these all as network endian. It is actually
pretty confusing in someplaces what is what. Ie for instance the
ibv_sa_path_rec is unpacked but in network endian, while things
like ibv_ah_attrs are in host endian. I've made errors getting this
right before (partly because there are no docs..)

> +#define	UMAD_OPENIB_OUI		(0x001405)

Enum?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
