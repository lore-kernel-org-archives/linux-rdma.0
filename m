From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [RFC] XRC upstream merge reboot
Date: Wed, 22 Jun 2011 10:17:05 +0300
Message-ID: <201106221017.06212.jackm@dev.mellanox.co.il>
References: <1828884A29C6694DAF28B7E6B8A82373F7AB@ORSMSX101.amr.corp.intel.com> <201105181754.33759.jackm@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <201105181754.33759.jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, tziporet-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi Sean,

Some initial feature feedback.

I noticed (from the code in your git, xrc branch) that the XRC target QPs
stick around until the XRC domain is de-allocated.
There was a long thread about this in December, 2007, where the MPI community
found this approach unacceptable (leading to accumulation of "dead" XRC TGT qp's).
They needed to leave the XRC domain active, and just allocate/delete TGT QPs as needed,
without resource usage buildup.

See the thread starting at:
http://lists.openfabrics.org/pipermail/general/2007-December/044215.html
([ofa-general] [RFC] XRC -- make receiving XRC QP independent of any one user process)

This discussion lead to the addition of the XRC reg/unreg verbs for processes to
"register" with XRC TGT QPs, and reference counting for destroying
these QPs.

In addition, this approach also required propagating the XRC TGT QP events
to all processes registered with that QP, so that they could unregister
in the event of an error -- reducing the QP reference count and allowing it to be destroyed.

See also the threads starting at:
http://lists.openfabrics.org/pipermail/general/2008-January/045302.html
([ofa-general] [PATCH 0/ 8] XRC patch series (including xrc receive-only QPs))

I know that this looks ugly, but I did not see any other method other than registration to
allow persistence of TGT QPs without unnecessary "dead" resource buildup.

Any thoughts on this?

-Jack

On Wednesday 18 May 2011 17:54, Jack Morgenstein wrote:
> Sean,
> Great that you are taking this on!  I will review this next week.
> 
> -Jack
> 
> On Tuesday 17 May 2011 00:13, Hefty, Sean wrote:
> > I've been working on a set of XRC patches aimed at upstream inclusion to the kernel, libibverbs, and librdmacm.  I'm using existing patches as the major starting point.  A goal is to maintain the user space ABI.  Before proceeding further, I wanted to get broader feedback.  Starting at the top and working down, these are the basic ideas:
> > 
> > 
> > librdmacm
> > ---------
> > The API is basically unchanged.  XRC usage is indicated through the QP type.  The challenge is determining if XRC maps to a specific rdma_port_space.
> > 
> > 
> > libibverbs
> > ----------
> > We define a new device capability flag IBV_DEVICE_EXT_OPS, indicating that the library supports extended operations.  If set, the provider library returns an extended structure from ibv_open_device():
> > 
> > 	struct ibv_context_ext {
> > 		struct ibv_context context;
> > 		int                version;
> > 		struct ibv_ext_ops ext_ops;
> > 	};
> > 
> > The ext_ops will allow for additional operations not provided by ibv_context_ops, for example:
> > 
> > 	struct ibv_ext_ops {
> > 		int	(share_pd)(struct ibv_pd *pd, int fd, int oflags);
> > 	};
> > 
> > In order for libibverbs to check for ext_ops support, it steals a byte from the device name:
> > 
> > 	/*
> > 	 * Support for extended operations is recorded at the end of
> > 	 * the name character array.
> > 	 */
> > 	#define ext_ops_cap            name[IBV_SYSFS_NAME_MAX - 1]
> > 
> > (If strlen(name) indicates that this byte terminates the string, extended operation support is disabled for this device.)
> > 
> > Hopefully, this provides the framework needed for libibverbs to support both old and new provider libraries.
> > 
> > From an architecture viewpoint, XRC adds 4 new XRC specific objects: domains, INI QPs, TGT QPs, and SRQs.  For the purposes of the libibverbs API only, I'm suggesting the following mappings:
> > 
> > XRC domains - Hidden under a PD, dynamically allocated when needed.  An extended ops call allows the xrcd to be shared between processes.  This minimizes changes to existing structures and APIs which only take a struct ibv_pd.
> > 
> > INI QPs - Exposed through a new IBV_QPT_XRC_SQ qp type.  This is a send-only QP with minimal differences from an RC QP from a user's perspective.
> > 
> > TGT QPs - Not exposed to user space.  XRC TGT QP creation and setup is handled by the kernel.
> > 
> > XRC SRQs - Exposed through a new IBV_QPT_XRC_RQ qp type.  This is an SRQ that is tracked using a struct ibv_qp.  This minimizes API changes to both libibverbs and librdmacm.
> > 
> > If ext_ops are supported and in active use, extended structures may be expected with some calls, such as ibv_post_send() requiring a struct ibv_xrc_send_wr for XRC QPs.
> > 
> > 	struct ibv_xrc_send_wr {
> > 		struct ibv_send_wr wr;
> > 		uint32_t remote_qpn;
> > 	};
> > 
> > 
> > uverbs
> > ------
> > (Ideas for kernel changes are sketchier, but the existing patches cover most of the functionality except for IB CM interactions.)
> > 
> > Need new uverbs commands to support alloc/dealloc xrcd and create xrc srq.  Create QP must handle XRC INI QPs.  XRC TGT QPs are not exposed; ***all XRC INI->TGT QP setup is done in band***.
> > 
> > Somewhere, an xrc sub-module listens on a SID and accepts incoming XRC connection requests.  This requires associating the xrcd and SID, the details of which I'm not clear on.  The xrcd is most readily known to uverbs, but a SID is usually formed by the rdma_cm.  Even how the latter is done is unclear.
> > 
> > The usage model I envision is for a user to call listen on an XRC SRQ (IBV_QPT_XRC_RQ), which listens for a SIDR REQ to resolve the SRQN and a REQ to setup the INI->TGT QPs.  The issue is sync'ing the lifetime of any formed connections with the xrcd.
> > 
> > 
> > verbs
> > -----
> > The patch for this is basically available.  3 new calls are added: ib_create_xrc_srq, ib_alloc_xrcd, and ib_dealloc_xrcd.  The IB_QPT_XRC is split into 2 types: IB_QPT_INI_XRC and IB_QPT_TGT_XRC.  An INI QP has a pd, but no xrcd, while the TGT QP is the reverse.
> > 
> > 
> > Existing patches to the mlx4 driver and library would be modified to handle these changes.  If anyone has any thoughts on these changes, I'd appreciate them before I have them implemented.  :)
> > 
> > - Sean
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> > the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > 
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
