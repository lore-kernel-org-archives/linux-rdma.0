From: <cait-DpaxOq6QOWMAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH for-next V2 05/11] IB/core: Add =?UTF-8?Q?rdma=5Fnetwork=5Ftyp?=
 =?UTF-8?Q?e=20to=20wc?=
Date: Mon, 07 Dec 2015 11:19:45 -0700
Message-ID: <20151207111945.48b52fb35c6f209c51bccbb9807b6df0.d873ff1393.wbe@email24.secureserver.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Moni Shoua asked:



> but how? all you have in hand is the sgid which can appear several

> times in the GID table in different indices.


Step back and review the context.

Adding an extra field to the WC is *not* going to redesign the hardware.

Anything that software can do in the verbs library you can do yourself.

The justification for including something in the work completion would
have
to be that the field was something almost always desired so that the it
made
sense to figure it out for everyone, even those that did not need it.

If this is a tricky calculation that would call for a library utiity
routine
to do it, not performing it on every completion.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
