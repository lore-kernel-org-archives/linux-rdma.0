From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: Re: [PATCH v2 00/13] Request for Comments on SoftiWarp
Date: Fri, 20 Oct 2017 08:45:01 -0500
Message-ID: <20171020134501.GD11604@ssaleem-MOBL4.amr.corp.intel.com>
References: <20171006122853.16310-1-bmt@zurich.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20171006122853.16310-1-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bernard Metzler <bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

On Fri, Oct 06, 2017 at 08:28:40AM -0400, Bernard Metzler wrote:
> This patch set introduces the SoftiWarp driver.
> 
> It is a re-posting of yesterdays misformatted patch and splits it into
> consumable pieces. Furthermore, it fixes formatting issues as
> indicated by checkpatch.
> 
> 
> 
> 
> Originally introduced to linux-rdma in 2011, SoftiWarp (siw) is
> around as a project for a while. It aims at implementing the iWARP protocol
> suite (IETF-RFC 5044/5041/5040/6581) on top of kernel TCP sockets.
> It integrates with the linux-rdma framework. When our
> initial attempt to contribute siw to Linux somehow sanded up, we
> continued to use and further develop it as an open source project,
> currently hosted at https://github.com/zrlio/softiwarp.
> 
> We found siw being useful, if applications are using
> an RDMA API for communication (in particular, the ibverbs API), and
> there is no local RDMA hardware support. This might be relevant for RDMA
> application development and testing, as well as setups where
> RDMA client applications at hosts without hardware RDMA support
> want to communicate with servers which want to offload communication
> to dedicated RDMA hardware. With the advent of NVME storage technology,
> and NVME over Fabrics as a remote storage access method, use cases
> may expand within that area (we recently added the driver support
> needed to run siw at both NVMeF initiator and target side).
> Last but not least, since supporting different (asynchronous, one sided)
> communication patterns, we found pure siw client-server deployments can
> outperform sockets based communication setups.
> 
> With all that, siw complements Soft-RoCE, also a pure software implementation
> of an RDMA provider, but running the RoCE/RoCEv2 protocol. In contradiction
> to Soft-RoCE, SoftiWarp per definition implements only the RC (reliable
> connected) RDMA service, as defined by iWARP.
> 
> SoftiWarp comprises a kernel module and a user space library, both
> plugging into the linux-rdma kernel environment, or libibverbs and librdmacm
> respectively. It supports both kernel and user level RDMA applications.
> For efficiency, user level communication endpoint resources such as
> send/receive and completion queues are shared (memory mapped) between
> siw kernel component and siw user library. We tested siw interoperability
> with hardware iWARP products, such as Chelsio's T3/T4/T5/T6 adapters.
> 
> We approach the list with this RFC, since we are seeking for advice on
> how to make siw ready for Linux acceptance. So, we are prepared -
> and hoping for - constructive criticism on what we are presenting here.
> 
> The current code has limitations we are aware of. In particular, we are
> currently working on:
> 
> 1) IPv6 addressing support.
> 
> 2) Revised debug code. The currently used siw specific debug macros seem to
>    be obsolete and should probably get substituted by state of the art driver
>    debug code.
> 
> 3) NUMA awareness. We expect better performance results if siw
>    would do a better job here.
> 
> 4) Module parametrization. All settable driver parameters are currently set
>    via module parameters. It might be a good idea to have those within /sys.
> 
> 5) Transmit path implementation. We experimented with different approaches
>    to implement a low latency transmit path. The current design of having
>    one per CPU core transmit thread might be not the best idea. Advice
>    is appreciated!
> 
> For the patch set we provide, we added siw as another software driver to
> drivers/infiniband/sw.
> 
> 
> 
> To experiment with the current siw code, we suggest cloning our out-of-tree
> development repo at https://github.com/zrlio/softiwarp.
> Here, the branch 'dev-siw.mem_ext' contains the most recent code
> development status, which is currently in sync with the patch.
> Testing siw requires the installation of both user library and kernel
> module, located within userlib/ and kernel/ respectively. That siw
> version expects a running kernel of version >= 4.12.
>

So you need OFED (which ver. ?) installed for user-space?
Is there a plan to integrate your user-space into rdma core? Would be
easier to evaulate/test.
  
Shiraz
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
