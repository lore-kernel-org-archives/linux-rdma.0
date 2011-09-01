From: "Bob Pearson" <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: [patch v2 12/37] add rxe_verbs.h
Date: Wed, 31 Aug 2011 23:35:05 -0500
Message-ID: <039101cc6860$8626a350$9273e9f0$@systemfabricworks.com>
References: <20110724194300.421253331@systemfabricworks.com> <20110724201228.710989476@systemfabricworks.com> <CAO+b5-qQBWeyFacCU3tx92jG2zw1=YZJRRX5SbQ57Ztx+zxuew@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-qQBWeyFacCU3tx92jG2zw1=YZJRRX5SbQ57Ztx+zxuew-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org [mailto:bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org] On
> Behalf Of Bart Van Assche
> Sent: Monday, August 15, 2011 8:00 AM
> To: rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org
> Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [patch v2 12/37] add rxe_verbs.h
> 
> On Sun, Jul 24, 2011 at 9:43 PM, <rpearson-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
> 
> + rxe_qp.c:char *rxe_qp_state_name[] = {
> 
> One more comment about rxe_verbs.h: why is the above declaration
> present in this header file ? As far as I can see it's only used in
> rxe_qp.c and not in any other source file.

Agreed. Can make static in rxe_qp.c and drop here.

> 
> Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
