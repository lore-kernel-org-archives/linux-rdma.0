From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: RE: [PATCH resend] libmlx4: Add multicast IBoE support
Date: Mon, 26 Mar 2012 23:27:33 +0000
Message-ID: <CFE9BFE80FFE4D4892AA5D31387E310F61794FB5@MTLDAG02.mtl.com>
References: <1330101150-1253-1-git-send-email-sbohrer@rgmadvisors.com>
 <CAL1RGDWe8fSFdQXrTXpDps1G+q4-eWodh0g2mmnHiqA8UgSuUA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAL1RGDWe8fSFdQXrTXpDps1G+q4-eWodh0g2mmnHiqA8UgSuUA-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Shawn Bohrer <sbohrer-EgGFQ3RFNTIP7C3xziwOQw@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Correct.

-----Original Message-----
=46rom: Roland Dreier [mailto:roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org]=20
Sent: Tuesday, March 27, 2012 12:10 AM
To: Shawn Bohrer
Cc: Or Gerlitz; Eli Cohen; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: Re: [PATCH resend] libmlx4: Add multicast IBoE support

> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ah->av.dlid =3D htons(0xc0000);

Presumably this should be 0xc000 not 0xc0000?

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
