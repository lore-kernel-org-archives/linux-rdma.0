From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: [PATCH V2 2/4] IB/usnic: Cisco VIC - driver part 1/3
Date: Thu, 12 Sep 2013 09:19:55 +0300
Message-ID: <52315D0B.8050202@mellanox.com>
References: <47A33601BBFF7E4B8F0D5D0C96F3022C013CF35A@xmb-rcd-x09.cisco.com> <CAJZOPZJjXFh2KU-cpq5_=C7tA0i_gSYNtUo=T-gSttUKRychaw@mail.gmail.com> <47A33601BBFF7E4B8F0D5D0C96F3022C013D700A@xmb-rcd-x09.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <47A33601BBFF7E4B8F0D5D0C96F3022C013D700A-nsZYYkk5h5QoZIgnCEkqtaBKnGwkPULj@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Christian Benvenuti (benve)" <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/09/2013 00:07, Upinder Malhi (umalhi) wrote:
> Hi Or,
> 	The GRH is emulated by software.  That is, when the app receives a packet, the first 40 bytes contain the GRH.

I was asking what protocol you are using in the Ethernet MAC header on 
the wire?

Or.

>
>
> On Sep 11, 2013, at 12:19 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:
>
>> So you are supporting UD QPs but these QPs don't generate IBTA UD
>> headers nor iWARP headers, correct?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
