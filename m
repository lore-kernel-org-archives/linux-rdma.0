From: David Dillow <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>
Subject: RE: [patch 37/44] rxe_sb8.c
Date: Sat, 02 Jul 2011 12:55:29 -0400
Message-ID: <1309625729.20982.2.camel@obelisk.thedillows.org>
References: <20110701131821.928693424@systemfabricworks.com>
	 <20110701132202.486466900@systemfabricworks.com>
	 <CAL1RGDWLRw26RUr=WjUgzrn=6aGBukghoyOm5ordJv72mSsTBA@mail.gmail.com>
	 <000601cc3843$e3854cb0$aa8fe610$@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <000601cc3843$e3854cb0$aa8fe610$@systemfabricworks.com>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bob Pearson <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: 'Roland Dreier' <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, 2011-07-01 at 18:09 -0500, Bob Pearson wrote:
> Hi Roland,
> 
> Perhaps. We have some ICRC specific APIs as well as plain Jane CRC
> calculation that includes a copy at the same time.
> If I knew who maintained crc32.c I would be happy to talk to them and see
> what they think.

No one is really the maintainer there. 'git log' says Joakim Tjernlund
has touched it quite a bit, but your best bet is to post patches to
LKML, and perhaps Andrew Morton.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
