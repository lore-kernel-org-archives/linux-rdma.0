From: Usha Srinivasan <usha.srinivasan-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: RE: [Bug 1963] Cannot run Iometer between two ConnectX DDR HCAs
Date: Thu, 25 Feb 2010 12:04:16 -0600
Message-ID: <7866DA1F8D2D4541B87FEE88E633ABAA2B2C80DCFF@MNEXMB1.qlogic.org>
References: <bug-1963-19@https.bugs.openfabrics.org/>
 <20100225170525.E15D2E626AA@openfabrics.org>
 <86DAB4257DD64013AD4DCB70EA83EE90@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <86DAB4257DD64013AD4DCB70EA83EE90-Zpru7NauK7drdx17CPfAsdBPR1lH4CV8@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

System2 is still up (although with Iometer I have run into system 2 hanging). Once the test fails, I can do pretty much nothing. Ibv_devinfo says Failed to get IB device list.  The ping was my test to figure out if things were still ok between the two systems. And, its failure told me that the link at system2 was down.


Here are the log entries from the incident(in chronological order):
mlx4_cmd_wait: Command 24 completed with timeout after 5000 msecs
mlx4_cmd_wait: HCA has been reset.
mlx4_cmd_wait: Command failed: op 0x24, status 0xff, errno -16, token 0x7f90.
mlx4_cmd_wait: Command 17 completed with timeout after 5000 msecs
mlx4_cmd_wait: Command failed: op 0x17, status 0xff, errno -16, token 0xdf1.
HW2SW_CQ failed (-16) for CQN 00008d
mlx4_cmd_wait: Command 0f completed with timeout after 5000 msecs
mlx4_cmd_wait: Command failed: op 0xf, status 0xff, errno -16, token 0x22.
HW2SW_MPT failed (-16)
OpenFabrics IPoIB Adapter #2: Network controller link is down.


I will reboot & try running ibv_send_bw.
Usha

-----Original Message-----
From: Sean Hefty [mailto:sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org] 
Sent: Thursday, February 25, 2010 12:46 PM
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Usha Srinivasan
Subject: RE: [Bug 1963] Cannot run Iometer between two ConnectX DDR HCAs

>------- Comment #1 from usha.srinivasan-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org  2010-02-25 09:05 -------
>This morning, I ran ib_send_bw between my two connectx systems and ran into a
>send problem there as well.
>
>At system1 I ran these tests:
>ib_send_bw -c UD
>ib_send_bw -c UD -all
>ib_send_bw -c UD -all -t 1500 -n 1500
>ib_send_bw -c UD -all -t 1800 -n 1800
>ib_send_bw -c UD -all -t 2000 -n 2000
>
>At system2, I ran:
>ib_send_bw -c UD <sys1_ipoib_addr>
>ib_send_bw -c UD -all <sys1_ipoib_addr>
>ib_send_bw -c UD -all -n 1500 -t 1500 <sys1_ipoib_addr>
>ib_send_bw -c UD -all -n 1800 -t 1800 <sys1_ipoib_addr>
>ib_send_bw -c UD -all -n 2000 -t 2000 <sys1_ipoib_addr>
>
>All was well until I got to the 2000 packets; in that test, the sender stopped
>after packet size 32.  I waited a bit and hit Ctrl-C. Then I ran vstat and it
>would not run (sometimes I get a popup saying appcrashed but this time it just
>went to end of job.)  All seems fine at sytem1 the receiver, but it can no
>longer ping system2.

Running ib_send_bw *shouldn't* have any affect on using ping.  Did system2
crash, or is it still running?  Can you see if anything running to the HCA works
(e.g. try ibv_devinfo or sminfo)?

>Am I doing something wrong? Or, is this a WinOF bug or a Windows 2008 bug?
>(I'm CC'ing Sean & Stan for their advice on running ib-send-bw.)

Can you also try running with ibv_send_bw and see if the results are the same?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
