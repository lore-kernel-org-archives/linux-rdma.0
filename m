From: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: Re: where is the perftest tree ?
Date: Tue, 17 May 2011 14:40:57 -0500
Message-ID: <4DD2CF49.8090601@systemfabricworks.com>
References: <4DC8038F.4010607@systemfabricworks.com> <4DD2A842.4070507@systemfabricworks.com> <1828884A29C6694DAF28B7E6B8A82373F8E8@ORSMSX101.amr.corp.intel.com> <4DD2B164.7040303@systemfabricworks.com> <4DD2CD3C.4090006@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060201030901010003020403"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4DD2CD3C.4090006-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ido Shamai <idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is a multi-part message in MIME format.
--------------060201030901010003020403
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 05/17/2011 02:32 PM, Ido Shamai wrote:
> Hello everyone,
> 
> Frank sorry I was gone for a while, I've lost access to this account and didn't saw those mails.
> 
> I forget to update to git tree for a a while but now it's up to date,
> with your changes also (Frank thanks for the patches).
> 
> The git tree is in -
> 
> git://git.openfabrics.org/~shamoya/perftest.git
> 

Thanks Ido. 

I've attached a patch for the Makefile so it doesn't rebuild everything every time someone types make.
Signed-off-by: Frank Zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>

There's also a typo in README: conatains -> contains (which I'll let you fix).

Regards,
  Frank.

--------------060201030901010003020403
Content-Type: text/x-diff;
 name="perftest-makefile.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="perftest-makefile.diff"

diff --git a/Makefile b/Makefile
index b4132c6..134ea26 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 RDMACM_TESTS = rdma_lat rdma_bw
-MCAST_TESTS = send_bw send_lat
-TESTS = write_bw_postlist write_lat write_bw read_lat read_bw
+MCAST_TESTS = ib_send_bw ib_send_lat
+TESTS = ib_write_bw_postlist ib_write_lat ib_write_bw ib_read_lat ib_read_bw
 UTILS = clock_test
 
 all: ${RDMACM_TESTS} ${MCAST_TESTS} ${TESTS} ${UTILS}
@@ -22,14 +22,19 @@ ${TESTS} ${UTILS}: LOADLIBES += -libverbs
 
 ${RDMACM_TESTS}: %: %.c ${BASIC_FILES} ${BASIC_HEADERS}
 	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) $< ${BASIC_FILES} $(LOADLIBES) $(LDLIBS) -o $@
-${MCAST_TESTS}: %: %.c ${BASIC_FILES} ${EXTRA_FILES} ${MCAST_FILES} ${BASIC_HEADERS} ${EXTRA_HEADERS} ${MCAST_HEADERS}
-	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) $< ${BASIC_FILES} ${EXTRA_FILES} ${MCAST_FILES} $(LOADLIBES) $(LDLIBS) -o ib_$@
-${TESTS} ${UTILS}: %: %.c ${BASIC_FILES} ${EXTRA_FILES} ${BASIC_HEADERS} ${EXTRA_HEADERS}
-	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) $< ${BASIC_FILES} ${EXTRA_FILES} $(LOADLIBES) $(LDLIBS) -o ib_$@
+
+${MCAST_TESTS}: ib_%: %.c ${BASIC_FILES} ${EXTRA_FILES} ${MCAST_FILES} ${BASIC_HEADERS} ${EXTRA_HEADERS} ${MCAST_HEADERS}
+	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) $< ${BASIC_FILES} ${EXTRA_FILES} ${MCAST_FILES} $(LOADLIBES) $(LDLIBS) -o $@
+
+${TESTS}: ib_%: %.c ${BASIC_FILES} ${EXTRA_FILES} ${BASIC_HEADERS} ${EXTRA_HEADERS}
+	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) $< ${BASIC_FILES} ${EXTRA_FILES} $(LOADLIBES) $(LDLIBS) -o $@
+
+${UTILS}: %: %.c ${BASIC_FILES} ${EXTRA_FILES} ${BASIC_HEADERS} ${EXTRA_HEADERS}
+	$(CC) $(CPPFLAGS) $(CFLAGS) $(LDFLAGS) $< ${BASIC_FILES} ${EXTRA_FILES} $(LOADLIBES) $(LDLIBS) -o $@
 
 clean:
 	$(foreach fname,${RDMACM_TESTS}, rm -f ${fname})
-	$(foreach fname,${MCAST_TESTS}, rm -f ib_${fname})
-	$(foreach fname,${TESTS} ${UTILS}, rm -f ib_${fname})
+	$(foreach fname,${MCAST_TESTS}, rm -f ${fname})
+	$(foreach fname,${TESTS} ${UTILS}, rm -f ${fname})
 .DELETE_ON_ERROR:
 .PHONY: all clean

--------------060201030901010003020403--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
