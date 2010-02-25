From: Or Gerlitz <ogerlitz-hKgKHo2Ms0FWk0Htik3J/w@public.gmane.org>
Subject: Re: Oops in iscsi_conn_failure()
Date: Thu, 25 Feb 2010 10:06:02 +0200
Message-ID: <4B862F6A.5020800@Voltaire.com>
References: <hm15jb$or7$1@dough.gmane.org> <hm1b44$fa4$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <hm1b44$fa4$1@dough.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roman Kononov <roman-63PA5aZBFHTyn80wtf4cgA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roman Kononov wrote:
> The same with 2.6.32.9
> kernel: BUG: unable to handle kernel paging request at 00000000621ae010
> kernel: IP: [<ffffffffa004110e>] iscsi_conn_failure+0x1e/0xc0 [libiscsi]

Can you elaborate what does it take to reproduce that? 

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
