From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: Re: [PATCH] IB/mad: In validate_mad, validate CM method and attribute
Date: Thu, 12 Nov 2015 10:03:20 -0800
Message-ID: <5644D468.3060507@sandisk.com>
References: <56447CA2.1070802@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56447CA2.1070802-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 11/12/2015 03:48 AM, Hal Rosenstock wrote:
> A new SRP target has been observed to respond to Send CM REQ
> with GetResp of CM REQ with bad status. This is non conformant
> with IBA spec but exposes a vulnerability in the current MAD/CM
> code which will respond to the incoming GetResp of CM REQ as if
> it was a valid incoming Send of CM REQ rather than tossing
> this on the floor. It also causes the MAD layer not to
> retransmit the original REQ even though it has not received a REP.

Hello Hal,

With which SRP target has this behavior been observed ? Has this patch 
been tested with the LIO SRP target ?

Thanks,

Bart.

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
