From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v4 4/7] libibverbs: Add support for XRC QPs
Date: Mon, 18 Mar 2013 14:38:52 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F365DA2@ORSMSX101.amr.corp.intel.com>
References: <1828884A29C6694DAF28B7E6B8A8237346A981A0@FMSMSX151.amr.corp.intel.com>
 <1363394326-908-4-git-send-email-sean.hefty@intel.com>
 <5145C820.9090801@mellanox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5145C820.9090801-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org" <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > @@ -590,6 +613,11 @@ struct ibv_send_wr {
> >   			uint32_t	remote_qpn;
> >   			uint32_t	remote_qkey;
> >   		} ud;
> > +		struct {
> > +			uint64_t	reserved[3];
> > +			uint32_t	reserved2;
> > +			uint32_t	remote_srqn;
> > +		} xrc;
> >   	} wr;
> >   };
> 
> these added reserved fields ofcourse don't enlarge the union size,
> correct? so why have it, maybe you
> want to make sure no one will srink the union size in the future?

The reserved fields are needed, so that remote_srqn doesn't fall over the top of an existing field.
 
> I easily think on 3-4 more use cases for a create_qp extended verb that
> allows the app to
> specify QP creation flags e.g in the same manner we have them in the
> kernel, for example:
> 
> 1. suport blocking of multicast self-loopback (kernel
> IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK)
> 2. support TCP segementation (kernel IB_QP_CREATE_IPOIB_UD_LSO)
> 3. support some HPC optimizations whose patches are now under the works
> 4. etc more
> 
> Can we re-define this verb such that it can serve for both XRC QPs and
> non-XRC QPs for which creation flags are desired?
> maybe add creation flags and IBV_QP_CREATE_XRC as a value that tells to
> create XRC QP, and we can add other flags on top of.

Honestly, I really don't care about any other verbs extensions or possible future changes until XRC is upstream.  The only thing we're doing is constantly delaying XRC because of continual background churn.  Version 3 of these patches were submitted 6 months ago.  The kernel support went in well over a year ago.  struct ibv_qp_init_attr_ex is already extensible.  If we need flags, they can be added to it when they're necessary.  But XRC doesn't need them.



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
