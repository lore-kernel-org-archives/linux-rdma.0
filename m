From: Justin Clift <justin-oNuxUQfTmABg9hUCZPvPmw@public.gmane.org>
Subject: open-iscsi-generic compile dies on RHEL6
Date: Wed, 28 Apr 2010 14:24:58 +1000
Message-ID: <4BD7B89A.3000808@salasaga.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi all,

Getting a simple compilation failure for open-iscsi-generic (from OFED 
1.5.1 release) on RHEL6:

**********************************************************************
...
cc -O2 -g -Wall -Wstrict-prototypes -I../include -DLinux 
-DNETLINK_ISCSI=8 -D_GNU_SOURCE   -c -o iscsistart.o iscsistart.c
cc -O2 -g -Wall -Wstrict-prototypes -I../include -DLinux 
-DNETLINK_ISCSI=8 -D_GNU_SOURCE   -c -o statics.o statics.c
cc -O2 -g -Wall -Wstrict-prototypes -I../include -DLinux 
-DNETLINK_ISCSI=8 -D_GNU_SOURCE -static netlink.o util.o io.o auth.o 
login.o log.o md5.o sha1.o iscsi_sysfs.o idbm.o initiator.o queue.o 
actor.o mgmt_ipc.o isns.o transport.o iscsistart.o statics.o -o iscsistart
/usr/bin/ld: cannot find -lc
collect2: ld returned 1 exit status
make: *** [iscsistart] Error 1
+ echo 'Failed to build open-iscsi userspace code, cleaning up...'

**********************************************************************

Seems pretty basic, and generally I'd think this box is missing a -devel 
library, but the glibc-devel libraries (i686 and x86_64) are installed.

Anyone have any ideas?  This isn't urgent for me, as I'm not using 
iSCSI/iSER atm, more mentioning in case anyone has suggestions as I'm 
willing to try them. :)

Regards and best wishes,

Justin Clift

-- 
Salasaga  -  Open Source eLearning IDE
               http://www.salasaga.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
