From: "Bob Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: [patch 37/44] rxe_sb8.c
Date: Thu, 14 Jul 2011 00:03:16 -0500
Message-ID: <008501cc41e3$57b7b2a0$072717e0$@systemfabricworks.com>
References: <20110701131821.928693424@systemfabricworks.com>	 <20110701132202.486466900@systemfabricworks.com>	 <CAL1RGDWLRw26RUr=WjUgzrn=6aGBukghoyOm5ordJv72mSsTBA@mail.gmail.com>	 <000601cc3843$e3854cb0$aa8fe610$@systemfabricworks.com> <1309625729.20982.2.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1309625729.20982.2.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'David Dillow' <dave-i1Mk8JYDVaaSihdK6806/g@public.gmane.org>, 'Roland Dreier' <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

David, Roland,

After some travel I got back to looking at the CRC32 calculation. I have three test systems: x86_64, x86_32 and Sparc/64. If I am going to replace lib/crc32.c I need to implement both the LE and BE (bit *not* byte order) APIs. Ethernet and InfiniBand use the LE bit order, a minority of device drivers (e.g. ATM and Firewire) use the BE bit order. It turns out that the algorithm in lib/crc32.c has improved since the last time I looked and is now a, sort of, slice by 4 equivalent to the slice by 8 algorithm. On the x86_64 system with current gcc -O3 I measure 2.8 cycles per byte with lib/crc32.c and 1.5 cycles/byte using  rxe_sb8.c. I should have replacements for the standard routine in a day or two. Once it's working and tested I'll try to touch base with Andrew.

Bob

-----Original Message-----
From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of David Dillow
Sent: Saturday, July 02, 2011 11:55 AM
To: Bob Pearson
Cc: 'Roland Dreier'; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Subject: RE: [patch 37/44] rxe_sb8.c

On Fri, 2011-07-01 at 18:09 -0500, Bob Pearson wrote:
> Hi Roland,
> 
> Perhaps. We have some ICRC specific APIs as well as plain Jane CRC 
> calculation that includes a copy at the same time.
> If I knew who maintained crc32.c I would be happy to talk to them and 
> see what they think.

No one is really the maintainer there. 'git log' says Joakim Tjernlund has touched it quite a bit, but your best bet is to post patches to LKML, and perhaps Andrew Morton.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at  http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
