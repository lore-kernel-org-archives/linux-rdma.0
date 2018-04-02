From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: [PATCH v4 iproute2-next 0/7] cm_id, cq, mr, and pd resource tracking
Date: Sun, 1 Apr 2018 20:13:09 -0500
Message-ID: <00a701d3ca1f$c3685d30$4a391790$@opengridcomputing.com>
References: <cover.1522359537.git.swise@opengridcomputing.com> <8cdcb764-da42-e540-90e6-309eda0eb599@gmail.com> <20180401182945.GI22232@mtr-leonro.local>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180401182945.GI22232@mtr-leonro.local>
Content-Language: en-us
Sender: netdev-owner@vger.kernel.org
To: 'Leon Romanovsky' <leon@kernel.org>, 'David Ahern' <dsahern@gmail.com>
Cc: stephen@networkplumber.org, netdev@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> 
> On Sun, Apr 01, 2018 at 09:22:14AM -0600, David Ahern wrote:
> > On 3/29/18 3:38 PM, Steve Wise wrote:
> > > This series enhances the iproute2 rdma tool to include dumping of
> > > connection manager id (cm_id), completion queue (cq), memory region
> (mr),
> > > and protection domain (pd) rdma resources.  It is the user-space part
of
> > > the kernel resource tracking series merged into rdma-next for 4.17 [1]
> > > and [2].
> > >
> > > Changes since v3:
> > > - replaced rdma_cma.h inclusion with UAPI rdma_user_cm.h
> > > - display only device names instead of device/port for cq, mr, and pd
> > > since they are not associated with a specific port.
> > >
> > > Changes since v2:
> > > - pull in rdma-core:include/rdma/rdma_cma.h
> > > - 80 column reformat
> > > - add reviewed-by tags
> > >
> > > Changes since v1/RFC:
> > > - removed RFC tag
> > > - initialize rd properly to avoid passing a garbage port number
> > > - revert accidental change to qp_valid_filters
> > > - removed cm_id dev/network/transport types
> > > - cm_id ip addrs now passed up as __kernel_sockaddr_storage
> > > - cm_id ip address ports printed as "address:port" strings
> > > - only parse/display memory keys and iova if available
> > > - filter on "users" for cqs and pds
> > > - fixed memory leaks
> > > - removed PD_FLAGS attribute
> > > - filter on "mrlen" for mrs
> > > - filter on "poll-ctx" for cqs
> > > - don't require addrs or qp_type for parsing cm_ids
> > > - only filter optional attrs if they are present
> > > - remove PGSIZE MR attr to match kernel
> > >
> > > [1] https://www.spinics.net/lists/linux-rdma/msg61720.html
> > > [2] https://www.spinics.net/lists/linux-rdma/msg62979.html
> > >     https://www.spinics.net/lists/linux-rdma/msg62980.html
> > >
> > > ---
> > >
> >
> > applied to iproute2-next. Thanks,
> 
> Thanks David
> 

Yes, Thanks David and Leon.
