From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: generic RDMA READ/WRITE API V6
Date: Tue, 12 Apr 2016 13:31:29 -0500
Message-ID: <019a01d194e9$876885c0$96399140$@opengridcomputing.com>
References: <1460410360-13104-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1460410360-13104-1-git-send-email-hch@lst.de>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: 'Christoph Hellwig' <hch@lst.de>, dledford@redhat.com
Cc: bart.vanassche@sandisk.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

> This series contains patches that implement a first version of a gene=
ric
> API to handle RDMA READ/WRITE operations as commonly used on the targ=
et
> (or server) side for storage protocols.
>=20
> This has been developed for the upcoming NVMe over Fabrics target, an=
d
> extensively te=D1=95ted as part of that, although this upstream versi=
on has
> additional updates over the one we're currently using.
>=20
> It hides details such as the use of MRs for iWarp devices, and will a=
llow
> looking at other HCA specifics easily in the future.
>=20
> This series contains also conversion the SRP and iSER targets to the =
new
> API.
>=20
> I think it's basically ready to merge now.
>

I agree.
=20
> I also have a git tree available at:
>=20
> 	git://git.infradead.org/users/hch/rdma.git rdma-rw-api
>=20

With your rdam-rw-api branch, + these fixes:

=46rom: Steve Wise <swise@...>
Subject: [PATCH 0/3] iw_cxgb3/4 bug fixes
http://article.gmane.org/gmane.linux.drivers.rdma/35350

=46rom: Christoph Hellwig <hch@...>
Subject: fix large I/O regression with iSER in 4.4+ V2
http://article.gmane.org/gmane.linux.drivers.rdma/35345


And a workaround for this 4.6 regression that breaks cxgb4:

=46rom: Steve Wise <swise <at> opengridcomputing.com>
Subject: RE: 4.6-rc2 regression with commit 104daa71b396: check VPD acc=
ess offset against length
http://article.gmane.org/gmane.linux.kernel.pci/50831


The iSER initiator and target test ok on cxgb4/iWARP.

Tested-by: Steve Wise <swise@opengridcomputing.com>

Steve.
