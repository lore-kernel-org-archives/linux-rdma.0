From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] libibumad: add string functions for various defines
Date: Thu, 21 Feb 2013 16:24:50 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F352181@ORSMSX101.amr.corp.intel.com>
References: <20130218153638.2b452d138f0918b945bcdb71@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130218153638.2b452d138f0918b945bcdb71-i2BcT+NCU+M@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +#define UMAD_GENERIC_ATTRIBUTE_STR \
> +		case UMAD_ATTR_CLASS_PORT_INFO: \
> +			return "Class Port Info"; \
> +		case UMAD_ATTR_NOTICE: \
> +			return "Notice"; \
> +		case UMAD_ATTR_INFORM_INFO: \
> +			return "Inform Info"

What if you convert this to something like:

static inline char *umad_attr_str(be16_t attr_id)
{
	switch(ntohs(attr_id)) {
		case UMAD_ATTR_CLASS_PORT_INFO:
			return "Class Port Info";
		case UMAD_ATTR_NOTICE:
			return "Notice";
		case UMAD_ATTR_INFORM_INFO:
			return "Inform Info";
		default:
			return "unknown";
	}
}

and then...

> +static inline char * umad_sm_attr_str(be16_t attr_id)
> +{
> +	switch(ntohs(attr_id)) {
> +

remove this line

> +		UMAD_GENERIC_ATTRIBUTE_STR;

and...

> +
> +		case UMAD_SMP_ATTR_NODE_DESC:
> +			return ("NodeDescription");
> +		case UMAD_SMP_ATTR_NODE_INFO:
> +			return ("NodeInfo");
> +		case UMAD_SMP_ATTR_SWITCH_INFO:
> +			return ("SwitchInfo");
> +		case UMAD_SMP_ATTR_GUID_INFO:
> +			return ("GUIDInfo");
> +		case UMAD_SMP_ATTR_PORT_INFO:
> +			return ("PortInfo");
> +		case UMAD_SMP_ATTR_PKEY_TABLE:
> +			return ("P_KeyTable");
> +		case UMAD_SMP_ATTR_SLVL_TABLE:
> +			return ("SLtoVLMappingTable");
> +		case UMAD_SMP_ATTR_VL_ARB_TABLE:
> +			return ("VLArbitrationTable");
> +		case UMAD_SMP_ATTR_LINEAR_FT:
> +			return ("LinearForwardingTable");
> +		case UMAD_SMP_ATTR_RANDOM_FT:
> +			return ("RandomForwardingTable");
> +		case UMAD_SMP_ATTR_MCAST_FT:
> +			return ("MulticastForwardingTable");
> +		case UMAD_SMP_ATTR_SM_INFO:
> +			return ("SMInfo");
> +		case UMAD_SMP_ATTR_VENDOR_DIAG:
> +			return ("VendorDiag");
> +		case UMAD_SMP_ATTR_LED_INFO:
> +			return ("LedInfo");
> +		case UMAD_SMP_ATTR_LINK_SPD_WIDTH_TABLE:
> +			return ("LinkSpeedWidthPairsTable");

add:
		default:
			return umad_attr_str(attr_id);

> +	}
> +	return ("<unknown>");
> +}

- Sean
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
