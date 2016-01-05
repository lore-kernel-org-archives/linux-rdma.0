From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-RC] IB/cm: Fix sleeping while atomic when creating AH
 from WC
Date: Tue, 5 Jan 2016 13:33:15 +0200
Message-ID: <CAAKD3BD=Va_0yNQ4c=2V4CH5Qns0TPSGe5P8-mv1rLAJPy0q=A@mail.gmail.com>
References: <1444568298-17289-1-git-send-email-matanb@mellanox.com>
	<1444568298-17289-2-git-send-email-matanb@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A82373A9734356@ORSMSX109.amr.corp.intel.com>
	<CAAKD3BCe_LAuyxifm=j-Am44S1k4nT328WrGBC+Day+XxMxk9g@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A82373A9734A57@ORSMSX109.amr.corp.intel.com>
	<CAAKD3BAF763brdhsrHtpm_peHk--g3iza53AioiUefepHM_s2w@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A82373A9735914@ORSMSX109.amr.corp.intel.com>
	<567AFE42.2080107@redhat.com>
	<CAAKD3BBGhWqp7kJfBQAhYHDVz5JgjNg4M+0GBTwg7Us4hioO-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAAKD3BBGhWqp7kJfBQAhYHDVz5JgjNg4M+0GBTwg7Us4hioO-A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Dec 24, 2015 at 9:46 AM, Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:
> On Wed, Dec 23, 2015 at 10:04 PM, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org> wrote:
>> On 10/15/2015 12:58 PM, Hefty, Sean wrote:
>>>>>> ib_create_ah_from_wc needs to resolve the DMAC in order to create the
>>>>>> AH (this may result sending an ARP and waiting for response).
>>>>>> CM uses this function (which is now sleepable).
>>>>>
>>>>> This is a significant change to the CM.  The CM calls are invoked
>>>> assuming that they return relatively quickly.  They're invoked from
>>>> callbacks and internally.  Having the calls now wait for an ARP response
>>>> requires that this be re-architected, so the calling thread doesn't go out
>>>> to lunch for several seconds.
>>>>
>>>> Agree - this is a significant change, but it was done a long time ago
>>>> (at v4.3 if I recall). When we need to send a message we need to
>>>
>>> We're at 4.3-rc5?
>>>
>>>> figure out the destination MAC. Even the passive side needs to do that
>>>> as some vendors don't report the source MAC of the packet in their wc.
>>>> Even if they did, since IP based addressing is rout-able by its
>>>> nature, it should follow the networking stack rules. Some crazy
>>>> configurations could force sending responses to packets that came from
>>>> router1 to router2 - so we have no choice than resolving the DMAC at
>>>> every side.
>>>
>>> Ib_create_ah_from_wc is broken.   It is now an asynchronous operation, only the call itself was left as synchronous.  We can't block kernel threads for a minute, or however long ARP takes to resolve.  The call itself must change to be async, and all users of it updated to allocate some request, queue it, and handle all race conditions that result -- such as state changes or destruction of the work that caused the request to be initiated.
>>>
>>
>> I don't know who had intended to address this, but it got left out of
>> the 4.4 work.  We need to not let this drop through the cracks (for
>> another release).  Can someone please put fixing this properly on their
>> TODO list?
>>
>
> IMHO, the proposed patch makes things better. Not applying the current
> patch means we have a "sleeping while atomic" error (in addition to
> the fact that kernel threads could wait until the ARP process
> finishes), which is pretty bad. I tend to agree that adding another CM
> state is probably a better approach, but unless someone steps up and
> add this for v4.5, I think that's the best thing we have.
>
>> --
>> Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
>>               GPG KeyID: 0E572FDD
>>
>>
>
> Matan

Yishai has found a double free bug in the error flow of this patch.
The fix is pretty simple.
Thanks Yishai for catching and testing this fix.

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 07a3bbf..832674f 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -296,10 +296,9 @@ static int _cm_alloc_response_msg(struct cm_port *port,
                               0, IB_MGMT_MAD_HDR, IB_MGMT_MAD_DATA,
                               GFP_ATOMIC,
                               IB_MGMT_BASE_VERSION);
-       if (IS_ERR(m)) {
-               ib_destroy_ah(ah);
+       if (IS_ERR(m))
                return PTR_ERR(m);
-       }
+
        m->ah = ah;
        *msg = m;
        return 0;
@@ -310,13 +309,18 @@ static int cm_alloc_response_msg(struct cm_port *port,
                                 struct ib_mad_send_buf **msg)
 {
        struct ib_ah *ah;
+       int ret;

        ah = ib_create_ah_from_wc(port->mad_agent->qp->pd, mad_recv_wc->wc,
                                  mad_recv_wc->recv_buf.grh, port->port_num);
        if (IS_ERR(ah))
                return PTR_ERR(ah);

-       return _cm_alloc_response_msg(port, mad_recv_wc, ah, msg);
+       ret = _cm_alloc_response_msg(port, mad_recv_wc, ah, msg);
+       if (ret)
+               ib_destroy_ah(ah);
+
+       return ret;
 }

 static void cm_free_msg(struct ib_mad_send_buf *msg)


Doug, if you intend to take this patch. I can squash this fix and respin it.

Thanks,
Matan
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
