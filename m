From: Florent Parent <florent.parent-hUdP7zcY/u2zFPF/XzyFIQ@public.gmane.org>
Subject: Re: bug report: opensm 3.3.15 crash (with traces)
Date: Wed, 2 Apr 2014 17:43:37 -0400
Message-ID: <CAF3spKES=F1Tr6Y-iwMV_Dues80HnHvxOeaSN9KjTJbQvU0qyg@mail.gmail.com>
References: <CAF3spKHCEVtmdjXHS-1YGjZ2OHsURsn3Junt3OhbNCF7_AfG9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAF3spKHCEVtmdjXHS-1YGjZ2OHsURsn3Junt3OhbNCF7_AfG9A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi,

We experienced constant crashing from opensm 3.3.15 (3.3.15-1.el6.cq5)
after a recent upgrade. We compiled and installed 3.3.17 and problem
went away.

OpenSM server: CentOS 6.5 w/ stock RDMA. OpenSM 3.3.15 was from the
CentOS repository.

A behaviour that may help diagnose this: Unusual large amount messages
were filling up the opensm.log file:

Mar 13 09:50:04 909147 [4FAFC700] 0x01 -> log_rcv_cb_error: ERR 3111:
Received MAD with error status = 0x1C
                        SubnGetResp(SwitchInfo), attr_mod 0x0, TID 0x73c86e46
                        Initial path: 0,1,33,30,28 Return path: 0,10,32,13,28

80 of these messages occur periodically. smpquery on the paths shows
that these all point to the Sun QNEM switches (80 I4 chips).
"use_mfttop FALSE" eliminated these messages.

Florent


*** glibc detected *** /usr/sbin/opensm: malloc(): smallbin double
linked list corrupted: 0x00007f9b3c4352a0 ***
======= Backtrace: =========
/lib64/libc.so.6(+0x76166)[0x7f9b56279166]
/lib64/libc.so.6(+0x79f1f)[0x7f9b5627cf1f]
/lib64/libc.so.6(__libc_malloc+0x71)[0x7f9b5627d991]
/usr/sbin/opensm[0x4216f3]
/usr/sbin/opensm(osm_pkey_mgr_process+0x467)[0x422187]
/usr/sbin/opensm[0x446efb]
/usr/sbin/opensm(osm_state_mgr_process+0x1f8)[0x448538]
/usr/sbin/opensm[0x4422bb]
/usr/lib64/libosmcomp.so.3(+0x85fe)[0x7f9b56ddb5fe]
/lib64/libpthread.so.0(+0x79d1)[0x7f9b5659e9d1]
/lib64/libc.so.6(clone+0x6d)[0x7f9b562ebb6d]

*** glibc detected *** /usr/sbin/opensm: double free or corruption
(out): 0x00007fe2f42e1830 ***
======= Backtrace: =========
/lib64/libc.so.6(+0x76166)[0x7fe30ec9d166]
/lib64/libc.so.6(+0x78c93)[0x7fe30ec9fc93]
/usr/sbin/opensm[0x449cf6]
/usr/sbin/opensm(osm_subn_rescan_conf_files+0x194)[0x44af14]
/usr/sbin/opensm[0x447260]
/usr/sbin/opensm(osm_state_mgr_process+0x1f8)[0x448538]
/usr/sbin/opensm[0x4422bb]
/usr/lib64/libosmcomp.so.3(+0x85fe)[0x7fe30f7ff5fe]
/lib64/libpthread.so.0(+0x79d1)[0x7fe30efc29d1]
/lib64/libc.so.6(clone+0x6d)[0x7fe30ed0fb6d]

*** glibc detected *** /usr/sbin/opensm: malloc(): smallbin double
linked list corrupted: 0x00007f200838ede0 ***
======= Backtrace: =========
/lib64/libc.so.6(+0x76166)[0x7f2025131166]
/lib64/libc.so.6(+0x79f1f)[0x7f2025134f1f]
/lib64/libc.so.6(__libc_malloc+0x71)[0x7f2025135991]
/usr/sbin/opensm[0x4216f3]
/usr/sbin/opensm(osm_pkey_mgr_process+0x467)[0x422187]
/usr/sbin/opensm[0x446efb]
/usr/sbin/opensm(osm_state_mgr_process+0x1f8)[0x448538]
/usr/sbin/opensm[0x4422bb]
/usr/lib64/libosmcomp.so.3(+0x85fe)[0x7f2025c935fe]
/lib64/libpthread.so.0(+0x79d1)[0x7f20254569d1]
/lib64/libc.so.6(clone+0x6d)[0x7f20251a3b6d]


*** glibc detected *** /usr/sbin/opensm: malloc(): smallbin double
linked list corrupted: 0x00007f8464013df0 ***
======= Backtrace: =========
/lib64/libc.so.6(+0x76166)[0x7f847ec95166]
/lib64/libc.so.6(+0x79f1f)[0x7f847ec98f1f]
/lib64/libc.so.6(__libc_malloc+0x71)[0x7f847ec99991]
/usr/sbin/opensm[0x4216f3]
/usr/sbin/opensm(osm_pkey_mgr_process+0x467)[0x422187]
/usr/sbin/opensm[0x446efb]
/usr/sbin/opensm(osm_state_mgr_process+0x1f8)[0x448538]
/usr/sbin/opensm[0x4422bb]
/usr/lib64/libosmcomp.so.3(+0x85fe)[0x7f847f7f75fe]
/lib64/libpthread.so.0(+0x79d1)[0x7f847efba9d1]
/lib64/libc.so.6(clone+0x6d)[0x7f847ed07b6d]
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
