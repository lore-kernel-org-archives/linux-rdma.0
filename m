From: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Subject: Re: [PATCH] libibumad: add string functions for various enums
Date: Fri, 22 Feb 2013 11:23:15 -0800
Message-ID: <20130222112315.9469e2a6003a98d26d2f1ec5@llnl.gov>
References: <20130222091333.57b91bbb5957928eeb0e62a7@llnl.gov>
	<5127B87E.5020907@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <5127B87E.5020907-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On Fri, 22 Feb 2013 13:27:10 -0500
Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org> wrote:

> On 2/22/2013 12:13 PM, Ira Weiny wrote:

[snip]

> > +.BI "char * umad_class_str(uint8_t mgmt_class)"
> > +.BI "char * umad_method_str(uint8_t mgmt_class, uint8_t method)"
> > +.BI "char * umad_mad_status_str(be16_t status, char * buf, size_t len)"
> > +.BI "char * umad_attribute_str(uint8_t mgmt_class, be16_t attr_id)"
> > +
> > +.SH "DESCRIPTION"
> > +
> > +.B "char * umad_class_str(uint8_t mgmt_class)"
> > +Return string value of management class enum
> > +
> > +.B "char * umad_method_str(uint8_t mgmt_class, uint8_t method)"
> > +Return string value of method enum
> 
> Should this now be:
> Return string value of method for mgmt_class specified

Yea.

[snip]

> > +			return ("ReportResp");
> > +		case UMAD_METHOD_TRAP_REPRESS:
> > +			return ("TrapRepress");
> > +		case UMAD_METHOD_RESP:
> > +			return ("Resp");
> 
> There's no RESP method, right ? So shouldn't UMAD_METHOD_RESP case be
> removed ?

Good point.  But then shouldn't that enum value then be defined as UMAD_METHOD_RESP_MASK?

Ira

> 
> -- Hal
> 
> > +		default:
> > +			return ("<unknown");
> > +	}
> > +}
> > +
> 
> <snip...>
> 
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
