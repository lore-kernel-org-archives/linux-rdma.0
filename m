From: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: IB/iSER major problems with Linux 3.0 and Solaris targets
Date: Wed, 11 Jan 2012 15:11:07 +0100
Message-ID: <4F0D987B.4060206@profitbricks.com>
References: <4EEA0577.5030304@profitbricks.com>	<CAFr+87sPBQnhWEs08JxDrgbS_t9qCtEhHgVwHjw4b=iKF_9U3g@mail.gmail.com> <CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020906080803020104010306"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAFr+87tzqHzRttxAV=rZmjpAFCFGtiO3ns2F4XVfmD+GTzCL8A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------020906080803020104010306
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi list, hi Or,

at the moment we use our kernel 3.0 ported OFA kernel modules from
OFED-1.5.4 to make iSER work together with our kernel 3.0 ported
open-iscsi 2.0.869 and Solaris 11 COMSTAR targets.

Now, we've got the problem that ib_iser from in there ignores its
"debug_level" parameter. /sys/module/ib_iser/parameters/debug_level
shows "0" but it spams the whole kernel log with debug messages. Seems
to be a code bug.

We've also tested a 3.0.15 mainline kernel with in-tree IB modules
together with the OFED-1.5.4 user-space and this has much better IPoIB
performance than the kernel stuff from OFED. So, we want to use them
instead, but there is the same problem with the iSER debug messages and
iSER doesn't work together with our Solaris 11 COMSTAR targets.

We've tested this with open-iscsi (2.0.872, commit
4323e342d2c9fb8ed7233ce855001c189ec55b23) user-space.
TCP is O.K. but iSER reports an error while login attempt:
"iscsiadm: initiator reported error (11 - iSCSI PDU timed out)"

The sent PDUs from iscsid debugging are the same, but there is an IO
page fault in the kernel log. I've attached the relevant part and the
iscsid log.

This looks interesting:
"iser: iser_drain_tx_cq:tx id ffff88402391f898 status 4 vend_err 57"

Or, could you please investigate/explain?

It is a pain that we need both: working iSER and IPoIB traffic with good
performance.

Cheers,

Sebastian


On 19/12/11 10:14, Sebastian Riemer wrote:
> Hi list,
>
> I've already sent this to the open-iscsi mailing list, but I guess
> this is more relevant for linux-rdma.
>
> Finally I've got IB/iSER running on Debian Squeeze with Linux kernel 3.0
> smoothly.
>
> The problem was that we did not have the suitable OFED for our kernel
> and we did not use the open-iscsi from OFED. Kernel 3.0 is supported
> since OFED-1.5.4 from 2011-12-05.
>
> So, I've taken the 1.5.2-based stuff from Debian/Experimental and I've
> updated it to 1.5.4 from OFA. Then, I've noticed that Debian doesn't
> build "ib_iser" in the OFA kernel source and that they don't build the
> open-iscsi kernel/user-space code - I made it do so.
>
> The next problem was that open-iscsi kernel code in OFED-1.5.4 is for <=
> 2.6.32 based RedHat distributions. I had to port the source from 2.6.30
> to 3.0 due to kernel API changes. OFA even forgot libiscsi_tcp.[ch] in
> OFED-1.5.4. So, I had to import it from 2.6.30 mainline.
> I did so, because we wanted to compare TCP and iSER speed over
> InfiniBand. Our Solaris COMSTAR targets provide both.
>
> After fixing the kernel, there was still a problem in the open-iscsi
> 2.0.869 user-space from OFED. Some sysfs magic has changed - so that the
> iSCSI host number couldn't be found.
>
> After fixing that, it worked for me.
>
> Cheers,
>
> Sebastian
>   


--------------020906080803020104010306
Content-Type: text/x-log;
 name="kernel.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="kernel.log"

Jan 11 12:53:25 pserver214 kernel: [  716.518372] SCSI subsystem initialized
Jan 11 12:53:25 pserver214 kernel: [  716.521146] Loading iSCSI transport class v2.0-870.
Jan 11 12:53:25 pserver214 kernel: [  716.528756] iscsi: registered transport (tcp)
Jan 11 12:53:30 pserver214 kernel: [  721.903544] iscsi: registered transport (iser)
Jan 11 12:54:46 pserver214 kernel: [  797.537439] iser: iser_connect:connecting to: 10.1.24.204, port 0xbc0c
Jan 11 12:54:46 pserver214 kernel: [  797.563158] iser: iser_cma_handler:event 0 status 0 conn ffff880807b17a80 id ffff880807594400
Jan 11 12:54:46 pserver214 kernel: [  797.566402] iser: iser_cma_handler:event 2 status 0 conn ffff880807b17a80 id ffff880807594400
Jan 11 12:54:46 pserver214 kernel: [  797.579704] iser: iser_create_ib_conn_res:setting conn ffff880807b17a80 cma_id ffff880807594400: fmr_pool ffff88082426b400 qp ffff8807ed22aa00
Jan 11 12:54:46 pserver214 kernel: [  797.586557] iser: iser_cma_handler:event 9 status 0 conn ffff880807b17a80 id ffff880807594400
Jan 11 12:54:46 pserver214 kernel: [  797.787932] iser: iscsi_iser_ep_poll:ib conn ffff880807b17a80 rc = 1
Jan 11 12:54:46 pserver214 kernel: [  797.788137] scsi0 : iSCSI Initiator over iSER, v.0.1
Jan 11 12:54:46 pserver214 kernel: [  797.794249] iser: iscsi_iser_conn_bind:binding iscsi/iser conn ffff8808058deab8 ffff8808058decc8 to ib_conn ffff880807b17a80
Jan 11 12:54:46 pserver214 kernel: [  797.794710] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0013 address=0x0000000006488000 flags=0x0050]
Jan 11 12:54:46 pserver214 kernel: [  797.794919] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0013 address=0x0000000006488200 flags=0x0050]
Jan 11 12:54:46 pserver214 kernel: [  797.794998] iser: iser_drain_tx_cq:tx id ffff88402391f898 status 4 vend_err 57
Jan 11 12:54:46 pserver214 kernel: [  797.795006]  connection1:0: detected conn error (1011)
Jan 11 12:54:46 pserver214 kernel: [  797.795338] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0013 address=0x0000000006488100 flags=0x0050]
Jan 11 12:54:46 pserver214 kernel: [  797.795535] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0013 address=0x0000000006488040 flags=0x0050]
Jan 11 12:54:46 pserver214 kernel: [  797.795730] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0013 address=0x00000000064880c0 flags=0x0050]
Jan 11 12:54:46 pserver214 kernel: [  797.795925] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0013 address=0x0000000006488080 flags=0x0050]
Jan 11 12:54:46 pserver214 kernel: [  797.796119] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0013 address=0x0000000006488140 flags=0x0050]
Jan 11 12:54:46 pserver214 kernel: [  797.796314] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0013 address=0x0000000006488180 flags=0x0050]
Jan 11 12:54:46 pserver214 kernel: [  797.796508] AMD-Vi: Event logged [IO_PAGE_FAULT device=03:00.0 domain=0x0013 address=0x00000000064881c0 flags=0x0050]
Jan 11 12:55:01 pserver214 kernel: [  812.811486] iser: iscsi_iser_ep_disconnect:ib conn ffff880807b17a80 state 4
Jan 11 12:55:01 pserver214 kernel: [  812.812093] iser: iser_cma_handler:event 10 status 0 conn ffff880807b17a80 id ffff880807594400
Jan 11 12:55:01 pserver214 kernel: [  812.812232] iser: iser_free_ib_conn_res:freeing conn ffff880807b17a80 cma_id ffff880807594400 fmr pool ffff88082426b400 qp ffff8807ed22aa00
Jan 11 12:55:01 pserver214 kernel: [  812.813821] iser: iser_device_try_release:device ffff8808059fc300 refcount 0
Jan 11 12:55:04 pserver214 kernel: [  815.064508] iser: iser_connect:connecting to: 10.1.24.204, port 0xbc0c
Jan 11 12:55:04 pserver214 kernel: [  815.082863] iser: iser_cma_handler:event 0 status 0 conn ffff8807fb8de280 id ffff880807595000
Jan 11 12:55:04 pserver214 kernel: [  815.086057] iser: iser_cma_handler:event 2 status 0 conn ffff8807fb8de280 id ffff880807595000
Jan 11 12:55:04 pserver214 kernel: [  815.099221] iser: iser_create_ib_conn_res:setting conn ffff8807fb8de280 cma_id ffff880807595000: fmr_pool ffff8807ed2f3f80 qp ffff8807ed228a00
Jan 11 12:55:04 pserver214 kernel: [  815.101435] iser: iser_cma_handler:event 9 status 0 conn ffff8807fb8de280 id ffff880807595000
Jan 11 12:55:04 pserver214 kernel: [  815.314980] iser: iscsi_iser_ep_poll:ib conn ffff8807fb8de280 rc = 1
Jan 11 12:55:04 pserver214 kernel: [  815.315113] iser: iscsi_iser_conn_bind:binding iscsi/iser conn ffff8808058deab8 ffff8808058decc8 to ib_conn ffff8807fb8de280
Jan 11 12:55:04 pserver214 kernel: [  815.315644] iser: iser_drain_tx_cq:tx id ffff88402391f898 status 4 vend_err 57
Jan 11 12:55:04 pserver214 kernel: [  815.315779]  connection1:0: detected conn error (1011)
Jan 11 12:55:19 pserver214 kernel: [  830.082349] iser: iscsi_iser_ep_disconnect:ib conn ffff8807fb8de280 state 4
Jan 11 12:55:19 pserver214 kernel: [  830.082928] iser: iser_cma_handler:event 10 status 0 conn ffff8807fb8de280 id ffff880807595000
Jan 11 12:55:19 pserver214 kernel: [  830.083079] iser: iser_free_ib_conn_res:freeing conn ffff8807fb8de280 cma_id ffff880807595000 fmr pool ffff8807ed2f3f80 qp ffff8807ed228a00
Jan 11 12:55:19 pserver214 kernel: [  830.084398] iser: iser_device_try_release:device ffff8807fc662000 refcount 0
Jan 11 12:55:21 pserver214 kernel: [  832.335256] iser: iser_connect:connecting to: 10.1.24.204, port 0xbc0c
Jan 11 12:55:21 pserver214 kernel: [  832.353035] iser: iser_cma_handler:event 0 status 0 conn ffff880805448280 id ffff880807596c00
Jan 11 12:55:21 pserver214 kernel: [  832.356099] iser: iser_cma_handler:event 2 status 0 conn ffff880805448280 id ffff880807596c00
Jan 11 12:55:21 pserver214 kernel: [  832.369360] iser: iser_create_ib_conn_res:setting conn ffff880805448280 cma_id ffff880807596c00: fmr_pool ffff8808062fe380 qp ffff8807ed229400
Jan 11 12:55:21 pserver214 kernel: [  832.372343] iser: iser_cma_handler:event 9 status 0 conn ffff880805448280 id ffff880807596c00
Jan 11 12:55:21 pserver214 kernel: [  832.585722] iser: iscsi_iser_ep_poll:ib conn ffff880805448280 rc = 1
Jan 11 12:55:21 pserver214 kernel: [  832.585856] iser: iscsi_iser_conn_bind:binding iscsi/iser conn ffff8808058deab8 ffff8808058decc8 to ib_conn ffff880805448280
Jan 11 12:55:21 pserver214 kernel: [  832.586375] iser: iser_drain_tx_cq:tx id ffff88402391f898 status 4 vend_err 57
Jan 11 12:55:21 pserver214 kernel: [  832.586510]  connection1:0: detected conn error (1011)
Jan 11 12:55:36 pserver214 kernel: [  847.353001] iser: iscsi_iser_ep_disconnect:ib conn ffff880805448280 state 4
Jan 11 12:55:36 pserver214 kernel: [  847.353665] iser: iser_cma_handler:event 10 status 0 conn ffff880805448280 id ffff880807596c00
Jan 11 12:55:36 pserver214 kernel: [  847.353807] iser: iser_free_ib_conn_res:freeing conn ffff880805448280 cma_id ffff880807596c00 fmr pool ffff8808062fe380 qp ffff8807ed229400
Jan 11 12:55:36 pserver214 kernel: [  847.355194] iser: iser_device_try_release:device ffff8807ed232240 refcount 0
Jan 11 12:55:38 pserver214 kernel: [  849.605959] iser: iser_connect:connecting to: 10.1.24.204, port 0xbc0c
Jan 11 12:55:38 pserver214 kernel: [  849.622975] iser: iser_cma_handler:event 0 status 0 conn ffff880806366280 id ffff880807591400
Jan 11 12:55:38 pserver214 kernel: [  849.625917] iser: iser_cma_handler:event 2 status 0 conn ffff880806366280 id ffff880807591400
Jan 11 12:55:38 pserver214 kernel: [  849.639061] iser: iser_create_ib_conn_res:setting conn ffff880806366280 cma_id ffff880807591400: fmr_pool ffff8807ed23f380 qp ffff8807ed22ae00
Jan 11 12:55:38 pserver214 kernel: [  849.641741] iser: iser_cma_handler:event 9 status 0 conn ffff880806366280 id ffff880807591400
Jan 11 12:55:38 pserver214 kernel: [  849.856434] iser: iscsi_iser_ep_poll:ib conn ffff880806366280 rc = 1
Jan 11 12:55:38 pserver214 kernel: [  849.856562] iser: iscsi_iser_conn_bind:binding iscsi/iser conn ffff8808058deab8 ffff8808058decc8 to ib_conn ffff880806366280
Jan 11 12:55:38 pserver214 kernel: [  849.857080] iser: iser_drain_tx_cq:tx id ffff88402391f898 status 4 vend_err 57
Jan 11 12:55:38 pserver214 kernel: [  849.857215]  connection1:0: detected conn error (1011)
Jan 11 12:55:53 pserver214 kernel: [  864.623753] iser: iscsi_iser_ep_disconnect:ib conn ffff880806366280 state 4
Jan 11 12:55:53 pserver214 kernel: [  864.624413] iser: iser_cma_handler:event 10 status 0 conn ffff880806366280 id ffff880807591400
Jan 11 12:55:53 pserver214 kernel: [  864.624558] iser: iser_free_ib_conn_res:freeing conn ffff880806366280 cma_id ffff880807591400 fmr pool ffff8807ed23f380 qp ffff8807ed22ae00
Jan 11 12:55:53 pserver214 kernel: [  864.625841] iser: iser_device_try_release:device ffff8807fc585a40 refcount 0

--------------020906080803020104010306
Content-Type: text/x-log;
 name="2.0.872-iser.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="2.0.872-iser.log"

iscsid: sysfs_init: sysfs_path='/sys'

iscsid: sysfs_attr_get_value: open '/module/scsi_transport_iscsi'/'version'

iscsid: sysfs_attr_get_value: new uncached attribute '/sys/module/scsi_transport_iscsi/version'

iscsid: sysfs_attr_get_value: add to cache '/sys/module/scsi_transport_iscsi/version'

iscsid: sysfs_attr_get_value: cache '/sys/module/scsi_transport_iscsi/version' with attribute value '2.0-870'

iscsid: transport class version 2.0-870. iscsid version 2.0-872
iscsid: in ctldev_open
iscsid: created NETLINK_ISCSI socket...
iscsid: InitiatorName=iqn.2010-03.com.profitbricks:cloud:pserver:pserver214
iscsid: InitiatorName=iqn.2010-03.com.profitbricks:cloud:pserver:pserver214
iscsid: InitiatorAlias=pserver214
iscsid: Max file limits 1024 1024

iscsid: found .svn

iscsid: found 10.1.23.200,3260

iscsid: Looking for config file /etc/iscsi/send_targets/10.1.23.200,3260

iscsid: Looking for config file /etc/iscsi/send_targets/10.1.23.200,3260 config st_config.
iscsid: Could not open /etc/iscsi/send_targets/10.1.23.200,3260/st_config: No such file or directory

iscsid: Could not read discovery record for 10.1.23.200:3260.
iscsid: found 10.1.23.206,3260

iscsid: Looking for config file /etc/iscsi/send_targets/10.1.23.206,3260

iscsid: Looking for config file /etc/iscsi/send_targets/10.1.23.206,3260 config st_config.
iscsid: Could not open /etc/iscsi/send_targets/10.1.23.206,3260/st_config: No such file or directory

iscsid: Could not read discovery record for 10.1.23.206:3260.
iscsid: found 10.1.23.202,3260

iscsid: Looking for config file /etc/iscsi/send_targets/10.1.23.202,3260

iscsid: Looking for config file /etc/iscsi/send_targets/10.1.23.202,3260 config st_config.
iscsid: Could not open /etc/iscsi/send_targets/10.1.23.202,3260/st_config: No such file or directory

iscsid: Could not read discovery record for 10.1.23.202:3260.
iscsid: Could not increase process priority: Success
iscsid: reaped pid 10598, reap_count now 0
iscsid: poll result 1
iscsid: in read_transports
iscsid: Adding new transport iser
iscsid: Matched transport iser

iscsid: sysfs_attr_get_value: open '/class/iscsi_transport/iser'/'handle'

iscsid: sysfs_attr_get_value: new uncached attribute '/sys/class/iscsi_transport/iser/handle'

iscsid: sysfs_attr_get_value: add to cache '/sys/class/iscsi_transport/iser/handle'

iscsid: sysfs_attr_get_value: cache '/sys/class/iscsi_transport/iser/handle' with attribute value '18446744072100522112'

iscsid: sysfs_attr_get_value: open '/class/iscsi_transport/iser'/'caps'

iscsid: sysfs_attr_get_value: new uncached attribute '/sys/class/iscsi_transport/iser/caps'

iscsid: sysfs_attr_get_value: add to cache '/sys/class/iscsi_transport/iser/caps'

iscsid: sysfs_attr_get_value: cache '/sys/class/iscsi_transport/iser/caps' with attribute value '0x9'

iscsid: Adding new transport tcp
iscsid: Matched transport tcp

iscsid: sysfs_attr_get_value: open '/class/iscsi_transport/tcp'/'handle'

iscsid: sysfs_attr_get_value: new uncached attribute '/sys/class/iscsi_transport/tcp/handle'

iscsid: sysfs_attr_get_value: add to cache '/sys/class/iscsi_transport/tcp/handle'

iscsid: sysfs_attr_get_value: cache '/sys/class/iscsi_transport/tcp/handle' with attribute value '18446744072100476864'

iscsid: sysfs_attr_get_value: open '/class/iscsi_transport/tcp'/'caps'

iscsid: sysfs_attr_get_value: new uncached attribute '/sys/class/iscsi_transport/tcp/caps'

iscsid: sysfs_attr_get_value: add to cache '/sys/class/iscsi_transport/tcp/caps'

iscsid: sysfs_attr_get_value: cache '/sys/class/iscsi_transport/tcp/caps' with attribute value '0x39'

iscsid: Allocted session 0x21ad380
iscsid: no authentication configured...
iscsid: resolved 10.1.24.204 to 10.1.24.204
iscsid: setting iface iser, dev ib1.bbbb, set ip , hw default, transport iser.

iscsid: get ev context 0x21b83d0
iscsid: in ktransport_ep_connect
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: ktransport_ep_connect got handle 1
iscsid: sched conn context 0x21b83d0 event 2, tmo 0
iscsid: thread 0x21b83d0 schedule: delay 0 state 3
iscsid: Setting login timer 0x21b4578 timeout 15
iscsid: thread 0x21b4578 schedule: delay 60 state 3
iscsid: thread 021b4578 wait some more
iscsid: exec thread 021b83d0 callback
iscsid: put ev context 0x21b83d0
iscsid: in ktransport_ep_poll
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: in kcreate_session
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: expecting event 28, got 106, handling...
iscsid: in ctldev_handle
iscsid: in nl_read
iscsid: ctldev_handle got event type 106

iscsid: in nlpayload_read
iscsid: sysfs_attr_get_value: open '/class/scsi_host/host0'/'proc_name'

iscsid: sysfs_attr_get_value: new uncached attribute '/sys/class/scsi_host/host0/proc_name'

iscsid: sysfs_attr_get_value: add to cache '/sys/class/scsi_host/host0/proc_name'

iscsid: sysfs_attr_get_value: cache '/sys/class/scsi_host/host0/proc_name' with attribute value 'iscsi_iser'

iscsid: in read_transports
iscsid: Updating transport iser
iscsid: sysfs_attr_get_value: open '/class/iscsi_transport/iser'/'handle'

iscsid: sysfs_attr_get_value: new uncached attribute '/sys/class/iscsi_transport/iser/handle'

iscsid: sysfs_attr_get_value: add to cache '/sys/class/iscsi_transport/iser/handle'

iscsid: sysfs_attr_get_value: cache '/sys/class/iscsi_transport/iser/handle' with attribute value '18446744072100522112'

iscsid: sysfs_attr_get_value: open '/class/iscsi_transport/iser'/'caps'

iscsid: sysfs_attr_get_value: new uncached attribute '/sys/class/iscsi_transport/iser/caps'

iscsid: sysfs_attr_get_value: add to cache '/sys/class/iscsi_transport/iser/caps'

iscsid: sysfs_attr_get_value: cache '/sys/class/iscsi_transport/iser/caps' with attribute value '0x9'

iscsid: Updating transport tcp
iscsid: sysfs_attr_get_value: open '/class/iscsi_transport/tcp'/'handle'

iscsid: sysfs_attr_get_value: new uncached attribute '/sys/class/iscsi_transport/tcp/handle'

iscsid: sysfs_attr_get_value: add to cache '/sys/class/iscsi_transport/tcp/handle'

iscsid: sysfs_attr_get_value: cache '/sys/class/iscsi_transport/tcp/handle' with attribute value '18446744072100476864'

iscsid: sysfs_attr_get_value: open '/class/iscsi_transport/tcp'/'caps'

iscsid: sysfs_attr_get_value: new uncached attribute '/sys/class/iscsi_transport/tcp/caps'

iscsid: sysfs_attr_get_value: add to cache '/sys/class/iscsi_transport/tcp/caps'

iscsid: sysfs_attr_get_value: cache '/sys/class/iscsi_transport/tcp/caps' with attribute value '0x39'

iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: Could not set session1 priority. READ/WRITE throughout and latency could be affected.

iscsid: created new iSCSI session sid 1 host no 0
iscsid: in kcreate_conn
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: created new iSCSI connection 1:0
iscsid: in kbind_conn
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: bound iSCSI connection 1:0 to session 1
iscsid: sysfs_attr_get_value: open '/class/iscsi_connection/connection1:0'/'exp_statsn'

iscsid: sysfs_attr_get_value: new uncached attribute '/sys/class/iscsi_connection/connection1:0/exp_statsn'

iscsid: sysfs_attr_get_value: add to cache '/sys/class/iscsi_connection/connection1:0/exp_statsn'

iscsid: sysfs_attr_get_value: cache '/sys/class/iscsi_connection/connection1:0/exp_statsn' with attribute value '0'

iscsid: sending login PDU with current stage 1, next stage 3, transit 0x80, isid 0x00023d010000 exp_statsn 0
iscsid: >    InitiatorName=iqn.2010-03.com.profitbricks:cloud:pserver:pserver214
iscsid: >    InitiatorAlias=pserver214
iscsid: >    TargetName=iqn.2010-03.com.profitbricks:cloud:customers:storage200
iscsid: >    SessionType=Normal
iscsid: >    DefaultTime2Wait=2
iscsid: >    DefaultTime2Retain=0
iscsid: >    IFMarker=No
iscsid: >    OFMarker=No
iscsid: >    ErrorRecoveryLevel=0
iscsid: >    InitialR2T=No
iscsid: >    ImmediateData=Yes
iscsid: >    MaxBurstLength=16776192
iscsid: >    FirstBurstLength=262144
iscsid: >    MaxOutstandingR2T=1
iscsid: >    MaxConnections=1
iscsid: >    DataPDUInOrder=Yes
iscsid: >    DataSequenceInOrder=Yes
iscsid: >    InitiatorRecvDataSegmentLength=131072
iscsid: >    TargetRecvDataSegmentLength=8192
iscsid: >    RDMAExtensions=Yes
iscsid: in ksend_pdu_begin
iscsid: send PDU began for hdr 48 bytes and data 516 bytes
iscsid: in kwritev
iscsid: wrote 48 bytes of PDU header
iscsid: in kwritev
iscsid: wrote 516 bytes of PDU data
iscsid: in ksend_pdu_end
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: send PDU finished for conn 1:0
iscsid: thread removed

iscsid: poll result 1
iscsid: in ctldev_handle
iscsid: in nl_read
iscsid: ctldev_handle got event type 102

iscsid: get ev context 0x21b83d0
iscsid: message real length is 72 bytes, recv_handle 0x21b8420
iscsid: in nlpayload_read
iscsid: sched conn context 0x21b83d0 event 3, tmo 0
iscsid: thread 0x21b83d0 schedule: delay 0 state 3
iscsid: exec thread 021b83d0 callback
iscsid: Kernel reported iSCSI connection 1:0 error (1011 - ISCSI_ERR_CONN_FAILED: iSCSI connection failed) state (2)
iscsid: put ev context 0x21b83d0
iscsid: ignoring conn error in login. let it timeout
iscsid: thread removed

iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 was scheduled at 50:60, curtime 110 q_forw 0x674190 &pend_list 0x674190
iscsid: thread 021b4578 now in actor_list
iscsid: exec thread 021b4578 callback
iscsid: iscsi_login_eh
iscsid: login failed ISCSI_CONN_STATE_IN_LOGIN/R_STAGE_NO_CHANGE 0
iscsid: re-opening session 1 (reopen_cnt 0)
iscsid: thread 021b4578 delete: state 3
iscsid: thread 021b45b0 delete: state 0
iscsid: in ktransport_ep_disconnect
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: in kstop_conn
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: connection 1:0 is stopped for recovery
iscsid: Waiting 2 seconds before trying to reconnect.

iscsid: Requeue reopen attempt in 2 secs

iscsid: thread 021b4578 delete: state 3
iscsid: thread 0x21b4578 schedule: delay 8 state 3
iscsid: thread removed

iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 was scheduled at 110:8, curtime 119 q_forw 0x674190 &pend_list 0x674190
iscsid: thread 021b4578 now in actor_list
iscsid: exec thread 021b4578 callback
iscsid: iscsi_login_eh
iscsid: login failed ISCSI_CONN_STATE_XPT_WAIT/R_STAGE_NO_CHANGE
iscsid: in ktransport_ep_disconnect
iscsid: get ev context 0x21b83d0
iscsid: in ktransport_ep_connect
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: ktransport_ep_connect got handle 1
iscsid: sched conn context 0x21b83d0 event 2, tmo 0
iscsid: thread 0x21b83d0 schedule: delay 0 state 3
iscsid: Setting login timer 0x21b4578 timeout 15
iscsid: thread 0x21b4578 schedule: delay 60 state 3
iscsid: thread removed

iscsid: thread 021b83d0 removed from poll_list
iscsid: exec thread 021b83d0 callback
iscsid: put ev context 0x21b83d0
iscsid: in ktransport_ep_poll
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: in kbind_conn
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: bound iSCSI connection 1:0 to session 1
iscsid: sysfs_attr_get_value: open '/class/iscsi_connection/connection1:0'/'exp_statsn'

iscsid: sysfs_attr_get_value: new uncached attribute '/sys/class/iscsi_connection/connection1:0/exp_statsn'

iscsid: sysfs_attr_get_value: add to cache '/sys/class/iscsi_connection/connection1:0/exp_statsn'

iscsid: sysfs_attr_get_value: cache '/sys/class/iscsi_connection/connection1:0/exp_statsn' with attribute value '0'

iscsid: sending login PDU with current stage 1, next stage 3, transit 0x80, isid 0x00023d010000 exp_statsn 0
iscsid: >    InitiatorName=iqn.2010-03.com.profitbricks:cloud:pserver:pserver214
iscsid: >    InitiatorAlias=pserver214
iscsid: >    TargetName=iqn.2010-03.com.profitbricks:cloud:customers:storage200
iscsid: >    SessionType=Normal
iscsid: >    DefaultTime2Wait=2
iscsid: >    DefaultTime2Retain=0
iscsid: >    IFMarker=No
iscsid: >    OFMarker=No
iscsid: >    ErrorRecoveryLevel=0
iscsid: >    InitialR2T=No
iscsid: >    ImmediateData=Yes
iscsid: >    MaxBurstLength=16776192
iscsid: >    FirstBurstLength=262144
iscsid: >    MaxOutstandingR2T=1
iscsid: >    MaxConnections=1
iscsid: >    DataPDUInOrder=Yes
iscsid: >    DataSequenceInOrder=Yes
iscsid: >    InitiatorRecvDataSegmentLength=131072
iscsid: >    TargetRecvDataSegmentLength=8192
iscsid: >    RDMAExtensions=Yes
iscsid: in ksend_pdu_begin
iscsid: send PDU began for hdr 48 bytes and data 516 bytes
iscsid: in kwritev
iscsid: wrote 48 bytes of PDU header
iscsid: in kwritev
iscsid: wrote 516 bytes of PDU data
iscsid: in ksend_pdu_end
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: send PDU finished for conn 1:0
iscsid: thread removed

iscsid: poll result 1
iscsid: in ctldev_handle
iscsid: in nl_read
iscsid: ctldev_handle got event type 102

iscsid: get ev context 0x21b83d0
iscsid: message real length is 72 bytes, recv_handle 0x21b8420
iscsid: in nlpayload_read
iscsid: sched conn context 0x21b83d0 event 3, tmo 0
iscsid: thread 0x21b83d0 schedule: delay 0 state 3
iscsid: exec thread 021b83d0 callback
iscsid: Kernel reported iSCSI connection 1:0 error (1011 - ISCSI_ERR_CONN_FAILED: iSCSI connection failed) state (2)
iscsid: put ev context 0x21b83d0
iscsid: ignoring conn error in login. let it timeout
iscsid: thread removed

iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 was scheduled at 119:60, curtime 179 q_forw 0x674190 &pend_list 0x674190
iscsid: thread 021b4578 now in actor_list
iscsid: exec thread 021b4578 callback
iscsid: iscsi_login_eh
iscsid: login failed ISCSI_CONN_STATE_IN_LOGIN/R_STAGE_NO_CHANGE 1
iscsid: re-opening session 1 (reopen_cnt 1)
iscsid: thread 021b4578 delete: state 3
iscsid: thread 021b45b0 delete: state 3
iscsid: in ktransport_ep_disconnect
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: in kstop_conn
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: connection 1:0 is stopped for recovery
iscsid: Waiting 2 seconds before trying to reconnect.

iscsid: Requeue reopen attempt in 2 secs

iscsid: thread 021b4578 delete: state 3
iscsid: thread 0x21b4578 schedule: delay 8 state 3
iscsid: thread removed

iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 was scheduled at 179:8, curtime 188 q_forw 0x674190 &pend_list 0x674190
iscsid: thread 021b4578 now in actor_list
iscsid: exec thread 021b4578 callback
iscsid: iscsi_login_eh
iscsid: login failed ISCSI_CONN_STATE_XPT_WAIT/R_STAGE_NO_CHANGE
iscsid: in ktransport_ep_disconnect
iscsid: get ev context 0x21b83d0
iscsid: in ktransport_ep_connect
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: ktransport_ep_connect got handle 1
iscsid: sched conn context 0x21b83d0 event 2, tmo 0
iscsid: thread 0x21b83d0 schedule: delay 0 state 3
iscsid: Setting login timer 0x21b4578 timeout 15
iscsid: thread 0x21b4578 schedule: delay 60 state 3
iscsid: thread removed

iscsid: thread 021b83d0 removed from poll_list
iscsid: exec thread 021b83d0 callback
iscsid: put ev context 0x21b83d0
iscsid: in ktransport_ep_poll
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: in kbind_conn
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: bound iSCSI connection 1:0 to session 1
iscsid: sysfs_attr_get_value: open '/class/iscsi_connection/connection1:0'/'exp_statsn'

iscsid: sysfs_attr_get_value: new uncached attribute '/sys/class/iscsi_connection/connection1:0/exp_statsn'

iscsid: sysfs_attr_get_value: add to cache '/sys/class/iscsi_connection/connection1:0/exp_statsn'

iscsid: sysfs_attr_get_value: cache '/sys/class/iscsi_connection/connection1:0/exp_statsn' with attribute value '0'

iscsid: sending login PDU with current stage 1, next stage 3, transit 0x80, isid 0x00023d010000 exp_statsn 0
iscsid: >    InitiatorName=iqn.2010-03.com.profitbricks:cloud:pserver:pserver214
iscsid: >    InitiatorAlias=pserver214
iscsid: >    TargetName=iqn.2010-03.com.profitbricks:cloud:customers:storage200
iscsid: >    SessionType=Normal
iscsid: >    DefaultTime2Wait=2
iscsid: >    DefaultTime2Retain=0
iscsid: >    IFMarker=No
iscsid: >    OFMarker=No
iscsid: >    ErrorRecoveryLevel=0
iscsid: >    InitialR2T=No
iscsid: >    ImmediateData=Yes
iscsid: >    MaxBurstLength=16776192
iscsid: >    FirstBurstLength=262144
iscsid: >    MaxOutstandingR2T=1
iscsid: >    MaxConnections=1
iscsid: >    DataPDUInOrder=Yes
iscsid: >    DataSequenceInOrder=Yes
iscsid: >    InitiatorRecvDataSegmentLength=131072
iscsid: >    TargetRecvDataSegmentLength=8192
iscsid: >    RDMAExtensions=Yes
iscsid: in ksend_pdu_begin
iscsid: send PDU began for hdr 48 bytes and data 516 bytes
iscsid: in kwritev
iscsid: wrote 48 bytes of PDU header
iscsid: in kwritev
iscsid: wrote 516 bytes of PDU data
iscsid: in ksend_pdu_end
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: send PDU finished for conn 1:0
iscsid: thread removed

iscsid: poll result 1
iscsid: in ctldev_handle
iscsid: in nl_read
iscsid: ctldev_handle got event type 102

iscsid: get ev context 0x21b83d0
iscsid: message real length is 72 bytes, recv_handle 0x21b8420
iscsid: in nlpayload_read
iscsid: sched conn context 0x21b83d0 event 3, tmo 0
iscsid: thread 0x21b83d0 schedule: delay 0 state 3
iscsid: exec thread 021b83d0 callback
iscsid: Kernel reported iSCSI connection 1:0 error (1011 - ISCSI_ERR_CONN_FAILED: iSCSI connection failed) state (2)
iscsid: put ev context 0x21b83d0
iscsid: ignoring conn error in login. let it timeout
iscsid: thread removed

iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 was scheduled at 188:60, curtime 248 q_forw 0x674190 &pend_list 0x674190
iscsid: thread 021b4578 now in actor_list
iscsid: exec thread 021b4578 callback
iscsid: iscsi_login_eh
iscsid: login failed ISCSI_CONN_STATE_IN_LOGIN/R_STAGE_NO_CHANGE 2
iscsid: re-opening session 1 (reopen_cnt 2)
iscsid: thread 021b4578 delete: state 3
iscsid: thread 021b45b0 delete: state 3
iscsid: in ktransport_ep_disconnect
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: in kstop_conn
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: connection 1:0 is stopped for recovery
iscsid: Waiting 2 seconds before trying to reconnect.

iscsid: Requeue reopen attempt in 2 secs

iscsid: thread 021b4578 delete: state 3
iscsid: thread 0x21b4578 schedule: delay 8 state 3
iscsid: thread removed

iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 was scheduled at 248:8, curtime 257 q_forw 0x674190 &pend_list 0x674190
iscsid: thread 021b4578 now in actor_list
iscsid: exec thread 021b4578 callback
iscsid: iscsi_login_eh
iscsid: login failed ISCSI_CONN_STATE_XPT_WAIT/R_STAGE_NO_CHANGE
iscsid: in ktransport_ep_disconnect
iscsid: get ev context 0x21b83d0
iscsid: in ktransport_ep_connect
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: ktransport_ep_connect got handle 1
iscsid: sched conn context 0x21b83d0 event 2, tmo 0
iscsid: thread 0x21b83d0 schedule: delay 0 state 3
iscsid: Setting login timer 0x21b4578 timeout 15
iscsid: thread 0x21b4578 schedule: delay 60 state 3
iscsid: thread removed

iscsid: thread 021b83d0 removed from poll_list
iscsid: exec thread 021b83d0 callback
iscsid: put ev context 0x21b83d0
iscsid: in ktransport_ep_poll
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: in kbind_conn
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: bound iSCSI connection 1:0 to session 1
iscsid: sysfs_attr_get_value: open '/class/iscsi_connection/connection1:0'/'exp_statsn'

iscsid: sysfs_attr_get_value: new uncached attribute '/sys/class/iscsi_connection/connection1:0/exp_statsn'

iscsid: sysfs_attr_get_value: add to cache '/sys/class/iscsi_connection/connection1:0/exp_statsn'

iscsid: sysfs_attr_get_value: cache '/sys/class/iscsi_connection/connection1:0/exp_statsn' with attribute value '0'

iscsid: sending login PDU with current stage 1, next stage 3, transit 0x80, isid 0x00023d010000 exp_statsn 0
iscsid: >    InitiatorName=iqn.2010-03.com.profitbricks:cloud:pserver:pserver214
iscsid: >    InitiatorAlias=pserver214
iscsid: >    TargetName=iqn.2010-03.com.profitbricks:cloud:customers:storage200
iscsid: >    SessionType=Normal
iscsid: >    DefaultTime2Wait=2
iscsid: >    DefaultTime2Retain=0
iscsid: >    IFMarker=No
iscsid: >    OFMarker=No
iscsid: >    ErrorRecoveryLevel=0
iscsid: >    InitialR2T=No
iscsid: >    ImmediateData=Yes
iscsid: >    MaxBurstLength=16776192
iscsid: >    FirstBurstLength=262144
iscsid: >    MaxOutstandingR2T=1
iscsid: >    MaxConnections=1
iscsid: >    DataPDUInOrder=Yes
iscsid: >    DataSequenceInOrder=Yes
iscsid: >    InitiatorRecvDataSegmentLength=131072
iscsid: >    TargetRecvDataSegmentLength=8192
iscsid: >    RDMAExtensions=Yes
iscsid: in ksend_pdu_begin
iscsid: send PDU began for hdr 48 bytes and data 516 bytes
iscsid: in kwritev
iscsid: wrote 48 bytes of PDU header
iscsid: in kwritev
iscsid: wrote 516 bytes of PDU data
iscsid: in ksend_pdu_end
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: send PDU finished for conn 1:0
iscsid: thread removed

iscsid: poll result 1
iscsid: in ctldev_handle
iscsid: in nl_read
iscsid: ctldev_handle got event type 102

iscsid: get ev context 0x21b83d0
iscsid: message real length is 72 bytes, recv_handle 0x21b8420
iscsid: in nlpayload_read
iscsid: sched conn context 0x21b83d0 event 3, tmo 0
iscsid: thread 0x21b83d0 schedule: delay 0 state 3
iscsid: exec thread 021b83d0 callback
iscsid: Kernel reported iSCSI connection 1:0 error (1011 - ISCSI_ERR_CONN_FAILED: iSCSI connection failed) state (2)
iscsid: put ev context 0x21b83d0
iscsid: ignoring conn error in login. let it timeout
iscsid: thread removed

iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 wait some more
iscsid: thread 021b4578 was scheduled at 257:60, curtime 317 q_forw 0x674190 &pend_list 0x674190
iscsid: thread 021b4578 now in actor_list
iscsid: exec thread 021b4578 callback
iscsid: iscsi_login_eh
iscsid: login failed ISCSI_CONN_STATE_IN_LOGIN/R_STAGE_NO_CHANGE 3
iscsid: Giving up on initial login attempt after 60 seconds.

iscsid: disconnect conn
iscsid: in ktransport_ep_disconnect
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: stop conn (conn state 2)
iscsid: in kstop_conn
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: kdestroy conn
iscsid: in kdestroy_conn
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: kdestroy session 1
iscsid: in kdestroy_session
iscsid: in __kipc_call
iscsid: in kwritev
iscsid: in nlpayload_read
iscsid: expecting event 12, got 105, handling...
iscsid: in ctldev_handle
iscsid: in nl_read
iscsid: ctldev_handle got event type 105

iscsid: get ev context 0x21b83d0
iscsid: message real length is 72 bytes, recv_handle 0x21b8420
iscsid: in nlpayload_read
iscsid: sched conn context 0x21b83d0 event 5, tmo 0
iscsid: thread 0x21b83d0 schedule: delay 0 state 3
iscsid: in nlpayload_read
iscsid: expecting event 12, got 104, handling...
iscsid: in ctldev_handle
iscsid: in nl_read
iscsid: ctldev_handle got event type 104

iscsid: in nlpayload_read
iscsid: session destroyed sid 1 host no 0
iscsid: in nlpayload_read
iscsid: in nlpayload_read
iscsid: Connection1:0 to [target: iqn.2010-03.com.profitbricks:cloud:customers:storage200, portal: 10.1.24.204,3260] through [iface: iser] is shutdown.
iscsid: mgmt_ipc_write_rsp: rsp to fd 5
iscsid: thread 021b4578 delete: state 3
iscsid: thread 021b45b0 delete: state 3
iscsid: destroying session

iscsid: thread 021b83d0 delete: state 4
iscsid: deleting a scheduled/waiting thread!
iscsid: put ev context 0x21b83d0
iscsid: Releasing session 0x21ad380
iscsid: thread removed

iscsid: pid 10597 caught signal 15
iscsid: iscsid shutting down.

--------------020906080803020104010306--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
