From: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] librdmacm/mckey: enforce local binding for unmapped multicast
 addresses
Date: Sun, 1 Nov 2009 11:31:22 +0200 (IST)
Message-ID: <Pine.LNX.4.64.0911011130140.6591@zuben.voltaire.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

enforce local binding is specified for unmapped multicast addresses, otherwise mckey
crashes when attempting to use the cma_id->verbs pointer in the port query verb.

Signed-off-by: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>

Sean, using unmapped multicast addresses I see that a different broacast group is
created by the SM such that mckey doesn't manage to join the ipv4 broadcast group

$ ./mckey -M ff12:401b:ffff:0:0:0:ffff:ffff -b 10.10.5.62 -p 0x2

mckey: joined dgid: ff12:401b:ffff:: mlid c00b sl 0

looking in the SA, I see that the MGID used by the rdma-cm is a bif different
from the one used by IPoIB, since the former uses/set only the lower 28 bits where
the latter sets the lower 32 bits for this mgid, any idea what can be  done here?

$ saquery $THIS_NODE_LID

MCMemberRecord group dump:
                MGID....................ff12:401b:ffff::ffff:ffff
                Mlid....................0xC000
                Mtu.....................0x84
                pkey....................0xFFFF
                Rate....................0x83
                SL......................0x0
....

MCMemberRecord group dump:
                MGID....................ff12:401b:ffff::fff:ffff
                Mlid....................0xC00B
                Mtu.....................0x84
                pkey....................0xFFFF
                Rate....................0x83
                SL......................0x0


Index: librdmacm/examples/mckey.c
===================================================================
--- librdmacm.orig/examples/mckey.c
+++ librdmacm/examples/mckey.c
@@ -273,7 +273,7 @@ static int join_handler(struct cmatest_n
 	char buf[40];

 	inet_ntop(AF_INET6, param->ah_attr.grh.dgid.raw, buf, 40);
-	printf("mckey: joined dgid: %s\n", buf);
+	printf("mckey: joined dgid: %s mlid %x sl %d\n", buf, param->ah_attr.dlid, param->ah_attr.sl);

 	node->remote_qpn = param->qp_num;
 	node->remote_qkey = param->qkey;
@@ -556,6 +556,11 @@ int main(int argc, char **argv)
 		}
 	}

+	if (unmapped_addr && !src_addr) {
+		printf("unmapped multicast address requires binding to source address\n");
+		exit(1);
+	}
+
 	test.dst_addr = (struct sockaddr *) &test.dst_in;
 	test.connects_left = connections;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
