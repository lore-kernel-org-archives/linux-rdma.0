From: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: RE: rsockets and fork
Date: Fri, 17 Aug 2012 14:40:25 -0700
Message-ID: <1345239625.1128.20.camel@oc1677441337.ibm.com>
References: <1344899557.2101.29.camel@oc1677441337.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A7DB36@ORSMSX101.amr.corp.intel.com>
	 <502A9039.4090505@us.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A89125@ORSMSX101.amr.corp.intel.com>
	 <1344968289.2101.36.camel@oc1677441337.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A89AEB@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A89AEB-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 2012-08-16 at 23:40 +0000, Hefty, Sean wrote:

> I don't have RoCE installed.  With IB, I haven't been able to see this problem after dozens of attempts.  The performance isn't divided equally, but I usually see between 3-10 Gbps out of each connection.  I'm running with some additional patches, but I don't see where those would affect any hang.
> 
> During development, I've seen issues where specific transfer patterns just happen to fall on boundary conditions that result in hangs or slowness.  Hopefully that's not the case because those are a pain to identify.
> 
> Is this something that you would be able to use a debugger on?  Dumping the contents of the struct rsocket * would be useful in troubleshooting if we're waiting on credits, buffer space, the app, or something else.
> 
Here are the dumps of struct rsocket of a hung netperf connection.
netserver: hang in recv()

(gdb) bt
#0  0x0000003286ed83f0 in __read_nocancel () from /lib64/libc.so.6
#1  0x0000003b7220a1c4 in ibv_get_cq_event () from /usr/lib64/libibverbs.so.1
#2  0x00007fee00642197 in rs_get_cq_event (rs=0x18139c0) at src/rsocket.c:941
#3  0x00007fee00643567 in rs_process_cq (rs=0x18139c0, nonblock=0, 
    test=0x7fee006414b0 <rs_conn_have_rdata>) at src/rsocket.c:989
#4  0x00007fee006438bd in rs_get_comp (rs=0x18139c0, nonblock=<value optimized out>, 
    test=0x7fee006414b0 <rs_conn_have_rdata>) at src/rsocket.c:1019
#5  0x00007fee00643b51 in rrecv (socket=<value optimized out>, buf=0x17fdd10, len=87380, 
    flags=<value optimized out>) at src/rsocket.c:1136
#6  0x000000000042d6e3 in recv_data ()
#7  0x0000000000430da9 in recv_omni ()
#8  0x0000000000403628 in process_requests ()
#9  0x00000000004037b0 in spawn_child ()
#10 0x00000000004038f0 in accept_connection ()
#11 0x0000000000403a46 in accept_connections ()
#12 0x000000000040407a in main ()
(gdb) p *(struct rsocket *)0x18139c0
$1 = {cm_id = 0x1813b80, slock = {sem = {__size = "\000\000\000\000\200", '\000' <repeats 26 times>, 
      __align = 549755813888}, cnt = 0}, rlock = {sem = {
      __size = "\000\000\000\000\200", '\000' <repeats 26 times>, __align = 549755813888}, cnt = 1}, 
  cq_lock = {sem = {__size = "\000\000\000\000\200", '\000' <repeats 26 times>, 
      __align = 549755813888}, cnt = 0}, cq_wait_lock = {sem = {
      __size = "\000\000\000\000\200", '\000' <repeats 26 times>, __align = 549755813888}, cnt = 1}, 
  opts = 0, fd_flags = 2, so_opts = 4, tcp_opts = 2, ipv6_opts = 0, state = 1792, cq_armed = 1, 
  retries = 0, err = 0, index = 16, ctrl_avail = 3, sqe_avail = 1020, sbuf_bytes_avail = 131072, 
  sseq_no = 0, sseq_comp = 1024, sq_size = 1024, sq_inline = 64, rq_size = 1024, rseq_no = 3515, 
  rseq_comp = 4026, rbuf_bytes_avail = 63488, rbuf_free_offset = 65536, rbuf_offset = 129024, 
  rmsg_head = 440, rmsg_tail = 440, rmsg = 0x1813dd0, remote_sge = 1, remote_sgl = {addr = 6784856, 
    key = 2550145917, length = 2}, target_mr = 0x1815e60, target_sge = 0, target_sgl = {{
      addr = 140617248624656, key = 2550146173, length = 65536}, {addr = 140617248690192, 
      key = 2550146173, length = 65536}}, rbuf_size = 131072, rmr = 0x17dd680, 
  rbuf = 0x7fee00347010 "netperf", sbuf_size = 131072, smr = 0x17dffd0, ssgl = {{
      addr = 140660182515728, length = 0, lkey = 3758105205}, {addr = 140660182515728, length = 0, 
      lkey = 3758105205}}, sbuf = 0x7fee00368010 ""}

netperf: hang in send()
(gdb) bt
#0  0x0000003120ad83f0 in __read_nocancel () from /lib64/libc.so.6
#1  0x0000003da700a1c4 in ibv_get_cq_event () from /usr/lib64/libibverbs.so.1
#2  0x00007fe40157f197 in rs_get_cq_event (rs=0x678610) at src/rsocket.c:941
#3  0x00007fe401580567 in rs_process_cq (rs=0x678610, nonblock=0, 
    test=0x7fe40157e430 <rs_conn_can_send>) at src/rsocket.c:989
#4  0x00007fe4015808bd in rs_get_comp (rs=0x678610, 
    nonblock=<value optimized out>, test=0x7fe40157e430 <rs_conn_can_send>)
    at src/rsocket.c:1019
#5  0x00007fe401581b92 in rsend (socket=<value optimized out>, 
    buf=<value optimized out>, len=65536, flags=<value optimized out>)
    at src/rsocket.c:1244
#6  0x000000000042ba6d in send_data ()
#7  0x000000000042d158 in send_omni_inner ()
#8  0x000000000042fbf1 in send_tcp_stream ()
#9  0x000000000040239d in main ()
(gdb) p *(struct rsocket *)0x678610
$1 = {cm_id = 0x6a2af0, slock = {sem = {
      __size = "\000\000\000\000\200", '\000' <repeats 26 times>, 
      __align = 549755813888}, cnt = 1}, rlock = {sem = {
      __size = "\000\000\000\000\200", '\000' <repeats 26 times>, 
      __align = 549755813888}, cnt = 0}, cq_lock = {sem = {
      __size = "\000\000\000\000\200", '\000' <repeats 26 times>, 
      __align = 549755813888}, cnt = 0}, cq_wait_lock = {sem = {
      __size = "\000\000\000\000\200", '\000' <repeats 26 times>, 
      __align = 549755813888}, cnt = 1}, opts = 0, fd_flags = 2, so_opts = 4, 
  tcp_opts = 0, ipv6_opts = 0, state = 1792, cq_armed = 1, retries = 0, err = 0, 
  index = 12, ctrl_avail = 4, sqe_avail = 1020, sbuf_bytes_avail = 131072, 
  sseq_no = 3522, sseq_comp = 4538, sq_size = 1024, sq_inline = 64, 
  rq_size = 1024, rseq_no = 0, rseq_comp = 512, rbuf_bytes_avail = 0, 
  rbuf_free_offset = 0, rbuf_offset = 0, rmsg_head = 0, rmsg_tail = 0, 
  rmsg = 0x6a2d90, remote_sge = 0, remote_sgl = {addr = 25246472, 
    key = 3758105461, length = 2}, target_mr = 0x6a4e20, target_sge = 1, 
  target_sgl = {{addr = 140660182446096, key = 3758105717, length = 0}, {
      addr = 140660182511632, key = 3758105717, length = 0}}, rbuf_size = 131072, 
  rmr = 0x677c80, rbuf = 0x7fe401275010 "", sbuf_size = 131072, smr = 0x678980, 
  ssgl = {{addr = 140617248825360, length = 2048, lkey = 2550145661}, {
      addr = 140617248759824, length = 0, lkey = 2550145661}}, 
  sbuf = 0x7fe401296010 "netperf"}


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
