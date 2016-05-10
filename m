From: "Steve Wise" <swise@opengridcomputing.com>
Subject: RE: generic RDMA READ/WRITE API V8
Date: Tue, 10 May 2016 12:26:28 -0500
Message-ID: <9b8601d1aae1$15f13d70$41d3b850$@opengridcomputing.com>
References: <1462291273-22403-1-git-send-email-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1462291273-22403-1-git-send-email-hch@lst.de>
Content-Language: en-us
Sender: target-devel-owner@vger.kernel.org
To: dledford@redhat.com
Cc: bart.vanassche@sandisk.com, sagi@grimberg.me, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, 'Christoph Hellwig' <hch@lst.de>
List-Id: linux-rdma@vger.kernel.org

>=20
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
>=20
> I also have a git tree available at:
>=20
> 	git://git.infradead.org/users/hch/rdma.git rdma-rw-api
>=20
> gitweb:
>=20
> 	http://git.infradead.org/users/hch/rdma.git/shortlog/refs/heads/rdma=
-rw-
> api
>

Hey Doug,=20

Is this on your to-do list for 4.7?  I think it is ready to merge.  But=
 I don't see it in your k.o/for-4.7 branch yet.

Thanks,

Steve.
