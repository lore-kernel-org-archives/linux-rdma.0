From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: Re: IB/iSER major problems with Linux 3.0 and Solaris targets
Date: Mon, 16 Jan 2012 15:07:41 +0100
Message-ID: <4F142F2D.1070108@profitbricks.com>
References: <4EEA0577.5030304@profitbricks.com>	<CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g@mail.gmail.com>	<CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A@mail.gmail.com>	<4F0D987B.4060206@profitbricks.com> <CAJZOPZJOT4Mdyzg+Q06HevikqdA7Sy1KqD1V6Q5LjsiuFsYv5w@mail.gmail.com> <4F0EA679.1020703@profitbricks.com> <4F0EA7F3.8040704@mellanox.com> <4F0EB30F.8040504@profitbricks.com> <4F0EF9AD.6090403@profitbricks.com> <4F0F06EF.3080006@mellanox.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020500080503010205030700"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4F0F06EF.3080006-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------020500080503010205030700
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 12/01/12 17:14, Or Gerlitz wrote:
> 
> you didn't send the kernel logs from the failure after opening the iser 
> (debug_level=2) and libiscsi (debug_libiscsi_session=1
> debug_libiscsi_conn=1) debug prints

OK, I've also set mlx4_core debug_level=2 and have verified in
/sys/module that the parameters are really set.
Please find attached the relevant part of the kernel log while login
attempt.

I've also attached the log from the working stuff from OFED-1.5.4 for a
compare and the settings from discovery.

I'll try to backport the IB + iSCSI kernel code from 3.2.1 to 3.0.15 next.

Cheers,

Sebastian

--------------020500080503010205030700
Content-Type: application/x-gzip;
 name="iser_dbg_dmesg.log.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="iser_dbg_dmesg.log.gz"

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
u+qlc0e5213P4XELwo04vM/t/58MFYSgPgAA
--------------020500080503010205030700
Content-Type: application/x-gzip;
 name="iser_ofa_dbg_dmesg.log.gz"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="iser_ofa_dbg_dmesg.log.gz"

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
hQ6r5fNv/g/YYKRAojEAAA==
--------------020500080503010205030700
Content-Type: text/plain;
 name="iser1_ofa"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="iser1_ofa"

node.name = iqn.2010-03.com.profitbricks:cloud:customers:storage200
node.tpgt = 2
node.startup = manual
iface.hwaddress = default
iface.iscsi_ifacename = iser1
iface.net_ifacename = ib1.bbbb
iface.transport_name = iser
node.discovery_address = 10.1.24.204
node.discovery_port = 3260
node.discovery_type = send_targets
node.session.initial_cmdsn = 0
node.session.initial_login_retry_max = 4
node.session.cmds_max = 128
node.session.queue_depth = 32
node.session.auth.authmethod = None
node.session.timeo.replacement_timeout = 30
node.session.err_timeo.abort_timeout = 15
node.session.err_timeo.lu_reset_timeout = 20
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
node.conn[0].address = 10.1.24.204
node.conn[0].port = 3260
node.conn[0].startup = manual
node.conn[0].tcp.window_size = 524288
node.conn[0].tcp.type_of_service = 0
node.conn[0].timeo.logout_timeout = 15
node.conn[0].timeo.login_timeout = 15
node.conn[0].timeo.auth_timeout = 45
node.conn[0].timeo.noop_out_interval = 5
node.conn[0].timeo.noop_out_timeout = 5
node.conn[0].iscsi.MaxRecvDataSegmentLength = 131072
node.conn[0].iscsi.HeaderDigest = None
node.conn[0].iscsi.DataDigest = None
node.conn[0].iscsi.IFMarker = No
node.conn[0].iscsi.OFMarker = No


--------------020500080503010205030700--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
