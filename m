From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: rdma_create_qp() and max_send_wr
Date: Sun, 22 May 2011 09:46:21 +0300
Message-ID: <4DD8B13D.4070802@mellanox.com>
References: <1303404264.2243.19.camel@deela.quest-ce.net> <BANLkTikUOv3mtgb3x_vbbk845_36fu1QhA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <BANLkTikUOv3mtgb3x_vbbk845_36fu1QhA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Eli Cohen <eli-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> Getting exactly the right value for max_qp_wr is kind of tricky because
> of complicated allocation rules.  I guess this is just a mlx4 bug in
> reporting not quite the right value from ibv_query_device().

Maybe the correct way to go for mlx4 is to go min/max that is, report 
the --minimal-- of max(recv, send) value that would work for an app 
setting of either of their send or the recv WR numbers.

Or.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
