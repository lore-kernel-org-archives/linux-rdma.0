From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [RFC 2/12] ib-mgmt: provide MAD definitions with libibumad
Date: Sat, 23 Oct 2010 19:01:37 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B87B@orsmsx501.amr.corp.intel.com>
References: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7EE@orsmsx501.amr.corp.intel.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B809B7F1@orsmsx501.amr.corp.intel.com>
 <20101023190601.GA10883@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20101023190601.GA10883-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > +/* Management base version */
> > +#define UMAD_BASE_VERSION		1
> 
> Could you elaborate in the comment what you see this being used for?

The comment should just go.  This is copy-paste from the kernel headers.

> > +struct umad_hdr {
> 
> Could we agree on a naming scheme? I was thinking umad_hdr_NE or
> somesuch to identify these all as network endian. It is actually
> pretty confusing in someplaces what is what. Ie for instance the
> ibv_sa_path_rec is unpacked but in network endian, while things
> like ibv_ah_attrs are in host endian. I've made errors getting this
> right before (partly because there are no docs..)

maybe we should define net16/be16, etc. data types, similar to the kernel and ib_types?

> > +#define	UMAD_OPENIB_OUI		(0x001405)
> 
> Enum?

sure - unless someone can think of a reason why that wouldn't work
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
