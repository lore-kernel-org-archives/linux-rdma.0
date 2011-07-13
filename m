From: Mike Levine <mikejlevine-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: open-iscsi-generic compile dies on RHEL6
Date: Wed, 13 Jul 2011 15:10:21 +0000 (UTC)
Message-ID: <loom.20110713T170724-725@post.gmane.org>
References: <4BD7B89A.3000808@salasaga.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Justin Clift <justin@...> writes:


> cc -O2 -g -Wall -Wstrict-prototypes -I../include -DLinux 
> -DNETLINK_ISCSI=8 -D_GNU_SOURCE -static netlink.o util.o io.o auth.o 
> login.o log.o md5.o sha1.o iscsi_sysfs.o idbm.o initiator.o queue.o 
> actor.o mgmt_ipc.o isns.o transport.o iscsistart.o statics.o -o iscsistart
> /usr/bin/ld: cannot find -lc
> collect2: ld returned 1 exit status
> make: *** [iscsistart] Error 1
> + echo 'Failed to build open-iscsi userspace code, cleaning up...'
> 

hi justin, 
you need the static glibc-devel

yum install glibc-static

you can tell by the -static in the line that fails.

--
mike




--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
