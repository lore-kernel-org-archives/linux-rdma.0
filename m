From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibumad: add string functions for various defines
Date: Thu, 21 Feb 2013 08:47:08 -0800
Message-ID: <20130221084708.b0ae44ad7b700ded7090ba0d@llnl.gov>
References: <20130218153638.2b452d138f0918b945bcdb71@llnl.gov>
	<1828884A29C6694DAF28B7E6B8A823736F352181@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A823736F352181-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Thu, 21 Feb 2013 16:24:50 +0000
"Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org> wrote:

> > +#define UMAD_GENERIC_ATTRIBUTE_STR \
> > +		case UMAD_ATTR_CLASS_PORT_INFO: \
> > +			return "Class Port Info"; \
> > +		case UMAD_ATTR_NOTICE: \
> > +			return "Notice"; \
> > +		case UMAD_ATTR_INFORM_INFO: \
> > +			return "Inform Info"
> 
> What if you convert this to something like:

This would definitely work but I was concerned that someone reading the header file would confuse such a function with:

static inline char * umad_attribute_str(uint8_t mgmt_class, be16_t attr_id)

and not get proper decoding.

Anyway, that is what I was thinking.  The macro is pretty obfuscated.  :-(

Perhaps:

static inline char *umad_common_attr_str(be16_t attr_id)

That follows the spec better.

Patch to follow,
Ira

> 
> static inline char *umad_attr_str(be16_t attr_id)
> {
> 	switch(ntohs(attr_id)) {
> 		case UMAD_ATTR_CLASS_PORT_INFO:
> 			return "Class Port Info";
> 		case UMAD_ATTR_NOTICE:
> 			return "Notice";
> 		case UMAD_ATTR_INFORM_INFO:
> 			return "Inform Info";
> 		default:
> 			return "unknown";
> 	}
> }
> 
> and then...
> 
> > +static inline char * umad_sm_attr_str(be16_t attr_id)
> > +{
> > +	switch(ntohs(attr_id)) {
> > +
> 
> remove this line
> 
> > +		UMAD_GENERIC_ATTRIBUTE_STR;
> 
> and...
> 
> > +
> > +		case UMAD_SMP_ATTR_NODE_DESC:
> > +			return ("NodeDescription");
> > +		case UMAD_SMP_ATTR_NODE_INFO:
> > +			return ("NodeInfo");
> > +		case UMAD_SMP_ATTR_SWITCH_INFO:
> > +			return ("SwitchInfo");
> > +		case UMAD_SMP_ATTR_GUID_INFO:
> > +			return ("GUIDInfo");
> > +		case UMAD_SMP_ATTR_PORT_INFO:
> > +			return ("PortInfo");
> > +		case UMAD_SMP_ATTR_PKEY_TABLE:
> > +			return ("P_KeyTable");
> > +		case UMAD_SMP_ATTR_SLVL_TABLE:
> > +			return ("SLtoVLMappingTable");
> > +		case UMAD_SMP_ATTR_VL_ARB_TABLE:
> > +			return ("VLArbitrationTable");
> > +		case UMAD_SMP_ATTR_LINEAR_FT:
> > +			return ("LinearForwardingTable");
> > +		case UMAD_SMP_ATTR_RANDOM_FT:
> > +			return ("RandomForwardingTable");
> > +		case UMAD_SMP_ATTR_MCAST_FT:
> > +			return ("MulticastForwardingTable");
> > +		case UMAD_SMP_ATTR_SM_INFO:
> > +			return ("SMInfo");
> > +		case UMAD_SMP_ATTR_VENDOR_DIAG:
> > +			return ("VendorDiag");
> > +		case UMAD_SMP_ATTR_LED_INFO:
> > +			return ("LedInfo");
> > +		case UMAD_SMP_ATTR_LINK_SPD_WIDTH_TABLE:
> > +			return ("LinkSpeedWidthPairsTable");
> 
> add:
> 		default:
> 			return umad_attr_str(attr_id);
> 
> > +	}
> > +	return ("<unknown>");
> > +}
> 
> - Sean
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


-- 
Ira Weiny
Member of Technical Staff
Lawrence Livermore National Lab
925-423-8008
weiny2-i2BcT+NCU+M@public.gmane.org
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
