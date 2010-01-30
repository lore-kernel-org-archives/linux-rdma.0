From: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH 0/7] Increase maximum Infiniband HCAs per-system
Date: Fri, 29 Jan 2010 23:13:00 -0800
Message-ID: <adamxzwkqv7.fsf@roland-alpha.cisco.com>
References: <20100129214039.17745.38679.stgit@bob.kio>
	<adar5p8ldxv.fsf@roland-alpha.cisco.com>
	<20100129234145.GC5177@ldl.fc.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100129234145.GC5177-e+Ta4ugHZmL3oGB3hsPCZA@public.gmane.org> (Alex Chiang's message of
	"Fri, 29 Jan 2010 16:41:45 -0700")
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Chiang <achiang-VXdhtT5mjnY@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, justin.chen-VXdhtT5mjnY@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

 > What I'm a little unsure of is, does IB_UMAD_MAX_AGENTS need to
 > double too? We don't export the agent id in the filesystem
 > anywhere, but we do give it to the user via an ioctl. That's just
 > used for book keeping purposes but...

I don't think so.  That is a limit on "agents" registered per open file,
so it is orthogonal to the number of devices.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
