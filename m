From: Andrea Gozzelino <Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org>
Subject: Socket Direct Protocol: help (2)
Date: Mon, 12 Apr 2010 16:33:50 +0200 (CEST)
Message-ID: <1246722.1271082830120.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
References: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun@imap.lnl.infn.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <13381_1271060138_o3C8FUH8013968_2977669.1271060085255.SLOX.WebMail.wwwrun-XDIR3SKYeFbgKi2NxijLtw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, pavel-+ZI9xUNit7I@public.gmane.org, mingo-X9Un+BFzKDI@public.gmane.org, Eric B Munson <ebmunson-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise@>
List-Id: linux-rdma@vger.kernel.org

On Apr 12, 2010 10:14 AM, Andrea Gozzelino
<Andrea.Gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org> wrote:

> Good morning,
> 
> I'm testing some Neteffect cards (Intel code E10G81GP - Neteffect
> NE020.LP.1.SSR).
> PC has Linux| (kernel version) 2.6.18-164.15.1.el5 | x86_64 x86_64
> x86_64 GNU/Linux.
> 
> In this phase, I measure the bandwidth with the netserver/nerperf
> (version netperf-2.4.5) ad hoc tests.
> They work fine with TCP protocol - as OFED 1.5.1 example programs -
> and
> they have some problems with SDP one.
> 
> I'm trying test with the command lines below:
> 
> server: LD_PRELOAD=/usr/local/lib64/libsdp.so netserver
> 
> client: LD_PRELOAD=/usr/local/lib64/libsdp.so netperf -H
> server_address
> -c -C
> -- -m 65536
> 
> The /etc/libsdp.conf file contains rules below:
> use both listen * *:*
> use both connect * *:*
> log min-level 9 destination file libsdp.log
> 
> Client displays "Connection error: Can not allocate memory" and the
> connection fails.
> (original text on client log file:libsdp Error connect: failed for SDP
> fd:6 with error:Cannot allocate memory)
> 
> The library path is:
> /usr/local/lib64/libsdp.so
> 
> 
> Could someone explain me how LD_PRELOAD environment variable must be
> set?
> I don't understand why the test work with TCP and not with SDP.
> Could I work with wrong Linux kernel environment or parameters?
> 
> I don't know if there is a specific mailing list for SDP so I ask you
> help.
> 
> Thank you very much,
> Andrea 
> 
> 
> 
> 
> 
> 
> 
> Andrea Gozzelino
> 
> INFN - Laboratori Nazionali di Legnaro	(LNL)
> Viale dell'Universita' 2
> I-35020 - Legnaro (PD)- ITALIA
> Tel: +39 049 8068346
> Fax: +39 049 641925
> Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org			
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma"
> in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Hi all,

I add that in kernel space SDP debug the error is:

command line: dmesg
sdp_init_qp:95 sdp_sock( 2100:2 40720:0): recv sge's. capability: 4
needed: 9
sdp_init_qp:95 sdp_sock( 2100:2 41203:0): recv sge's. capability: 4
needed: 9

The structure sdp_init_qp() is defined in
/usr/src/ofa_kernel-1.5.1/drivers/infiniband/ulp/sdp/sdp_cma.c (lines 76
- 141).

Could be a firmware problem?
I have this situation:
command line: ethtool -i eth2
driver: iw_nes
version: 1.5.0.0
firmware-version: 3.16
bus-info: 0000:03:00.0

Thank you very much,
Andrea
Andrea Gozzelino

INFN - Laboratori Nazionali di Legnaro	(LNL)
Viale dell'Universita' 2
I-35020 - Legnaro (PD)- ITALIA
Tel: +39 049 8068346
Fax: +39 049 641925
Mail: andrea.gozzelino-PK20h7lG/Rc1GQ1Ptb7lUw@public.gmane.org			

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
