From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 2/4] IB/usnic: Cisco VIC - driver part 1/3
Date: Wed, 11 Sep 2013 21:07:07 +0000
Message-ID: <47A33601BBFF7E4B8F0D5D0C96F3022C013D700A@xmb-rcd-x09.cisco.com>
References: <47A33601BBFF7E4B8F0D5D0C96F3022C013CF35A@xmb-rcd-x09.cisco.com>
 <CAJZOPZJjXFh2KU-cpq5_=C7tA0i_gSYNtUo=T-gSttUKRychaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAJZOPZJjXFh2KU-cpq5_=C7tA0i_gSYNtUo=T-gSttUKRychaw-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Content-ID: <EC865D3E9C83CE4385C583AF458E3FBC-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Christian Benvenuti (benve)" <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Or,
	The GRH is emulated by software.  That is, when the app receives a packet, the first 40 bytes contain the GRH.

Upinder

On Sep 11, 2013, at 12:19 PM, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> So you are supporting UD QPs but these QPs don't generate IBTA UD
> headers nor iWARP headers, correct?

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
