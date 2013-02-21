From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: RE: [PATCH] libibumad: add string functions for various defines
Date: Thu, 21 Feb 2013 17:00:46 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A823736F3521ED@ORSMSX101.amr.corp.intel.com>
References: <20130218153638.2b452d138f0918b945bcdb71@llnl.gov>
	<1828884A29C6694DAF28B7E6B8A823736F352181@ORSMSX101.amr.corp.intel.com>
 <20130221084708.b0ae44ad7b700ded7090ba0d@llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20130221084708.b0ae44ad7b700ded7090ba0d-i2BcT+NCU+M@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <weiny2-i2BcT+NCU+M@public.gmane.org>
Cc: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

> This would definitely work but I was concerned that someone reading the header
> file would confuse such a function with:
> 
> static inline char * umad_attribute_str(uint8_t mgmt_class, be16_t attr_id)
> 
> and not get proper decoding.
> 
> Anyway, that is what I was thinking.  The macro is pretty obfuscated.  :-(
> 
> Perhaps:
> 
> static inline char *umad_common_attr_str(be16_t attr_id)
> 
> That follows the spec better.

I'm more concerned that the #define was placed in an external header file, followed by it being a macro that's part of a switch statement.

As for the actual functions, I think they should be exported by the library, rather than declared as static inline calls (see similar libibverbs and librdmacm calls).  If a caller uses these in more than one place, they're rather large functions that end up embedded in the user's code.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
