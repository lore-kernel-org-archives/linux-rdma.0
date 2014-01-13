From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH for-next] IB/usnic: Expose flows via debugfs
Date: Tue, 14 Jan 2014 01:39:22 +0200
Message-ID: <CAJZOPZK9K+kxZ5NuBtir30uOwVciSEVtpxJX6HxZ+xhi9M7whA@mail.gmail.com>
References: <6F4F8D2C-F10F-4697-ABD5-552D2E696361@cisco.com>
	<52B6BDAF.6030407@mellanox.com>
	<BC780FB0-731D-42FA-B003-E61B473B23E2@cisco.com>
	<52CD16CE.7080804@mellanox.com>
	<BDC9DBAD-3303-4A61-85C6-4F49957E693E@cisco.com>
	<52D26147.4010709@mellanox.com>
	<9D597492-61CB-4C2D-9853-87EEFEA64BEA@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <9D597492-61CB-4C2D-9853-87EEFEA64BEA-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "<roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org> Dreier" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Jan 14, 2014 at 12:14 AM, Upinder Malhi (umalhi)
<umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org> wrote:
> We are happy to use netlink if it makes sense.  What you are saying is: Netlink is used all over the kernel.  Bc it is used all over the kernel, it must be the right answer for all userspace/kernel interactions.  Therefore, if something doesn't use netlink, it must be wrong (ex. procfs, sysfs, debugfs).
>
> We want to put the rx byte/packet count in debug fs because it is intended for developers.  We do not want to put these in a common infrastructure bc as we have found internally, lacking tx statistics confuses users.  We are being asked to write the ib core statistics infrastructure, that if it was available today, we would not use.  So unless someone else jumps in here, we are going to keep these in the debug fs.

What wrong with exposing the the flow tuples from netlink and then see
what's missing that justified debugfs?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
