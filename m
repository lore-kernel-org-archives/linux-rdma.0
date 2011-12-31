From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: When is it safe to release connection resources?
Date: Sat, 31 Dec 2011 10:55:57 +0000
Message-ID: <CAO+b5-roeptjJSQ3HyP3r8zY7EOZT=bH-BG7eB3_ZabefFsVAw@mail.gmail.com>
References: <4EFC987B.6070901@list-group.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4EFC987B.6070901-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Flavio Baronti <f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 29, 2011 at 4:42 PM, Flavio Baronti
<f.baronti-ngIpsMLAhaq41k5uCYKmRQ@public.gmane.org> wrote:
> I'm new to RDMA development and I have a question regarding resource release.
> If I understood correctly, when ibv_get_cq_event returns, it holds some sort
> of lock over the completion queue, which is released when I call
> ibv_req_notify_cq. This lock is checked also in ibv_destroy_cq, so that:
> 1) When ibv_destroy_cq returns, I am certain that there is no thread running
> somewhere between ibv_get_cq_event and ibv_req_notify_cq
> 2) When ibv_destroy_cq returns, I am certain that ibv_get_cq_event will not
> return the destroyed cq any more.

There is a paragraph in the IBTA that warns that the above sequence
can cause WQE and data segment leakage in the HCA for QPs associated
with an SRQ. I don't know though whether this can also occur for QPs
with a private receive queue - I'm not a HCA firmware expert.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
