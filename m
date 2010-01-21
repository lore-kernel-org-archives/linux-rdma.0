From: =?iso-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Subject: [PATCH] libibverbs: Force line-buffering in ibv_asyncwatch
Date: Thu, 21 Jan 2010 14:40:45 +0100
Message-ID: <ED0695A5-CBE3-4CE2-A20C-BBC7BEF28C33@Sun.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Cc: OFED mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

ibv_asyncwatch defaults to block-buffering when stdout is redirected to a file or pipe. This fix makes it more usable in scripted environments.

Signed-off-by: Hakon Bugge <Haakon.Bugge-xsfywfwIY+M@public.gmane.org>
---
diff --git a/examples/asyncwatch.c b/examples/asyncwatch.c
index e56b4dc..f9fe6ff 100644
--- a/examples/asyncwatch.c
+++ b/examples/asyncwatch.c
@@ -98,6 +98,9 @@ int main(int argc, char *argv[])
                return 1;
        }
 
+       /* Force line-buffering if stdout is redirected */
+       setlinebuf(stdout);
+
        printf("%s: async event FD %d\n",
               ibv_get_device_name(*dev_list), context->async_fd);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
