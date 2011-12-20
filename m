From: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: IB/iSER with Linux 3.0 and Debian: Lesson learned
Date: Tue, 20 Dec 2011 23:55:41 +0200
Message-ID: <CAJZOPZLweaD19nS94Enh1rxXwRt+bHr=cPMxdg2zcCP_d4bzfw@mail.gmail.com>
References: <4EEA0577.5030304@profitbricks.com>
	<CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g@mail.gmail.com>
	<CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A@mail.gmail.com>
	<4EF02E10.4070501@mellanox.com>
	<CAFr+87tQ2Vw9X3A25WUVstWfNhANj-FktXs6ZtU6d4as_j1k8A@mail.gmail.com>
	<4EF06AF6.6080901@mellanox.com>
	<CAFr+87sHu6YksMhKFxQitRpi2pd77r0WCJ5JzTQfwJ2qoNUD1g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFr+87sHu6YksMhKFxQitRpi2pd77r0WCJ5JzTQfwJ2qoNUD1g-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Christie <michaelc-hcNo3dDEHLuVc3sceRu5cw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org> wrote:
> 2011/12/20 Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>:

>> Beep(2), so your system has distro which is based on kernel 2.6.32 and iscsi
>> initiator tools version 2.0.871 and per your needs, you've booted it with kernel 3.0 .
>> At this point should you have stop and make sure that this combo works, iscsi wise
>> (simpler to test iscsi/tcp... no need in rdma knowledge), did you do this validation?

> I did - TCP worked very well. I've also updated from git to latest 2.0.872 (latest
> (change 2011-11-01) for testing. TCP always worked and iSER was always unusable.

news to me, see next

> Yes, I even took the max. 2.6.35 supported kernel stuff from
> open-iscsi git and have changed the Makefile to make it compile
> against my kernel. With that I ensured that open-iscsi kernel code and
> user-space match. TCP O.K. - no iSER with that!
>
>> If this combo is working iscsi/tcp wise but not ib_iser wise, its seems to
>> be a bug, and I'd be happy to help with finding the root cause, etc.
>
> Have you ever developed/tested the ib_iser module for/with > 2.6.30 kernels?

horses, please, stay at home, or at least run a little bit slower,
just for you - from 2 minutes
ago - iser works well with 3.2.0-rc5 (its say -dirty b/c its a
development system and the kernel has some patches, but not iser ones)
and iscsi-initiator-utils of 6.2.0.872-21.el6, I will try tomorrow
with upstream iscsi-initiator-utils and see if there's a problem
there.

[root@vsa1 ~]# uname -r
3.2.0-rc5-dirty

[root@vsa1 ~]# rpm -q iscsi-initiator-utils
iscsi-initiator-utils-6.2.0.872-21.el6.x86_64

[root@vsa1 ~]# iscsiadm -m node -T iqn.vsa1.ib -l
Logging in to [iface: default, target: iqn.vsa1.ib, portal: 192.168.20.19,3260]
Login to [iface: default, target: iqn.vsa1.ib, portal:
192.168.20.19,3260] successful.

[root@vsa1 ~]# iscsiadm -m session
iser: [4] 192.168.20.19:3260,1 iqn.vsa1.ib

[root@vsa1 ~]# iscsiadm -m session -P 3
iSCSI Transport Class version 2.0-870
version 2.0-872
Target: iqn.vsa1.ib
        Current Portal: 192.168.20.19:3260,1
        Persistent Portal: 192.168.20.19:3260,1
                **********
                Interface:
                **********
                Iface Name: default
                Iface Transport: iser
                Iface Initiatorname: iqn.1994-05.com.redhat:41e62a1ec85d
                Iface IPaddress: <empty>
                Iface HWaddress: <empty>
                Iface Netdev: <empty>
                SID: 4
                iSCSI Connection State: LOGGED IN
                iSCSI Session State: LOGGED_IN
                Internal iscsid Session State: NO CHANGE
                ************************
                Negotiated iSCSI params:
                ************************
                HeaderDigest: None
                DataDigest: None
                MaxRecvDataSegmentLength: 128
                MaxXmitDataSegmentLength: 8192
                FirstBurstLength: 65536
                MaxBurstLength: 262144
                ImmediateData: No
                InitialR2T: Yes
                MaxOutstandingR2T: 1
                ************************
                Attached SCSI devices:
                ************************
                Host Number: 7  State: running
                scsi7 Channel 00 Id 0 Lun: 0
                scsi7 Channel 00 Id 0 Lun: 1
                        Attached scsi disk sdb          State: running
[root@vsa1 ~]# iscsiadm -m node -T iqn.vsa1.ib
# BEGIN RECORD 2.0-872
node.name = iqn.vsa1.ib
node.tpgt = 1
node.startup = manual
iface.hwaddress = <empty>
iface.ipaddress = <empty>
iface.iscsi_ifacename = default
iface.net_ifacename = <empty>
iface.transport_name = iser
iface.initiatorname = <empty>
node.discovery_address = 192.168.20.19
node.discovery_port = 3260
node.discovery_type = send_targets
node.session.initial_cmdsn = 0
node.session.initial_login_retry_max = 8
node.session.xmit_thread_priority = -20
node.session.cmds_max = 128
node.session.queue_depth = 32
node.session.auth.authmethod = None
node.session.auth.username = <empty>
node.session.auth.password = <empty>
node.session.auth.username_in = <empty>
node.session.auth.password_in = <empty>
node.session.timeo.replacement_timeout = 120
node.session.err_timeo.abort_timeout = 15
node.session.err_timeo.lu_reset_timeout = 30
node.session.err_timeo.tgt_reset_timeout = 30
node.session.err_timeo.host_reset_timeout = 60
node.session.iscsi.FastAbort = Yes
node.session.iscsi.InitialR2T = No
node.session.iscsi.ImmediateData = Yes
node.session.iscsi.FirstBurstLength = 262144
node.session.iscsi.MaxBurstLength = 16776192
node.session.iscsi.DefaultTime2Retain = 0
node.session.iscsi.DefaultTime2Wait = 2
node.session.iscsi.MaxConnections = 1
node.session.iscsi.MaxOutstandingR2T = 1
node.session.iscsi.ERL = 0
node.conn[0].address = 192.168.20.19
node.conn[0].port = 3260
node.conn[0].startup = manual
node.conn[0].tcp.window_size = 524288
node.conn[0].tcp.type_of_service = 0
node.conn[0].timeo.logout_timeout = 15
node.conn[0].timeo.login_timeout = 15
node.conn[0].timeo.auth_timeout = 45
node.conn[0].timeo.noop_out_interval = 5
node.conn[0].timeo.noop_out_timeout = 5
node.conn[0].iscsi.MaxXmitDataSegmentLength = 0
node.conn[0].iscsi.MaxRecvDataSegmentLength = 262144
node.conn[0].iscsi.HeaderDigest = None
node.conn[0].iscsi.IFMarker = No
node.conn[0].iscsi.OFMarker = No
# END RECORD

[root@vsa1 ~]# iscsiadm -m node -T iqn.vsa1.ib -u
Logging out of session [sid: 4, target: iqn.vsa1.ib, portal: 192.168.20.19,3260]
Logout of [sid: 4, target: iqn.vsa1.ib, portal: 192.168.20.19,3260] successful.

and this is the system log

Dec 20 23:36:47 vsa1 root: AAAAAAAAAA iSER TEST WITH 3.2-rc5
Dec 20 23:36:52 vsa1 kernel: iser: iser_connect:connecting to:
192.168.20.19, port 0xbc0c
Dec 20 23:36:52 vsa1 kernel: iser: iser_cma_handler:event 0 status 0
conn ffff88062429d2b8 id ffff880620193000
Dec 20 23:36:52 vsa1 kernel: iser: iser_cma_handler:event 2 status 0
conn ffff88062429d2b8 id ffff880620193000
Dec 20 23:36:52 vsa1 kernel: iser: iser_create_ib_conn_res:setting
conn ffff88062429d2b8 cma_id ffff880620193000: fmr_pool
ffff880613b61500 qp ffff8805fec70400
Dec 20 23:36:52 vsa1 kernel: iser: iser_cma_handler:event 9 status 0
conn ffff88062429d2b8 id ffff880620193000
Dec 20 23:36:52 vsa1 kernel: iser: iscsi_iser_ep_poll:ib conn
ffff88062429d2b8 rc = 1
Dec 20 23:36:52 vsa1 kernel: scsi5 : iSCSI Initiator over iSER, v.0.1
Dec 20 23:36:52 vsa1 kernel: iser: iscsi_iser_conn_bind:binding
iscsi/iser conn ffff8804f9af8358 ffff8804f9af85c8 to ib_conn
ffff88062429d2b8
Dec 20 23:36:52 vsa1 kernel: scsi 5:0:0:0: RAID              Mellanox
vsa              1    PQ: 0 ANSI: 5
Dec 20 23:36:52 vsa1 kernel: scsi 5:0:0:0: Attached scsi generic sg2 type 12
Dec 20 23:36:52 vsa1 kernel: scsi 5:0:0:1: Direct-Access     Mellanox
VIRTUAL-DISK     0001 PQ: 0 ANSI: 5
Dec 20 23:36:52 vsa1 kernel: sd 5:0:0:1: Attached scsi generic sg3 type 0
Dec 20 23:36:52 vsa1 kernel: sd 5:0:0:1: [sdb] 2147483648 512-byte
logical blocks: (1.09 TB/1.00 TiB)
Dec 20 23:36:52 vsa1 kernel: sd 5:0:0:1: [sdb] Write Protect is off
Dec 20 23:36:52 vsa1 kernel: sd 5:0:0:1: [sdb] Write cache: enabled,
read cache: enabled, doesn't support DPO or FUA
Dec 20 23:36:52 vsa1 kernel: sdb: unknown partition table
Dec 20 23:36:52 vsa1 kernel: sd 5:0:0:1: [sdb] Attached SCSI disk
Dec 20 23:36:52 vsa1 iscsid: Could not set session2 priority.
READ/WRITE throughout and latency could be affected.
Dec 20 23:36:52 vsa1 iscsid: Connection2:0 to [target: iqn.vsa1.ib,
portal: 192.168.20.19,3260] through [iface: default] is operational
now
Dec 20 23:36:54 vsa1 kernel: sd 5:0:0:1: [sdb] Synchronizing SCSI cache
Dec 20 23:36:55 vsa1 kernel: iser: iscsi_iser_ep_disconnect:ib conn
ffff88062429d2b8 state 2
Dec 20 23:36:55 vsa1 kernel: iser: iser_cma_handler:event 10 status 0
conn ffff88062429d2b8 id ffff880620193000
Dec 20 23:36:55 vsa1 kernel: iser: iser_free_ib_conn_res:freeing conn
ffff88062429d2b8 cma_id ffff880620193000 fmr pool ffff880613b61500 qp
ffff8805fec70400
Dec 20 23:36:55 vsa1 kernel: iser: iser_device_try_release:device
ffff880554ba6000 refcount 0
Dec 20 23:36:55 vsa1 iscsid: Connection2:0 to [target: iqn.vsa1.ib,
portal: 192.168.20.19,3260] through [iface: default] is shutdown.


> I've seen that there were lots of changes in the whole
> open-iscsi kernel stack between 2.6.30 and 2.6.32. The whole ABI has
> changed in libiscsi. They added stuff e.g. at the first position in
> enums. If ib_iser isn't aware of such changes lots of crap can happen.
> ...and happened to me while testing by the way.

I don't use ofed at all, work only with upstream or distro code.
AFAIK, the upstream kernel is functional with iser at all times,
again, I will do the validation with the iscsi  tools and if the
upstream iscsi tools aren't functional with the upstream iser code but
are functional with the upstream iscsi/tcp code, we will (the iscsi
maintainer and myself) fix that, and thanks for this possible heads
up.

>> But this way or another, OFA isn't an iscsi tools factory, nor have anyone
>> that can/want to support iscsi tools, we (folks from the rdma vendors
>> community that deal with iscsi) are working with the upstream iscsi
>> maintainer to address iscsi issues. The fact that OFA ships iscsi code
>> except for ib_iser/cxgb4i/etc modules is a bug, BTW, I'll act to change that.

> ib_iser has tight dependencies to open-iscsi code (see attached). In
> my opinion an ib_iser developer should work that tight together with
> the open-iscsi guys. They should inform you about all ABI and API
> changes in libiscsi so that you can react on that. As an user of
> IB/iSER it is really confusing that this isn't the case and that OFA
> only provides 2.6.30 based open-iscsi stuff which only works for iSER
> due to missing libiscsi_tcp in there. At least this could be fixed easily.

no way, OFA isn't iscsi factory, we can't support the iscsi kernel
modules except for iser, nor any of the iscsi user space tools - and
its a historic bug that someone with wrong ambitions added iscsi
modules/tools info the ofa stack. The OFA stack should be compatible
with the kernel/distro it is running on. As you can see in the
maintainers file, I act as the iser maintainer, and I do work closely
with the iscsi maintainer, maybe should work closer if indeed you
stepped on a problem with the upstream iscsi tools, as for the iscsi
tools provided with debian, I am not sure what was the problem, send
me tgz with the sources to my @mellanox address and I can try look on
that.


> Would it help, if we provide our patches for open-iscsi and IB/iSER >
> 2.6.32 to bring that into mainline OFED?

patches to ib/iser are always wellcome, send me and cc this list, for
open-iscsi, not to me.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
