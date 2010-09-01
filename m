From: James A Simmons <uja-1Heg1YXhbW8@public.gmane.org>
Subject: libsdp.spec file fix
Date: Wed, 01 Sep 2010 11:21:53 -0400
Message-ID: <1283354513.14487.77.camel@bohr.ornl.gov>
Reply-To: simmonsja-1Heg1YXhbW8@public.gmane.org
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-z21mQvUnFkrRkN9H1YRt"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


--=-z21mQvUnFkrRkN9H1YRt
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

This fixes the spec file to allow the user to pass in a value for
--with-openib.

P.S 
	Was already sent to maintain fo libsdp.

--=-z21mQvUnFkrRkN9H1YRt
Content-Disposition: attachment; filename=sdp-spec.diff
Content-Type: text/x-patch; name=sdp-spec.diff; charset=UTF-8
Content-Transfer-Encoding: 7bit

--- libsdp.spec.orig	2010-09-01 10:51:42.000000000 -0400
+++ libsdp.spec	2010-09-01 10:53:04.000000000 -0400
@@ -27,7 +27,7 @@
 %setup -q
 
 %build
-%configure
+%configure %{?configure_options}
 make
 
 %install

--=-z21mQvUnFkrRkN9H1YRt--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
