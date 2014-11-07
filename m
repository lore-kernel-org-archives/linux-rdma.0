From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH v2 1/6] ib/mad: Add function to support format specifiers
 for node description
Date: Fri, 07 Nov 2014 17:44:44 -0500
Message-ID: <545D4B5C.20907@dev.mellanox.co.il>
References: <1415311595-29720-1-git-send-email-ira.weiny@intel.com> <545CB845.6070104@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237399DFFD90@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237399DFFD90-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "Weiny, Ira" <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, "roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org" <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Eitan Zahavi <eitan-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/7/2014 3:53 PM, Hefty, Sean wrote:
>>> Define a default Node Description format to be "%h %d"
>>
>> There are a lot of Node Description schemes in use in the field
>> currently. New format needs to be made as unlikely as possible to
>> interfere with those. So perhaps H:%h D:%d ?
> 
> Is there something for this in the upstream kernel code already? 

No; not AFAIK.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
