From: "J. Bruce Fields" <bfields-uC3wQj2KruNg9hUCZPvPmw@public.gmane.org>
Subject: Re: [PATCH v2 1/6] SUNRPC: Silence WARN_ON when NFSv4.1 over RDMA is
 in use
Date: Tue, 23 Aug 2016 16:53:55 -0400
Message-ID: <20160823205355.GA29452@fieldses.org>
References: <20160822185459.12076.43516.stgit@klimt.1015granger.net>
 <20160822185742.12076.34446.stgit@klimt.1015granger.net>
 <3E0207D8-CFB2-4233-B92B-165B10E9920E@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <3E0207D8-CFB2-4233-B92B-165B10E9920E-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-nfs-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: List Linux RDMA Mailing <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux NFS Mailing List <linux-nfs-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Tue, Aug 23, 2016 at 01:39:15PM -0400, Chuck Lever wrote:
> Hi Bruce-
> 
> 
> > On Aug 22, 2016, at 2:57 PM, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org> wrote:
> > 
> > Using NFSv4.1 on RDMA should be safe, so broaden the new checks in
> > rpc_create().
> > 
> > WARN_ON_ONCE is used, matching most other WARN call sites in clnt.c.
> > 
> > Fixes: 39a9beab5acb ("rpc: share one xps between all backchannels")
> > Fixes: d50039ea5ee6 ("nfsd4/rpc: move backchannel create logic...")
> > Signed-off-by: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
> > ---
> 
> Do you want to take this, or should it go through Trond/Anna ?

I don't care, feel free to add my reviewed-by: if it goes through
someone else.

Looks like this should be for 4.8 (and stable), not 4.9?

--b.

> 
> 
> > net/sunrpc/clnt.c |    4 ++--
> > 1 file changed, 2 insertions(+), 2 deletions(-)
> > 
> > diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
> > index 7f79fb7..66f23b3 100644
> > --- a/net/sunrpc/clnt.c
> > +++ b/net/sunrpc/clnt.c
> > @@ -453,7 +453,7 @@ static struct rpc_clnt *rpc_create_xprt(struct rpc_create_args *args,
> > 	struct rpc_xprt_switch *xps;
> > 
> > 	if (args->bc_xprt && args->bc_xprt->xpt_bc_xps) {
> > -		WARN_ON(args->protocol != XPRT_TRANSPORT_BC_TCP);
> > +		WARN_ON_ONCE(!(args->protocol & XPRT_TRANSPORT_BC));
> > 		xps = args->bc_xprt->xpt_bc_xps;
> > 		xprt_switch_get(xps);
> > 	} else {
> > @@ -520,7 +520,7 @@ struct rpc_clnt *rpc_create(struct rpc_create_args *args)
> > 	char servername[48];
> > 
> > 	if (args->bc_xprt) {
> > -		WARN_ON(args->protocol != XPRT_TRANSPORT_BC_TCP);
> > +		WARN_ON_ONCE(!(args->protocol & XPRT_TRANSPORT_BC));
> > 		xprt = args->bc_xprt->xpt_bc_xprt;
> > 		if (xprt) {
> > 			xprt_get(xprt);
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> --
> Chuck Lever
> 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-nfs" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
