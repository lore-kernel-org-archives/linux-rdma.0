From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: Re: re librdmacm-devel dependency on librdmacm
Date: Wed, 2 Feb 2011 17:43:35 +0200
Message-ID: <4D497BA7.9070701@voltaire.com>
References: <4D4934FA.8070905@voltaire.com> <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC0C1C2C@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CF9C39F99A89134C9CF9C4CCB68B8DDF25CC0C1C2C-osO9UTpF0USkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hefty, Sean wrote:
> What is librdmacm-devel?

as the name suggests... package for developers

Or.

> [root@celery ~]# rpm -qi librdmacm-devel
> Name        : librdmacm-devel              Relocations: (not relocatable)
> Version     : 1.0.8                             Vendor: Red Hat, Inc.
> Release     : 5.el5                         Build Date: Mon 22 Jun 2009 05:36:27 PM IDT
> Install Date: Wed 02 Feb 2011 03:05:06 PM IST      Build Host: hs20-bc1-2.build.redhat.com
> Group       : System Environment/Libraries   Source RPM: librdmacm-1.0.8-5.el5.src.rpm
> Size        : 45934                            License: GPL/BSD
> Signature   : DSA/SHA1, Thu 16 Jul 2009 08:14:31 AM IDT, Key ID 5326810137017186
> Packager    : Red Hat, Inc. <http://bugzilla.redhat.com/bugzilla>
> URL         : http://www.openfabrics.org/
> Summary     : RDMA cm library header files
> Description :
> RDMA cm library header files.

> [root@celery ~]# rpm -ql librdmacm-devel
> /usr/include/rdma
> /usr/include/rdma/rdma_cma.h
> /usr/include/rdma/rdma_cma_abi.h
> /usr/lib64/librdmacm.so
> /usr/share/man/man3/rdma_accept.3.gz
> /usr/share/man/man3/rdma_ack_cm_event.3.gz
> /usr/share/man/man3/rdma_bind_addr.3.gz
> /usr/share/man/man3/rdma_connect.3.gz
> /usr/share/man/man3/rdma_create_event_channel.3.gz
> /usr/share/man/man3/rdma_create_id.3.gz
> /usr/share/man/man3/rdma_create_qp.3.gz
> /usr/share/man/man3/rdma_destroy_event_channel.3.gz
> /usr/share/man/man3/rdma_destroy_id.3.gz
> /usr/share/man/man3/rdma_destroy_qp.3.gz
> /usr/share/man/man3/rdma_disconnect.3.gz
> /usr/share/man/man3/rdma_event_str.3.gz
> /usr/share/man/man3/rdma_free_devices.3.gz
> /usr/share/man/man3/rdma_get_cm_event.3.gz
> /usr/share/man/man3/rdma_get_devices.3.gz
> /usr/share/man/man3/rdma_get_dst_port.3.gz
> /usr/share/man/man3/rdma_get_local_addr.3.gz
> /usr/share/man/man3/rdma_get_peer_addr.3.gz
> /usr/share/man/man3/rdma_get_src_port.3.gz
> /usr/share/man/man3/rdma_join_multicast.3.gz
> /usr/share/man/man3/rdma_leave_multicast.3.gz
> /usr/share/man/man3/rdma_listen.3.gz
> /usr/share/man/man3/rdma_migrate_id.3.gz
> /usr/share/man/man3/rdma_notify.3.gz
> /usr/share/man/man3/rdma_reject.3.gz
> /usr/share/man/man3/rdma_resolve_addr.3.gz
> /usr/share/man/man3/rdma_resolve_route.3.gz
> /usr/share/man/man3/rdma_set_option.3.gz
> /usr/share/man/man7/rdma_cm.7.gz


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
