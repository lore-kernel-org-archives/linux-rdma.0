From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] RDMA/ucma.c: Fix for ucma context uid=0, causing iWarp
 RDMA applications to fail in connection establishment
Date: Fri, 3 Aug 2012 05:05:51 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237346A7C5B8@ORSMSX101.amr.corp.intel.com>
References: <20120803001226.GA8060@TENIKOLO-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120803001226.GA8060@TENIKOLO-MOBL>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Nikolova, Tatyana E" <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Lacombe, John S" <john.s.lacombe-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

>  drivers/infiniband/core/ucma.c |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
> index 8002ae6..6cc40de 100644
> --- a/drivers/infiniband/core/ucma.c
> +++ b/drivers/infiniband/core/ucma.c
> @@ -803,9 +803,8 @@ static ssize_t ucma_accept(struct ucma_file *file, const
> char __user *inbuf,
>  	if (cmd.conn_param.valid) {
>  		ucma_copy_conn_param(&conn_param, &cmd.conn_param);
>  		mutex_lock(&file->mut);
> +		ctx->uid = cmd.uid;
>  		ret = rdma_accept(ctx->cm_id, &conn_param);
> -		if (!ret)
> -			ctx->uid = cmd.uid;

This is actually trying to revert a previous commit:

commit 9ced69ca5296567033804950d8d2161f454c5012
Author: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Date:   Tue Jan 10 23:53:41 2012 +0000

    RDMA/ucma: Discard all events for new connections until accepted
    
    After reporting a new connection request to user space, the rdma_ucm
    will discard subsequent events until the user has associated a user
    space idenfier with the kernel cm_id.  This is needed to avoid
    reporting a reject/disconnect event to the user for a request that
    they may not have processed.
    
    The user space identifier is set once the user tries to accept the
    connection request.  However, the following race exists in ucma_accept():
    
        ctx->uid = cmd.uid;
        <events may be reported now>
        ret = rdma_accept(ctx->cm_id, ...);
    
    Once ctx->uid has been set, new events may be reported to the user.
    While the above mentioned race is avoided, there is an issue that the
    user _may_ receive a reject/disconnect event if rdma_accept() fails,
    depending on when the event is processed.  To simplify the use of
    rdma_accept(), discard all events unless rdma_accept() succeeds.
    
    This problem was discovered based on questions from Roland Dreier
    <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>.
    
    Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
    Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

The file->mut should protect against an event being reported to user space with the uid set to 0.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
