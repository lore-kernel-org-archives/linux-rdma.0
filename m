From: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/4] Initial implementation of threaded throughput client
Date: Mon, 18 Dec 2017 10:26:46 -0500
Message-ID: <3a89ef9052c77e94f15d621ccebeee84d87bdd92.1513609601.git.dledford@redhat.com>
References: <cover.1513609601.git.dledford@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1513609601.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1513609601.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
References: <cover.1513609601.git.dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We add fields to the handler_info struct and use that to store
the results of individual threads since the thread destructor would
otherwise delete our performance data before we could sum it up for a
total.  Otherwise, we reuse most of the implementation of the server
thread code.

Signed-off-by: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/Client.cpp   | 140 ++++++++++++++++++++++++++++++++++++-------------------
 src/Client.h     |   3 +-
 src/Defs.h       |   8 ++++
 src/SockPerf.cpp |  53 +++++++++++++++++++--
 4 files changed, 150 insertions(+), 54 deletions(-)

diff --git a/src/Client.cpp b/src/Client.cpp
index f8c1fdd11256..0edf9c36c3fc 100644
--- a/src/Client.cpp
+++ b/src/Client.cpp
@@ -33,7 +33,9 @@
 #include "PacketTimes.h"
 #include "Switches.h"
 
-TicksTime s_startTime, s_endTime;
+extern CRITICAL_SECTION	thread_exit_lock;
+extern os_thread_t *thread_pid_array;
+TicksTime g_c_startTime, g_c_endTime;
 
 //==============================================================================
 //==============================================================================
@@ -119,7 +121,7 @@ void client_statistics(int serverNo, Message *pMsgRequest)
 
 	/* Print total statistic that is independent on server count */
 	if (SERVER_NO == 0) {
-		TicksDuration totalRunTime = s_endTime - s_startTime;
+		TicksDuration totalRunTime = g_c_endTime - g_c_startTime;
 		if (g_skipCount) {
 			log_msg_file2(f, "[Total Run] RunTime=%.3lf sec; Warm up time=%" PRIu32 " msec; SentMessages=%" PRIu64 "; ReceivedMessages=%" PRIu64 "; SkippedMessages=%" PRIu64 "",
 				totalRunTime.toDecimalUsec()/1000000, g_pApp->m_const_params.warmup_msec, sendCount, receiveCount, g_skipCount);
@@ -261,24 +263,34 @@ void client_statistics(int serverNo, Message *pMsgRequest)
 }
 
 //------------------------------------------------------------------------------
-void stream_statistics(Message *pMsgRequest)
+void stream_statistics(struct handler_info *p_info)
 {
-	TicksDuration totalRunTime = s_endTime - s_startTime;
+	TicksDuration totalRunTime = p_info->c_endTime - p_info->c_startTime;
+	uint64_t sendCount = p_info->sendCount;
+	char prefix[20];
+
+	if (g_pApp->m_const_params.mthread) {
+		if (p_info->id)
+			snprintf(prefix, sizeof prefix, "[TID: %d] ", p_info->id);
+		else
+			snprintf(prefix, sizeof prefix, "[TID: ALL] ");
+	}
+	else {
+		prefix[0] = '\0';
+	}
 
 	if (totalRunTime <= TicksDuration::TICKS0) return;
 	if (!g_pApp->m_const_params.b_stream) return;
 
-	const uint64_t sendCount = pMsgRequest->getSequenceCounter();
-
 	// Send only mode!
 	if (g_skipCount) {
-		log_msg("Total of %" PRIu64 " messages sent in %.3lf sec (%" PRIu64 " messages skipped)\n",
-				sendCount, totalRunTime.toDecimalUsec()/1000000, g_skipCount);
+		log_msg("%sTotal of %" PRIu64 " messages sent in %.3lf sec (%" PRIu64 " messages skipped)\n",
+				prefix, sendCount, totalRunTime.toDecimalUsec()/1000000, g_skipCount);
 	}
 	else 
 	{
-		log_msg("Total of %" PRIu64 " messages sent in %.3lf sec\n",
-				sendCount, totalRunTime.toDecimalUsec()/1000000);
+		log_msg("%sTotal of %" PRIu64 " messages sent in %.3lf sec\n",
+				prefix, sendCount, totalRunTime.toDecimalUsec()/1000000);
 	}
 	if (g_pApp->m_const_params.mps != MPS_MAX) {
 		if (g_pApp->m_const_params.msg_size_range)
@@ -308,17 +320,17 @@ void stream_statistics(Message *pMsgRequest)
 	int total_line_ip_data = g_pApp->m_const_params.msg_size;
 	double MBps = ((double)msgps * total_line_ip_data)/1024/1024; /* No including IP + UDP Headers per fragment */
 	if (ip_frags_per_msg == 1)
-		log_msg("Summary: Message Rate is %d [msg/sec]", msgps);
+		log_msg("%sSummary: Message Rate is %d [msg/sec]", prefix, msgps);
 	else
-		log_msg("Summary: Message Rate is %d [msg/sec], Packet Rate is about %d [pkt/sec] (%d ip frags / msg)", msgps, pktps, ip_frags_per_msg);
+		log_msg("%sSummary: Message Rate is %d [msg/sec], Packet Rate is about %d [pkt/sec] (%d ip frags / msg)", prefix, msgps, pktps, ip_frags_per_msg);
 	if (g_pApp->m_const_params.giga_size){
-		log_msg("Summary: BandWidth is %.3f GBps (%.3f Gbps)", MBps/1000, MBps*8/1000);
+		log_msg("%sSummary: BandWidth is %.3f GBps (%.3f Gbps)", prefix, MBps/1000, MBps*8/1000);
 	}
 	else if (g_pApp->m_const_params.increase_output_precision){
-			log_msg("Summary: BandWidth is %.9f GBps (%.9f Gbps)", MBps, MBps*8);
+			log_msg("%sSummary: BandWidth is %.9f GBps (%.9f Gbps)", prefix, MBps, MBps*8);
 	}
 	else{
-		log_msg("Summary: BandWidth is %.3f MBps (%.3f Mbps)", MBps, MBps*8);
+		log_msg("%sSummary: BandWidth is %.3f MBps (%.3f Mbps)", prefix, MBps, MBps*8);
 	}
 }
 
@@ -329,7 +341,7 @@ void client_sig_handler(int signum)
 		log_msg("Test end (interrupted by signal %d)", signum);
 		return;
 	}
-	s_endTime.setNowNonInline();
+	g_c_endTime.setNowNonInline();
 	g_b_exit = true;
 
 	// Just in case not Activity updates where logged add a '\n'
@@ -370,13 +382,15 @@ ClientBase::~ClientBase()
 	delete m_pMsgRequest;
 }
 
+
 //------------------------------------------------------------------------------
 template <class IoType, class SwitchDataIntegrity, class SwitchActivityInfo, class SwitchCycleDuration, class SwitchMsgSize , class PongModeCare >
-Client<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration, SwitchMsgSize , PongModeCare>::Client(int _fd_min, int _fd_max, int _fd_num):
+Client<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration, SwitchMsgSize , PongModeCare>::Client(struct handler_info *_p_info):
 	ClientBase(),
-	m_ioHandler(_fd_min, _fd_max, _fd_num),
+	m_ioHandler(_p_info->fd_min, _p_info->fd_max, _p_info->fd_num),
 	m_pongModeCare(m_pMsgRequest)
 {
+	p_info = _p_info;
 	os_thread_init (&m_receiverTid);
 }
 
@@ -408,6 +422,8 @@ template <class IoType, class SwitchDataIntegrity, class SwitchActivityInfo, cla
 void Client<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration, SwitchMsgSize , PongModeCare>
 ::cleanupAfterLoop()
 {
+	p_info->c_endTime.setNowNonInline();
+
 	usleep(100*1000);//0.1 sec - wait for rx packets for last sends (in normal flow)
 	if (m_receiverTid.tid) {
 		os_thread_kill(&m_receiverTid);
@@ -426,7 +442,9 @@ void Client<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration
 	}
 	else if (g_pApp->m_const_params.b_stream)
 	{
-		stream_statistics(m_pMsgRequest);
+		p_info->sendCount = m_pMsgRequest->getSequenceCounter();
+
+		stream_statistics(p_info);
 	}
 	else
 	{
@@ -581,9 +599,12 @@ int Client<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration,
 					}
 
 					if (rc == SOCKPERF_ERR_NONE) {
-						s_startTime.setNowNonInline();
-						g_lastTicks = s_startTime;
-						g_cycleStartTime = s_startTime - g_pApp->m_const_params.cycleDuration;
+						p_info->c_startTime.setNowNonInline();
+						if (g_c_startTime == TicksTime::TICKS0) {
+							g_c_startTime = p_info->c_startTime;
+							g_lastTicks = p_info->c_startTime;
+							g_cycleStartTime = p_info->c_startTime - g_pApp->m_const_params.cycleDuration;
+						}
 					}
 				}
 			}
@@ -635,7 +656,7 @@ void Client<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration
 ::doPlayback()
 {
 	usleep(100*1000);//wait for receiver thread to start (since we don't use warmup) //TODO: configure!
-	s_startTime.setNowNonInline();//reduce code size by calling non inline func from slow path
+	p_info->c_startTime.setNowNonInline();//reduce code size by calling non inline func from slow path
 	const PlaybackVector &pv = * g_pApp->m_const_params.pPlaybackVector;
 
 	size_t i = 0;
@@ -655,7 +676,7 @@ void Client<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration
 		m_switchActivityInfo.execute(m_pMsgRequest->getSequenceCounter());
 	}
 	g_cycle_wait_loop_counter++; //for silenting waring at the end
-	s_endTime.setNowNonInline();//reduce code size by calling non inline func from slow path
+	p_info->c_endTime.setNowNonInline();//reduce code size by calling non inline func from slow path
 	usleep(20*1000);//wait for reply of last packet //TODO: configure!
 	g_b_exit = true;
 }
@@ -684,61 +705,61 @@ void Client<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration
 
 //------------------------------------------------------------------------------
 template <class IoType, class SwitchDataIntegrity, class SwitchActivityInfo, class SwitchCycleDuration, class SwitchMsgSize, class PongModeCare>
-void client_handler(int _fd_min, int _fd_max, int _fd_num) {
-	Client<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration, SwitchMsgSize, PongModeCare> c(_fd_min, _fd_max, _fd_num);
+void client_handler(struct handler_info *_p_info) {
+	Client<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration, SwitchMsgSize, PongModeCare> c(_p_info);
 	c.doHandler();
 }
 
 //------------------------------------------------------------------------------
 template <class IoType, class SwitchDataIntegrity, class SwitchActivityInfo, class SwitchCycleDuration, class SwitchMsgSize>
-void client_handler(int _fd_min, int _fd_max, int _fd_num) {
+void client_handler(struct handler_info *_p_info) {
 	if (g_pApp->m_const_params.b_stream)
-		client_handler<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration, SwitchMsgSize, PongModeNever> (_fd_min, _fd_max, _fd_num);
+		client_handler<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration, SwitchMsgSize, PongModeNever> (_p_info);
 	else if (g_pApp->m_const_params.reply_every == 1)
-		client_handler<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration, SwitchMsgSize, PongModeAlways> (_fd_min, _fd_max, _fd_num);
+		client_handler<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration, SwitchMsgSize, PongModeAlways> (_p_info);
 	else
-		client_handler<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration, SwitchMsgSize, PongModeNormal> (_fd_min, _fd_max, _fd_num);
+		client_handler<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration, SwitchMsgSize, PongModeNormal> (_p_info);
 }
 
 //------------------------------------------------------------------------------
 template <class IoType, class SwitchDataIntegrity, class SwitchActivityInfo, class SwitchCycleDuration>
-void client_handler(int _fd_min, int _fd_max, int _fd_num) {
+void client_handler(struct handler_info *_p_info) {
 	if (g_pApp->m_const_params.msg_size_range > 0)
-		client_handler<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration, SwitchOnMsgSize> (_fd_min, _fd_max, _fd_num);
+		client_handler<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration, SwitchOnMsgSize> (_p_info);
 	else
-		client_handler<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration, SwitchOff> (_fd_min, _fd_max, _fd_num);
+		client_handler<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchCycleDuration, SwitchOff> (_p_info);
 }
 
 //------------------------------------------------------------------------------
 template <class IoType, class SwitchDataIntegrity, class SwitchActivityInfo>
-void client_handler(int _fd_min, int _fd_max, int _fd_num) {
+void client_handler(struct handler_info *_p_info) {
 	if (g_pApp->m_const_params.cycleDuration > TicksDuration::TICKS0) {
 		if (g_pApp->m_const_params.dummy_mps) {
-			client_handler<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchOnDummySend> (_fd_min, _fd_max, _fd_num);
+			client_handler<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchOnDummySend> (_p_info);
 		} else {
-			client_handler<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchOnCycleDuration> (_fd_min, _fd_max, _fd_num);
+			client_handler<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchOnCycleDuration> (_p_info);
 		}
 	}
 	else
-		client_handler<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchOff> (_fd_min, _fd_max, _fd_num);
+		client_handler<IoType, SwitchDataIntegrity, SwitchActivityInfo, SwitchOff> (_p_info);
 }
 
 //------------------------------------------------------------------------------
 template <class IoType, class SwitchDataIntegrity>
-void client_handler(int _fd_min, int _fd_max, int _fd_num) {
+void client_handler(struct handler_info *_p_info) {
 	if (g_pApp->m_const_params.packetrate_stats_print_ratio > 0)
-		client_handler<IoType, SwitchDataIntegrity, SwitchOnActivityInfo> (_fd_min, _fd_max, _fd_num);
+		client_handler<IoType, SwitchDataIntegrity, SwitchOnActivityInfo> (_p_info);
 	else
-		client_handler<IoType, SwitchDataIntegrity, SwitchOff> (_fd_min, _fd_max, _fd_num);
+		client_handler<IoType, SwitchDataIntegrity, SwitchOff> (_p_info);
 }
 
 //------------------------------------------------------------------------------
 template <class IoType>
-void client_handler(int _fd_min, int _fd_max, int _fd_num) {
+void client_handler(struct handler_info *_p_info) {
 	if (g_pApp->m_const_params.data_integrity)
-		client_handler<IoType, SwitchOnDataIntegrity> (_fd_min, _fd_max, _fd_num);
+		client_handler<IoType, SwitchOnDataIntegrity> (_p_info);
 	else
-		client_handler<IoType, SwitchOff> (_fd_min, _fd_max, _fd_num);
+		client_handler<IoType, SwitchOff> (_p_info);
 }
 
 //------------------------------------------------------------------------------
@@ -748,29 +769,29 @@ void client_handler(handler_info *p_info)
 		switch (g_pApp->m_const_params.fd_handler_type) {
 			case SELECT:
 			{
-				client_handler<IoSelect> (p_info->fd_min, p_info->fd_max, p_info->fd_num);
+				client_handler<IoSelect> (p_info);
 				break;
 			}
 			case RECVFROM:
 			{
-				client_handler<IoRecvfrom> (p_info->fd_min, p_info->fd_max, p_info->fd_num);
+				client_handler<IoRecvfrom> (p_info);
 				break;
 			}
 			case RECVFROMMUX:
 			{
-				client_handler<IoRecvfromMUX> (p_info->fd_min, p_info->fd_max, p_info->fd_num);
+				client_handler<IoRecvfromMUX> (p_info);
 				break;
 			}
 #ifndef WIN32
 			case POLL:
 			{
-				client_handler<IoPoll> (p_info->fd_min, p_info->fd_max, p_info->fd_num);
+				client_handler<IoPoll> (p_info);
 				break;
 			}
 #ifndef __FreeBSD__
 			case EPOLL:
 			{
-				client_handler<IoEpoll> (p_info->fd_min, p_info->fd_max, p_info->fd_num);
+				client_handler<IoEpoll> (p_info);
 				break;
 			}
 #endif
@@ -783,3 +804,26 @@ void client_handler(handler_info *p_info)
 		}
 	}
 }
+
+void *client_handler_multi_thread(void *arg)
+{
+	struct handler_info *p_info = (handler_info *)arg;
+
+	if (p_info) {
+		client_handler(p_info);
+
+		/* Mark this thread as complete (the first index is reserved for main thread) */
+		{
+			int i = p_info->id + 1;
+			if (p_info->id < g_pApp->m_const_params.threads_num) {
+				if (thread_pid_array && thread_pid_array[i].tid && (thread_pid_array[i].tid == os_getthread().tid)) {
+					ENTER_CRITICAL(&thread_exit_lock);
+					thread_pid_array[i].tid = 0;
+					LEAVE_CRITICAL(&thread_exit_lock);
+				}
+			}
+		}
+	}
+
+	return 0;
+}
diff --git a/src/Client.h b/src/Client.h
index 965b3b847cad..a3898705987a 100644
--- a/src/Client.h
+++ b/src/Client.h
@@ -53,6 +53,7 @@ private:
 	os_thread_t m_receiverTid;
 	IoType m_ioHandler;
 	addr_to_id   m_ServerList;
+	struct handler_info *p_info;
 
 	SwitchDataIntegrity m_switchDataIntegrity;
 	SwitchActivityInfo  m_switchActivityInfo;
@@ -61,7 +62,7 @@ private:
 	PongModeCare        m_pongModeCare; // has msg_sendto() method and can be one of: PongModeNormal, PongModeAlways, PongModeNever
 
 public:
-	Client(int _fd_min, int _fd_max, int _fd_num);
+	Client(struct handler_info *_p_info);
 	virtual ~Client();
 	void doHandler();
 	void client_receiver_thread();
diff --git a/src/Defs.h b/src/Defs.h
index 0ee0f1e229c7..97c54cd3b248 100644
--- a/src/Defs.h
+++ b/src/Defs.h
@@ -467,6 +467,14 @@ typedef struct handler_info {
 	int fd_min;					/**< minimum descriptor (fd) */
 	int fd_max;					/**< maximum socket descriptor (fd) */
 	int fd_num;					/**< number of socket descriptors */
+	/* These are all of the stats relevant to a single thread's streaming
+	 * I/O performance.  When running a throughput test as client and
+	 * running in multiple threads, we sum these up to across the
+	 * threads to get a total
+	 */
+	uint64_t sendCount;
+	TicksTime c_startTime;
+	TicksTime c_endTime;
 }handler_info;
 
 typedef struct clt_session_info {
diff --git a/src/SockPerf.cpp b/src/SockPerf.cpp
index 3c628cbc5ba1..3f912adf103e 100644
--- a/src/SockPerf.cpp
+++ b/src/SockPerf.cpp
@@ -91,8 +91,10 @@ CRITICAL_SECTION	thread_exit_lock;
 os_thread_t *thread_pid_array = NULL;
 
 // forward declarations from Client.cpp & Server.cpp
+extern void stream_statistics(struct handler_info *p_info);
 extern void client_sig_handler(int signum);
 extern void client_handler(handler_info *);
+extern void *client_handler_multi_thread(void *);
 extern void server_sig_handler(int signum);
 extern void server_handler(handler_info *);
 extern void *server_handler_multi_thread(void *);
@@ -362,8 +364,8 @@ void select_per_thread(void *(handler)(void *), int _fd_num) {
 	int last_fds = 0;
 	handler_info *handler_info_array = NULL;
 
-	handler_info_array = (handler_info*)MALLOC(sizeof(handler_info) * g_pApp->m_const_params.threads_num);
-	memset(handler_info_array, 0, sizeof(handler_info) * g_pApp->m_const_params.threads_num);
+	handler_info_array = (handler_info*)MALLOC(sizeof(handler_info) * (g_pApp->m_const_params.threads_num + 1));
+	memset(handler_info_array, 0, sizeof(handler_info) * (g_pApp->m_const_params.threads_num + 1));
 	if (!handler_info_array) {
 		log_err("Failed to allocate memory for handler_info_arr");
 		rc = SOCKPERF_ERR_NO_MEMORY;
@@ -390,7 +392,7 @@ void select_per_thread(void *(handler)(void *), int _fd_num) {
 		num_of_remainded_fds = _fd_num % g_pApp->m_const_params.threads_num;
 		fd_num = _fd_num / g_pApp->m_const_params.threads_num;
 
-		for (i = 0; i < g_pApp->m_const_params.threads_num; i++) {
+		for (i = 1; i <= g_pApp->m_const_params.threads_num; i++) {
 			handler_info *cur_handler_info = (handler_info_array + i);
 
 			/* Set ID of handler (thread) */
@@ -420,7 +422,7 @@ void select_per_thread(void *(handler)(void *), int _fd_num) {
 				rc = SOCKPERF_ERR_FATAL;
 				break;
 			}
-			thread_pid_array[i + 1].tid = thread.tid;
+			thread_pid_array[i].tid = thread.tid;
 			last_fds = cur_handler_info->fd_max + 1;
 		}
 
@@ -429,6 +431,17 @@ void select_per_thread(void *(handler)(void *), int _fd_num) {
 			sleep(1);
 		}
 
+		/* If we are stopped by a timer, we need to wait for the
+		 * sending threads to complete and fill out their p_info
+		 * structs or our totals are off.  We might have been the
+		 * thread that took the timer interrupt, and os_thread_join
+		 * below isn't waiting for us to get results, so just sleep
+		 * for a little extra time
+		 */
+		if (g_pApp->m_const_params.b_stream) {
+			sleep(1);
+		}
+
 		/* Stop all launched threads (the first index is reserved for main thread) */
 		for (i = 1; i <= g_pApp->m_const_params.threads_num; i++) {
 			os_thread_t cur_thread_pid;
@@ -448,6 +461,31 @@ void select_per_thread(void *(handler)(void *), int _fd_num) {
 		DELETE_CRITICAL(&thread_exit_lock);
 	}
 
+	/* Print out stream stats for all threads combined */
+	if (g_pApp->m_const_params.b_stream && g_pApp->m_const_params.mthread &&
+	    g_pApp->m_const_params.threads_num > 1) {
+		struct handler_info *p0 = handler_info_array;
+		struct handler_info *t;
+		int threads = g_pApp->m_const_params.threads_num;
+		TicksDuration threadRunTime, totalRunTime;
+
+		totalRunTime = TicksDuration::TICKS0;
+		/* Sum up the totals fields */
+		for (i = 1; i <= threads; i++) {
+			t = handler_info_array + i;
+			p0->sendCount += t->sendCount;
+			threadRunTime = t->c_endTime - t->c_startTime;
+			totalRunTime += threadRunTime;
+		}
+		/* average out the runtimes across the threads */
+		totalRunTime /= threads;
+		p0->c_startTime = t->c_startTime;
+		p0->c_endTime = t->c_startTime + totalRunTime;
+
+		/* print it out */
+		stream_statistics(p0);
+	}
+
 	/* Free thread info allocated data */
 	if (handler_info_array) {
 		FREE(handler_info_array);
@@ -3471,7 +3509,12 @@ void do_test()
 #endif
 	switch (s_user_params.mode) {
 	case MODE_CLIENT:
-		client_handler(&info);
+		if (s_user_params.b_stream && s_user_params.mthread) {
+			select_per_thread(client_handler_multi_thread, fd_num);
+		}
+		else {
+			client_handler(&info);
+		}
 		break;
 	case MODE_SERVER:
 		if (s_user_params.mthread) {
-- 
2.14.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
