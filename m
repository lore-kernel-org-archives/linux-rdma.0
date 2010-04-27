From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: failed test on bug 2027
Date: Tue, 27 Apr 2010 12:34:02 +0200 (CEST)
Message-ID: <5464727.1272364442704.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_Part_16266_2043198.1272364442703"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: amirv-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

------=_Part_16266_2043198.1272364442703
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Amir, 
I have checked the bug solution with OFED-1.5.2-20100425-0600 version
without success. 

TEST LOG:
client machine
export LD_PRELOAD=/usr/lib64/libsdp.so
netperf -H address -c -C -l 60 -- -m 65536
tail -f /var/log/libsdp.log 

OUTPUT
Tue Apr 27 10:08:38 2010 netperf[19051] libsdp Error connect: failed for
SDP
fd:6 with error:Cannot allocate memory
Tue Apr 27 11:47:55 2010 netperf[19081] libsdp Error connect: failed for
SDP
fd:6 with error:Cannot allocate memory

dmesg

OUTPUT
client_script[13876]: segfault at 00007fffef8de000 rip 000000387d07ad8a
rsp
00007fffef8d5648 error 6
C_copiato[20437]: segfault at 00007ffff0257b3c rip 00000000004009e3 rsp
00007ffff0257b30 error 6
client_20[1539]: segfault at 00007fffa2acd85c rip 0000000000400a80 rsp
00007fffa2acd850 error 6
sdp_init_qp:95 sdp_sock( 2100:2 55190:0): recv sge's. capability: 4
needed: 9
sdp_init_qp:95 sdp_sock( 2100:2 41003:0): recv sge's. capability: 4
needed: 9
sdp_init_qp:95 sdp_sock( 2100:2 55192:0): recv sge's. capability: 4
needed: 9
sdp_init_qp:95 sdp_sock( 2100:2 38542:0): recv sge's. capability: 4
needed: 9

------------------

server machine
export LD_PRELOAD=/usr/lib64/libsdp.so
netserver 
    Starting netserver at port 12865
Starting netserver at hostname 0.0.0.0 port 12865 and family AF_UNSPEC

------------------
Amir, I think that bug 2028 is also involved in NE020 SDP working. 
Steve, is it possible? 
If yes, I will check the bug 2027 and 2028 solutions in July 2010. 
Is it correct?

I reopen the bug 2027 because I don't see any changes.
Please consider that the bug 2027 could be connected with the 2028 one
in Bugzilla.

Keep in touch.
Thank you very much.
Regards,
Andrea




Andrea Gozzelino

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2
I-35020 - Legnaro (PD)- ITALIA
Tel: +39 049 8068346
Fax: +39 049 641925
Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org			

------=_Part_16266_2043198.1272364442703
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename=test.txt

client machine
export LD_PRELOAD=/usr/lib64/libsdp.so
netperf -H address -c -C -l 60 -- -m 65536
tail -f /var/log/libsdp.log 

OUTPUT
Tue Apr 27 10:08:38 2010 netperf[19051] libsdp Error connect: failed for SDP fd:6 with error:Cannot allocate memory
Tue Apr 27 11:47:55 2010 netperf[19081] libsdp Error connect: failed for SDP fd:6 with error:Cannot allocate memory

dmesg

OUTPUT
client_script[13876]: segfault at 00007fffef8de000 rip 000000387d07ad8a rsp 00007fffef8d5648 error 6
C_copiato[20437]: segfault at 00007ffff0257b3c rip 00000000004009e3 rsp 00007ffff0257b30 error 6
client_20[1539]: segfault at 00007fffa2acd85c rip 0000000000400a80 rsp 00007fffa2acd850 error 6
sdp_init_qp:95 sdp_sock( 2100:2 55190:0): recv sge's. capability: 4 needed: 9
sdp_init_qp:95 sdp_sock( 2100:2 41003:0): recv sge's. capability: 4 needed: 9
sdp_init_qp:95 sdp_sock( 2100:2 55192:0): recv sge's. capability: 4 needed: 9
sdp_init_qp:95 sdp_sock( 2100:2 38542:0): recv sge's. capability: 4 needed: 9

------------------

server machine
export LD_PRELOAD=/usr/lib64/libsdp.so
netserver 
    Starting netserver at port 12865
    Starting netserver at hostname 0.0.0.0 port 12865 and family AF_UNSPEC

------------------



------=_Part_16266_2043198.1272364442703--

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
