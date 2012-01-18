From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH 2/2] IB/mad: Return unsupported for MADs as appropriate
Date: Wed, 18 Jan 2012 19:06:40 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823732DC04EDB@ORSMSX101.amr.corp.intel.com>
References: <20120118084255.18560.40844.stgit@kop-dev-sles11-04.qlogic.org>
 <20120118084311.18560.22509.stgit@kop-dev-sles11-04.qlogic.org>
 <1828884A29C6694DAF28B7E6B8A823732DC03E16@ORSMSX101.amr.corp.intel.com>
 <20120118190214.GK2892@obsidianresearch.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20120118190214.GK2892-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Cc: Swapna Thete <swapna.thete-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org



> -----Original Message-----
> From: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org [mailto:linux-rdma-
> owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Jason Gunthorpe
> Sent: Wednesday, January 18, 2012 11:02 AM
> To: Hefty, Sean
> Cc: Swapna Thete; roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> Subject: Re: [PATCH 2/2] IB/mad: Return unsupported for MADs as appropriate
> 
> On Wed, Jan 18, 2012 at 06:06:11PM +0000, Hefty, Sean wrote:
> > > +	} else {
> > > +		memcpy(response, recv, sizeof(*response));
> > > +		response->header.recv_wc.wc = &response->header.wc;
> > > +		response->header.recv_wc.recv_buf.mad = &response->mad.mad;
> > > +		response->header.recv_wc.recv_buf.grh = &response->grh;
> > > +		response->mad.mad.mad_hdr.method = IB_MGMT_METHOD_GET_RESP;
> > > +		response->mad.mad.mad_hdr.status =
> > > +				__be16_to_cpu(IB_MGMT_MAD_STATUS_BAD_VERSION);
> > > +		agent_send_response(&response->mad.mad, &recv->grh, wc,
> > > +			port_priv->device, port_num, qp_info->qp->qp_num);
> > >  	}
> >
> > I think we need to do more here than just generate a GetResp for an
> > unmatched receive.  The received MAD in question could itself be a
> > GetResp or a Send, Trap, Report, etc.  Maybe add a check:
> 
> No, refer to Figure 169. GetResp is the correct response.
> 
> The method cannot be parsed outside the context of the
> (baseVersion,manamgentClass,classVersion) tuple. A agent that does not
> understand the managementClass must return GetResp.
> 
> I feel if the base version is not supported then a GetResp should be
> returned without a memcpy. The base version set to the highest
> supported value and the TID copied over from the reply but everything
> else 0'd. This allows base version discovery which might be important
> some day.

See C13-47 - "Packets failing one or more of these checks are discarded and no action is taken in response unless the method is a Get() or a Set()."

This patch would send a GetResp() to any method.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
