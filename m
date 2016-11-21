From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: [PATCH 1/3] IB/mad: Fix an array index check
Date: Mon, 21 Nov 2016 16:17:52 -0500
Message-ID: <1cbca3ac-a525-fe5c-118e-0fce5b1c6c83@dev.mellanox.co.il>
References: <94eb11fc-b558-b994-c933-da784caefc53@sandisk.com>
 <396b3fe2-6a84-efed-07de-3e6381009ad1@sandisk.com>
 <d5924c69-c052-84d3-06e3-b74ed8eb58d3@dev.mellanox.co.il>
 <ab9e8563-160b-a9de-08b3-b09bdd52fbad@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ab9e8563-160b-a9de-08b3-b09bdd52fbad-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Bart,

On 11/21/2016 3:52 PM, Bart Van Assche wrote:
> Hello Hal,
> 
> I think such a check is already present in ib_register_mad_agent():
> 
> 		if (mad_reg_req->mgmt_class >= MAX_MGMT_CLASS) {

You're right.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
