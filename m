From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: Re: [PATCH]  link-local address fix for rdma_resolve_addr
Date: Wed, 14 Oct 2009 14:09:29 -0600
Message-ID: <20091014200929.GO5191@obsidianresearch.com>
References: <1255471781.14513.7.camel@wilder.ibm.com>
	<20091013231234.GK5191@obsidianresearch.com>
	<1255537437.14513.28.camel@wilder.ibm.com>
	<20091014170155.GL5191@obsidianresearch.com>
	<1255548798.5111.24.camel@wilder.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1255548798.5111.24.camel-XfwDJb4SXxnMbYB6QlFGEg@public.gmane.org>
List-Unsubscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=unsubscribe>
List-Archive: <http://lists.openfabrics.org/pipermail/ewg>
List-Post: <mailto:ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org>
List-Help: <mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=help>
List-Subscribe: <http://lists.openfabrics.org/cgi-bin/mailman/listinfo/ewg>,
	<mailto:ewg-request-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org?subject=subscribe>
Sender: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
Errors-To: ewg-bounces-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
To: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, wilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, ewg-ZwoEplunGu1OwGhvXhtEPSCwEArCW2h5@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Wed, Oct 14, 2009 at 12:33:17PM -0700, David J. Wilder wrote:
> 
> On Wed, 2009-10-14 at 11:01 -0600, Jason Gunthorpe wrote:
> > On Wed, Oct 14, 2009 at 09:23:57AM -0700, David J. Wilder wrote:
> > 
> > > This new patch should closely emulate tcp_ipv6.c. when both source and
> > > destination scope_ids are given with link-local address. 
> > 
> > Maybe like this:
> > 
> >         fl.oif = 0;
> > 
> > 	if (ipv6_addr_type(&src_in->sin6_addr) & IPV6_ADDR_LINKLOCAL) {
> > 	    if (!src_in->sin6_scope_id)
> >                 return -EINVAL;
> >             fl.oif = src_in->sin6scope_id;
> >         }
> > 	if (ipv6_addr_type(&dst_in->sin6_addr) & IPV6_ADDR_LINKLOCAL){
> >                 if (dst_in.sin6_scope_id) {
> >                         if (fl.oif && fl.oif != dst_in.sin6_scope_id)
> > 			        return -EINVAL;
> >                         fl.oif = dst_in.sin6_scope_id;
> >                 }
> >                 if (!fl.oif)
> > 			return -EINVAL;
> > 	}
> > 
> > 
> > src and dest have to be tested seperately, the TCPv6 versions don't
> > require them to be both link local.
> 
> Hum.. this change is not working with rping. The src address has been
> filled in already with a link-local address and no scope_id so it is
> returning -EINVAL.  Another bug I guess.... I am doing some more
> debug.   

Ah feh, you are running into that other bug..

http://lists.openfabrics.org/pipermail/general/2009-July/060612.html

Basically it does this:

int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
                      struct sockaddr *dst_addr, int timeout_ms)
                ret = rdma_resolve_ip(&addr_client, (struct sockaddr *) &id->route.addr.src_addr,
                                      dst_addr, &id->route.addr.dev_addr,
                                      timeout_ms, addr_handler,
				      id_priv);
int rdma_resolve_ip(struct rdma_addr_client *client,
                    struct sockaddr *src_addr, struct sockaddr *dst_addr,
                    struct rdma_dev_addr *addr, int timeout_ms,
                    void (*callback)(int status, struct sockaddr *src_addr,
                                     struct rdma_dev_addr *addr, void *context),
                    void *context)
        req->status = addr_resolve_local(src_in, dst_in, addr);

static int addr_resolve_local(struct sockaddr *src_in,
                              struct sockaddr *dst_in,
                              struct rdma_dev_addr *addr)
                dev = ip_dev_find(&init_net, dst_ip);
[..]
       for_each_netdev(&init_net, dev)
                        if (ipv6_chk_addr(&init_net,
                                          &((struct sockaddr_in6 *) addr)->sin6_addr,
                                          dev, 1))
                                break;

So, it tries to match the source addr to the addrs bound to the
device, which is wrong - that isn't how the ip stack works.

You can patch this up a little bit by fixing up addr_resolve_local to
set sin6_scope_ip.

But really the correct thing to do is to remove addr_resolve_local and
place the source address into the struct flowi and use the result of
the route lookup to bind to the source device, and set the source
address if it is unset.

Jason
