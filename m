From: =?iso-8859-1?Q?H=E5kon_Bugge?= <Haakon.Bugge-UdXhSnd/wVw@public.gmane.org>
Subject: Re: ib_write_bw hanging when using max max_inline value
Date: Mon, 25 Jan 2010 12:39:47 +0100
Message-ID: <45B7D3D4-811E-4645-8C18-6E32BE411650@Sun.COM>
References: <46402909-D956-438D-B560-8EA2ECB1068F@Sun.COM>
 <4B5BDA20.8070609@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; CHARSET=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-reply-to: <4B5BDA20.8070609-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Jan 24, 2010, at 6:26 , Or Gerlitz wrote:
> attaching a debugger is typically helpful to see where a program talking directly to the hardware hangs. If it happens on the slow pass, strace can be useful as well.  Did you take a look on the actual values set for this qp, that it as suggested by ibv_create_qp(3) look on the init attributes after the function returns.


The capabilities in qp_init_attr used as input to ibv_create_qp() are:

max_send_wr = 100, max_recv_wr = 1, max_send_sge = 1, max_recv_sge = 1, max_inline_data = 928

Upon return from ibv_create_qp, the capabilities are modified to the following (note, max_inline_data is not changed);

max_send_wr = 125, max_recv_wr = 1, max_send_sge = 32, max_recv_sge = 1, max_inline_data = 928

All WRs have IBV_SEND_SIGNALED set. The program does not get any completions, hence it is running in the while loop surrounding the call to ibv_poll_cq().

Note decreasing the size of the RDMA to 912 bytes, the program works.


-h

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
