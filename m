From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 2/4] IB/usnic: Cisco VIC - driver part 1/3
Date: Thu, 12 Sep 2013 16:51:28 +0000
Message-ID: <47A33601BBFF7E4B8F0D5D0C96F3022C013EB2BD@xmb-rcd-x09.cisco.com>
References: <47A33601BBFF7E4B8F0D5D0C96F3022C013CF35A@xmb-rcd-x09.cisco.com>
 <CAJZOPZJjXFh2KU-cpq5_=C7tA0i_gSYNtUo=T-gSttUKRychaw@mail.gmail.com>
 <47A33601BBFF7E4B8F0D5D0C96F3022C013D700A@xmb-rcd-x09.cisco.com>
 <52315D0B.8050202@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <52315D0B.8050202-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Content-ID: <9AFB13EA03CBE24C8B01657740A5C8CA-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Christian Benvenuti (benve)" <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We are using the RoCE ethertype in the MAC frames, and that is all of the similarity between usNIC protocol and RoCE.  L3 is not the GRH, but rather a usNIC L3 header.  Customers can distinguish between RoCE traffic and usNIC traffic by looking at the version of the L3 frame.  It is set to 6 for RoCE traffic and to 8 for usNIC traffic.

Upinder

On Sep 11, 2013, at 11:19 PM, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org> wrote:

> On 12/09/2013 00:07, Upinder Malhi (umalhi) wrote:
>> Hi Or,
>> 	The GRH is emulated by software.  That is, when the app receives a packet, the first 40 bytes contain the GRH.
> 
> I was asking what protocol you are using in the Ethernet MAC header on the wire?
> 
> Or.
> 
>> 
>> 
>> On Sep 11, 2013, at 12:19 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>> 
>>> So you are supporting UD QPs but these QPs don't generate IBTA UD
>>> headers nor iWARP headers, correct?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
>> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
