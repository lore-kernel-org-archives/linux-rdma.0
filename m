From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: Re: partitions / ib_read_bw
Date: Sat, 22 Jun 2013 07:56:13 -0400
Message-ID: <51C590DD.3000704@dev.mellanox.co.il>
References: <AB9234BD-66C3-4D8E-93CA-5AF8D26818AB@lanl.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <AB9234BD-66C3-4D8E-93CA-5AF8D26818AB-YOWKrPYUwWM@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Coulter, Susan K" <skc-YOWKrPYUwWM@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On 6/21/2013 5:48 PM, Coulter, Susan K wrote:
> 
> One of my test clusters is running with multiple partitions.
> The partitions look correct (using "smpquery pkey") and the path records look correct (using "saquery pr").
> 
> I'd like a simple user-level test to validate who is allowed to talk to who; and hoped to use ib_read_bw.
> Alas, ib_read_bw does not honor partitions.
> 
> Below is a patch I wrote to try and add pkey support to ib_read_bw.  No joy.
> 
> The server shows it is populating ibv_qp_attr with the pkey(s) of any full partition it is a member of, 
> but the client does not get that same pkey in ibv_wc.
> 
> What am I missing?

The QPs need to be bound to the proper pkey index. An additional command
line pkey parameter is needed on client and maybe also server side.
Server side pkey parameter could be avoided if QPs are initialized for
all pkeys configured.

-- Hal
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
