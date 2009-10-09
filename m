From: "David J. Wilder" <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: Re: [ewg] rping is not resolving ipv6 addresses
Date: Fri, 09 Oct 2009 14:15:01 -0700
Message-ID: <1255122901.3533.20.camel@wilder.ibm.com>
References: <1254957121.23471.17.camel@wilder.ibm.com>
	 <adavdiqn63u.fsf@cisco.com> <1255114672.3533.8.camel@wilder.ibm.com>
	 <15ddcffd0910091353w51bddc60w8452ca107de296fb@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <15ddcffd0910091353w51bddc60w8452ca107de296fb-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <or.gerlitz-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, wilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


On Fri, 2009-10-09 at 22:53 +0200, Or Gerlitz wrote:
> David J. Wilder <dwilder-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org> wrote:
> > I added an option to rping to specify a source address and supply it to
> 
> patch?
> 
> > rdma_resolve_addr(), but now it is failing rdma_resolve_route().
> > $ ./rping -d  -c -v -a fe80::202:c903:1:1925 -i fe80::202:c903:1:28ed
> > cma_event type RDMA_CM_EVENT_ADDR_RESOLVED cma_id 0x100213d0 (parent)
> > cma_event type RDMA_CM_EVENT_ROUTE_ERROR cma_id 0x100213d0 (parent)
> > cma event RDMA_CM_EVENT_ROUTE_ERROR, error -22
> 
> what does the neighbour info (ip neigh show | grep 1925)  shows after
> running rping?

If I run rping without my rping change to add the source address to
rdma_resolve_address(),  ip neigh show gives:
 fe80::202:c903:1:1925 dev eth1  FAILED

Notice that interface is incorrect, it should be ib0. tcpdump showed the
neighbor-discovery sent out the eth0 interface.

Running with my rping change to specify the local-link address of my ib0
interface "ip neigh show" never shows any entry for
fe80::202:c903:1:1925


> can you do ipoib ping and ping6 to the fe80::202:c903:1:1925 host?
> 
> Or.

Yes ping6 will work but I must specify the interface to use:
ping6 fe80::202:c903:1:1925%ib0

Here is the patch to rping to allow the source address to be specified.
I am not sure this is the correct approach to fix this.

--- rping.c.orig	2009-10-08 15:22:29.000000000 -0500
+++ rping.c	2009-10-08 15:29:59.000000000 -0500
@@ -144,6 +144,7 @@ struct rping_cb {
 	sem_t sem;
 
 	struct sockaddr_storage sin;
+	struct sockaddr_storage src;
 	uint16_t port;			/* dst port in NBO */
 	int verbose;			/* verbose logging */
 	int count;			/* ping count */
@@ -1003,7 +1004,7 @@ static int rping_bind_client(struct rpin
 
 	DEBUG_LOG("rping_bind_client: about to call rdma_resolve_addr\n");
 
-	ret = rdma_resolve_addr(cb->cm_id, NULL, (struct sockaddr *) &cb->sin, 2000);
+	ret = rdma_resolve_addr(cb->cm_id, &cb->src, (struct sockaddr *) &cb->sin, 2000);
 	if (ret) {
 		fprintf(stderr, "rdma_resolve_addr error %d\n", ret);
 		return ret;
@@ -1131,11 +1132,14 @@ int main(int argc, char *argv[])
 	sem_init(&cb->sem, 0, 0);
 
 	opterr = 0;
-	while ((op=getopt(argc, argv, "a:Pp:C:S:t:scvVd")) != -1) {
+	while ((op=getopt(argc, argv, "a:i:Pp:C:S:t:scvVd")) != -1) {
 		switch (op) {
 		case 'a':
 			ret = get_addr(optarg, (struct sockaddr *) &cb->sin);
 			break;
+		case 'i':
+			ret = get_addr(optarg, (struct sockaddr *) &cb->src);
+			break;
 		case 'P':
 			persistent_server = 1;
 			break;


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
