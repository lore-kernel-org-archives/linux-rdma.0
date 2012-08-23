From: Sridhar Samudrala <sri-r/Jw6+rmf7HQT0dZR+AlfA@public.gmane.org>
Subject: RE: rsockets and fork
Date: Wed, 22 Aug 2012 17:30:58 -0700
Message-ID: <1345681858.25565.12.camel@oc1677441337.ibm.com>
References: <1344899557.2101.29.camel@oc1677441337.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A7DB36@ORSMSX101.amr.corp.intel.com>
	 <502A9039.4090505@us.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A89125@ORSMSX101.amr.corp.intel.com>
	 <1344968289.2101.36.camel@oc1677441337.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A89AEB@ORSMSX101.amr.corp.intel.com>
	 <1345239625.1128.20.camel@oc1677441337.ibm.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A89F70@ORSMSX101.amr.corp.intel.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A89F90@ORSMSX101.amr.corp.intel.com>
	 <1828884A29C6694DAF28B7E6B8A8237346A8A7A8@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237346A8A7A8-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Wed, 2012-08-22 at 23:35 +0000, Hefty, Sean wrote:
> I'm haven't identified the specific problem with fork support, but I did see this in libmlx4:
> 
> mlx4_alloc_context()
> {
> 	...
> 	context->uar = mmap(NULL, to_mdev(ibdev)->page_size, PROT_WRITE,
> 			    MAP_SHARED, cmd_fd, 0);
> 	if (context->uar == MAP_FAILED)
> 		goto err_free;
> 
> 	if (resp.bf_reg_size) {
> 		context->bf_page = mmap(NULL, to_mdev(ibdev)->page_size,
> 					PROT_WRITE, MAP_SHARED, cmd_fd,
> 					to_mdev(ibdev)->page_size);
> 	...
> }
> 
> I don't know for certain that these mmap() calls cause an issue, but the preload library socket() function calls rsocket(), which loads and initializes libibverbs.  This calls mlx4_alloc_context() before fork() has been called.
> 
> I added the following hack to the preload socket() call, which skips calling rsocket().
> 
> 	if ((domain == PF_INET || domain == PF_INET6) &&
> 	    (type == SOCK_STREAM) && (!protocol || protocol == IPPROTO_TCP) && fork_support) {
> 		printf("skipping rsocket call\n");
> 		goto realsock;
> 	}
> 
> 	recursive = 1;
> 	ret = rsocket(domain, type, protocol);
> 	recursive = 0;
> 	if (ret >= 0) {
> 		if (fork_support) {
> 			rclose(ret);
> realsock:
> 			ret = real.socket(domain, type, protocol);
> 
> With the above hack, I no longer see hangs when running with fork() and the netperf performance is split.  This should delay libibverbs initializing until after fork() has been called.

Yes. This fixes the hangs i am seeing with netperf too.

I saw this code in preload library and was wondering why rsocket() is called
and closed immediately if fork_support is enabled. I guess you are doing this
so that you can fallback to real socket at the initial socket() call instead 
of waiting all the way until fork_active/fork_passive. This should be OK
specifically if a user is using preload library and enabling fork_support.

This doesn't look like a hack to me. However it looks like a bug if rsocket()
followed by rclose() doesn't cleanup all the resources correctly.

Thanks
Sridhar

> I'm trying to decide whether to keep this work-around or find a better solution.
> 
> - Sean


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
