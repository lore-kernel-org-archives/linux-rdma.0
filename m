From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: rdma_create_qp() and max_send_wr
Date: Sun, 22 May 2011 11:21:07 +0300
Message-ID: <20110522082107.GG2659@mtldesk30>
References: <1303404264.2243.19.camel@deela.quest-ce.net>
 <BANLkTikUOv3mtgb3x_vbbk845_36fu1QhA@mail.gmail.com>
 <4DD8B13D.4070802@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4DD8B13D.4070802-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, jackm-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
Cc: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Sun, May 22, 2011 at 09:46:21AM +0300, Or Gerlitz wrote:
> 
> Maybe the correct way to go for mlx4 is to go min/max that is,
> report the --minimal-- of max(recv, send) value that would work for
> an app setting of either of their send or the recv WR numbers.
> 

I see that OFED already contains a fix for this that Jack pushed. So I
guess Jack will send it for upstream submission.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
