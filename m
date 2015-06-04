From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next V2 0/9] Add completion timestamping support
Date: Thu, 4 Jun 2015 17:24:40 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373A8FE4F98@ORSMSX109.amr.corp.intel.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
 <1433098827.114391.179.camel@redhat.com>
 <CAAKD3BBo9A5AV9Uv-q1TgSQ6hs-oSUn5QsUT+5+6mk1RwW7AUA@mail.gmail.com>
 <1433157904.114391.188.camel@redhat.com>
 <20150601164322.GA14391@obsidianresearch.com>
 <1433255724.114391.225.camel@redhat.com>
 <20150602180844.GD17776@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373A8FE4F16@ORSMSX109.amr.corp.intel.com>
 <20150604164759.GC27699@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150604164759.GC27699-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Can you share what the libfabric change would look like to add a
> timestamp field to the completion? That might be informative,
> libfabric is also consuming the kernel UAPI.

Libfabric uses a CQ format option. so this would just require a new format.

There is no type checking on CQ poll (read).  The provider interface looks like this:

struct fi_ops_cq {
	size_t	size;
	ssize_t	(*read)(struct fid_cq *cq, void *buf, size_t count);
	ssize_t	(*readfrom)(struct fid_cq *cq, void *buf, size_t count,
			fi_addr_t *src_addr);

(We could construct static inline calls with type checking if someone wanted that.)

If I were adding timestamps, I would probably define a new completion structure with 2 u64 time stamp fields (start and end times), and figure out when start occurred, end occurred, and the timing metric later.  :)

I would assume that these are non-wrapping values.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
