From: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster-Mmb7MZpHnFY@public.gmane.org>
Subject: format string mismatch in drivers/iio/industrialio-core.c:206
Date: Mon, 19 May 2014 16:19:04 +0200
Message-ID: <537A12D8.5020106@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

FIWI cppcheck blames this :

[drivers/iio/industrialio-core.c:206]: (warning) %i in format string (no. 1) requires 'int *' but the argument type is 'unsigned int *'.
[drivers/iio/industrialio-core.c:206]: (warning) %i in format string (no. 2) requires 'int *' but the argument type is 'unsigned int *'.


-- 
Toralf

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
