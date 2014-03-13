From: "Wangyufei (James)" <james.wangyufei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [Question] unexpected block during RDMA migration
Date: Thu, 13 Mar 2014 03:11:28 +0000
Message-ID: <EEB1E96D22080142BF33AF115818A5E173213A06@SZXEMA501-MBS.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: zh-CN
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Wangrui (K)" <moon.wangrui-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Zhaoyanbin (A)" <lefty.zhao-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello,
    Recently I did a test like this:
    1. I have host A and host B. I set ib0 on host A 192.168.0.1, I set ib0 on host B 192.168.0.2.
    2. I start a guestOS C on host A, and I do a RDMA migration from host A to host B.
    3. During the RDMA migration, I make host B power off(It simulates bad net connection or bad power supply).
    
    Then I found that:
    1. The libvirt migration api will block there forever.
    2. I debug the qemu process, and it blocks in RDMA api like forever. The stack is like this:

#0  0x00007fe987f2061c in pthread_cond_wait@@GLIBC_2.3.2 ()
   from /lib64/libpthread.so.0
#1  0x00007fe9887bf1d3 in rdma_destroy_id ()
   from /usr/lib64/librdmacm.so.1
#2  0x00007fe98a484eb3 in qemu_rdma_resolve_host (rdma=0x7fe98b585670,
    errp=0x7fffdc452bb8) at migration-rdma.c:981
#3  0x00007fe98a487d05 in qemu_rdma_source_init (rdma=0x7fe98b585670,
    errp=0x7fffdc452c10, pin_all=true) at migration-rdma.c:2298
#4  0x00007fe98a48a762 in rdma_start_outgoing_migration (opaque=
    0x7fe98ab67240 <current_migration.25929>, host_port=
    0x7fe98b4a5a97 "192.168.0.1:49152", errp=0x7fffdc452c88)
    at migration-rdma.c:3426
#5  0x00007fe98a48bd28 in qmp_migrate (uri=
0x7fe98b4a5a90 "x-rdma:192.168.0.1:49152", has_blk=true, blk=false,
has_inc=true, inc=false, has_detach=true, detach=true, errp=0x7fffaf760008)
    at migration.c:459
#6  0x00007fd00969f3b4 in qmp_marshal_input_migrate (mon=0x7fd00a61adc0, qdict=
    0x7fd00a7585f0, ret=0x7fffaf760058) at qmp-marshal.c:2793
#7  0x00007fd00978033f in qmp_call_cmd (mon=0x7fd00a61adc0, cmd=
    0x7fd009ced100 <qmp_cmds+1344>, params=0x7fd00a7585f0)
    at /home/sdb/qemu-kvm-1.5.1/monitor.c:4520
#8  0x00007fd009780606 in handle_qmp_command (parser=0x7fd00a619738, tokens=
    0x7fd00a618cd0) at /home/sdb/qemu-kvm-1.5.1/monitor.c:4598
#9  0x00007fd009813036 in json_message_process_token (lexer=0x7fd00a619740,
    token=0x7fd00a67c690, type=JSON_OPERATOR, x=124, y=10)
    at qobject/json-streamer.c:87
#10 0x00007fd00982d0ef in json_lexer_feed_char (lexer=0x7fd00a619740, ch=
    125 '}', flush=false) at qobject/json-lexer.c:303
#11 0x00007fd00982d3a0 in json_lexer_feed (lexer=0x7fd00a619740, buffer=
    0x7fffaf760330 "}\005v\257\377\177", size=1) at qobject/json-lexer.c:356
#12 0x00007fd009813270 in json_message_parser_feed (parser=0x7fd00a619738,
    buffer=0x7fffaf760330 "}\005v\257\377\177", size=1)
    at qobject/json-streamer.c:110
#13 0x00007fd00978070d in monitor_control_read (opaque=0x7fd00a61adc0, buf=
    0x7fffaf760330 "}\005v\257\377\177", size=1)
at /home/sdb/qemu-kvm-1.5.1/monitor.c:4619
#14 0x00007fd00968d9b2 in qemu_chr_be_write (s=0x7fd00a61a990, buf=
    0x7fffaf760330 "}\005v\257\377\177", len=1) at qemu-char.c:254
#15 0x00007fd009691de8 in tcp_chr_read (chan=0x7fd00a67ee40, cond=G_IO_IN,
    opaque=0x7fd00a61a990) at qemu-char.c:2607
#16 0x00007fd008b8569a in g_main_context_dispatch ()
   from /usr/lib64/libglib-2.0.so.0
#17 0x00007fd009659e59 in glib_pollfds_poll () at main-loop.c:188
#18 0x00007fd009659f4a in os_host_main_loop_wait (timeout=5643498)
    at main-loop.c:233
#19 0x00007fd00965a004 in main_loop_wait (nonblocking=0) at main-loop.c:478
#20 0x00007fd0096e8b27 in main_loop () at vl.c:2186
#21 0x00007fd0096efe33 in main (argc=49, argv=0x7fffaf761968, envp=
    0x7fffaf761af8) at vl.c:4639

    3. Just as the stack above, the main_loop of qemu will be blocked until I destroy the qemu process.

    It's unreasonable. I expect it returns error.
    What do you think about this? It confused me.

Best Regards,
-WangYufei

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
