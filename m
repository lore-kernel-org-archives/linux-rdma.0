From: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: ib_post_send in drivers
Date: Fri, 20 Nov 2009 20:26:34 +0100
Message-ID: <e2e108260911201126o5233ea3v94163083fe3d26fc@mail.gmail.com>
References: <4B06C0EA.2070501@systemfabricworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <4B06C0EA.2070501-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Nov 20, 2009 at 5:16 PM, frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org> wrote:
>
> It seems ib_post_send() is implemented slightly differently in the various hardware drivers (as in kernel 2.6.31). Here are the differences I've noticed regarding the bad_wr parameter.
>
> amso1100/c2_qp.c : c2_post_send()
> * bails out and does not set bad_wr if the 1st check is bad.
>
> cxgb3/iwch_qp.c : post_one_send()
> * test for bad_send_wr but it should always be set
>
> cxgb3/iwch_qp.c : iwch_post_send()
> * bails out and does not set bad_wr if the 1st 2 checks are bad
>
> ehca/ehca_reqs.c : ehca_post_send()
> * bails out and does not set bad_wr if the 1st check is bad.
> * test for bad_send_wr but it should always be set
> * always return success if at least one post succeeded.
>
> ehca/ehca_reqs.c : post_one_send()
> * test for bad_send_wr but it should always be set
>
> nes/nes_verbs.c : nes_post_send()
> * bails out and does not set bad_wr if the 1st check is bad.
>
> I think assume most are bugs (especially the ehca driver). I can post a patch to fix these if confirmed.

I would like to add the following item to the above list:

mlx4/qp.c: mlx4_ib_post_send()
* when passing a list containing more than one item to
mlx4_ib_post_send(), and sending the second or later item fails (e.g.
because of QP overflow), the preceding items are sent anyway. This
behavior makes it almost impossible to get error recovery right for
block device implementations that use ib_post_send() (e.g. the SRPT
target implementation).

If my interpretation of the section about verbs in the InfiniBand
Architecture Specification is correct, either all work requests should
be processed or none. A quote from section 11.4.1.1, Post Send Request
(page 622 in volume 1 of release 1.2.1):

If an immediate error is returned, the QP state shall not be affected.

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
