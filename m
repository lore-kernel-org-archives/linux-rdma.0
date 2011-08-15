From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [patch v2 12/37] add rxe_verbs.h
Date: Mon, 15 Aug 2011 14:59:42 +0200
Message-ID: <CAO+b5-qQBWeyFacCU3tx92jG2zw1=YZJRRX5SbQ57Ztx+zxuew@mail.gmail.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201228.710989476@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110724201228.710989476-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Sun, Jul 24, 2011 at 9:43 PM, <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:

+ rxe_qp.c:char *rxe_qp_state_name[] = {

One more comment about rxe_verbs.h: why is the above declaration
present in this header file ? As far as I can see it's only used in
rxe_qp.c and not in any other source file.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
