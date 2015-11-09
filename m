From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH libibcm] cmpost.c: Handle ibv_get_device_list returning no
 IB devices in init()
Date: Mon, 9 Nov 2015 15:37:02 +0200
Message-ID: <5640A17E.8000509@dev.mellanox.co.il>
References: <56369FEE.7060100@dev.mellanox.co.il>
 <1828884A29C6694DAF28B7E6B8A82373A9BA5132@ORSMSX110.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A82373A9BA5132-8oqHQFITsIHTXloPLtfHfbfspsVTdybXVpNB7YpNyf8@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/5/2015 7:46 PM, Hefty, Sean wrote:
> Merged - thanks.
> 
> This is the first patch against the libibcm in over 4 years.  Is there a reason why this is being used instead of the librdmacm?  I ask because I assumed that the libibcm was basically deprecated.  The last release was over 6 years ago.

I started trying to use this test program to try to reproduce a CM bug.
More to follow after some additional verification.

-- Hal

> - Sean
> 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
