From: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: Re: Kernel v4.16 / v4.17 SRP and SRPT patches
Date: Thu, 11 Jan 2018 15:43:55 -0500
Message-ID: <1515703435.21421.9.camel@redhat.com>
References: <1515531652.26021.1.camel@redhat.com>
         <1515537614.26021.3.camel@redhat.com> <1515591723.26021.6.camel@redhat.com>
         <20180110182648.GI4518@ziepe.ca> <1515609623.2745.20.camel@wdc.com>
         <1515610750.10153.1.camel@redhat.com> <20180110191510.GK4518@ziepe.ca>
         <1515612639.10153.3.camel@redhat.com> <20180110205243.GP4776@mellanox.com>
         <1515618674.10153.6.camel@redhat.com> <20180110211501.GS4776@mellanox.com>
         <1515675741.21421.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1515675741.21421.1.camel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bart Van Assche <Bart.VanAssche-Sjgp3cTcYWE@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org" <ddutile-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart

So after sorting out the panic issue I started full testing of your
patch sets for SRPT and SRP.

This is the fisrt time i am using your kernel for both the SRPT side
(server) and SRP side (Client)

Server and Client both running kernel off your tree

[root@fedstorage ~]# uname -a
Linux fedstorage.bos.redhat.com 4.15.0-rc7.bart+ #1 SMP Thu Jan 11
14:17:33 EST 2018 x86_64 x86_64 x86_64 GNU/Linux

Prior to booting the Server on your tree I could find my LUNS,
I was using 4.15 from Mike Snitzers tree for the server.

Now I see this on probe for SRP devices.

I have not changed any configuration entries for the srpt driver.

Still at
[root@fedstorage modprobe.d]# cat ib_srpt.conf 
options ib_srpt srp_max_req_size=8296 srpt_srq_size=32768



Server log
----------
Linux fedstorage.bos.redhat.com 4.15.0-rc7.bart+ #1 SMP Thu Jan 11
14:17:33 EST 2018 x86_64 x86_64 x86_64 GNU/Linux
[root@fedstorage ~]# [  533.405291] IPv6: ADDRCONF(NETDEV_CHANGE): ib0:
link becomes ready
[  533.442884] IPv6: ADDRCONF(NETDEV_CHANGE): ib1: link becomes ready
[  540.024438] ib_srpt Received SRP_LOGIN_REQ with i_port_id
7cfe:9003:0072:6e4e:7cfe:9003:0072:6ed2, t_port_id
7cfe:9003:0072:6e4e:7cfe:9003:0072:6e4e and it_iu_len 2116 on port 1
(guid=fe80:0000:0000:0000:7cfe:9003:0072:6e4e); pkey 0xffff
[  540.141464] ib_srpt failed to create queue pair with sq_size = 16384
(-12) - retrying
[  540.186159] ib_srpt failed to create queue pair with sq_size = 8192
(-12) - retrying
[  540.231794] ib_srpt Rejected login for initiator
7cfe:9003:0072:6ed2: r[root@fedstorage modprobe.d]# cat ib_srpt.conf 
options ib_srpt srp_max_req_size=8296 srpt_srq_size=32768
et = -13.
[  540.274077] ib_srpt Rejecting login with reason 0x10006
[  540.304117] ib_srpt Received SRP_LOGIN_REQ with i_port_id
7cfe:9003:0072:6e4f:7cfe:9003:0072:6ed3, t_port_id
7cfe:9003:0072:6e4e:7cfe:9003:0072:6e4e and it_iu_len 2116 on port 1
(guid=fe80:0000:0000:0000:7cfe:9003:0072:6e4f); pkey 0xffff
[  540.426295] ib_srpt failed to create queue pair with sq_size = 16384
(-12) - retrying
[  540.470829] ib_srpt failed to create queue pair with sq_size = 8192
(-12) - retrying
[  540.515817] ib_srpt Rejected login for initiator
7cfe:9003:0072:6ed3: ret = -13.
[  540.556485] ib_srpt Rejecting login with reason 0x10006


Client log
----------
[  554.414466] IPv6: ADDRCONF(NETDEV_CHANGE): ib0: link becomes ready
[  559.264828] scsi host2: ib_srp: SRP LOGIN from
fe80:0000:0000:0000:7cfe:9003:0072:6ed2 to
fe80:0000:0000:0000:7cfe:9003:0072:6e4e REJECTED, reason 0x00010006
[  559.342571] scsi host2: ib_srp: Connection 0/8 to
fe80:0000:0000:0000:7cfe:9003:0072:6e4e failed
[  559.546713] scsi host1: ib_srp: SRP LOGIN from
fe80:0000:0000:0000:7cfe:9003:0072:6ed3 to
fe80:0000:0000:0000:7cfe:9003:0072:6e4f REJECTED, reason 0x00010006
[  559.626139] scsi host1: ib_srp: Connection 0/8 to
fe80:0000:0000:0000:7cfe:9003:0072:6e4f failed
[  591.325685] scsi host1: ib_srp: SRP LOGIN from
fe80:0000:0000:0000:7cfe:9003:0072:6ed2 to
fe80:0000:0000:0000:7cfe:9003:0072:6e4e REJECTED, reason 0x00010006
[  591.404376] scsi host1: ib_srp: Connection 0/8 to
fe80:0000:0000:0000:7cfe:9003:0072:6e4e failed
[  591.605330] scsi host2: ib_srp: SRP LOGIN from
fe80:0000:0000:0000:7cfe:9003:0072:6ed3 to
fe80:0000:0000:0000:7cfe:9003:0072:6e4f REJECTED, reason 0x00010006
[  591.681975] scsi host2: ib_srp: Connection 0/8 to
fe80:0000:0000:0000:7cfe:9003:0072:6e4f failed
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
