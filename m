From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-RC] IB/cm: Fix sleeping while atomic when creating AH
 from WC
Date: Sun, 18 Oct 2015 10:28:43 +0300
Message-ID: <CAAKD3BCdbD8MC4PJGuVzUxiq5wEbCNjX4e91vBkcoErJVM8FQg@mail.gmail.com>
References: <1444568298-17289-1-git-send-email-matanb@mellanox.com>
	<1444568298-17289-2-git-send-email-matanb@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A82373A9734356@ORSMSX109.amr.corp.intel.com>
	<CAAKD3BCe_LAuyxifm=j-Am44S1k4nT328WrGBC+Day+XxMxk9g@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A82373A9734A57@ORSMSX109.amr.corp.intel.com>
	<CAAKD3BAF763brdhsrHtpm_peHk--g3iza53AioiUefepHM_s2w@mail.gmail.com>
	<1828884A29C6694DAF28B7E6B8A82373A9735914@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A9735914-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, Oct 15, 2015 at 7:58 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> >> ib_create_ah_from_wc needs to resolve the DMAC in order to create the
>> >> AH (this may result sending an ARP and waiting for response).
>> >> CM uses this function (which is now sleepable).
>> >
>> > This is a significant change to the CM.  The CM calls are invoked
>> assuming that they return relatively quickly.  They're invoked from
>> callbacks and internally.  Having the calls now wait for an ARP response
>> requires that this be re-architected, so the calling thread doesn't go out
>> to lunch for several seconds.
>>
>> Agree - this is a significant change, but it was done a long time ago
>> (at v4.3 if I recall). When we need to send a message we need to
>
> We're at 4.3-rc5?
>

Sorry, meant v3.14.

>> figure out the destination MAC. Even the passive side needs to do that
>> as some vendors don't report the source MAC of the packet in their wc.
>> Even if they did, since IP based addressing is rout-able by its
>> nature, it should follow the networking stack rules. Some crazy
>> configurations could force sending responses to packets that came from
>> router1 to router2 - so we have no choice than resolving the DMAC at
>> every side.
>
> Ib_create_ah_from_wc is broken.   It is now an asynchronous operation, only the call itself was left as synchronous.  We can't block kernel threads for a minute, or however long ARP takes to resolve.  The call itself must change to be async, and all users of it updated to allocate some request, queue it, and handle all race conditions that result -- such as state changes or destruction of the work that caused the request to be initiated.


Today, cm assumes paths are reversible primary_path->reversible = 1.
That's true for both IB and RoCE. We could say vendors must report the
SMAC in WC and then ib_create_ah_from_wc will be atomic (for these
cases). If we wish to lift these limitations, we need to make
ib_create_ah_from_wc asynchronous, but that's true even prior the RoCE
IP based addressing patch.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
