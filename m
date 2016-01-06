From: james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: How to determine hex address for srpt acls, its not /sys/class/infiniband/mlx4_0/ports/1/gids/0
Date: Wed, 6 Jan 2016 04:06:25 -0500
Message-ID: <CA+X5Wn7O4YaLnzfM=0ezLDwjw7p36HUaMH07hpRA4b-a5eN2ow@mail.gmail.com>
References: <CA+X5Wn7hu=0kGv1tb+4YRQFocrQ9CdWU=_P0hmLiiEZG7G94bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CA+X5Wn7hu=0kGv1tb+4YRQFocrQ9CdWU=_P0hmLiiEZG7G94bg-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

After more digging, I found out this out of no where hex string is
referred to as "initiator_ext", and is being sent since srp_daemon.sh
give srp_daemon the "-n" flag.  Since there's no user-set
initiator_ext, srp_daemon grabs it from somewhere.

If I want to continue using the "-n" flag, how can I find out what my
initiator is going to send as initiator_ext, so the target can be set
up to work with it?

Or, can I set my own initiator_ext, it looks by appending it to
/etc/srp_daemon.conf ?

Why doesn't ibsrpdm give the initiator_ext value?

On Thu, Dec 31, 2015 at 10:06 PM, james harvey <jamespharvey20-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
> I'm at a loss on how to get the hex address to go underneath acls when
> setting up srpt.  If I use the fe80 prefix I see everywhere including
> /sys, it gets rejected.  If I use the prefix shown in the kernel
> rejection method, which I can't find anywhere else, it works fine.
>
> targetcli configuration:
>
> /> ls
> o- / .........................................................................................................................
> [...]
>   o- backstores
> ..............................................................................................................
> [...]
>   | o- block ..................................................................................................
> [Storage Objects: 3]
>   | | o- kvm1 ....................................................................
> [/dev/disk1/kvm1 (100.0GiB) write-thru activated]
>   | | o- kvm2 ....................................................................
> [/dev/disk2/kvm2 (100.0GiB) write-thru activated]
>   | | o- kvm3 ....................................................................
> [/dev/disk3/kvm3 (100.0GiB) write-thru activated]
>   | o- fileio .................................................................................................
> [Storage Objects: 0]
>   | o- pscsi ..................................................................................................
> [Storage Objects: 0]
>   | o- ramdisk ................................................................................................
> [Storage Objects: 0]
>   o- iscsi ............................................................................................................
> [Targets: 0]
>   o- loopback .........................................................................................................
> [Targets: 0]
>   o- sbp ..............................................................................................................
> [Targets: 0]
>   o- srpt .............................................................................................................
> [Targets: 1]
>   | o- ib.fe800000000000000002c90300001679
> ...........................................................................
> [no-gen-acls]
>   |   o- acls ............................................................................................................
> [ACLs: 1]
>   |   | o- ib.fe800000000000000002c90300001e79
> ....................................................................
> [Mapped LUNs: 3]
>   |   |   o- mapped_lun0
> ....................................................................................
> [lun0 block/kvm1 (rw)]
>   |   |   o- mapped_lun1
> ....................................................................................
> [lun1 block/kvm2 (rw)]
>   |   |   o- mapped_lun2
> ....................................................................................
> [lun2 block/kvm3 (rw)]
>   |   o- luns ............................................................................................................
> [LUNs: 3]
>   |     o- lun0
> .....................................................................................
> [block/kvm1 (/dev/disk1/kvm1)]
>   |     o- lun1
> .....................................................................................
> [block/kvm2 (/dev/disk2/kvm2)]
>   |     o- lun2
> .....................................................................................
> [block/kvm3 (/dev/disk3/kvm3)]
>   o- vhost ............................................................................................................
> [Targets: 0]
>   o- xen_pvscsi
> .......................................................................................................
> [Targets: 0]
>
> NOTE my InfiniBand cards have similar IDs, and only differ by one
> character -- compare the end, 1679 vs 1e79.
>
> On the target (host):
> $ cat /sys/class/infiniband/mlx4_0/ports/1/gids/0
> fe80:0000:0000:0000:0002:c903:0000:1679
> {It's my understanding this should be used underneath srpt, as the wwn}
>
> On the initiator (client):
> $ cat /sys/class/infiniband/mlx4_0/ports/1/gids/0
> fe80:0000:0000:0000:0002:c903:0000:1e79
> {It's my understanding this should be used underneath acls, and mapped
> with the luns}
> # ibsrpdm -c
> id_ext=0002c90300001678,ioc_guid=0002c90300001678,dgid=fe800000000000000002c90300001679,pkey=ffff,service_id=0002c90300001678
> {so, its /etc/srp_daemon.conf is just comments and the line}
> a id_ext=0002c90300001678,ioc_guid=0002c90300001678,dgid=fe800000000000000002c90300001679,pkey=ffff,service_id=0002c90300001678
>
> But, after starting service target on the target, and service
> srpdaemon on the initiator, dmesg on target shows:
> [  849.710278] ib_srpt Received SRP_LOGIN_REQ with i_port_id
> 0x7916000003c90200:0x2c90300001e79, t_port_id
> 0x2c90300001678:0x2c90300001678 and it_iu_len 260 on port 1
> (guid=0xfe80000000000000:0x2c90300001679)
> [  849.714528] ib_srpt Session : kernel thread ib_srpt_compl (PID 24481) started
> [  849.714601] ib_srpt Rejected login because no ACL has been
> configured yet for initiator 0x7916000003c902000002c90300001e79.
> [  849.714613] ib_srpt Session 0x7916000003c902000002c90300001e79:
> kernel thread ib_srpt_compl (PID 24481) stopped
>
> And, dmesg on initiator shows:
> [  976.616221] scsi host11: ib_srp: REJ received
> [  976.616229] scsi host11: ib_srp: SRP LOGIN from
> fe80:0000:0000:0000:0002:c903:0000:1e79 to
> fe80:0000:0000:0000:0002:c903:0000:1679 REJECTED, reason 0x00010001
> [  976.616269] scsi host11: ib_srp: Connection 0/4 failed
> [  976.616276] scsi host11: ib_srp: Sending CM DREQ failed
>
> Why is the target machine, in the srp context only, seeing the ports
> as starting with 0x7916000003c90200 and 0x2c90300001678, and the
> client machine seeing the ports as starting with fe80:0000:0000:0000?
> What are these 0x7916... and 0x2c90... prefixes, and how can I find
> them besides getting a rejection and looking at the kernel logs?  I
> haven't seen these prefixes anywhere else on either system.
>
> In targetcli, if I use acls with 0x7916000003c902000002c90300001e79,
> then everything works great.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
