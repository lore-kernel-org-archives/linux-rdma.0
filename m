From: "ira.weiny" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 39/49] IB/hfi1: add sysfs routines
Date: Wed, 8 Jul 2015 19:22:42 -0400
Message-ID: <20150708232240.GA19936@phlsvsds.ph.intel.com>
References: <20150615132434.29741.35258.stgit@phlsvslse11.ph.intel.com> <20150615132929.29741.87559.stgit@phlsvslse11.ph.intel.com> <CAJ3xEMiiqY04q4pnjRSm=7UBnS_jQJP-KhAkYEvu7FAu-F98sA@mail.gmail.com> <CAJ3xEMiJ_0pFUvPJN7ov50v0hOZVsN7qC27ZbG5+pfmVuZQuMw@mail.gmail.com> <32E1700B9017364D9B60AED9960492BC257513D9@fmsmsx120.amr.corp.intel.com> <CAJ3xEMjdhyk2OOfeCV4sZMF=Fh06H-hJn_2y85V0eBLYBBgPiA@mail.gmail.com> <32E1700B9017364D9B60AED9960492BC2575DB49@fmsmsx120.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <32E1700B9017364D9B60AED9960492BC2575DB49-RjuIdWtd+YbTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Marciniszyn, Mike" <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <gerlitz.or-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, Jul 08, 2015 at 10:32:44PM +0000, Marciniszyn, Mike wrote:
> > > This sysfs entries are used by PSM2 to form packets from user space.
> > 
> > You didn't explain what's SC and what's SC-to-VL and why PSM2 can't talk to
> > the SM to query that.

Like IB the SL to SC to VL maps are available via SMA queries on the local
port.  However, it is more secure if SMP queries are limited to root or
management nodes.  (This is also true in IB.)

So requiring PSM, ie regular applications, to issue SMA queries on the local
port is not appropriate as it precludes a more secure policy of restricting
the umad interface.

sysfs is IMO a reasonable interface to communicate these tables to regular
user applications.

Ira

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
