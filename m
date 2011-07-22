From: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Subject: [PATCH 14/14] SIWv3: Documentation: siw.txt
Date: Fri, 22 Jul 2011 20:48:24 +0200
Message-ID: <1311360504-15343-1-git-send-email-bmt@zurich.ibm.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

---
 Documentation/networking/siw.txt |  155 ++++++++++++++++++++++++++++++++++++++
 1 files changed, 155 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/networking/siw.txt

diff --git a/Documentation/networking/siw.txt b/Documentation/networking/siw.txt
new file mode 100644
index 0000000..fb51735
--- /dev/null
+++ b/Documentation/networking/siw.txt
@@ -0,0 +1,155 @@
+SoftiWARP: Software iWARP kernel driver module.
+
+General
+-------
+SoftiWARP (siw) implements the iWARP protocol suite (MPA/DDP/RDMAP,
+IETF-RFC 5044/5041/5040) completely in software as a Linux kernel module.
+siw runs on top of TCP kernel sockets and exports the Linux kernel ibverbs
+RDMA interface. siw interfaces with the iwcm connection manager.
+
+
+Transmit Path
+-------------
+If a send queue (SQ) work queue element gets posted, siw tries to send
+it directly out of the application context. If the SQ was non-empty,
+SQ processing is done asynchronously by a kernel worker thread. This
+thread is scheduled if the TCP socket signals new write space to
+be available. If during send operation the socket send space becomes
+exhausted, SQ processing is abandoned until new socket write space
+becomes available.
+
+
+Receive Path
+------------
+All application data is placed into target buffers within softirq
+socket callback. Application notification is asynchronous.
+
+
+User Interface
+--------------
+All user space fast path operations such as posting of work requests and
+reaping of work completions currently involve an asynchronous call into
+the siw kernel module via ib_uverbs interface. Kernel/user-mapped send
+and receive as well as completion queues are not part of the current code.
+In particular, mapped completion queues may improve performance,
+since reaping completion queue entries as well as re-arming
+the completion queue could be done more efficiently.
+
+
+Kernel Client Support
+---------------------
+To guarantee non-blocking fast path operations, for kernel clients
+all work queue elements (send/receive/shared-receive queue) are
+pre-allocated during connection resource setup.
+
+
+Memory Management
+-----------------
+siw currently uses the ib_umem_get() function of the ib_core module
+to pin memory for later use in data transfer operations. Transmit
+and receive memory are checked against correct access permissions only
+at the moment of access by the network input path or before pushing it
+to the TCP socket for transmission.
+ib_umem_get() provides DMA mappings for the requested address space which
+are not used by siw.
+
+
+Module Parameters
+-----------------
+The following siw module parameters are recognized.
+
+loopback_enabled:
+	If set, siw attaches also to the looback device. Checked only
+	during module insertion.
+
+mpa_crc_required:
+	If set, the MPA CRC is generated and checked both in tx and rx
+	path. Without hardware support, setting this flag will severely
+	hurt throughput. Default setting is 0 (off).
+
+mpa_crc_strict:
+	If set, MPA CRC will not be enabled, even if peer requests
+	it. If the peer requests CRC generation, the connection setup
+	will be aborted. Default setting is 1 (on).
+
+zcopy_tx:
+	If set, payloads of non-signalled work requests
+	(such as non-signalled WRITE or SEND as well as all READ
+	responses) are transferred using the TCP sockets
+	sendpage interface. This parameter can be switched on and
+	off dynamically (echo 1 >> /sys/module/siw/parameters/zcopy_tx
+	for enablement, 0 for disabling). System load may benefits from
+	using zero copy data transmission. Zero copy is not enabled if
+	mpa_crc_enabled is set. Default setting is 1 (on).
+
+tcp_nodelay:
+	If set, on the TCP socket the TCP_NODELAY option is set.
+	Default setting is 1 (on).
+
+iface_list:
+	Comma-separated list of interfaces siw should attach to.
+	If no list is given, siw attaches to all available devices.
+	If a list is given, siw skips those devices not listed.
+	Currently, the list is restricted to 12 entries. If needed,
+	the 'SIW_MAX_IF' #define in siw_main.c can be modified.
+	This parameter might be useful to skip devices which are
+	attached to a real RNIC device. Default setting is an empty list.
+
+
+Compile Time Flags:
+-------------------
+-DCHECK_DMA_CAPABILITIES
+	Checks if the device siw wants to attach to provides
+	DMA capabilities. While DMA capabilities are currently not
+	needed (siw works on top of kernel TCP sockets), siw
+	uses ib_umem_get() which performs a (not used) DMA address
+	translation. Writing a siw private memory reservation and
+	pinning routine would solve the issue.
+
+-DSIW_TX_FULLSEGS
+	Experimental, not enabled by default. If set,
+	siw tries not to overrun the socket (not sending until
+	-EAGAIN return), but stops sending if the current segment
+	would not fit into the socket's estimated tx buffer. With that,
+	wire FPDUs may get truncated by the TCP stack far less often.
+	Since this feature manipulates the sock's SOCK_NOSPACE
+	bit, it violates strict layering and is therefore considered
+	proprietary.
+	Since TCP is a byte stream protocol, no guarantee can be given
+	if FPDUs are not fragmented.
+
+
+Debugging SoftiWARP:
+--------------------
+Runtime debugging:
+	The siw_debug.h file defines a 'dprint' macro which is used
+	to debug siw at runtime. Verbosity of debugging is controlled
+	at compile time via setting 'DPRINT_MASK' to an or'd list
+	of know values as defined in siw_debug.h,
+	e.g. '#define DPRINT_MASK (DBG_ON|DBG_CM)'
+	to debug errors and connection management. Defining DPRINT_MASK
+	to '0' avoids to compile any runtime debugging code.
+
+Debugfs support:
+	To track siw's usage of its objects (connection endpoints,
+	TCP sockets, protection domains, queue pairs, shared receive
+	queues, completion queues, memory registrations, work queue
+	elements), some debug filesystem support has been added.
+	To make use of it, the kernel must be enabled for debug
+	filesystem support (enable 'Kernel hacking -> Debug filesystem'
+	during kernel configuration). Furthermore, the debug filesystem
+	must be mounted, e.g. use
+
+	# mount -t debugfs none /sys/kernel/debug
+
+	If the siw kernel module is loaded, the siw/ directory now
+	contains the following entries for each siw device
+	(e.g. /sys/kernel/debug/siw/siw_eth0):
+
+	stats: 	Summary of allocated WQEs, PDs, QPs, CQs, SRQs, MRs, CEPs.
+		WQE statistics are not gathered if 'DPRINT_MASK' is
+		set to '0' (see above).
+
+	qp:	Status of allocated queue pairs.
+
+	cep:	Status of allocated connection end points.
-- 
1.5.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
