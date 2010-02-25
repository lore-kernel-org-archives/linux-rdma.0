From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [Bug 1963] Cannot run Iometer between two ConnectX DDR HCAs
Date: Thu, 25 Feb 2010 09:46:24 -0800
Message-ID: <86DAB4257DD64013AD4DCB70EA83EE90@amr.corp.intel.com>
References: <bug-1963-19@https.bugs.openfabrics.org/> <20100225170525.E15D2E626AA@openfabrics.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100225170525.E15D2E626AA-G2znmakfqn7U1rindQTSdQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Usha Srinivasan' <usha.srinivasan-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

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
