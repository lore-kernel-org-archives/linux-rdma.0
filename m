From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v3 2/2] IB/mad: Use ID allocator routines to allocate
 agent number (fwd)
Date: Sun, 17 Jun 2018 08:42:37 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1806170841460.6553@hadrien>
References: <alpine.DEB.2.20.1806161803360.2838@hadrien> <20180617093515.000043b8@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20180617093515.000043b8@dev.mellanox.co.il>
Sender: linux-kernel-owner@vger.kernel.org
To: jackm <jackm@dev.mellanox.co.il>
Cc: Julia Lawall <julia.lawall@lip6.fr>, Hans Westgaard Ry <hans.westgaard.ry@oracle.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Hakon Bugge <haakon.bugge@oracle.com>, Parav Pandit <parav@mellanox.com>, Pravin Shedge <pravin.shedge4linux@gmail.com>, Matthew Wilcox <mawilcox@microsoft.com>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@kernel.org>, Wei Wang <wei.w.wang@intel.com>, Chris Mi <chrism@mellanox.com>, Eric Biggers <ebiggers@google.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Mel Gorman <mgorman@techsingularity.net>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, kbuild-all@01.org
List-Id: linux-rdma@vger.kernel.org



On Sun, 17 Jun 2018, jackm wrote:

> On Sat, 16 Jun 2018 18:04:41 +0200 (CEST)
> Julia Lawall <julia.lawall@lip6.fr> wrote:
>
> > ib_mad_client_id is declared as u32, so it will not be < 0 (line 382).
> >
> > julia
> >
> Julia, your are correct.
> However, I was under the impression that this patch set was abandoned
> in favor of the one submitted by Matthew Wilcox! (Convert IB/mad to use
> an IDR for agent IDs)

No idea.  I just get the kbuild reports, and this was one that I didn't
get to in a timely manner.  So it's probably fine to ignore it.

julia

>
> Hans, Matthew?
>
> -Jack
> > ---------- Forwarded message ----------
> > Date: Fri, 8 Jun 2018 08:49:57 +0800
> > From: kbuild test robot <lkp@intel.com>
> > To: kbuild@01.org
> > Cc: Julia Lawall <julia.lawall@lip6.fr>
> > Subject: Re: [PATCH v3 2/2] IB/mad: Use ID allocator routines to
> > allocate agent number
> >
> > Hi Hans,
> >
> > Thank you for the patch! Perhaps something to improve:
> >
> > [auto build test WARNING on linus/master]
> > [also build test WARNING on v4.17]
> > [if your patch is applied to the wrong git tree, please drop us a
> > note to help improve the system]
> >
> > url:
> > https://github.com/0day-ci/linux/commits/Hans-Westgaard-Ry/IB-mad-Use-ID-allocator-routines-to-allocate-agent-number/20180608-022348 ::::::
> > branch date: 6 hours ago :::::: commit date: 6 hours ago
> >
> > >> drivers/infiniband/core/mad.c:382:5-21: WARNING: Unsigned
> > >> expression compared with zero: ib_mad_client_id < 0
> >
> > #
> > https://github.com/0day-ci/linux/commit/74b1ba09003c9d132878734bf44f32a62bad31db
> > git remote add linux-review https://github.com/0day-ci/linux git
> > remote update linux-review git checkout
> > 74b1ba09003c9d132878734bf44f32a62bad31db vim +382
> > drivers/infiniband/core/mad.c
> >
> > 2527e681 Sean Hefty        2006-07-20  190
> > ^1da177e Linus Torvalds    2005-04-16  191  /*
> > ^1da177e Linus Torvalds    2005-04-16  192   * ib_register_mad_agent
> > - Register to send/receive MADs ^1da177e Linus Torvalds
> > 2005-04-16  193   */ ^1da177e Linus Torvalds    2005-04-16  194
> > struct ib_mad_agent *ib_register_mad_agent(struct ib_device *device,
> > ^1da177e Linus Torvalds    2005-04-16  195
> > 					   u8 port_num, ^1da177e
> > Linus Torvalds    2005-04-16  196
> > 					   enum ib_qp_type qp_type,
> > ^1da177e Linus Torvalds    2005-04-16  197
> > 					   struct ib_mad_reg_req
> > *mad_reg_req, ^1da177e Linus Torvalds    2005-04-16  198
> > 					   u8 rmpp_version, ^1da177e
> > Linus Torvalds    2005-04-16  199
> > 					   ib_mad_send_handler
> > send_handler, ^1da177e Linus Torvalds    2005-04-16  200
> > 					   ib_mad_recv_handler
> > recv_handler, 0f29b46d Ira Weiny         2014-08-08  201
> > 					   void *context, 0f29b46d
> > Ira Weiny         2014-08-08  202
> > 					   u32 registration_flags)
> > ^1da177e Linus Torvalds    2005-04-16  203  { ^1da177e Linus
> > Torvalds    2005-04-16  204  	struct ib_mad_port_private
> > *port_priv; ^1da177e Linus Torvalds    2005-04-16  205
> > struct ib_mad_agent *ret = ERR_PTR(-EINVAL); ^1da177e Linus
> > Torvalds    2005-04-16  206  	struct ib_mad_agent_private
> > *mad_agent_priv; ^1da177e Linus Torvalds    2005-04-16  207
> > struct ib_mad_reg_req *reg_req = NULL; ^1da177e Linus Torvalds
> > 2005-04-16  208  	struct ib_mad_mgmt_class_table *class;
> > ^1da177e Linus Torvalds    2005-04-16  209  	struct
> > ib_mad_mgmt_vendor_class_table *vendor; ^1da177e Linus Torvalds
> > 2005-04-16  210  	struct ib_mad_mgmt_vendor_class
> > *vendor_class; ^1da177e Linus Torvalds    2005-04-16  211
> > struct ib_mad_mgmt_method_table *method; ^1da177e Linus Torvalds
> > 2005-04-16  212  	int ret2, qpn; ^1da177e Linus Torvalds
> > 2005-04-16  213  	unsigned long flags; ^1da177e Linus
> > Torvalds    2005-04-16  214  	u8 mgmt_class, vclass; 74b1ba09
> > Hans Westgaard Ry 2018-06-07  215  	u32 ib_mad_client_id;
> > ^1da177e Linus Torvalds    2005-04-16  216  	/* Validate
> > parameters */ ^1da177e Linus Torvalds    2005-04-16  217  	qpn
> > = get_spl_qp_index(qp_type); 9ad13a42 Ira Weiny         2014-08-08
> > 218  	if (qpn == -1) { 9ad13a42 Ira Weiny         2014-08-08
> > 219  		dev_notice(&device->dev, 9ad13a42 Ira
> > Weiny         2014-08-08  220
> > "ib_register_mad_agent: invalid QP Type %d\n", 9ad13a42 Ira
> > Weiny         2014-08-08  221  			   qp_type);
> > ^1da177e Linus Torvalds    2005-04-16  222  		goto
> > error1; 9ad13a42 Ira Weiny         2014-08-08  223  	}
> > ^1da177e Linus Torvalds    2005-04-16  224 9ad13a42 Ira Weiny
> > 2014-08-08  225  	if (rmpp_version && rmpp_version !=
> > IB_MGMT_RMPP_VERSION) { 9ad13a42 Ira Weiny         2014-08-08  226
> > 		dev_notice(&device->dev, 9ad13a42 Ira Weiny
> > 2014-08-08  227  			   "ib_register_mad_agent:
> > invalid RMPP Version %u\n", 9ad13a42 Ira Weiny         2014-08-08
> > 228  			   rmpp_version); fa619a77 Hal
> > Rosenstock    2005-07-27  229  		goto error1; 9ad13a42
> > Ira Weiny         2014-08-08  230  	} ^1da177e Linus
> > Torvalds    2005-04-16  231 ^1da177e Linus Torvalds    2005-04-16
> > 232  	/* Validate MAD registration request if supplied */
> > ^1da177e Linus Torvalds    2005-04-16  233  	if (mad_reg_req)
> > { 9ad13a42 Ira Weiny         2014-08-08  234  		if
> > (mad_reg_req->mgmt_class_version >= MAX_MGMT_VERSION) { 9ad13a42 Ira
> > Weiny         2014-08-08  235
> > dev_notice(&device->dev, 9ad13a42 Ira Weiny         2014-08-08  236
> > 				   "ib_register_mad_agent: invalid
> > Class Version %u\n", 9ad13a42 Ira Weiny         2014-08-08  237
> > 				   mad_reg_req->mgmt_class_version);
> > ^1da177e Linus Torvalds    2005-04-16  238
> > goto error1; 9ad13a42 Ira Weiny         2014-08-08  239
> > 		} 9ad13a42 Ira Weiny         2014-08-08  240
> > 		if (!recv_handler) { 9ad13a42 Ira Weiny
> > 2014-08-08  241  			dev_notice(&device->dev,
> > 9ad13a42 Ira Weiny         2014-08-08  242
> > 				   "ib_register_mad_agent: no
> > recv_handler\n"); ^1da177e Linus Torvalds    2005-04-16  243
> > 			goto error1; 9ad13a42 Ira Weiny
> > 2014-08-08  244  		} ^1da177e Linus Torvalds
> > 2005-04-16  245  		if (mad_reg_req->mgmt_class >=
> > MAX_MGMT_CLASS) { ^1da177e Linus Torvalds    2005-04-16  246
> > 			/* ^1da177e Linus Torvalds    2005-04-16
> > 247  			 * IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE is
> > the only ^1da177e Linus Torvalds    2005-04-16  248
> > 			 * one in this range currently allowed
> > ^1da177e Linus Torvalds    2005-04-16  249
> > */ ^1da177e Linus Torvalds    2005-04-16  250
> > 			if (mad_reg_req->mgmt_class != 9ad13a42 Ira
> > Weiny         2014-08-08  251
> > IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE) { 9ad13a42 Ira Weiny
> > 2014-08-08  252
> > dev_notice(&device->dev, 9ad13a42 Ira Weiny         2014-08-08  253
> > 					   "ib_register_mad_agent:
> > Invalid Mgmt Class 0x%x\n", 9ad13a42 Ira Weiny         2014-08-08
> > 254
> > mad_reg_req->mgmt_class); ^1da177e Linus Torvalds    2005-04-16  255
> > 				goto error1; 9ad13a42 Ira
> > Weiny         2014-08-08  256  			} ^1da177e
> > Linus Torvalds    2005-04-16  257  		} else if
> > (mad_reg_req->mgmt_class == 0) { ^1da177e Linus Torvalds
> > 2005-04-16  258  			/* ^1da177e Linus
> > Torvalds    2005-04-16  259  			 * Class 0 is
> > reserved in IBA and is used for ^1da177e Linus Torvalds
> > 2005-04-16  260  			 * aliasing of
> > IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE ^1da177e Linus Torvalds
> > 2005-04-16  261  			 */ 9ad13a42 Ira
> > Weiny         2014-08-08  262
> > dev_notice(&device->dev, 9ad13a42 Ira Weiny         2014-08-08  263
> > 				   "ib_register_mad_agent: Invalid
> > Mgmt Class 0\n"); ^1da177e Linus Torvalds    2005-04-16  264
> > 			goto error1; ^1da177e Linus Torvalds
> > 2005-04-16  265  		} else if
> > (is_vendor_class(mad_reg_req->mgmt_class)) { ^1da177e Linus
> > Torvalds    2005-04-16  266  			/* ^1da177e
> > Linus Torvalds    2005-04-16  267  			 * If
> > class is in "new" vendor range, ^1da177e Linus Torvalds
> > 2005-04-16  268  			 * ensure supplied OUI is
> > not zero ^1da177e Linus Torvalds    2005-04-16  269
> > 			 */ 9ad13a42 Ira Weiny         2014-08-08
> > 270  			if (!is_vendor_oui(mad_reg_req->oui))
> > { 9ad13a42 Ira Weiny         2014-08-08  271
> > 				dev_notice(&device->dev, 9ad13a42 Ira
> > Weiny         2014-08-08  272
> > 					   "ib_register_mad_agent: No
> > OUI specified for class 0x%x\n", 9ad13a42 Ira Weiny
> > 2014-08-08  273
> > mad_reg_req->mgmt_class); ^1da177e Linus Torvalds    2005-04-16  274
> > 				goto error1; ^1da177e Linus
> > Torvalds    2005-04-16  275  			} 9ad13a42 Ira
> > Weiny         2014-08-08  276  		} 618a3c03 Hal
> > Rosenstock    2006-03-28  277  		/* Make sure class
> > supplied is consistent with RMPP */ 64cb9c6a Hal Rosenstock
> > 2006-04-12  278  		if
> > (!ib_is_mad_class_rmpp(mad_reg_req->mgmt_class)) { 9ad13a42 Ira
> > Weiny         2014-08-08  279  			if
> > (rmpp_version) { 9ad13a42 Ira Weiny         2014-08-08  280
> > 				dev_notice(&device->dev, 9ad13a42 Ira
> > Weiny         2014-08-08  281
> > 					   "ib_register_mad_agent:
> > RMPP version for non-RMPP class 0x%x\n", 9ad13a42 Ira Weiny
> > 2014-08-08  282
> > mad_reg_req->mgmt_class); 618a3c03 Hal Rosenstock    2006-03-28  283
> > 				goto error1; 618a3c03 Hal
> > Rosenstock    2006-03-28  284  			} 9ad13a42 Ira
> > Weiny         2014-08-08  285  		} 1471cb6c Ira
> > Weiny         2014-08-08  286 ^1da177e Linus Torvalds    2005-04-16
> > 287  		/* Make sure class supplied is consistent with
> > QP type */ ^1da177e Linus Torvalds    2005-04-16  288
> > 		if (qp_type == IB_QPT_SMI) { ^1da177e Linus
> > Torvalds    2005-04-16  289  			if
> > ((mad_reg_req->mgmt_class != ^1da177e Linus Torvalds    2005-04-16
> > 290
> > IB_MGMT_CLASS_SUBN_LID_ROUTED) && ^1da177e Linus Torvalds
> > 2005-04-16  291
> > (mad_reg_req->mgmt_class != 9ad13a42 Ira Weiny         2014-08-08
> > 292
> > IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE)) { 9ad13a42 Ira Weiny
> > 2014-08-08  293
> > dev_notice(&device->dev, 9ad13a42 Ira Weiny         2014-08-08  294
> > 					   "ib_register_mad_agent:
> > Invalid SM QP type: class 0x%x\n", 9ad13a42 Ira Weiny
> > 2014-08-08  295
> > mad_reg_req->mgmt_class); ^1da177e Linus Torvalds    2005-04-16  296
> > 				goto error1; 9ad13a42 Ira
> > Weiny         2014-08-08  297  			} ^1da177e
> > Linus Torvalds    2005-04-16  298  		} else { ^1da177e
> > Linus Torvalds    2005-04-16  299  			if
> > ((mad_reg_req->mgmt_class == ^1da177e Linus Torvalds    2005-04-16
> > 300
> > IB_MGMT_CLASS_SUBN_LID_ROUTED) || ^1da177e Linus Torvalds
> > 2005-04-16  301  			    (mad_reg_req->mgmt_class
> > == 9ad13a42 Ira Weiny         2014-08-08  302
> > 					IB_MGMT_CLASS_SUBN_DIRECTED_ROUTE))
> > { 9ad13a42 Ira Weiny         2014-08-08  303
> > 				dev_notice(&device->dev, 9ad13a42 Ira
> > Weiny         2014-08-08  304
> > 					   "ib_register_mad_agent:
> > Invalid GS QP type: class 0x%x\n", 9ad13a42 Ira Weiny
> > 2014-08-08  305
> > mad_reg_req->mgmt_class); ^1da177e Linus Torvalds    2005-04-16  306
> > 				goto error1; ^1da177e Linus
> > Torvalds    2005-04-16  307  			} 9ad13a42 Ira
> > Weiny         2014-08-08  308  		} ^1da177e Linus
> > Torvalds    2005-04-16  309  	} else { ^1da177e Linus
> > Torvalds    2005-04-16  310  		/* No registration
> > request supplied */ ^1da177e Linus Torvalds    2005-04-16  311
> > 		if (!send_handler) ^1da177e Linus Torvalds
> > 2005-04-16  312  			goto error1; 1471cb6c Ira
> > Weiny         2014-08-08  313  		if (registration_flags
> > & IB_MAD_USER_RMPP) 1471cb6c Ira Weiny         2014-08-08  314
> > 			goto error1; ^1da177e Linus Torvalds
> > 2005-04-16  315  	} ^1da177e Linus Torvalds    2005-04-16  316
> > ^1da177e Linus Torvalds    2005-04-16  317  	/* Validate
> > device and port */ ^1da177e Linus Torvalds    2005-04-16  318
> > 	port_priv = ib_get_mad_port(device, port_num); ^1da177e Linus
> > Torvalds    2005-04-16  319  	if (!port_priv) { f57e8ca5 Yuval
> > Shaia       2017-01-19  320  		dev_notice(&device->dev,
> > f57e8ca5 Yuval Shaia       2017-01-19  321
> > 			   "ib_register_mad_agent: Invalid port
> > %d\n", f57e8ca5 Yuval Shaia       2017-01-19  322
> > 			   port_num); ^1da177e Linus Torvalds
> > 2005-04-16  323  		ret = ERR_PTR(-ENODEV); ^1da177e
> > Linus Torvalds    2005-04-16  324  		goto error1;
> > ^1da177e Linus Torvalds    2005-04-16  325  	} ^1da177e Linus
> > Torvalds    2005-04-16  326 c8367c4c Ira Weiny         2011-05-19
> > 327  	/* Verify the QP requested is supported.  For example,
> > Ethernet devices c8367c4c Ira Weiny         2011-05-19  328
> > * will not have QP0 */ c8367c4c Ira Weiny         2011-05-19  329
> > 	if (!port_priv->qp_info[qpn].qp) { 9ad13a42 Ira Weiny
> > 2014-08-08  330  		dev_notice(&device->dev, 9ad13a42
> > Ira Weiny         2014-08-08  331
> > "ib_register_mad_agent: QP %d not supported\n", qpn); c8367c4c Ira
> > Weiny         2011-05-19  332  		ret =
> > ERR_PTR(-EPROTONOSUPPORT); c8367c4c Ira Weiny         2011-05-19
> > 333  		goto error1; c8367c4c Ira Weiny
> > 2011-05-19  334  	} c8367c4c Ira Weiny         2011-05-19  335
> > ^1da177e Linus Torvalds    2005-04-16  336  	/* Allocate
> > structures */ de6eb66b Roland Dreier     2005-11-02  337
> > mad_agent_priv = kzalloc(sizeof *mad_agent_priv, GFP_KERNEL);
> > ^1da177e Linus Torvalds    2005-04-16  338  	if
> > (!mad_agent_priv) { ^1da177e Linus Torvalds    2005-04-16  339
> > 		ret = ERR_PTR(-ENOMEM); ^1da177e Linus Torvalds
> > 2005-04-16  340  		goto error1; ^1da177e Linus
> > Torvalds    2005-04-16  341  	} b82cab6b Hal Rosenstock
> > 2005-07-27  342 ^1da177e Linus Torvalds    2005-04-16  343
> > if (mad_reg_req) { 9893e742 Julia Lawall      2010-05-15  344
> > 		reg_req = kmemdup(mad_reg_req, sizeof *reg_req,
> > GFP_KERNEL); ^1da177e Linus Torvalds    2005-04-16  345
> > 		if (!reg_req) { ^1da177e Linus Torvalds
> > 2005-04-16  346  			ret = ERR_PTR(-ENOMEM);
> > b82cab6b Hal Rosenstock    2005-07-27  347
> > goto error3; ^1da177e Linus Torvalds    2005-04-16  348
> > 		} ^1da177e Linus Torvalds    2005-04-16  349
> > 	} ^1da177e Linus Torvalds    2005-04-16  350 ^1da177e Linus
> > Torvalds    2005-04-16  351  	/* Now, fill in the various
> > structures */ ^1da177e Linus Torvalds    2005-04-16  352
> > mad_agent_priv->qp_info = &port_priv->qp_info[qpn]; ^1da177e Linus
> > Torvalds    2005-04-16  353  	mad_agent_priv->reg_req =
> > reg_req; fa619a77 Hal Rosenstock    2005-07-27  354
> > mad_agent_priv->agent.rmpp_version = rmpp_version; ^1da177e Linus
> > Torvalds    2005-04-16  355  	mad_agent_priv->agent.device =
> > device; ^1da177e Linus Torvalds    2005-04-16  356
> > mad_agent_priv->agent.recv_handler = recv_handler; ^1da177e Linus
> > Torvalds    2005-04-16  357
> > mad_agent_priv->agent.send_handler = send_handler; ^1da177e Linus
> > Torvalds    2005-04-16  358  	mad_agent_priv->agent.context =
> > context; ^1da177e Linus Torvalds    2005-04-16  359
> > mad_agent_priv->agent.qp = port_priv->qp_info[qpn].qp; ^1da177e Linus
> > Torvalds    2005-04-16  360  	mad_agent_priv->agent.port_num =
> > port_num; 0f29b46d Ira Weiny         2014-08-08  361
> > mad_agent_priv->agent.flags = registration_flags; d9620a4c Ralph
> > Campbell    2009-02-27  362
> > spin_lock_init(&mad_agent_priv->lock); d9620a4c Ralph Campbell
> > 2009-02-27  363  	INIT_LIST_HEAD(&mad_agent_priv->send_list);
> > d9620a4c Ralph Campbell    2009-02-27  364
> > INIT_LIST_HEAD(&mad_agent_priv->wait_list); d9620a4c Ralph
> > Campbell    2009-02-27  365
> > INIT_LIST_HEAD(&mad_agent_priv->done_list); d9620a4c Ralph
> > Campbell    2009-02-27  366
> > INIT_LIST_HEAD(&mad_agent_priv->rmpp_list); d9620a4c Ralph
> > Campbell    2009-02-27  367
> > INIT_DELAYED_WORK(&mad_agent_priv->timed_work, timeout_sends);
> > d9620a4c Ralph Campbell    2009-02-27  368
> > INIT_LIST_HEAD(&mad_agent_priv->local_list); d9620a4c Ralph
> > Campbell    2009-02-27  369
> > INIT_WORK(&mad_agent_priv->local_work, local_completions); d9620a4c
> > Ralph Campbell    2009-02-27  370
> > atomic_set(&mad_agent_priv->refcount, 1); d9620a4c Ralph Campbell
> > 2009-02-27  371  	init_completion(&mad_agent_priv->comp);
> > ^1da177e Linus Torvalds    2005-04-16  372 47a2b338 Daniel Jurgens
> > 2017-05-19  373  	ret2 =
> > ib_mad_agent_security_setup(&mad_agent_priv->agent, qp_type);
> > 47a2b338 Daniel Jurgens    2017-05-19  374  	if (ret2)
> > { 47a2b338 Daniel Jurgens    2017-05-19  375  		ret =
> > ERR_PTR(ret2); 47a2b338 Daniel Jurgens    2017-05-19  376
> > 		goto error4; 47a2b338 Daniel Jurgens    2017-05-19
> > 377  	} 74b1ba09 Hans Westgaard Ry 2018-06-07  378
> > ib_mad_client_id = ida_simple_get_cyclic(&ib_mad_client_ids, 74b1ba09
> > Hans Westgaard Ry 2018-06-07  379
> > 						1, 74b1ba09 Hans
> > Westgaard Ry 2018-06-07  380
> > 						BIT(24) - 1, 74b1ba09
> > Hans Westgaard Ry 2018-06-07  381
> > 						GFP_KERNEL); 74b1ba09
> > Hans Westgaard Ry 2018-06-07 @382  	if (ib_mad_client_id < 0)
> > { 74b1ba09 Hans Westgaard Ry 2018-06-07  383
> > pr_err("Couldn't allocate agent tid; errcode: %#x\n", 74b1ba09 Hans
> > Westgaard Ry 2018-06-07  384
> > ib_mad_client_id); 74b1ba09 Hans Westgaard Ry 2018-06-07  385
> > 		ret = ERR_PTR(ib_mad_client_id); 74b1ba09 Hans
> > Westgaard Ry 2018-06-07  386  		goto error4; 74b1ba09
> > Hans Westgaard Ry 2018-06-07  387  	} 74b1ba09 Hans Westgaard
> > Ry 2018-06-07  388  	mad_agent_priv->agent.hi_tid =
> > ib_mad_client_id; 47a2b338 Daniel Jurgens    2017-05-19  389 ^1da177e
> > Linus Torvalds    2005-04-16  390
> > spin_lock_irqsave(&port_priv->reg_lock, flags); ^1da177e Linus
> > Torvalds    2005-04-16  391 ^1da177e Linus Torvalds    2005-04-16
> > 392  	/* ^1da177e Linus Torvalds    2005-04-16  393
> > * Make sure MAD registration (if supplied) ^1da177e Linus Torvalds
> > 2005-04-16  394  	 * is non overlapping with any existing ones
> > ^1da177e Linus Torvalds    2005-04-16  395  	 */ ^1da177e
> > Linus Torvalds    2005-04-16  396  	if (mad_reg_req)
> > { ^1da177e Linus Torvalds    2005-04-16  397
> > mgmt_class = convert_mgmt_class(mad_reg_req->mgmt_class); ^1da177e
> > Linus Torvalds    2005-04-16  398  		if
> > (!is_vendor_class(mgmt_class)) { ^1da177e Linus Torvalds
> > 2005-04-16  399  			class =
> > port_priv->version[mad_reg_req-> ^1da177e Linus Torvalds
> > 2005-04-16  400
> > mgmt_class_version].class; ^1da177e Linus Torvalds    2005-04-16
> > 401  			if (class) { ^1da177e Linus Torvalds
> > 2005-04-16  402  				method =
> > class->method_table[mgmt_class]; ^1da177e Linus Torvalds
> > 2005-04-16  403  				if (method)
> > { ^1da177e Linus Torvalds    2005-04-16  404
> > 					if (method_in_use(&method,
> > ^1da177e Linus Torvalds    2005-04-16  405
> > 							   mad_reg_req))
> > 47a2b338 Daniel Jurgens    2017-05-19  406
> > 						goto error5; ^1da177e
> > Linus Torvalds    2005-04-16  407  				}
> > ^1da177e Linus Torvalds    2005-04-16  408  			}
> > ^1da177e Linus Torvalds    2005-04-16  409
> > ret2 = add_nonoui_reg_req(mad_reg_req, mad_agent_priv, ^1da177e Linus
> > Torvalds    2005-04-16  410
> > 						  mgmt_class);
> > ^1da177e Linus Torvalds    2005-04-16  411  		} else
> > { ^1da177e Linus Torvalds    2005-04-16  412
> > 			/* "New" vendor class range */ ^1da177e Linus
> > Torvalds    2005-04-16  413  			vendor =
> > port_priv->version[mad_reg_req-> ^1da177e Linus Torvalds
> > 2005-04-16  414
> > mgmt_class_version].vendor; ^1da177e Linus Torvalds    2005-04-16
> > 415  			if (vendor) { ^1da177e Linus Torvalds
> > 2005-04-16  416  				vclass =
> > vendor_class_index(mgmt_class); ^1da177e Linus Torvalds
> > 2005-04-16  417  				vendor_class =
> > vendor->vendor_class[vclass]; ^1da177e Linus Torvalds    2005-04-16
> > 418  				if (vendor_class) { ^1da177e
> > Linus Torvalds    2005-04-16  419
> > 					if
> > (is_vendor_method_in_use( ^1da177e Linus Torvalds    2005-04-16  420
> > 							vendor_class,
> > ^1da177e Linus Torvalds    2005-04-16  421
> > 							mad_reg_req))
> > 47a2b338 Daniel Jurgens    2017-05-19  422
> > 						goto error5; ^1da177e
> > Linus Torvalds    2005-04-16  423  				}
> > ^1da177e Linus Torvalds    2005-04-16  424  			}
> > ^1da177e Linus Torvalds    2005-04-16  425
> > ret2 = add_oui_reg_req(mad_reg_req, mad_agent_priv); ^1da177e Linus
> > Torvalds    2005-04-16  426  		} ^1da177e Linus
> > Torvalds    2005-04-16  427  		if (ret2) { ^1da177e
> > Linus Torvalds    2005-04-16  428  			ret =
> > ERR_PTR(ret2); 47a2b338 Daniel Jurgens    2017-05-19  429
> > 			goto error5; ^1da177e Linus Torvalds
> > 2005-04-16  430  		} ^1da177e Linus Torvalds
> > 2005-04-16  431  	} ^1da177e Linus Torvalds    2005-04-16  432
> > ^1da177e Linus Torvalds    2005-04-16  433  	/* Add mad agent
> > into port's agent list */ ^1da177e Linus Torvalds    2005-04-16  434
> > 	list_add_tail(&mad_agent_priv->agent_list,
> > &port_priv->agent_list); ^1da177e Linus Torvalds    2005-04-16  435
> > 	spin_unlock_irqrestore(&port_priv->reg_lock, flags); ^1da177e
> > Linus Torvalds    2005-04-16  436 ^1da177e Linus Torvalds
> > 2005-04-16  437  	return &mad_agent_priv->agent; 47a2b338
> > Daniel Jurgens    2017-05-19  438  error5: ^1da177e Linus Torvalds
> > 2005-04-16  439  	spin_unlock_irqrestore(&port_priv->reg_lock,
> > flags); 47a2b338 Daniel Jurgens    2017-05-19  440
> > ib_mad_agent_security_cleanup(&mad_agent_priv->agent); 74b1ba09 Hans
> > Westgaard Ry 2018-06-07  441
> > ida_simple_remove(&ib_mad_client_ids, ib_mad_client_id); 74b1ba09
> > Hans Westgaard Ry 2018-06-07  442 47a2b338 Daniel Jurgens
> > 2017-05-19  443  error4: ^1da177e Linus Torvalds    2005-04-16  444
> > 	kfree(reg_req); b82cab6b Hal Rosenstock    2005-07-27  445
> > error3: 2012a116 Adrian Bunk       2005-11-27  446
> > kfree(mad_agent_priv); ^1da177e Linus Torvalds    2005-04-16  447
> > error1: ^1da177e Linus Torvalds    2005-04-16  448  	return
> > ret; ^1da177e Linus Torvalds    2005-04-16  449  } ^1da177e Linus
> > Torvalds    2005-04-16  450  EXPORT_SYMBOL(ib_register_mad_agent);
> > ^1da177e Linus Torvalds    2005-04-16  451
> >
> > ---
> > 0-DAY kernel test infrastructure                Open Source
> > Technology Center
> > https://lists.01.org/pipermail/kbuild-all                   Intel
> > Corporation
>
>
