From: Greg I Kerr <kerr.g-movQPkccWJngpn9g0Uvcdg@public.gmane.org>
Subject: How is Q_KEY Set
Date: Tue, 15 Mar 2011 14:45:12 -0400
Message-ID: <AANLkTikM2W2douWdRd4JfT5K_=mQjd6v_K5z8RwBW5vt@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I was wondering how the Q_KEY is set by default, if
the user doesn't specify it in the ibv_qp_attr struct?

I couldn't find a suitable answer in the spec. The reason
I'm asking is because I have a program where I create a
"connection" in the sense that I perform all steps from
opening the device to creating queue pairs and modifying
them to point at the remote queue pairs. Then I run all the
destructor functions, until I close the device.

I then re-open a new "connection." Right now I'm having
issues with the poll_cq function either never finding anything
on the queue, or returning transport retry counter error, when
I try to send data over the new connection.

When investigating the issue I noticed that the new QP
had the same Q_KEY as the old QP, which surprised me.

Thanks

-- Greg Kerr
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
