From: Ming Lin <mlin@kernel.org>
Subject: Re: iSER multi-queue configuration
Date: Fri, 29 Apr 2016 23:13:56 -0700
Message-ID: <1461996836.4373.5.camel@kernel.org>
References: <CAF1ivSa24Y114s0f0g74jgmP8MuPfrfU_uAA7AAVR8Tsz=+avg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSa24Y114s0f0g74jgmP8MuPfrfU_uAA7AAVR8Tsz=+avg@mail.gmail.com>
Sender: target-devel-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, target-devel <target-devel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 2016-04-29 at 14:11 -0700, Ming Lin wrote:
> Hi,
>=20
> I use mlx5 to setup iSER and have scsi mq enabled.
>=20
> root@xxx:~# cat /sys/module/scsi_mod/parameters/use_blk_mq
> Y
>=20
> But it seems there is only 1 HW queue that maps to 48 SW queues.
>=20
> root@xxx:/sys/block/sdb/mq# ls
> 0
>=20
> root@xxx:/sys/block/sdb/mq# ls 0/
> active=C2=A0=C2=A0cpu1=C2=A0=C2=A0=C2=A0cpu11=C2=A0=C2=A0cpu13=C2=A0=C2=
=A0cpu15=C2=A0=C2=A0cpu17=C2=A0=C2=A0cpu19=C2=A0=C2=A0cpu20=C2=A0=C2=A0=
cpu22=C2=A0=C2=A0cpu24
> cpu26=C2=A0=C2=A0cpu28=C2=A0=C2=A0cpu3=C2=A0=C2=A0=C2=A0cpu31=C2=A0=C2=
=A0cpu33=C2=A0=C2=A0cpu35=C2=A0=C2=A0cpu37=C2=A0=C2=A0cpu39=C2=A0=C2=A0=
cpu40=C2=A0=C2=A0cpu42
> cpu44=C2=A0=C2=A0cpu46=C2=A0=C2=A0cpu5=C2=A0=C2=A0cpu7=C2=A0=C2=A0cpu=
9=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0dispatched=C2=A0=C2=A0pending=C2=A0=
=C2=A0run
> cpu0=C2=A0=C2=A0=C2=A0=C2=A0cpu10=C2=A0=C2=A0cpu12=C2=A0=C2=A0cpu14=C2=
=A0=C2=A0cpu16=C2=A0=C2=A0cpu18=C2=A0=C2=A0cpu2=C2=A0=C2=A0=C2=A0cpu21=C2=
=A0=C2=A0cpu23=C2=A0=C2=A0cpu25
> cpu27=C2=A0=C2=A0cpu29=C2=A0=C2=A0cpu30=C2=A0=C2=A0cpu32=C2=A0=C2=A0c=
pu34=C2=A0=C2=A0cpu36=C2=A0=C2=A0cpu38=C2=A0=C2=A0cpu4=C2=A0=C2=A0=C2=A0=
cpu41=C2=A0=C2=A0cpu43
> cpu45=C2=A0=C2=A0cpu47=C2=A0=C2=A0cpu6=C2=A0=C2=A0cpu8=C2=A0=C2=A0cpu=
_list=C2=A0=C2=A0io_poll=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0queued=C2=A0=C2=A0=
=C2=A0tags
>=20
> How to configure it that I can have 48 HW queues?
> That is 1 HW queue map to 1 SW queue.

Hi Sagi,

I'm looking at why there is only 1 HW queue for iser.

2185 int scsi_mq_setup_tags(struct Scsi_Host *shost)
2186 {
=2E..
2199=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0shost->tag_se=
t.nr_hw_queues =3D shost->nr_hw_queues ? : 1;


It seems because iser code does not set shost->nr_hw_queues at all.

Why?
