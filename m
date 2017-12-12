From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH rdma-core] Support writing man pages in MarkDown
Date: Tue, 12 Dec 2017 23:11:15 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373AB1C234C@ORSMSX109.amr.corp.intel.com>
References: <20171212225936.GA29558@ziepe.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171212225936.GA29558-uk2M96/98Pc@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> Since this may be a problem, I am thinking about following the
> libfabric approach and either including the precompiled man pages in
> the source tree, or just providing a framework for downstream to add-
> on precompiled files (with a cbuild command to make them) Looking for
> feedback on what path is best..

FWIW, one of the reasons libfabric went with pre-compiled man pages was to include a date for the last edit.  A service automatically updates the date when updating the page.

There's probably some way to get that in the markdown directly.

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
