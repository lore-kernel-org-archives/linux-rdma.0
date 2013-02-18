From: Sarat Kakarla <sarat.kakarla-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] Add fix to  _do_madrpc to set the errno after umad_recv.
Date: Mon, 18 Feb 2013 14:10:29 -0800
Message-ID: <5122A6D5.10400@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Jia Shi (E-mail)" <JIA.SHI-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

  _do_madrpc() (in libibmad-1.3.3/src/rpc.c) sends the mad request through umad_send() and waits for a response from umad_recv() with the timeout passed  by caller. Linux error 
number sent by peer in 'status' is not copied over to the process/thread local 'errno'.

Signed-off-by: Sarat Kakarla <sarat.kakarla-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

$diff -Naru rpc.c rpc_fix.c
--- rpc.c       2013-02-07 10:28:06.000000000 -0800
+++ rpc_fix.c   2013-02-18 13:57:15.000000000 -0800
@@ -175,6 +175,7 @@
                                          IB_MAD_TRID_F) != trid);

                 status = umad_status(rcvbuf);
+               errno = status;
                 if (!status)
                         return length;  /* done */
                 if (status == ENOMEM)
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
