From: Robert LeBlanc <robert-4JaGZRWAfWbajFs6igw21g@public.gmane.org>
Subject: Re: How do I clear out a send/receive queue in the kernel?
Date: Thu, 12 Jan 2017 11:20:39 -0700
Message-ID: <CAANLjFo93NU6XhLknruG_PfWaHnD0+eK8LfeiZ6g46Kt4kRUsg@mail.gmail.com>
References: <CAANLjFr0fORQACPu=79hWTkKA8i1YRN0tbsbz1EcYBJTA5BkmA@mail.gmail.com>
 <5c079d17-1402-7380-f9c4-f36d249608e4@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5c079d17-1402-7380-f9c4-f36d249608e4-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I see that in the code, but I don't think it is working. I have
something that seems to clear things out and I can prevent the iSCSI D
state issue and the session recovers, but after a few recoveries,
iSCSI starts becoming unhappy. Hopefully it is enough to give some
more insight into the problem for someone much smarter than me. I'm
cleaning up the patch now. I should have it out in a couple of hours.
You will find it in the other thread.

Thanks
----------------
Robert LeBlanc
PGP Fingerprint 79A2 9CA4 6CC4 45DD A904  C70E E654 3BB2 FA62 B9F1


On Thu, Jan 12, 2017 at 11:02 AM, Bart Van Assche
<bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org> wrote:
> On 01/11/2017 03:01 PM, Robert LeBlanc wrote:
>> How would I go about discarding anything in the send or receive queue
>> without gracefully flushing it or destroying the queue pair in the
>> kernel? I have a feeling I have something stuck in the send queue
>> preventing ib_drain_qp from completing, so I need to try just clearing
>> it out.
>
> Hello Robert,
>
> Have you already read the section about the QP error state in the IB
> spec? Most drivers call ib_modify_qp() to change the QP state into
> IB_QPS_ERR before calling ib_drain_qp().
>
> Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
