From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH V2 5/5] RDMA CM: Netlink Client
Date: Tue, 30 Nov 2010 12:01:15 -0700
Message-ID: <20101130190115.GL16788@obsidianresearch.com>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com>
 <1291047399-430-6-git-send-email-nirm@voltaire.com>
 <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8924212@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25B8924212-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org" <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "monis-smomgflXvOZWk0Htik3J/w@public.gmane.org" <monis-smomgflXvOZWk0Htik3J/w@public.gmane.org>, "ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org" <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Nov 30, 2010 at 08:13:45AM -0800, Hefty, Sean wrote:
> > +struct rdma_cm_id_stats {
> > +	enum rdma_node_type nt;
> > +	int port_num;
> > +	int bound_dev_if;
> > +	__be16	local_port;
> > +	__be16	remote_port;
> > +	__be32	local_addr[4];
> > +	__be32	remote_addr[4];
> 
> Please use sockaddr_storage, so that we can expand the rdma_cm
> beyond ipv4/6 address support.

Actually for netlink the proper thing to do here is to place the
sockaddr in a sub-attribute that can be variable-sized. Do not put
variably sized data into a struct like this.

Further, sockaddr_storage is not actually ABI guaranteed to be
constant in size, it is just the current largest sockaddr
possible. This is why the sockaddr size in/out parameter associated
with all sockaddrs is so important.

Don't put sockaddrs in fixed-size structures for user/kernel
interfaces.

Jason
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
