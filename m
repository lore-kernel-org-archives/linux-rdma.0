From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/1] Ibacm: default pkey for partitioned fabrics
Date: Wed, 9 Dec 2015 07:51:30 -0500
Message-ID: <566823D2.9010708@dev.mellanox.co.il>
References: <1449595982-20781-1-git-send-email-kaike.wan@intel.com>
 <20151208212133.GC14378@obsidianresearch.com>
 <1828884A29C6694DAF28B7E6B8A82373AAFE7BE2@ORSMSX109.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373AAFE7BE2-P5GAC/sN6hkd3b2yrw5b5LfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, "Wan, Kaike" <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 12/8/2015 7:26 PM, Hefty, Sean wrote:
>>> +	 * Determine the default pkey for parsing address file as well.
>>> +	 *   order of preference: first full-member non-management pkey,
>>> +	 *   0xffff, first pkey.
>>> +	 */
>>
>> This really should just be the 0 index pkey, which exactly matches how
>> IPoIB determines the default pkey, which is what matters when talking
>> rdmacm..
> 
> Ibacm currently hard-codes the 'default' pkey to 0xffff for ibacm <-> ibacm communication.   
> If there's no disagreement to switching to pkey[0], I'm fine with that.  

There's no IBA requirement that 0xffff pkey is always in index 0. It's
only a requirement on device bootup with non volatile storage per C10-123.

Furthermore, there's no requirement that 0xffff pkey is present in the
table. It may be that there's only 0x7fff pkey.

> I did not realize that ipoib uses this same default.

I think this is a problem in limiting partition use and should be
changed. Rather than assuming index 0, pkey table should be searched for
this pkey.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
