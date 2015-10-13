From: Matan Barak <matanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH rdma-RC] IB/cm: Fix sleeping while atomic when creating AH
 from WC
Date: Tue, 13 Oct 2015 11:22:31 +0300
Message-ID: <CAAKD3BCe_LAuyxifm=j-Am44S1k4nT328WrGBC+Day+XxMxk9g@mail.gmail.com>
References: <1444568298-17289-1-git-send-email-matanb@mellanox.com>
	<1444568298-17289-2-git-send-email-matanb@mellanox.com>
	<1828884A29C6694DAF28B7E6B8A82373A9734356@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A9734356-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Mon, Oct 12, 2015 at 7:42 PM, Hefty, Sean <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:
>> When IP based addressing was introduced, ib_create_ah_from_wc was
>> changed in order to support a suitable AH. Since this AH should
>> now contains the DMAC (which isn't a simple derivative of the GID).
>> In order to find the DMAC, an ARP should sometime be sent. This ARP
>> is a sleeping context.
>
> Wait - are you saying that the CM may now be waiting for an ARP response before it can send a message?
>

ib_create_ah_from_wc needs to resolve the DMAC in order to create the
AH (this may result sending an ARP and waiting for response).
CM uses this function (which is now sleepable).

> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
