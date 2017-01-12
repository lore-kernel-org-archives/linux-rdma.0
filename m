From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: How do I clear out a send/receive queue in the kernel?
Date: Thu, 12 Jan 2017 10:02:17 -0800
Message-ID: <5c079d17-1402-7380-f9c4-f36d249608e4@sandisk.com>
References: <CAANLjFr0fORQACPu=79hWTkKA8i1YRN0tbsbz1EcYBJTA5BkmA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAANLjFr0fORQACPu=79hWTkKA8i1YRN0tbsbz1EcYBJTA5BkmA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 01/11/2017 03:01 PM, Robert LeBlanc wrote:
> How would I go about discarding anything in the send or receive queue
> without gracefully flushing it or destroying the queue pair in the
> kernel? I have a feeling I have something stuck in the send queue
> preventing ib_drain_qp from completing, so I need to try just clearing
> it out.

Hello Robert,

Have you already read the section about the QP error state in the IB
spec? Most drivers call ib_modify_qp() to change the QP state into
IB_QPS_ERR before calling ib_drain_qp().

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
