From: Tziporet Koren <tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: RE: [ANNOUNCE] libmthca 1.0.5 and libmlx4 1.0.2 are released
Date: Mon, 18 Jul 2011 08:42:25 +0000
Message-ID: <CD250C48050CFB4D95E78C95F2FDDD6E071C9C38@mtldag02.mtl.com>
References: <1309981353-14301-1-git-send-email-roland@kernel.org>
 <CD250C48050CFB4D95E78C95F2FDDD6E071C09B6@mtldag02.mtl.com>
 <CAG4TOxN7iWn7JN7Yg_FMO1qdKFhhPXaujC-Chc=DfCyFMpxO5A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAG4TOxN7iWn7JN7Yg_FMO1qdKFhhPXaujC-Chc=DfCyFMpxO5A-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


>> What about the new CX3 device ID patch?

> Did I ever get a final version of the libmthca and kernel patches?

CX3 is using libmlx4 and not libmthca.
Vlad sent a patch on 1/19/11:
http://www.spinics.net/lists/linux-rdma/msg07237.html


Is contain adding several device IDs including CX3

Do you wish separate patch on each device?

Regards,
Tziporet
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
