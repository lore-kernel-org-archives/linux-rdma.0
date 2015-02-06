From: Christopher Mitchell <christopher-1z5WdJkP5Frk1uMJSBkQmQ@public.gmane.org>
Subject: Re: rdma_connect() and IBV_QPT_UC
Date: Fri, 6 Feb 2015 15:44:22 -0500
Message-ID: <CAPb9-SHsznYpLmUoguY1=qKbOTwCbKVLHqhSe5W=yeAYiJdg-Q@mail.gmail.com>
References: <CAPb9-SGWZmHnGQa+7Y72iBwDftsUeprFF3cGKDnf=RAAOSUo_g@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237399E55949@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399E55949-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean,

Thanks for the quick response. I've made the suggested changes, but
I'm afraid I am having the same problems. In fact, I see that a
previous thread (
http://www.spinics.net/lists/linux-rdma/msg07573.html ) follows
another user with the same problem. In fact, I finally found a message
(from you, actually!
http://www.spinics.net/lists/linux-rdma/msg07601.html ) saying that as
of 2011, librdmacm can't handle UC. Is this still the case?

Thanks,
Christopher

On Wed, Feb 4, 2015 at 9:19 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> I have a fairly complex system that I've built over the last few years
>> as part of my PhD that uses reliable connections for message-passing
>> and RDMA. After reading a recent paper, I decided to compare the
>> performance of message-passing over unreliable connections for the
>> sake of completeness, but unfortunately, I've repeatedly run into
>> obstacles trying to switch to using the UC mode. I even wrote a tiny
>> client and server that simply opens a connection, sends a message, and
>> sends a response, and when I switch from RC to UC, the rdma_accept()
>> at the server always fails with EINVAL when trying to accept the
>> client's rdma_connect(). I'm afraid documentation, source code, and
>> experimentation have left me stymied. I have tried using RDMA_PS_IB
>> and RDMA_PS_UDP instead of RDMA_PS_TCP in rdma_create_id() to no
>> avail, I've experimented with qp_attr fields, and my MWE shows the
>> same problems as the larger system. Any assistance woudl be greatly
>> appreciated, and I'd be happy to provide more details about my setup
>> of the event channel, queue pair, buffers, and so on if necessary.
>
> I believe you can get UC support by using the calls rdma_getaddrinfo and rdma_create_ep, which allows you to specify the qp_type as IBV_QPT_UC.  For the port space, you will need RDMA_PS_IB.  The TCP and UDP port spaces map to QP types RC and UD, respectively.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
