From: "Upinder Malhi (umalhi)" <umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH V2 2/4] IB/usnic: Cisco VIC - driver part 1/3
Date: Fri, 13 Sep 2013 18:39:44 +0000
Message-ID: <47A33601BBFF7E4B8F0D5D0C96F3022C013EBCA2@xmb-rcd-x09.cisco.com>
References: <47A33601BBFF7E4B8F0D5D0C96F3022C013CF35A@xmb-rcd-x09.cisco.com>
 <CAJZOPZJjXFh2KU-cpq5_=C7tA0i_gSYNtUo=T-gSttUKRychaw@mail.gmail.com>
 <47A33601BBFF7E4B8F0D5D0C96F3022C013D700A@xmb-rcd-x09.cisco.com>
 <52315D0B.8050202@mellanox.com>
 <47A33601BBFF7E4B8F0D5D0C96F3022C013EB2BD@xmb-rcd-x09.cisco.com>
 <1828884A29C6694DAF28B7E6B8A8237388CBFD30@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237388CBFD30-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Language: en-US
Content-ID: <07881CA8F2F9534A97E6393E6DB2FB3A-WwaMAgPkaIIluPl5bxqUMw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, "Jeff Squyres (jsquyres)" <jsquyres-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Christian Benvenuti (benve)" <benve-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sean,
	We selected version 8 because it is unused - not a standard version and not in use by anyone.

Upinder

On Sep 12, 2013, at 10:02 AM, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

>> We are using the RoCE ethertype in the MAC frames, and that is all of the
>> similarity between usNIC protocol and RoCE.  L3 is not the GRH, but rather
>> a usNIC L3 header.  Customers can distinguish between RoCE traffic and
>> usNIC traffic by looking at the version of the L3 frame.  It is set to 6
>> for RoCE traffic and to 8 for usNIC traffic.
> 
> I haven't kept that up to date with RoCE.  Is version 8 a standard version, or is this just some value that Cisco selected?  Hijacking the version in order to insert a vendor-specific header seems questionable.
> 
> - Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
