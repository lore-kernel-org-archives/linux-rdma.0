From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] libibumad: add string functions for various enums
Date: Fri, 22 Feb 2013 20:00:59 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F352B11@ORSMSX101.amr.corp.intel.com>
References: <20130222091333.57b91bbb5957928eeb0e62a7@llnl.gov>
	<1828884A29C6694DAF28B7E6B8A823736F352A97@ORSMSX101.amr.corp.intel.com>
 <20130222111908.2f8b1e56a8f67396a91a3893@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130222111908.2f8b1e56a8f67396a91a3893-i2BcT+NCU+M@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> > > +char * umad_class_str(uint8_t mgmt_class);
> > > +char * umad_method_str(uint8_t mgmt_class, uint8_t method);
> > > +char * umad_attribute_str(uint8_t mgmt_class, be16_t attr_id);
> > > +char * umad_mad_status_str(be16_t status, char * buf, size_t len);
> >
> > Why is umad_mad_status_str() different?
> 
> Which difference are you speaking of, the lack of mgmt_class or the required
> buffer?

I was referring to the buf/len input fields.  Why are those needed?  I didn't follow this reasoning:
 
> The required buffer allows for printing multiple strings for various fields
> which may be set.  This is done because status is not defined to be a strict
> enum.

+char * umad_mad_status_str(be16_t status, char * buf, size_t len)
+{
+	size_t n = len;
+	int rc = 0;
+
+	status = ntohs(status);
+
+	if (status & UMAD_STATUS_BUSY) {
+		rc = snprintf(buf, n, "busy");
+		if (rc < 0 || rc >= n)
+			goto done;
+		n -= rc;
+		buf += rc;
+	}
+
+	if (status & UMAD_STATUS_REDIRECT) {
+		rc = snprintf(buf, n, " redirection required");
+		if (rc < 0 || rc >= n)
+			goto done;
+		n -= rc;
+		buf += rc;
+	}
+
+	switch((status & 0x001C)) {
+	case UMAD_STATUS_BAD_VERSION:
+		rc = snprintf(buf, n, " bad version");
+		break;
+	case UMAD_STATUS_METHOD_NOT_SUPPORTED:
+		rc = snprintf(buf, n, " method not supported");
+		break;
+	case UMAD_STATUS_ATTR_NOT_SUPPORTED:
+		rc = snprintf(buf, n, " method/attribute combo not supported");
+		break;
+	case UMAD_STATUS_INVALID_ATTR_VALUE:
+		rc = snprintf(buf, n, " invalid attribute/modifier value");
+		break;
+	}
+
+	if (rc < 0 || rc >= n)
+		goto done;
+	n -= rc;
+	buf += rc;
+
+	if (n == len)
+		snprintf(buf, n, "Success");
+done:
+	return (buf);
+}

These return values seem mutually exclusive.  Surely we're not going to see a MAD with status 'busy - redirection required - bad version - success'?
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
