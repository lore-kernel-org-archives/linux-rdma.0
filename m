From: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Subject: Re: [PATCH 0/7] Increase maximum Infiniband HCAs per-system
Date: Fri, 29 Jan 2010 16:41:45 -0700
Message-ID: <20100129234145.GC5177@ldl.fc.hp.com>
References: <20100129214039.17745.38679.stgit@bob.kio> <adar5p8ldxv.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <adar5p8ldxv.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, justin.chen-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

* Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>:
> 
> Have you considered drivers/infiniband/core/user_mad.c and ucm.c?

Ah, darn. I had not considered those drivers. You're gonna make
me learn a lot more about IB than I'd originally intended. ;)

> I think user_mad.c is somewhat more important, as that is what
> allows an adapter to be used for running the SM.  So I think
> we're still left with some potential issues around lots of
> adapters in one system.  (I think use of ucm by real apps is
> minimal to nonexistent, but someday we should deal with that
> too)

Ok, a quick glance through those drivers shows:

	enum {
		IB_UMAD_MAX_PORTS  = 64,
		IB_UMAD_MAX_AGENTS = 32,

		IB_UMAD_MAJOR      = 231,
		IB_UMAD_MINOR_BASE = 0
	};

and

	enum {
		IB_UCM_MAJOR = 231,
		IB_UCM_BASE_MINOR = 224,
		IB_UCM_MAX_DEVICES = 32
	};

They're all sharing the same major number, so they'll all have to
get the same treatment as the uverbs driver wrt overflow (to
prevent minor number overlap).

What I'm a little unsure of is, does IB_UMAD_MAX_AGENTS need to
double too? We don't export the agent id in the filesystem
anywhere, but we do give it to the user via an ioctl. That's just
used for book keeping purposes but...

Currently, there are 2x as many ports as there are agents. Do we
want to keep that ratio, or would it be ok to have 4x as many
ports as there are agents?

Thanks (and sorry for the n00b questions).

/ac
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
