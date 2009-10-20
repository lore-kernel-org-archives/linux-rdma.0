From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 1/2] rdma/cm: support option to allow manually setting	IB path
Date: Tue, 20 Oct 2009 11:34:01 -0700
Message-ID: <46770152ACA04B6C8AA9497C45AC8FD0@amr.corp.intel.com>
References: <F0EFC2D8E6A340D48497497670C5969C@amr.corp.intel.com> <A08104C1CF70400F8BEF492AD49C8491@amr.corp.intel.com> <20091020181458.GD14520@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20091020181458.GD14520-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Jason Gunthorpe' <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>Can you please have some way for this to pass APM data and the
>reversible GMP path as well? We know this is a problem, lets not
>introduce new userspace APIs that further enshrine it..

Did you have something specific in mind?

ucma_set_ib_paths should be able to accommodate this; we just need some rules
defined.  More invasive kernel changes are needed to do anything with the extra
paths.

For APM, I'm guessing that you'd like a way to set a new alternate path after
establishing a connection.  ucma_set_ib_paths could still do this based on the
state of the connection.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
