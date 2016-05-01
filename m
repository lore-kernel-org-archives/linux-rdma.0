From: Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: iSER multi-queue configuration
Date: Sat, 30 Apr 2016 23:07:06 -0700
Message-ID: <1462082826.11010.3.camel@kernel.org>
References: <CAF1ivSa24Y114s0f0g74jgmP8MuPfrfU_uAA7AAVR8Tsz=+avg@mail.gmail.com>
	 <1461996836.4373.5.camel@kernel.org> <57256FB6.7030607@grimberg.me>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <57256FB6.7030607-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, target-devel <target-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, 2016-05-01 at 05:53 +0300, Sagi Grimberg wrote:
> > Hi Sagi,
>=20
> Hi Ming,
>=20
> > I'm looking at why there is only 1 HW queue for iser.
> >=20
> > 2185 int scsi_mq_setup_tags(struct Scsi_Host *shost)
> > 2186 {
> > ...
> > 2199=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0shost->ta=
g_set.nr_hw_queues =3D shost->nr_hw_queues ? :
> > 1;
> >=20
> >=20
> > It seems because iser code does not set shost->nr_hw_queues at all.
> >=20
> > Why?
>=20
> The iscsi driver has not yet been converted to scsi_mq and iser as
> an iscsi transport still does not use multi-queue.

I'm going to compare performance between NVMe over RDMA and SCSI over
RDMA. SRP supports scsi_mq, so I'd use SRP to do the apples-to-apples
comparison.

>=20
> In iscsi, a hw queue maps to an iscsi session. In order to support
> multi-queue we need to have iscsi open multiple sessions and map
> a session to a queue.
>=20
> I had some preliminary works on this (joint with Mike Christie) but I
> didn't have time thus far to implement a full conversion to scsi-mq.

I'd happy to test it once you done.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
