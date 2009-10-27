From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [ANNOUNCE] libibcm 1.0.5 and librdmacm 1.0.10 released
Date: Mon, 26 Oct 2009 17:11:22 -0700
Message-ID: <4256F55248EA4D8AB34F933CEF754FB3@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Vlad, please pull in these releases into OFED 1.5

libibcm 1.0.5, changes from 1.0.4:
	return errors from the library consistently

librdmacm 1.0.10, changes from 1.0.9:
	examples: print errno on failures
	return errors from the library consistently
	initialize correct pthread condition
	fix race initializing library

Both are available through my git trees and for download from:

http://www.openfabrics.org/downloads/rdmacm/

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
