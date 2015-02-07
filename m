From: Christopher Mitchell <christopher-1z5WdJkP5Frk1uMJSBkQmQ@public.gmane.org>
Subject: Re: rdma_connect() and IBV_QPT_UC
Date: Sat, 7 Feb 2015 15:21:48 -0500
Message-ID: <CAPb9-SHo1z=FiiM-dUpKCcXHS2a4JGrJ0ckskGqu60rQwmYfyw@mail.gmail.com>
References: <CAPb9-SGWZmHnGQa+7Y72iBwDftsUeprFF3cGKDnf=RAAOSUo_g@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237399E55949@ORSMSX109.amr.corp.intel.com>
	<CAPb9-SHsznYpLmUoguY1=qKbOTwCbKVLHqhSe5W=yeAYiJdg-Q@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A8237399E56213@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399E56213-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Sean,

I was able to replicate your results by building
examples/rdma_client.c and examples/rdma_server.c with
hints.ai_port_space = RDMA_PS_IB; and adding init_attr.qp_type =
IBV_QPT_UC; before rdma_create_ep() in each program, so that will give
me a starting point to try to figure out what's different between your
examples and my MWE. I'm trying to use UC to compare the quantitative
difference we get with Verb message-passing when the message receipts
returned in RC mode are no longer necessary (recent papers suggest
that even though UC is "unreliable", as long as the application is
aware of how many receive buffers its peer has, the transport is
essentially reliable, barring hardware failures).

Thanks,
Christopher

On Fri, Feb 6, 2015 at 3:53 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> Thanks for the quick response. I've made the suggested changes, but
>> I'm afraid I am having the same problems. In fact, I see that a
>> previous thread (
>> http://www.spinics.net/lists/linux-rdma/msg07573.html ) follows
>> another user with the same problem. In fact, I finally found a message
>> (from you, actually!
>> http://www.spinics.net/lists/linux-rdma/msg07601.html ) saying that as
>> of 2011, librdmacm can't handle UC. Is this still the case?
>
> UC support has never been a priority, so it's not something that's tested.  I modified one of the example librdmacm programs to use UC, and it seemed to work.  At least it made a connection and transferred some data.  I did not verify that UC was actually being used.
>
> A newer kernel may be needed, but I don't remember what patches are required or which version the changes went upstream.  Changes were never made specifically to support UC, but the changes to support XRC and native IB addressing should have made it possible.
>
> Btw, is there any reason why you're wanting to run over UC?  It kind of combines the worst part of UD with the worst features of RC -- kind of the el Camino of protocols.
>
> - Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
