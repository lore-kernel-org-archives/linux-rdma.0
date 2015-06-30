From: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH V2 2/5] ipath,qib: Expose max_sge_rd correctly
Date: Tue, 30 Jun 2015 13:00:04 -0400
Message-ID: <409FAA1D-FE85-4459-B896-BA9E0A80FC7E@oracle.com>
References: <20150629213332.4188.87551.stgit@build.ogc.int> <20150629213613.4188.82456.stgit@build.ogc.int> <20150630165425.GD30149@obsidianresearch.com>
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20150630165425.GD30149-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roid-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


On Jun 30, 2015, at 12:54 PM, Jason Gunthorpe <jgunthorpe@obsidianresea=
rch.com> wrote:

> On Mon, Jun 29, 2015 at 04:36:13PM -0500, Steve Wise wrote:
>> Applications must not assume that max_sge and max_sge_rd
>> are the same, Hence expose max_sge_rd correctly as well.
>=20
> Chuck,
>=20
> Now that this works, can we change NFS RDMA and get rid of the
> rdma_cap_read_multi_sge stuff?

Steve can propose a patch, I=92ll review.=20

If this is NFS server only, it will have to go through Bruce=92s
tree, or he can ACK it and it can go through linux-rdma.

--
Chuck Lever



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
