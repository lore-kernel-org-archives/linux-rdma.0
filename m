From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH v2 1/6] ib/mad: Add function to support format
 specifiers for node description
Date: Thu, 6 Nov 2014 22:55:14 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237399DFF8A3@ORSMSX109.amr.corp.intel.com>
References: <1415311595-29720-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1415311595-29720-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> +void ib_build_node_desc(char *dest, char *src, int dest_len,
> +			struct ib_device *dev)
> +{
> +	char *end = dest + dest_len-1;
> +	char *field;
> +
> +	while (*src && (dest < end)) {
> +		if (*src != '%') {
> +			*dest++ = *src++;
> +		} else {
> +			src++;
> +			switch (*src) {
> +			case 'h':
> +				field = init_utsname()->nodename;
> +				src++;
> +				while (*field && (*field != '.') && (dest < end))
> +					*dest++ = *field++;
> +			break;

Indentation is off

> +			case 'd':
> +				field = dev->name;
> +				src++;
> +				while (*field && (dest < end))
> +					*dest++ = *field++;
> +				break;
> +			default:
> +				src++;
> +			}
> +		}

src++ is called in every case and could be moved outside

> +	}
> +	if (dest < end)
> +		*dest = 0;
> +	else
> +		*end = 0;

*dest = '\0'; should be sufficient in all cases


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
