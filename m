From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH 3/3] IB/sa: route SA pathrecord query through netlink
Date: Tue, 19 May 2015 13:21:41 -0600
Message-ID: <20150519192141.GS18675@obsidianresearch.com>
References: <1431975616-23529-1-git-send-email-kaike.wan@intel.com>
 <1431975616-23529-4-git-send-email-kaike.wan@intel.com>
 <555AC36D.5050904@mellanox.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CAB243E@CRSMSX101.amr.corp.intel.com>
 <CAJ3xEMhkpYYtzrsOw=8JQOekpVT6xQC9P2itH3H3oAjjPfWrng@mail.gmail.com>
 <3F128C9216C9B84BB6ED23EF16290AFB0CAB2677@CRSMSX101.amr.corp.intel.com>
 <CAJ3xEMj8zmqj_3=ms9CXxrFVmmk7ZHHtcPXGJcAO24n1U_MSiQ@mail.gmail.com>
 <2807E5FD2F6FDA4886F6618EAC48510E11082B44@CRSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <2807E5FD2F6FDA4886F6618EAC48510E11082B44-8k97q/ur5Z2krb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Fleck, John" <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, May 19, 2015 at 07:17:49PM +0000, Weiny, Ira wrote:
> > Not sure, pick one of these, whatever works for you the best.
>=20
> No this will not work.  We don't want to use the timeout the caller
> provides.  The timeout for netlink may (and should be) different
> from the timeout needed when sending to the SA directly.

Why?

> N?????r??y????b?X??=C7=A7v?^?)=DE=BA{.n?+????{??=D9=9A?{ay?=1D=CA=87=DA=
=99?,j=07??f???h???z?=1E?w???=0C???j:+v???w?j?m????=07????zZ+?????=DD=A2=
j"??!

Does anyone else ever wonder what this garbage is on some of the
messages from @intel folks?

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
