From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: ib_post_send in drivers
Date: Fri, 20 Nov 2009 12:08:29 -0800
Message-ID: <E102E8F5252B43318544B660CF6B78F7@amr.corp.intel.com>
References: <4B06C0EA.2070501@systemfabricworks.com> <e2e108260911201126o5233ea3v94163083fe3d26fc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <e2e108260911201126o5233ea3v94163083fe3d26fc-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, frank zago <fzago-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

>mlx4/qp.c: mlx4_ib_post_send()
>* when passing a list containing more than one item to
>mlx4_ib_post_send(), and sending the second or later item fails (e.g.
>because of QP overflow), the preceding items are sent anyway. This
>behavior makes it almost impossible to get error recovery right for
>block device implementations that use ib_post_send() (e.g. the SRPT
>target implementation).

Yes - this is the correct behavior.  The bad_wr pointer should reference the WR
that failed, with all WRs in the list passed that point being returned
unprocessed.  This is the reason for having the bad_wr in the call.  Error
recovery shouldn't be any more difficult than posting one WR at a time.

>If my interpretation of the section about verbs in the InfiniBand
>Architecture Specification is correct, either all work requests should
>be processed or none. A quote from section 11.4.1.1, Post Send Request
>(page 622 in volume 1 of release 1.2.1):

The IB spec does not define an API.  For performance reasons, you don't want the
implementation to walk through the WR list multiple times - once to check it,
then a second time to actually post the requests to the hardware.

- Sean

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
