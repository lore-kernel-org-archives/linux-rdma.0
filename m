From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Re: [PATCH] [for-2.6.33] rdma/cm: revert associating an RDMA device
 when binding to loopback
Date: Wed, 10 Feb 2010 12:18:20 -0600
Message-ID: <4B72F86C.90505@opengridcomputing.com>
References: <58D723FE08DC6A4398E6596E38F3FA170566DA@XMB-RCD-205.cisco.com>	<0D5487526204477AA2ABED06E46768E2@amr.corp.intel.com>	<4B6C498F.3060708@opengridcomputing.com>	<38B735478FE94F40BBA3E8BFD794B10F@amr.corp.intel.com>	<4B6D9948.6040007@opengridcomputing.com>	<B41CA82E76BB439B892B4874D38EA652@amr.corp.intel.com>	<79BAA34231304F1E84C5A5A53C50A207@amr.corp.intel.com>	<4B6FFB1B.40905@mellanox.co.il> <4B701FE6.60302@opengridcomputing.com>	<adawrynwtz9.fsf@roland-alpha.cisco.com>	<421D3D6710E847C5B7CAC00EB73117C4@amr.corp.intel.com> <ada6365hsgm.fsf@roland-alpha.cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada6365hsgm.fsf-BjVyx320WGW9gfZ95n9DRSW4+XlvGpQz@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, tziporet-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, ewg-G2znmakfqn7U1rindQTSdQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Roland Dreier wrote:
> OK, I'm planning on sending this upstream later today.  Looks very small
> and simple, and then we can figure our what if anything we want to do
> for 2.6.34.
>
> Make sense for everyone?
>
>  - R.
>   

Yes.


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
